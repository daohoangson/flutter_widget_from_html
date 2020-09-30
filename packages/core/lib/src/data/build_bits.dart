part of '../core_data.dart';

/// A piece of HTML being built.
///
/// See [buildBit] for supported input and output types.
@immutable
abstract class BuildBit<InputType, OutputType> {
  /// The container tree.
  final BuildTree parent;

  /// The associated [TextStyleBuilder].
  final TextStyleBuilder tsb;

  /// Creates a build bit.
  ///
  /// [tsb] must be non-null unless this is a whitespace.
  BuildBit(this.parent, this.tsb);

  /// Returns true if this bit should be rendered inline.
  bool get isInline => true;

  /// The next bit in the tree.
  ///
  /// Note: the next bit may not have the same parent or grandparent,
  /// it's only guaranteed to be within the same tree.
  BuildBit get next {
    BuildBit x = this;

    while (x != null) {
      final siblings = x.parent?._children;
      final i = siblings?.indexOf(x) ?? -1;
      if (i == -1) return null;

      for (var j = i + 1; j < siblings.length; j++) {
        final candidate = siblings[j];
        if (candidate is BuildTree) {
          final first = candidate.first;
          if (first != null) return first;
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
  BuildBit get prev {
    BuildBit x = this;

    while (x != null) {
      final siblings = x.parent?._children;
      final i = siblings?.indexOf(x) ?? -1;
      if (i == -1) return null;

      for (var j = i - 1; j > -1; j--) {
        final candidate = siblings[j];
        if (candidate is BuildTree) {
          final last = candidate.last;
          if (last != null) return last;
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
  bool get swallowWhitespace => !isInline;

  /// Builds input into output.
  ///
  /// Supported input types:
  /// - [BuildContext] (output must be `Widget`)
  /// - [GestureRecognizer]
  /// - [Null]
  /// - [TextStyleHtml] (output must be `InlineSpan`)
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
  BuildBit copyWith({BuildTree parent, TextStyleBuilder tsb});

  /// Removes self from [parent].
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
abstract class BuildTree extends BuildBit<Null, Iterable<Widget>> {
  final _children = <BuildBit>[];
  final _toStringBuffer = StringBuffer();

  /// Creates a tree.
  BuildTree(BuildTree parent, TextStyleBuilder tsb) : super(parent, tsb);

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

  /// Adds [bit] as the last bit.
  BuildBit add(BuildBit bit) {
    assert(bit.parent == this);
    _children.add(bit);
    return bit;
  }

  /// Adds a new line.
  BuildBit addNewLine() => add(_TextNewLine(this, tsb));

  /// Adds a whitespace.
  BuildBit addWhitespace() => add(_TextWhitespace(this));

  /// Adds a string of text.
  TextBit addText(String data) => add(TextBit(this, data));

  /// Builds widgets from bits.
  Iterable<WidgetPlaceholder> build();

  @override
  Iterable<WidgetPlaceholder> buildBit(Null _) => build();

  @override
  BuildBit copyWith({BuildTree parent, TextStyleBuilder tsb}) {
    final copied = sub(parent: parent ?? this.parent, tsb: tsb ?? this.tsb);
    for (final bit in _children) {
      copied.add(bit.copyWith(parent: copied));
    }
    return copied;
  }

  /// Replaces all children bits with [another].
  void replaceWith(BuildBit another) {
    assert(another.parent == this);
    _children
      ..clear()
      ..add(another);
  }

  /// Creates a sub tree.
  ///
  /// Remember to call [add] to connect the new tree to a parent.
  BuildTree sub({BuildTree parent, TextStyleBuilder tsb});

  @override
  String toString() {
    // avoid circular references
    if (_toStringBuffer.length > 0) return '$runtimeType#$hashCode';

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

/// A simple text bit.
class TextBit extends BuildBit<Null, String> {
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
class WidgetBit<T> extends BuildBit<Null, dynamic> {
  /// See [PlaceholderSpan.alignment].
  final PlaceholderAlignment alignment;

  /// See [PlaceholderSpan.baseline].
  final TextBaseline baseline;

  /// The widget to be rendered.
  final WidgetPlaceholder<T> child;

  WidgetBit._(
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
    TextStyleBuilder tsb,
  }) =>
      WidgetBit._(parent, tsb ?? parent.tsb, WidgetPlaceholder.lazy(child));

  /// Creates an inline widget.
  factory WidgetBit.inline(
    BuildTree parent,
    Widget child, {
    PlaceholderAlignment alignment = PlaceholderAlignment.baseline,
    TextBaseline baseline = TextBaseline.alphabetic,
    TextStyleBuilder tsb,
  }) =>
      WidgetBit._(parent, tsb ?? parent.tsb, WidgetPlaceholder.lazy(child),
          alignment, baseline);

  @override
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
      parent ?? this.parent, tsb ?? this.tsb, child, alignment, baseline);

  @override
  String toString() =>
      'WidgetBit.${isInline ? "inline" : "block"}#$hashCode $child';
}

class _TextNewLine extends BuildBit<Null, String> {
  _TextNewLine(BuildTree parent, TextStyleBuilder tsb) : super(parent, tsb);

  @override
  bool get swallowWhitespace => true;

  @override
  String buildBit(Null _) => '\n';

  @override
  BuildBit copyWith({BuildTree parent, TextStyleBuilder tsb}) =>
      _TextNewLine(parent ?? this.parent, tsb ?? this.tsb);
}

class _TextWhitespace extends BuildBit<Null, String> {
  _TextWhitespace(BuildTree parent) : super(parent, null);

  @override
  bool get swallowWhitespace => true;

  @override
  String buildBit(Null _) => ' ';

  @override
  BuildBit copyWith({BuildTree parent, TextStyleBuilder tsb}) =>
      _TextWhitespace(parent ?? this.parent);

  @override
  String toString() => 'Whitespace#$hashCode';
}
