part of '../core_data.dart';

/// A piece of HTML being built.
@immutable
abstract class BuildBit {
  /// The container tree.
  final BuildTree? parent;

  /// Creates a build bit.
  const BuildBit(this.parent);

  /// Returns true if this bit should be rendered inline.
  bool get isInline => true;

  /// The next bit in the tree.
  ///
  /// Note: the next bit may not have the same parent or grandparent,
  /// it's only guaranteed to be within the same tree.
  BuildBit? get next {
    BuildBit? x = this;

    while (x != null) {
      final siblings = x.parent?._children;
      final i = siblings?.indexOf(x) ?? -1;
      if (i == -1) {
        return null;
      }

      for (var j = i + 1; j < siblings!.length; j++) {
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

  /// The previous bit in the tree.
  ///
  /// Note: the previous bit may not have the same parent or grandparent,
  /// it's only guaranteed to be within the same tree.
  BuildBit? get prev {
    BuildBit? x = this;

    while (x != null) {
      final siblings = x.parent?._children;
      final i = siblings?.indexOf(x) ?? -1;
      if (i == -1) {
        return null;
      }

      for (var j = i - 1; j > -1; j--) {
        final candidate = siblings![j];
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
  bool? get swallowWhitespace => !isInline;

  /// The associated [HtmlStyle] builder.
  /// TODO: rename
  HtmlStyleBuilder get tsb {
    final tsb = parent?.tsb;
    return tsb!;
  }

  /// Creates a copy with the given fields replaced with the new values.
  BuildBit copyWith({BuildTree? parent});

  /// Flattens this bit.
  void flatten(Flattened f);

  @override
  String toString() => '$runtimeType#$hashCode $tsb';
}

/// A tree of [BuildBit]s.
abstract class BuildTree extends BuildBit {
  static final _anchors = Expando<List<Key>>();
  static final _buffers = Expando<StringBuffer>();

  final _children = <BuildBit>[];

  /// The list of direct children.
  Iterable<BuildBit> get children => _children;

  /// Creates a tree.
  BuildTree(BuildTree? parent) : super(parent);

  /// Anchor keys of this tree and its children.
  Iterable<Key>? get anchors => _anchors[this];

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
    for (final child in _children.reversed) {
      final last = child is BuildTree ? child.last : child;
      if (last != null) {
        return last;
      }
    }

    return null;
  }

  /// Appends [bit].
  @Deprecated('Use append instead')
  T add<T extends BuildBit>(T bit) => append(bit);

  /// Appends [bit].
  ///
  /// See also: [prepend].
  T append<T extends BuildBit>(T bit) {
    final child = bit.parent == this ? bit : bit.copyWith(parent: this);
    _children.add(child);
    return bit;
  }

  /// Adds whitespace.
  BuildBit addWhitespace(String data) => append(WhitespaceBit(this, data));

  /// Adds a string of text.
  TextBit addText(String data) => append(TextBit(this, data));

  /// Builds widgets from bits.
  Iterable<WidgetPlaceholder> build();

  /// Prepends [bit].
  ///
  /// See also: [append].
  T prepend<T extends BuildBit>(T bit) {
    final child = bit.parent == this ? bit : bit.copyWith(parent: this);
    _children.insert(0, child);
    return bit;
  }

  /// Replaces all children bits with [another].
  void replaceWith(BuildBit? another) {
    _children.clear();

    if (another != null) {
      final child =
          another.parent == this ? another : another.copyWith(parent: this);
      _children.add(child);
    }
  }

  /// Registers anchor [Key].
  void registerAnchor(Key anchor) {
    final existing = _anchors[this];
    final anchors = existing ?? (_anchors[this] = []);
    anchors.add(anchor);
    parent?.registerAnchor(anchor);
  }

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
    sb.writeln('BuildTree#$hashCode $tsb:');

    const _indent = '  ';
    for (final child in children) {
      sb.write('$_indent${child.toString().replaceAll('\n', '\n$_indent')}\n');
    }

    final str = sb.toString().trimRight();
    _buffers[this] = null;

    return str;
  }
}

/// A simple text bit.
class TextBit extends BuildBit {
  final String data;

  /// Creates with string.
  const TextBit(BuildTree parent, this.data) : super(parent);

  @override
  BuildBit copyWith({BuildTree? parent}) =>
      TextBit(parent ?? this.parent!, data);

  @override
  void flatten(Flattened f) => f.write(text: data);

  @override
  String toString() => '"$data"';
}

/// A widget bit.
abstract class WidgetBit<T> extends BuildBit {
  /// The widget to be rendered.
  final WidgetPlaceholder child;

  const WidgetBit._(BuildTree parent, this.child) : super(parent);

  /// Creates a block widget.
  static WidgetBit<Widget> block(BuildTree parent, Widget child) =>
      _WidgetBitBlock(parent, WidgetPlaceholder.lazy(child));

  /// Creates an inline widget.
  static WidgetBit<InlineSpan> inline(
    BuildTree parent,
    Widget child, {
    PlaceholderAlignment alignment = PlaceholderAlignment.bottom,
    TextBaseline baseline = TextBaseline.alphabetic,
  }) =>
      _WidgetBitInline(
        parent,
        WidgetPlaceholder.lazy(child),
        alignment,
        baseline,
      );
}

class _WidgetBitBlock extends WidgetBit<Widget> {
  const _WidgetBitBlock(BuildTree parent, WidgetPlaceholder child)
      : super._(parent, child);

  @override
  bool get isInline => false;

  @override
  BuildBit copyWith({BuildTree? parent}) =>
      _WidgetBitBlock(parent ?? this.parent!, child);

  @override
  void flatten(Flattened f) => f.widget(child);

  @override
  String toString() => 'WidgetBit.block#$hashCode $child';
}

class _WidgetBitInline extends WidgetBit<InlineSpan> {
  final PlaceholderAlignment alignment;
  final TextBaseline baseline;

  const _WidgetBitInline(
    BuildTree parent,
    WidgetPlaceholder child,
    this.alignment,
    this.baseline,
  ) : super._(parent, child);

  @override
  BuildBit copyWith({BuildTree? parent}) =>
      _WidgetBitInline(parent ?? this.parent!, child, alignment, baseline);

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
  final String data;

  /// Creates a whitespace.
  const WhitespaceBit(BuildTree parent, this.data) : super(parent);

  @override
  bool get swallowWhitespace => true;

  @override
  BuildBit copyWith({BuildTree? parent}) =>
      WhitespaceBit(parent ?? this.parent!, data);

  @override
  void flatten(Flattened f) => f.write(whitespace: data);

  @override
  String toString() => 'Whitespace[${data.codeUnits.join(' ')}]#$hashCode';
}

/// A flattened bit.
abstract class Flattened {
  /// Renders inline widget.
  void inlineWidget({
    PlaceholderAlignment alignment = PlaceholderAlignment.bottom,
    TextBaseline baseline = TextBaseline.alphabetic,
    required WidgetPlaceholder child,
  });

  /// Renders block [Widget].
  void widget(WidgetPlaceholder value);

  /// Writes textual contents.
  void write({String? text, String? whitespace});
}
