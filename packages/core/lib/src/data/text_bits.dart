part of '../core_data.dart';

@immutable
abstract class TextBit<T> {
  final TextBits parent;

  TextBit(this.parent);

  bool get canCompile => false;
  String get data => null;
  int get index => parent?._children?.indexOf(this) ?? -1;
  bool get isEmpty => false;
  bool get isNotEmpty => !isEmpty;
  TextStyleBuilder get tsb => null;

  T compile(TextStyleBuilder tsb) => throw UnimplementedError();

  bool detach() => parent?._children?.remove(this);

  bool insertAfter(TextBit another) {
    final i = another.index;
    if (i == -1) return false;

    another.parent._children.insert(i + 1, this);
    return true;
  }

  bool insertBefore(TextBit another) {
    final i = another.index;
    if (i == -1) return false;

    another.parent._children.insert(i, this);
    return true;
  }

  bool replaceWith(TextBit another) {
    final i = index;
    if (i == -1) return false;

    parent._children[i] = another;
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

  static TextBit nextOf(TextBit bit) {
    var x = bit;

    while (x != null) {
      final i = x.index;
      if (i != -1) {
        final siblings = x.parent._children;
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

  static TextBit tailOf(TextBits bits) {
    var x = bits;

    while (x != null) {
      final last = x.last;
      if (last != null) return last;
      x = x.parent;
    }

    return null;
  }
}

class TextData extends TextBit<void> {
  @override
  final String data;

  @override
  final TextStyleBuilder tsb;

  TextData(TextBits parent, this.data, this.tsb)
      : assert(parent != null),
        assert(data != null),
        assert(tsb != null),
        super(parent);
}

class TextWidget<T> extends TextBit<InlineSpan> {
  final PlaceholderAlignment alignment;
  final TextBaseline baseline;
  final WidgetPlaceholder<T> widget;

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

class TextBits extends TextBit<void> {
  final _children = <TextBit>[];

  @override
  final tsb;

  TextBits(this.tsb, [TextBits parent])
      : assert(tsb != null),
        super(parent);

  Iterable<TextBit> get bits sync* {
    for (final child in _children) {
      if (child is TextBits) {
        yield* child.bits;
      } else {
        yield child;
      }
    }
  }

  TextBit get first {
    for (final child in _children) {
      final first = child is TextBits ? child.first : child;
      if (first != null) return first;
    }

    return null;
  }

  bool get hasTrailingWhitespace {
    final tail = TextBit.tailOf(this);
    if (tail == null) return true;
    return tail is _TextWhitespace;
  }

  @override
  bool get isEmpty {
    for (final child in _children) {
      if (child.isNotEmpty) return false;
    }

    return true;
  }

  TextBit get last {
    for (final child in _children.reversed) {
      final last = child is TextBits ? child.last : child;
      if (last != null) return last;
    }

    return null;
  }

  void add(TextBit bit) => _children.add(bit);

  TextBit addNewLine() {
    final tail = TextBit.tailOf(this);
    if (tail is _TextNewLine) return tail..newLine();

    final bit = _TextNewLine(this);
    add(bit);
    return bit;
  }

  TextBit addWhitespace() {
    final tail = TextBit.tailOf(this);
    if (tail == null) return null;
    if (tail is _TextNewLine || tail is _TextWhitespace) return tail;

    final bit = _TextWhitespace(this);
    add(bit);
    return bit;
  }

  TextData addText(String data) {
    final bit = TextData(this, data, tsb);
    add(bit);
    return bit;
  }

  TextBits sub([TextStyleBuilder tsb]) {
    final sub = TextBits(tsb ?? this.tsb.sub(), this);
    add(sub);
    return sub;
  }

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

  void newLine() => _sb.write(_kNewLine);
}

class _TextWhitespace extends TextBit<void> {
  _TextWhitespace(TextBit parent)
      : assert(parent != null),
        super(parent);

  @override
  String get data => ' ';
}
