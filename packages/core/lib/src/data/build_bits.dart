part of '../core_data.dart';

/// A piece of HTML being built.
///
/// See [buildBit] for supported input types.
@immutable
abstract class BuildBit<T> {
  /// The container tree.
  final BuildTree parent;

  /// The associated [TextStyleBuilder].
  final TextStyleBuilder tsb;

  /// Creates a build bit.
  BuildBit(this.parent, this.tsb);

  /// The next bit in the tree.
  ///
  /// Note: the next bit may not have the same parent or grandparent,
  /// it's only guaranteed to be within the same tree.
  BuildBit get next {
    BuildBit x = this;

    while (x != null) {
      final siblings = x.parent?._children;
      final i = siblings?.indexOf(x) ?? -1;
      if (i != -1) {
        for (var j = i + 1; j < siblings.length; j++) {
          final candidate = siblings[j];
          if (candidate is BuildTree) {
            final first = candidate.first;
            if (first != null) return first;
          } else {
            return candidate;
          }
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
  BuildBit get prev {
    BuildBit x = this;

    while (x != null) {
      final siblings = x.parent?._children;
      final i = siblings?.indexOf(x) ?? -1;
      if (i != -1) {
        for (var j = i - 1; j > -1; j--) {
          final candidate = siblings[j];
          if (candidate is BuildTree) {
            final last = candidate.last;
            if (last != null) return last;
          } else {
            return candidate;
          }
        }
      }

      x = x.parent;
    }

    return null;
  }

  /// Controls whether [BuildTree.addWhitespace] should skip.
  bool get skipAddingWhitespace => false;

  /// Builds input into output.
  ///
  /// Supported input types:
  /// - [GestureRecognizer]
  /// - [Null]
  /// - [TextStyleHtml]
  /// - [TextStyleBuilder]
  ///
  /// Supported output types:
  /// - [GestureRecognizer]
  /// - [InlineSpan]
  /// - [String]
  /// - [Widget]
  /// - [InlineSpan] Function([BuildContext] context)
  ///
  /// Returning an unsupported type or `null` will not trigger any error.
  /// The output will be siliently ignored.
  dynamic buildBit(T input);

  /// Creates a copy with the given fields replaced with the new values.
  BuildBit copyWith({BuildTree parent, TextStyleBuilder tsb});

  /// Removes self from the parent.
  bool detach() => parent?._children?.remove(this);

  /// Inserts self after [another] in the tree.
  bool insertAfter(BuildBit another) {
    if (parent == null) return false;

    assert(parent == another.parent);
    final siblings = parent._children;
    final i = siblings.indexOf(another);
    if (i == -1) return false;

    siblings.insert(i + 1, this);
    return true;
  }

  /// Inserts self before [another] in the tree.
  bool insertBefore(BuildBit another) {
    if (parent == null) return false;

    assert(parent == another.parent);
    final siblings = parent._children;
    final i = siblings.indexOf(another);
    if (i == -1) return false;

    siblings.insert(i, this);
    return true;
  }

  @override
  String toString() => '$runtimeType#$hashCode $tsb';
}

/// A tree of [BuildBit]s.
abstract class BuildTree extends BuildBit<Null> {
  final _children = <BuildBit>[];

  /// Creates a tree.
  BuildTree(BuildTree parent, TextStyleBuilder tsb) : super(parent, tsb);

  /// The list of bits including direct children and their children.
  Iterable<BuildBit> get bits sync* {
    for (final child in _children) {
      if (child is BuildTree) {
        yield* child.bits;
      } else {
        yield child;
      }
    }
  }

  /// The first bit (recursively).
  BuildBit get first {
    for (final child in _children) {
      final first = child is BuildTree ? child.first : child;
      if (first != null) return first;
    }

    return null;
  }

  /// Returns `true` if there are no bits (recursively).
  bool get isEmpty {
    for (final child in _children) {
      if (child is BuildTree) {
        if (!child.isEmpty) return false;
      } else {
        return false;
      }
    }

    return true;
  }

  /// The last bit (recursively).
  BuildBit get last {
    for (final child in _children.reversed) {
      final last = child is BuildTree ? child.last : child;
      if (last != null) return last;
    }

    return null;
  }

  /// Adds [bit] to the tail of this tree.
  BuildBit add(BuildBit bit) {
    assert(bit.parent == this);
    _children.add(bit);
    return bit;
  }

  /// Adds a new line to the tail of this tree.
  BuildBit addNewLine() => add(_TextNewLine(this, tsb));

  /// Adds a new whitespace to the tail of this tree.
  BuildBit addWhitespace() {
    final tail = last ?? prev;
    if (tail == null) return null;
    if (tail.skipAddingWhitespace) return tail;

    final bit = _TextWhitespace(this);
    add(bit);
    return bit;
  }

  /// Adds a string to the tail of this tree.
  TextBit addText(String data) => add(TextBit(this, data));

  /// Builds widgets from bits.
  Iterable<WidgetPlaceholder> build();

  @override
  Iterable<WidgetPlaceholder> buildBit(Null _) => build();

  /// Replaces children bits with [another].
  void replaceWith(BuildBit another) {
    assert(another.parent == this);
    _children
      ..clear()
      ..add(another);
  }

  /// Creates a sub tree.
  BuildTree sub(TextStyleBuilder tsb);

  @override
  String toString() {
    final sb = StringBuffer();

    const _indent = '  ';
    for (final child in _children) {
      sb.write('$_indent${child.toString().replaceAll('\n', '\n$_indent')}\n');
    }

    return 'BuildTree#$hashCode $tsb:\n$sb'.trimRight();
  }
}

/// A simple text bit.
class TextBit extends BuildBit<Null> {
  final String data;

  TextBit._(BuildTree parent, TextStyleBuilder tsb, this.data)
      : super(parent, tsb);

  /// Creates with string,
  factory TextBit(BuildTree parent, String data, {TextStyleBuilder tsb}) =>
      TextBit._(parent, tsb ?? parent.tsb, data);

  @override
  String buildBit(Null _) => data;

  @override
  BuildBit copyWith({BuildTree parent, TextStyleBuilder tsb}) =>
      TextBit._(parent ?? this.parent, tsb ?? this.tsb, data);

  @override
  String toString() => '"$data"';
}

/// A widget bit.
class WidgetBit<T> extends BuildBit<Null> {
  /// See [PlaceholderSpan.alignment].
  final PlaceholderAlignment alignment;

  /// See [PlaceholderSpan.baseline].
  final TextBaseline baseline;

  /// The widget to be rendered.
  final WidgetPlaceholder<T> child;

  WidgetBit._(
    BuildTree parent,
    TextStyleBuilder tsb,
    this.alignment,
    this.baseline,
    this.child,
  ) : super(parent, tsb);

  /// Creates an block widget.
  factory WidgetBit.block(
    BuildTree parent,
    WidgetPlaceholder child, {
    TextStyleBuilder tsb,
  }) =>
      WidgetBit._(parent, tsb ?? parent.tsb, null, null, child);

  /// Creates an inline widget.
  factory WidgetBit.inline(
    BuildTree parent,
    WidgetPlaceholder child, {
    PlaceholderAlignment alignment = PlaceholderAlignment.baseline,
    TextBaseline baseline = TextBaseline.alphabetic,
    TextStyleBuilder tsb,
  }) =>
      WidgetBit._(parent, tsb ?? parent.tsb, alignment, baseline, child);

  @override
  bool get skipAddingWhitespace => !isInline;

  /// Returns `true` if widget should be rendered inline.
  bool get isInline => alignment != null && baseline != null;

  @override
  dynamic buildBit(Null _) => isInline
      ? WidgetSpan(
          alignment: alignment,
          baseline: baseline,
          child: child,
        )
      : child;

  @override
  BuildBit copyWith({BuildTree parent, TextStyleBuilder tsb}) => WidgetBit._(
      parent ?? this.parent, tsb ?? this.tsb, alignment, baseline, child);

  @override
  String toString() =>
      'WidgetBit.${isInline ? "inline" : "block"}#$hashCode $child';
}

class _TextNewLine extends BuildBit<Null> {
  _TextNewLine(BuildTree parent, TextStyleBuilder tsb) : super(parent, tsb);

  @override
  bool get skipAddingWhitespace => true;

  @override
  String buildBit(Null _) => '\n';

  @override
  BuildBit copyWith({BuildTree parent, TextStyleBuilder tsb}) =>
      _TextNewLine(parent ?? this.parent, tsb ?? this.tsb);
}

class _TextWhitespace extends BuildBit<Null> {
  _TextWhitespace(BuildTree parent) : super(parent, null);

  @override
  bool get skipAddingWhitespace => true;

  @override
  String buildBit(Null _) => ' ';

  @override
  BuildBit copyWith({BuildTree parent, TextStyleBuilder tsb}) =>
      _TextWhitespace(parent ?? this.parent);

  @override
  String toString() => 'Whitespace#$hashCode';
}
