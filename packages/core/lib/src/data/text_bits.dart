part of '../core_data.dart';

/// A bit of text.
@immutable
abstract class TextBit<CompileFrom, CompileTo> {
  /// The container [TextBits].
  final TextBits parent;

  /// The associated [TextStyleBuilder].
  final TextStyleBuilder tsb;

  /// Create a text bit.
  TextBit(this.parent, this.tsb);

  /// The next bit in the text tree.
  ///
  /// Note: the next bit may not have the same parent or grandparent,
  /// it's only guaranteed to be within the same tree.
  TextBit get next {
    TextBit x = this;

    while (x != null) {
      final siblings = x.parent?._children;
      final i = siblings?.indexOf(x) ?? -1;
      if (i != -1) {
        for (var j = i + 1; j < siblings.length; j++) {
          final candidate = siblings[j];
          if (candidate is TextBits) {
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

  /// The previous bit in the text tree.
  ///
  /// Note: the previous bit may not have the same parent or grandparent,
  /// it's only guaranteed to be within the same tree.
  TextBit get prev {
    TextBit x = this;

    while (x != null) {
      final siblings = x.parent?._children;
      final i = siblings?.indexOf(x) ?? -1;
      if (i != -1) {
        for (var j = i - 1; j > -1; j--) {
          final candidate = siblings[j];
          if (candidate is TextBits) {
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

  /// Compiles input into output.
  CompileTo compile(CompileFrom input) => throw UnimplementedError();

  /// Removes self from the parent.
  bool detach() => parent?._children?.remove(this);

  /// Inserts self after [another] in the text tree.
  bool insertAfter(TextBit another) {
    if (parent == null) return false;

    assert(parent == another.parent);
    final siblings = parent._children;
    final i = siblings.indexOf(another);
    if (i == -1) return false;

    siblings.insert(i + 1, this);
    return true;
  }

  /// Inserts self before [another] in the text tree.
  bool insertBefore(TextBit another) {
    if (parent == null) return false;

    assert(parent == another.parent);
    final siblings = parent._children;
    final i = siblings.indexOf(another);
    if (i == -1) return false;

    siblings.insert(i, this);
    return true;
  }

  /// Replaces self with [another].
  bool replaceWith(TextBit another) {
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
}

/// A simple data bit.
class TextData extends TextBit<void, String> {
  final String _data;

  /// Creates with data string
  TextData(TextBits parent, this._data) : super(parent, parent.tsb);

  @override
  String compile(void _) => _data;

  @override
  String toString() => '"$_data"';
}

/// An inline widget to be rendered within text paragraph.
class TextWidget<T> extends TextBit<TextStyleHtml, InlineSpan> {
  /// See [PlaceholderSpan.alignment].
  final PlaceholderAlignment alignment;

  /// See [PlaceholderSpan.baseline].
  final TextBaseline baseline;

  /// The widget to be rendered.
  final WidgetPlaceholder<T> child;

  /// Creates an inline widget.
  TextWidget(
    TextBits parent,
    this.child, {
    this.alignment = PlaceholderAlignment.baseline,
    this.baseline = TextBaseline.alphabetic,
  }) : super(parent, parent.tsb);

  @override
  InlineSpan compile(TextStyleHtml _) => WidgetSpan(
        alignment: alignment,
        baseline: baseline,
        child: child,
      );

  @override
  String toString() => '$child';
}

/// A container of bits.
class TextBits extends TextBit<void, void> {
  final _children = <TextBit>[];

  /// Creates a container.
  TextBits(TextStyleBuilder tsb, [TextBits parent]) : super(parent, tsb);

  /// The list of bits including direct children and their children.
  Iterable<TextBit> get bits sync* {
    for (final child in _children) {
      if (child is TextBits) {
        yield* child.bits;
      } else {
        yield child;
      }
    }
  }

  /// The first bit (recursively).
  TextBit get first {
    for (final child in _children) {
      final first = child is TextBits ? child.first : child;
      if (first != null) return first;
    }

    return null;
  }

  /// Returns `true` if the text (up to this container) has trailing whitespace.
  bool get hasTrailingWhitespace {
    final tail = last ?? prev;
    if (tail == null) return true;
    return tail is _TextWhitespace;
  }

  /// Returns `true` if there are no bits (recursively).
  bool get isEmpty {
    for (final child in _children) {
      if (child is TextBits) {
        if (!child.isEmpty) return false;
      } else {
        return false;
      }
    }

    return true;
  }

  /// The last bit (recursively).
  TextBit get last {
    for (final child in _children.reversed) {
      final last = child is TextBits ? child.last : child;
      if (last != null) return last;
    }

    return null;
  }

  /// Adds [bit] to the tail of this container.
  void add(TextBit bit) {
    assert(bit.parent == this);
    _children.add(bit);
  }

  /// Adds a new line to the tail of this container.
  TextBit addNewLine() {
    final tail = last ?? prev;
    if (tail is _TextNewLine) return tail..extend();

    final bit = _TextNewLine(this);
    add(bit);
    return bit;
  }

  /// Adds a new whitespace to the tail of this container.
  TextBit addWhitespace() {
    final tail = last ?? prev;
    if (tail == null) return null;
    if (tail is _TextNewLine || tail is _TextWhitespace) return tail;

    final bit = _TextWhitespace(this);
    add(bit);
    return bit;
  }

  /// Adds a string to the tail of this container.
  TextData addText(String data) {
    final bit = TextData(this, data);
    add(bit);
    return bit;
  }

  /// Creates a sub-container.
  TextBits sub(TextStyleBuilder tsb) {
    final sub = TextBits(tsb, this);
    add(sub);
    return sub;
  }

  /// Trims all trailing whitespaces.
  ///
  /// Returns the number of bits that have been detached.
  int trimRight() {
    var trimmed = 0;

    while (_children.isNotEmpty && hasTrailingWhitespace) {
      final child = _children.last;
      if (child is TextBits) {
        final _trimmed = child.trimRight();
        if (_trimmed > 0) {
          trimmed += _trimmed;
          if (child.isEmpty) child.detach();
        } else {
          child.detach();
        }
      } else {
        child.detach();
        trimmed++;
      }
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

    return 'TextBits#$hashCode $tsb:\n$sb'.trimRight();
  }
}

class _TextNewLine extends TextBit<TextStyleBuilder, Widget> {
  static const _kNewLine = '\n';

  final _sb = StringBuffer(_kNewLine);

  _TextNewLine(TextBits parent) : super(parent, parent.tsb);

  @override
  Widget compile(TextStyleBuilder tsb) {
    final lines = _sb.length - 1;
    if (lines < 1) return null;

    return HeightPlaceholder(
        CssLength(lines.toDouble(), CssLengthUnit.em), tsb);
  }

  void extend() => _sb.write(_kNewLine);

  @override
  String toString() => 'NewLine#$hashCode';
}

class _TextWhitespace extends TextBit<void, String> {
  _TextWhitespace(TextBit parent) : super(parent, null);

  @override
  String compile(void _) => ' ';

  @override
  String toString() => 'Whitespace#$hashCode';
}
