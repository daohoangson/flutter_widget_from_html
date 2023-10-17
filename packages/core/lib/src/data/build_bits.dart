part of '../core_data.dart';

/// A piece of HTML being built.
abstract class BuildBit {
  /// Creates a build bit.
  const BuildBit();

  /// Returns `true` if this build bit has a parent.
  ///
  /// This normally only returns `false` if it is the root tree.
  bool get hasParent => true;

  /// Controls whether to render inline.
  ///
  /// Returns `null` if it's indecisive (e.g. [BuildTree] not completely parsed).
  bool? get isInline => true;

  /// The next bit in the tree.
  ///
  /// Note: the next bit may not have the same parent or grandparent,
  /// it's only guaranteed to be within the same tree.
  BuildBit? get next {
    BuildBit? x = this;

    while (x != null) {
      if (!x.hasParent) {
        return null;
      }
      final siblings = x.parent._children ?? const [];
      final i = siblings.indexOf(x);
      if (i == -1) {
        return null;
      }

      for (var j = i + 1; j < siblings.length; j++) {
        final candidate = siblings[j];
        if (candidate is BuildTree) {
          final first = candidate.first;
          if (first != null) {
            return first;
          }
        } else {
          return candidate;
        }
      }

      x = x.parent;
    }

    return null;
  }

  /// The container tree.
  BuildTree get parent;

  /// The previous bit in the tree.
  ///
  /// Note: the previous bit may not have the same parent or grandparent,
  /// it's only guaranteed to be within the same tree.
  BuildBit? get prev {
    BuildBit? x = this;

    while (x != null) {
      if (!x.hasParent) {
        return null;
      }
      final siblings = x.parent._children ?? const [];
      final i = siblings.indexOf(x);
      if (i == -1) {
        return null;
      }

      for (var j = i - 1; j > -1; j--) {
        final candidate = siblings[j];
        if (candidate is BuildTree) {
          final last = candidate.last;
          if (last != null) {
            return last;
          }
        } else {
          return candidate;
        }
      }

      x = x.parent;
    }

    return null;
  }

  /// Controls whether to swallow following whitespaces.
  ///
  /// Returns `true` to swallow, `false` to accept whitespace.
  /// Returns `null` to use configuration from the previous bit.
  ///
  /// By default, do swallow if not [isInline].
  bool? get swallowWhitespace {
    final scopedIsInline = isInline;
    return scopedIsInline == null ? null : !scopedIsInline;
  }

  /// Creates a copy with the given fields replaced with the new values.
  BuildBit copyWith({BuildTree? parent});

  /// Flattens this bit.
  void flatten(Flattened f);

  @override
  String toString() => '$runtimeType#$hashCode';
}

/// A tree of [BuildBit]s.
abstract class BuildTree extends BuildBit with NonInheritedPropertiesOwner {
  static final _buffers = Expando<StringBuffer>();

  /// The associated DOM element.
  final dom.Element element;

  /// The [InheritedProperties] resolvers.
  final InheritanceResolvers inheritanceResolvers;

  List<BuildBit>? _children;

  /// Creates a tree.
  BuildTree({
    required this.element,
    required this.inheritanceResolvers,
  });

  /// The list of bits including direct children and sub-tree's.
  Iterable<BuildBit> get bits sync* {
    for (final child in children) {
      if (child is BuildTree) {
        yield* child.bits;
      } else {
        yield child;
      }
    }
  }

  /// The list of direct children.
  Iterable<BuildBit> get children => _children ?? const [];

  /// The first bit (recursively).
  BuildBit? get first {
    for (final child in children) {
      final first = child is BuildTree ? child.first : child;
      if (first != null) {
        return first;
      }
    }

    return null;
  }

  /// Returns `true` if there are no bits (recursively).
  bool get isEmpty {
    for (final child in children) {
      if (child is BuildTree) {
        if (!child.isEmpty) {
          return false;
        }
      } else {
        return false;
      }
    }

    return true;
  }

  /// The last bit (recursively).
  BuildBit? get last {
    final scopedChildren = _children;
    if (scopedChildren == null) {
      return null;
    }

    for (final child in scopedChildren.reversed) {
      final last = child is BuildTree ? child.last : child;
      if (last != null) {
        return last;
      }
    }

    return null;
  }

  /// The styling declarations.
  ///
  /// These are collected from:
  ///
  /// - `HtmlWidget.customStylesBuilder`
  /// - [BuildOp.defaultStyles]
  /// - Attribute `style` of [dom.Element]
  LockableList<css.Declaration> get styles;

  /// Adds an inline style.
  @Deprecated('Use BuildOp.defaultStyles instead.')
  void operator []=(String key, String value);

  /// Gets a styling declaration by [key].
  @Deprecated('Use .getStyle instead.')
  css.Declaration? operator [](String key) => getStyle(key);

  /// Appends [bit].
  ///
  /// See also: [prepend].
  T append<T extends BuildBit>(T bit) {
    final child = bit.parent == this ? bit : bit.copyWith(parent: this);
    final scopedChildren = _children ??= [];
    scopedChildren.add(child);
    return bit;
  }

  /// Adds whitespace.
  BuildBit addWhitespace(String data) => append(WhitespaceBit(this, data));

  /// Adds a string of text.
  TextBit addText(String data) => append(TextBit(this, data));

  /// Builds widget from bits.
  WidgetPlaceholder? build();

