part of '../core_data.dart';

/// A piece of HTML being built.
///
/// See [buildBit] for supported input and output types.
@immutable
abstract class BuildBit<InputType, OutputType> {
  /// The container tree.
  final BuildTree? parent;

  /// The associated [TextStyleBuilder].
  final TextStyleBuilder tsb;

  /// Creates a build bit.
  const BuildBit(this.parent, this.tsb);

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

  /// Builds input into output.
  ///
  /// Supported input types:
  /// - [BuildContext] (output must be `Widget`)
  /// - [GestureRecognizer]
  /// - [TextStyleHtml] (output must be `InlineSpan`)
  /// - [void]
  ///
  /// Supported output types:
  /// - [BuildTree]
  /// - [GestureRecognizer]
  /// - [InlineSpan]
  /// - [String]
  /// - [Widget]
  ///
  /// Returning an unsupported type or `null` will not trigger any error.
  /// The output will be siliently ignored.
  OutputType buildBit(InputType input);

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

  @override
  String toString() => '$runtimeType#$hashCode $tsb';
}

/// A tree of [BuildBit]s.
abstract class BuildTree extends BuildBit<void, Iterable<Widget>> {
  static final _anchors = Expando<List<Key>>();
  static final _buffers = Expando<StringBuffer>();

  final _children = <BuildBit>[];

  /// Creates a tree.
  BuildTree(BuildTree? parent, TextStyleBuilder tsb) : super(parent, tsb);

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
  Iterable<WidgetPlaceholder> buildBit(void _) => build();

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

    const indent = '  ';
    for (final child in _children) {
      sb.write('$indent${child.toString().replaceAll('\n', '\n$indent')}\n');
    }

    final str = sb.toString().trimRight();
    _buffers[this] = null;

    return str;
  }
}

/// A simple text bit.
class TextBit extends BuildBit<void, String> {
  final String data;

  /// Creates with string.
  TextBit(BuildTree parent, this.data, {TextStyleBuilder? tsb})
      : super(parent, tsb ?? parent.tsb);

  @override
  String buildBit(void _) => data;

  @override
  BuildBit copyWith({BuildTree? parent, TextStyleBuilder? tsb}) =>
      TextBit(parent ?? this.parent!, data, tsb: tsb ?? this.tsb);

  @override
  String toString() => '"$data"';
}

/// A widget bit.
class WidgetBit extends BuildBit<void, dynamic> {
  /// See [PlaceholderSpan.alignment].
  final PlaceholderAlignment? alignment;

  /// See [PlaceholderSpan.baseline].
  final TextBaseline? baseline;

  /// The widget to be rendered.
  final WidgetPlaceholder child;

  const WidgetBit._(
    BuildTree parent,
    TextStyleBuilder tsb,
    this.child, [
    this.alignment,
    this.baseline,
  ]) : super(parent, tsb);

  /// Creates a block widget.
  factory WidgetBit.block(
    BuildTree parent,
    Widget child, {
    TextStyleBuilder? tsb,
  }) =>
      WidgetBit._(parent, tsb ?? parent.tsb, WidgetPlaceholder.lazy(child));

  /// Creates an inline widget.
  factory WidgetBit.inline(
    BuildTree parent,
    Widget child, {
    PlaceholderAlignment alignment = PlaceholderAlignment.bottom,
    TextBaseline baseline = TextBaseline.alphabetic,
    TextStyleBuilder? tsb,
  }) =>
      WidgetBit._(
        parent,
        tsb ?? parent.tsb,
        WidgetPlaceholder.lazy(child),
        alignment,
        baseline,
      );

  @override
  bool get isInline => alignment != null && baseline != null;

  @override
  dynamic buildBit(void _) => isInline
      ? WidgetSpan(
          alignment: alignment!,
          baseline: baseline,
          child: child,
        )
      : child;

  @override
  BuildBit copyWith({BuildTree? parent, TextStyleBuilder? tsb}) => WidgetBit._(
        parent ?? this.parent!,
        tsb ?? this.tsb,
        child,
        alignment,
        baseline,
      );

  @override
  String toString() =>
      'WidgetBit.${isInline ? "inline" : "block"}#$hashCode $child';
}

/// A whitespace bit.
class WhitespaceBit extends BuildBit<void, String> {
  final String data;

  /// Creates a whitespace.
  WhitespaceBit(BuildTree parent, this.data, {TextStyleBuilder? tsb})
      : super(parent, tsb ?? parent.tsb);

  @override
  bool get swallowWhitespace => true;

  @override
  String buildBit(void _) => data;

  @override
  BuildBit copyWith({BuildTree? parent, TextStyleBuilder? tsb}) =>
      WhitespaceBit(parent ?? this.parent!, data, tsb: tsb ?? this.tsb);

  @override
  String toString() => 'Whitespace[${data.codeUnits.join(' ')}]#$hashCode';
}
