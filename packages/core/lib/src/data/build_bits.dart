part of '../core_data.dart';

/// A piece of HTML being built.
@immutable
abstract class BuildBit {
  /// The container tree.
  final BuildTree? parent;

  /// The associated [TextStyleBuilder].
  final TextStyleBuilder? tsb;

  /// Creates a build bit.
  const BuildBit(this.parent, [this.tsb]);

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

  /// Creates a copy with the given fields replaced with the new values.
  BuildBit copyWith({BuildTree? parent, TextStyleBuilder? tsb});

  /// Removes self from [parent].
  bool detach() => parent?._children.remove(this) ?? false;

  /// Flattens this bit.
  void flatten(Flattened f);

  /// Inserts self after [another] in the tree.
  bool insertAfter(BuildBit another) {
    if (parent == null) {
      return false;
    }

    assert(parent == another.parent);
    final siblings = parent!._children;
    final i = siblings.indexOf(another);
    if (i == -1) {
      return false;
    }

    siblings.insert(i + 1, this);
    return true;
  }

  /// Inserts self before [another] in the tree.
  bool insertBefore(BuildBit another) {
    if (parent == null) {
      return false;
    }

    assert(parent == another.parent);
    final siblings = parent!._children;
    final i = siblings.indexOf(another);
    if (i == -1) {
      return false;
    }

    siblings.insert(i, this);
    return true;
  }

  @override
  String toString() => '$runtimeType#$hashCode $tsb';
}

/// A tree of [BuildBit]s.
abstract class BuildTree extends BuildBit {
  static final _anchors = Expando<List<Key>>();
  static final _buffers = Expando<StringBuffer>();

  final _children = <BuildBit>[];
  final TextStyleBuilder _tsb;

  /// Creates a tree.
  BuildTree(BuildTree? parent, this._tsb) : super(parent, _tsb);

  /// Anchor keys of this tree and its children.
  Iterable<Key>? get anchors => _anchors[this];

  /// The list of bits including direct children and sub-tree's.
  Iterable<BuildBit> get bits sync* {
    for (final child in _children) {
      if (child is BuildTree) {
        yield* child.bits;
      } else {
        yield child;
      }
    }
  }

  /// The list of direct children.
  Iterable<BuildBit> get directChildren => _children;

  /// The first bit (recursively).
  BuildBit? get first {
    for (final child in _children) {
      final first = child is BuildTree ? child.first : child;
      if (first != null) {
        return first;
      }
    }

    return null;
  }

  /// Returns `true` if there are no bits (recursively).
  bool get isEmpty {
    for (final child in _children) {
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

  /// The list of sub-trees.
  Iterable<BuildTree> get subTrees sync* {
    for (final child in directChildren) {
      if (child is! BuildTree) {
        continue;
      }

      yield child;
      yield* child.subTrees;
    }
  }

  @override
  TextStyleBuilder get tsb => _tsb;

  /// Adds [bit] as the last bit.
  T add<T extends BuildBit>(T bit) {
    assert(bit.parent == this);
    _children.add(bit);
    return bit;
  }

  /// Adds whitespace.
  BuildBit addWhitespace(String data) => add(WhitespaceBit(this, data));

  /// Adds a string of text.
  TextBit addText(String data) => add(TextBit(this, data));

  /// Builds widgets from bits.
  Iterable<WidgetPlaceholder> build();

  @override
  BuildBit copyWith({BuildTree? parent, TextStyleBuilder? tsb}) {
    final copied = sub(parent: parent ?? this.parent, tsb: tsb ?? this.tsb);
    for (final bit in _children) {
      copied.add(bit.copyWith(parent: copied));
    }
    return copied;
  }

  /// Registers anchor [Key].
  void registerAnchor(Key anchor) {
    final existing = _anchors[this];
    final anchors = existing ?? (_anchors[this] = []);
    anchors.add(anchor);
    parent?.registerAnchor(anchor);
  }

  /// Creates a sub tree.
  ///
  /// Remember to call [add] to connect the new tree to a parent.
  BuildTree sub({BuildTree? parent, TextStyleBuilder? tsb});

  @override
  String toString() {
    // avoid circular references
    final existing = _buffers[this];
    if (existing != null) {
      return '$runtimeType#$hashCode (circular)';
    }

    final sb = _buffers[this] = StringBuffer();
    sb.writeln('$runtimeType#$hashCode $tsb:');

    const _indent = '  ';
    for (final child in _children) {
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
  TextBit(BuildTree parent, this.data, {TextStyleBuilder? tsb})
      : super(parent, tsb ?? parent.tsb);

  @override
  BuildBit copyWith({BuildTree? parent, TextStyleBuilder? tsb}) =>
      TextBit(parent ?? this.parent!, data, tsb: tsb ?? this.tsb);

  @override
  void flatten(Flattened f) => f.text = data;

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
  BuildBit copyWith({BuildTree? parent, TextStyleBuilder? tsb}) =>
      _WidgetBitBlock(parent ?? this.parent!, child);

  @override
  void flatten(Flattened f) => f.widget = child;

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
  BuildBit copyWith({BuildTree? parent, TextStyleBuilder? tsb}) =>
      _WidgetBitInline(parent ?? this.parent!, child, alignment, baseline);

  @override
  void flatten(Flattened f) => f.span = WidgetSpan(
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
  BuildBit copyWith({BuildTree? parent, TextStyleBuilder? tsb}) =>
      WhitespaceBit(parent ?? this.parent!, data);

  @override
  void flatten(Flattened f) => f.whitespace = data;

  @override
  String toString() => 'Whitespace[${data.codeUnits.join(' ')}]#$hashCode';
}

/// A flattened bit.
class Flattened {
  final List<dynamic>? _values;

  @visibleForTesting
  factory Flattened.forTesting(List<dynamic> values) => Flattened._(values);

  /// Disallows extending this class.
  const Flattened._(this._values);

  /// A no op constant.
  factory Flattened.noOp() => const Flattened._(null);

  /// Returns the current [GestureRecognizer].
  GestureRecognizer? get recognizer =>
      _values?.whereType<GestureRecognizer?>().last;

  /// Sets the [GestureRecognizer].
  set recognizer(GestureRecognizer? value) => _values?.add(value);

  /// Sets the [InlineSpan].
  // ignore: avoid_setters_without_getters
  set span(InlineSpan value) => _values?.add(value);

  /// Sets the contents [String].
  // ignore: avoid_setters_without_getters
  set text(String value) => _values?.add(value);

  /// Sets the whitespace.
  // ignore: avoid_setters_without_getters
  set whitespace(String value) => _values?.add(value);

  /// Sets the [Widget].
  // ignore: avoid_setters_without_getters
  set widget(WidgetPlaceholder value) => _values?.add(value);
}
