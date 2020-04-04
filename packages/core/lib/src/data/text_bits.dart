part of '../data_classes.dart';

@immutable
abstract class TextBit {
  final TextBits parent;

  TextBit(this.parent);

  bool get canCompile => false;
  String get data => null;
  bool get hasTrailingSpace => false;
  int get index => parent?._children?.indexOf(this) ?? -1;
  bool get isEmpty => false;
  bool get isNotEmpty => !isEmpty;
  TextStyleBuilders get tsb => null;

  InlineSpan compile(TextStyle style) => throw UnimplementedError();

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
    final self = this;
    final contents = self is WidgetBit ? "widget=${self.widget}" : "data=$data";
    return "[$clazz:$hashCode] $contents";
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

class DataBit extends TextBit {
  final String data;
  final TextStyleBuilders tsb;

  DataBit(TextBits parent, this.data, this.tsb)
      : assert(parent != null),
        assert(data != null),
        assert(tsb != null),
        super(parent);
}

class SpaceBit extends TextBit {
  final _buffer = StringBuffer();

  SpaceBit(TextBit parent, SpaceType type)
      : assert(parent != null),
        super(parent) {
    if (type != null) append(type);
  }

  @override
  String get data => _buffer.isEmpty ? null : _buffer.toString();

  @override
  bool get hasTrailingSpace => _buffer.isEmpty;

  void append(SpaceType type) {
    switch (type) {
      case SpaceType.newLine:
        _buffer.write('\n');
        break;
    }
  }
}

class WidgetBit extends TextBit {
  final PlaceholderAlignment alignment;
  final TextBaseline baseline;
  final IWidgetPlaceholder widget;

  WidgetBit(
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
  WidgetSpan compile(TextStyle style) => WidgetSpan(
        alignment: alignment,
        baseline: baseline,
        child: widget,
        style: style,
      );
}

class TextBits extends TextBit {
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

  @override
  bool get hasTrailingSpace => TextBit.tailOf(this)?.hasTrailingSpace ?? true;

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

  TextBit addSpace([SpaceType type]) {
    final tail = TextBit.tailOf(this);
    if (tail == null) {
      if (type == null) return null;
    } else if (tail is SpaceBit) {
      return tail..append(type);
    }

    final bit = SpaceBit(this, type);
    add(bit);
    return bit;
  }

  TextBit addText(String data) {
    final bit = DataBit(this, data, tsb);
    add(bit);
    return bit;
  }

  TextBits sub([TextStyleBuilders tsb]) {
    final sub = TextBits(tsb ?? this.tsb.sub(), this);
    add(sub);
    return sub;
  }

  int trimRight() {
    var trimmed = 0;

    while (_children.isNotEmpty && hasTrailingSpace) {
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
    return "\n[$clazz:$hashCode]\n$contents\n----";
  }

  Iterable<String> _toStrings() => _children.isNotEmpty
      ? (_children
          .map((child) => child is TextBits
              ? (List<String>()
                ..add("[${child.runtimeType}:${child.hashCode}]" +
                    (child.parent == this
                        ? ''
                        : " ⚠️ parent=${child.parent.hashCode}"))
                ..addAll(child._toStrings()))
              : [
                  child.toString() +
                      (child.parent == this
                          ? ''
                          : " ⚠️ parent=${child.parent.hashCode}")
                ])
          .map((lines) => lines.map((line) => "  $line"))
          .reduce((prev, lines) => List.from(prev)..addAll(lines)))
      : [];
}

enum SpaceType {
  newLine,
}