  /// Gets a styling declaration by [property].
  css.Declaration? getStyle(String property);

  /// {@macro flutter_widget_from_html.inherit}
  void inherit<T>(
    InheritanceResolverCallback<T> callback, [
    T? input,
  ]) =>
      inheritanceResolvers.enqueue(callback, input);

  /// Prepends [bit].
  ///
  /// See also: [append].
  T prepend<T extends BuildBit>(T bit) {
    final child = bit.parent == this ? bit : bit.copyWith(parent: this);
    final scopedChildren = _children ??= [];
    scopedChildren.insert(0, child);
    return bit;
  }

  /// Registers a build op.
  void register(BuildOp op);

  /// Creates a sub tree without [append]ing.
  BuildTree sub();

  @override
  String toString() {
    // avoid circular references
    final existing = _buffers[this];
    if (existing != null) {
      return 'BuildTree#$hashCode (circular)';
    }

    final sb = _buffers[this] = StringBuffer();
    sb.writeln('BuildTree#$hashCode $inheritanceResolvers:');

    const indent = '  ';
    for (final child in children) {
      sb.write('$indent${child.toString().replaceAll('\n', '\n$indent')}\n');
    }

    final str = sb.toString().trimRight();
    _buffers[this] = null;

    return str;
  }
}

/// A simple text bit.
class TextBit extends BuildBit {
  // The text data.
  final String data;

  @override
  final BuildTree parent;

  /// Creates with string.
  const TextBit(this.parent, this.data);

  @override
  BuildBit copyWith({BuildTree? parent}) =>
      TextBit(parent ?? this.parent, data);

  @override
  void flatten(Flattened f) => f.write(text: data);

  @override
  String toString() => '"$data"';
}

/// A widget bit.
abstract class WidgetBit<T> extends BuildBit {
  /// The widget to be rendered.
  final WidgetPlaceholder child;

  @override
  final BuildTree parent;

  const WidgetBit._(this.parent, this.child);

  /// How the placeholder aligns vertically with the text.
  ///
  /// See [ui.PlaceholderAlignment] for details on each mode.
  PlaceholderAlignment? get alignment => null;

  /// The [TextBaseline] to align against when using [ui.PlaceholderAlignment.baseline],
  /// [ui.PlaceholderAlignment.aboveBaseline], and [ui.PlaceholderAlignment.belowBaseline].
  ///
  /// This is ignored when using other alignment modes.
  TextBaseline? get baseline => null;

  /// Creates a block widget.
  static WidgetBit<Widget> block(BuildTree parent, Widget child) =>
      _WidgetBitBlock(
        parent,
        WidgetPlaceholder.lazy(
          child,
          debugLabel: '${parent.element.localName}--WidgetBit.block',
        ),
      );

  /// Creates an inline widget.
  static WidgetBit<InlineSpan> inline(
    BuildTree parent,
    Widget child, {
    PlaceholderAlignment alignment = PlaceholderAlignment.baseline,
    TextBaseline baseline = TextBaseline.alphabetic,
  }) =>
      _WidgetBitInline(
        parent,
        WidgetPlaceholder.lazy(
          child,
          debugLabel: '${parent.element.localName}--WidgetBit.inline',
        ),
        alignment,
        baseline,
      );
}

class _WidgetBitBlock extends WidgetBit<Widget> {
  const _WidgetBitBlock(super.parent, super.child) : super._();

  @override
  bool? get isInline => false;

  @override
  BuildBit copyWith({BuildTree? parent}) =>
      _WidgetBitBlock(parent ?? this.parent, child);

  @override
  void flatten(Flattened f) => f.widget(child);

  @override
  String toString() => 'WidgetBit.block#$hashCode $child';
}

class _WidgetBitInline extends WidgetBit<InlineSpan> {
  @override
  final PlaceholderAlignment alignment;

  @override
  final TextBaseline baseline;

  const _WidgetBitInline(
    super.parent,
    super.child,
    this.alignment,
    this.baseline,
  ) : super._();

  @override
  BuildBit copyWith({BuildTree? parent}) =>
      _WidgetBitInline(parent ?? this.parent, child, alignment, baseline);

  @override
  void flatten(Flattened f) => f.inlineWidget(
        alignment: alignment,
        baseline: baseline,
        child: child,
      );

  @override
  String toString() => 'WidgetBit.inline#$hashCode $child';
}

/// A whitespace bit.
class WhitespaceBit extends BuildBit {
  /// The whitespace data.
  final String data;

  @override
  final BuildTree parent;

  /// Creates a whitespace.
  const WhitespaceBit(this.parent, this.data);

  @override
  bool get swallowWhitespace => true;

  @override
  BuildBit copyWith({BuildTree? parent}) =>
      WhitespaceBit(parent ?? this.parent, data);

  @override
  void flatten(Flattened f) => f.write(whitespace: data);

  @override
  String toString() => 'Whitespace[${data.codeUnits.join(' ')}]#$hashCode';
}

/// A flattened bit.
abstract class Flattened {
  /// Renders inline widget.
  void inlineWidget({
    PlaceholderAlignment alignment = PlaceholderAlignment.baseline,
    TextBaseline baseline = TextBaseline.alphabetic,
    required Widget child,
  });

  /// Renders block [Widget].
  void widget(Widget value);

  /// Writes textual contents.
  void write({String? text, String? whitespace});
}
