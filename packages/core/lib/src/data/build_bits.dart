part of '../core_data.dart';

/// A piece of HTML being built.
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
  /// Supported output types:
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

  /// Replaces self with [another].
  bool replaceWith(BuildBit another) {
    if (parent == null) return false;

    assert(parent == another.parent);
    final siblings = parent._children;
    final i = siblings.indexOf(this);
    if (i == -1) return false;

    siblings[i] = another;
    return true;
  }

  @override
  String toString() => '$runtimeType#$hashCode $tsb';

  /// Trims leading whitespaces.
  ///
  /// Returns `true` if at least one bit has been detached.
  bool trimLeft() => false;

  /// Trims trailing whitespaces.
  ///
  /// Returns `true` if at least one bit has been detached.
  bool trimRight() => false;
}

/// A simple data bit.
class TextData extends BuildBit<void> {
  final String data;

  TextData._(BuildTree parent, TextStyleBuilder tsb, this.data)
      : super(parent, tsb);

  /// Creates with data string,
  factory TextData(BuildTree parent, String data, {TextStyleBuilder tsb}) =>
      TextData._(parent, tsb ?? parent.tsb, data);

  @override
  String buildBit(void _) => data;

  @override
  BuildBit copyWith({BuildTree parent, TextStyleBuilder tsb}) =>
      TextData._(parent ?? this.parent, tsb ?? this.tsb, data);

  @override
  String toString() => '"$data"';
}

/// An inline widget to be rendered within text.
class TextWidget<T> extends BuildBit<void> {
  /// See [PlaceholderSpan.alignment].
  final PlaceholderAlignment alignment;

  /// See [PlaceholderSpan.baseline].
  final TextBaseline baseline;

  /// The widget to be rendered.
  final WidgetPlaceholder<T> child;

  TextWidget._(
    BuildTree parent,
    TextStyleBuilder tsb,
    this.alignment,
    this.baseline,
    this.child,
  ) : super(parent, tsb);

  /// Creates an inline widget.
  factory TextWidget(
    BuildTree parent,
    WidgetPlaceholder child, {
    PlaceholderAlignment alignment = PlaceholderAlignment.baseline,
    TextBaseline baseline = TextBaseline.alphabetic,
    TextStyleBuilder tsb,
  }) =>
      TextWidget._(parent, tsb ?? parent.tsb, alignment, baseline, child);

  @override
  InlineSpan buildBit(void _) => WidgetSpan(
        alignment: alignment,
        baseline: baseline,
        child: child,
      );

  @override
  BuildBit copyWith({BuildTree parent, TextStyleBuilder tsb}) => TextWidget._(
      parent ?? this.parent, tsb ?? this.tsb, alignment, baseline, child);

  @override
  String toString() => 'TextWidget#$hashCode $child';
}

/// A tree of [BuildBit]s.
abstract class BuildTree extends BuildBit<void> {
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
  TextData addText(String data) => add(TextData(this, data));

  /// Builds widgets from bits.
  Iterable<Widget> build();

  @override
  Iterable<Widget> buildBit(void _) => build();

  /// Creates a sub tree.
  BuildTree sub(TextStyleBuilder tsb);

  @override
  bool trimLeft() {
    var trimmed = false;

    while (_children.isNotEmpty) {
      if (_children.first.trimLeft()) {
        trimmed = true;
      } else {
        break;
      }
    }

    if (_children.isEmpty) {
      detach();
      trimmed = true;
    }

    return trimmed;
  }

  @override
  bool trimRight() {
    var trimmed = false;

    while (_children.isNotEmpty) {
      if (_children.last.trimRight()) {
        trimmed = true;
      } else {
        break;
      }
    }

    if (_children.isEmpty) {
      detach();
      trimmed = true;
    }

    return trimmed;
  }

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

class _TextNewLine extends BuildBit<void> {
  _TextNewLine(BuildTree parent, TextStyleBuilder tsb) : super(parent, tsb);

  @override
  bool get skipAddingWhitespace => true;

  @override
  String buildBit(void input) => '\n';

  @override
  BuildBit copyWith({BuildTree parent, TextStyleBuilder tsb}) =>
      _TextNewLine(parent ?? this.parent, tsb ?? this.tsb);
}

class _TextWhitespace extends BuildBit<void> {
  _TextWhitespace(BuildTree parent) : super(parent, null);

  @override
  bool get skipAddingWhitespace => true;

  @override
  String buildBit(void _) => ' ';

  @override
  BuildBit copyWith({BuildTree parent, TextStyleBuilder tsb}) =>
      _TextWhitespace(parent ?? this.parent);

  @override
  String toString() => 'Whitespace#$hashCode';

  @override
  bool trimLeft() => detach();

  @override
  bool trimRight() => detach();
}
