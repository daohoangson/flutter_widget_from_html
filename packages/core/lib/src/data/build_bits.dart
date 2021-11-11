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

  /// Flattens this bit on demand.
  ///
  /// See [Flattener._loop]
  void onFlatten(FlattenState flattener);

  @override
  String toString() => '$runtimeType#$hashCode $tsb';
}

/// A tree of [BuildBit]s.
abstract class BuildTree extends BuildBit {
  static final _anchors = Expando<List<Key>>();

  final _children = <BuildBit>[];
  final _toStringBuffer = StringBuffer();
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

  @override
  void onFlatten(FlattenState flattener) {}

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
    if (_toStringBuffer.length > 0) {
      return '$runtimeType#$hashCode (circular)';
    }

    final sb = _toStringBuffer;
    sb.writeln('$runtimeType#$hashCode $tsb:');

    const _indent = '  ';
    for (final child in _children) {
      sb.write('$_indent${child.toString().replaceAll('\n', '\n$_indent')}\n');
    }

    final str = sb.toString().trimRight();
    sb.clear();

    return str;
  }
}

abstract class FlattenState {
  GestureRecognizer? get recognizer;
  set recognizer(GestureRecognizer? value);

  bool get swallowWhitespace;

  void addSpan(InlineSpan value);

  void addText(String value);

  void addWhitespace(String value, {required bool shouldBeSwallowed});

  void addWidget(Widget value);
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
  void onFlatten(FlattenState flattener) => flattener.addText(data);

  @override
  String toString() => '"$data"';
}

/// A widget bit.
abstract class WidgetBit<T> extends BuildBit {
  /// The widget to be rendered.
  final WidgetPlaceholder child;

  const WidgetBit._(BuildTree parent, TextStyleBuilder? tsb, this.child)
      : super(parent, tsb);

  /// Creates a block widget.
  static WidgetBit<Widget> block(
    BuildTree parent,
    Widget child, {
    TextStyleBuilder? tsb,
  }) =>
      _WidgetBitBlock(parent, tsb ?? parent.tsb, WidgetPlaceholder.lazy(child));

  /// Creates an inline widget.
  static WidgetBit<InlineSpan> inline(
    BuildTree parent,
    Widget child, {
    PlaceholderAlignment alignment = PlaceholderAlignment.bottom,
    TextBaseline baseline = TextBaseline.alphabetic,
    TextStyleBuilder? tsb,
  }) =>
      _WidgetBitInline(
        parent,
        tsb ?? parent.tsb,
        WidgetPlaceholder.lazy(child),
        alignment,
        baseline,
      );
}

class _WidgetBitBlock extends WidgetBit<Widget> {
  const _WidgetBitBlock(
    BuildTree parent,
    TextStyleBuilder? tsb,
    WidgetPlaceholder child,
  ) : super._(parent, tsb, child);

  @override
  bool get isInline => false;

  @override
  BuildBit copyWith({BuildTree? parent, TextStyleBuilder? tsb}) =>
      _WidgetBitBlock(parent ?? this.parent!, tsb ?? this.tsb, child);

  @override
  void onFlatten(FlattenState flattener) => flattener.addWidget(child);

  @override
  String toString() => 'WidgetBit.block#$hashCode $child';
}

class _WidgetBitInline extends WidgetBit<InlineSpan> {
  final PlaceholderAlignment alignment;
  final TextBaseline baseline;

  const _WidgetBitInline(
    BuildTree parent,
    TextStyleBuilder? tsb,
    WidgetPlaceholder child,
    this.alignment,
    this.baseline,
  ) : super._(parent, tsb, child);

  @override
  BuildBit copyWith({BuildTree? parent, TextStyleBuilder? tsb}) =>
      _WidgetBitInline(
        parent ?? this.parent!,
        tsb ?? this.tsb,
        child,
        alignment,
        baseline,
      );

  @override
  void onFlatten(FlattenState flattener) => flattener.addSpan(
        WidgetSpan(
          alignment: alignment,
          baseline: baseline,
          child: child,
        ),
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
  TextStyleBuilder? get tsb {
    // the below code will find the best style for this whitespace bit
    // easy case: whitespace at the beginning of a tag, use the previous style
    final parent = this.parent;
    if (parent == null || this == parent.first) {
      return null;
    }

    // complicated: whitespace at the end of a tag, try to merge with the next
    // unless it has unrelated style (e.g. next bit is a sibling)
    if (this == parent.last) {
      final next = nextNonWhitespace;
      if (next != null) {
        var tree = parent;
        while (tree.parent?.last == this) {
          tree = tree.parent!;
        }

        if (tree.parent == next.parent) {
          return next.tsb;
        } else {
          return null;
        }
      }
    }

    // fallback to parent's
    return parent.tsb;
  }

  @override
  BuildBit copyWith({BuildTree? parent, TextStyleBuilder? tsb}) =>
      WhitespaceBit(parent ?? this.parent!, data);

  @override
  void onFlatten(FlattenState flattener) {
    final shouldBeSwallowed = _shouldBeSwallowed(flattener);

    flattener.addWhitespace(
      data,
      shouldBeSwallowed: shouldBeSwallowed,
    );
  }

  @override
  String toString() => 'Whitespace[${data.codeUnits.join(' ')}]#$hashCode';

  bool _shouldBeSwallowed(FlattenState flattener) {
    if (flattener.swallowWhitespace) {
      return true;
    }

    final next = nextNonWhitespace;
    if (next != null && !next.isInline) {
      // skip whitespace before a new block
      return true;
    }

    return false;
  }
}

extension _BuildBit on BuildBit {
  BuildBit? get nextNonWhitespace {
    var next = this.next;
    while (next != null && next is WhitespaceBit) {
      next = next.next;
    }

    return next;
  }
}
