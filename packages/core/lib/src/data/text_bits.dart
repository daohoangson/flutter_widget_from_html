part of '../core_data.dart';

/// A bit of text being processed.
@immutable
abstract class TextBit<T> {
  /// The container [TextBits].
  final TextBits parent;

  /// Create a text bit.
  TextBit(this.parent);

  /// Controls whether this bit can compile itself.
  ///
  /// If this is `true`, [compile] must be implemented.
  /// If this is `false`, [data] will be appended into a buffer for rendering.
  bool get canCompile => false;

  /// The data string.
  String get data => null;

  /// The associated [TextStyleBuilder].
  TextStyleBuilder get tsb => null;

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

  /// Compiles into a [InlineSpan] or [Widget].
  ///
  /// Note: this method won't be called unless [canCompile] is `true`.
  T compile(TextStyleBuilder tsb) => throw UnimplementedError();

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
  String toString() {
    final clazz = runtimeType.toString();
    final contents = this is TextWidget
        ? 'widget=${(this as TextWidget).widget}'
        : 'data=$data';
    return '[$clazz:$hashCode] $contents';
  }
}

/// A simple data bit.
class TextData extends TextBit<void> {
  @override
  final String data;

  @override
  final TextStyleBuilder tsb;

  /// Creates with data string
  TextData(TextBits parent, this.data, this.tsb)
      : assert(parent != null),
        assert(data != null),
        assert(tsb != null),
        super(parent);
}

/// An inline widget to be rendered within text paragraph.
class TextWidget<T> extends TextBit<InlineSpan> {
  /// See [PlaceholderSpan.alignment].
  final PlaceholderAlignment alignment;

  /// See [PlaceholderSpan.baseline].
  final TextBaseline baseline;

  /// The widget to be rendered.
  final WidgetPlaceholder<T> widget;

  /// Creates an inline widget
  TextWidget(
    TextBits parent,
    this.widget, {
    this.alignment = PlaceholderAlignment.baseline,
    this.baseline = TextBaseline.alphabetic,
  })  : assert(parent != null),
        assert(widget != null),
        assert(alignment != null),
        assert(baseline != null),
        super(parent);

  @override
  bool get canCompile => true;

  @override
  InlineSpan compile(TextStyleBuilder _) => WidgetSpan(
        alignment: alignment,
        baseline: baseline,
        child: widget,
      );
}

/// A container of bits.
class TextBits extends TextBit<void> {
  final _children = <TextBit>[];

  @override
  final tsb;

  /// Creates a container.
  TextBits(this.tsb, [TextBits parent])
      : assert(tsb != null),
        super(parent);

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
    final bit = TextData(this, data, tsb);
    add(bit);
    return bit;
  }

  /// Creates a new sub-container.
  TextBits sub([TextStyleBuilder subTsb]) {
    final sub = TextBits(subTsb ?? tsb.sub(), this);
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
    final clazz = runtimeType.toString();
    final contents = _toStrings().join('\n');
    return '\n[$clazz:$hashCode]\n$contents\n----';
  }

  Iterable<String> _toStrings() => _children.isNotEmpty
      ? (_children
          .map((child) => child is TextBits
              ? (<String>[]
                ..add('[${child.runtimeType}:${child.hashCode}]' +
                    (child.parent == this
                        ? ''
                        : ' ⚠️ parent=${child.parent.hashCode}'))
                ..addAll(child._toStrings()))
              : [
                  child.toString() +
                      (child.parent == this
                          ? ''
                          : ' ⚠️ parent=${child.parent.hashCode}')
                ])
          .map((lines) => lines.map((line) => '  $line'))
          .reduce((prev, lines) => List.from(prev)..addAll(lines)))
      : [];
}

class _TextNewLine extends TextBit<Widget> {
  static const _kNewLine = '\n';

  final _sb = StringBuffer(_kNewLine);

  _TextNewLine(TextBits parent)
      : assert(parent != null),
        super(parent);

  @override
  bool get canCompile => true;

  @override
  String get data => _sb.toString();

  @override
  Widget compile(TextStyleBuilder tsb) {
    final lines = _sb.length - 1;
    if (lines < 1) return null;

    return HeightPlaceholder(
        CssLength(lines.toDouble(), CssLengthUnit.em), tsb);
  }

  void extend() => _sb.write(_kNewLine);
}

class _TextWhitespace extends TextBit<void> {
  _TextWhitespace(TextBit parent)
      : assert(parent != null),
        super(parent);

  @override
  String get data => ' ';
}
