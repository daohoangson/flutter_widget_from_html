import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

NodeMetadata lazySet(
  NodeMetadata meta, {
  BuildOp buildOp,
  Color color,
  bool decoOver,
  bool decoStrike,
  bool decoUnder,
  TextDecorationStyle decorationStyle,
  CssBorderStyle decorationStyleFromCssBorderStyle,
  String fontFamily,
  String fontSize,
  bool fontStyleItalic,
  FontWeight fontWeight,
  bool isBlockElement,
  bool isNotRenderable,
  Iterable<BuildOp> parentOps,
  Iterable<String> styles,
  Iterable<String> stylesPrepend,
}) {
  meta ??= NodeMetadata();

  if (buildOp != null) {
    meta._buildOps ??= [];
    final ops = meta._buildOps as List<BuildOp>;
    if (ops.indexOf(buildOp) == -1) {
      ops.add(buildOp);
    }
  }

  if (color != null) meta.color = color;

  if (decoStrike != null) meta.decoStrike = decoStrike;
  if (decoOver != null) meta.decoOver = decoOver;
  if (decoUnder != null) meta.decoUnder = decoUnder;

  if (decorationStyle != null) meta.decorationStyle = decorationStyle;
  if (decorationStyleFromCssBorderStyle != null) {
    switch (decorationStyleFromCssBorderStyle) {
      case CssBorderStyle.dashed:
        meta.decorationStyle = TextDecorationStyle.dashed;
        break;
      case CssBorderStyle.dotted:
        meta.decorationStyle = TextDecorationStyle.dotted;
        break;
      case CssBorderStyle.double:
        meta.decorationStyle = TextDecorationStyle.double;
        break;
      case CssBorderStyle.solid:
        meta.decorationStyle = TextDecorationStyle.solid;
        break;
    }
  }

  if (fontFamily != null) meta.fontFamily = fontFamily;
  if (fontSize != null) meta.fontSize = fontSize;
  if (fontStyleItalic != null) meta.fontStyleItalic = fontStyleItalic;
  if (fontWeight != null) meta.fontWeight = fontWeight;

  if (isBlockElement != null) meta._isBlockElement = isBlockElement;
  if (isNotRenderable != null) meta.isNotRenderable = isNotRenderable;

  if (parentOps != null) {
    assert(meta._parentOps == null);
    meta._parentOps = parentOps;
  }

  if (stylesPrepend != null) {
    styles = stylesPrepend;
  }
  if (styles != null) {
    assert(styles.length % 2 == 0);
    assert(!meta._stylesFrozen);
    meta._styles ??= [];
    if (styles == stylesPrepend) {
      meta._styles.insertAll(0, styles);
    } else {
      meta._styles.addAll(styles);
    }
  }

  return meta;
}

class BuildOp {
  final bool isBlockElement;

  // op with lower priority will run first
  final int priority;

  final BuildOpDefaultStyles _defaultStyles;
  final BuildOpOnChild _onChild;
  final BuildOpOnPieces _onPieces;
  final BuildOpOnWidgets _onWidgets;

  BuildOp({
    BuildOpDefaultStyles defaultStyles,
    bool isBlockElement,
    BuildOpOnChild onChild,
    BuildOpOnPieces onPieces,
    BuildOpOnWidgets onWidgets,
    this.priority = 10,
  })  : _defaultStyles = defaultStyles,
        this.isBlockElement = isBlockElement ?? onWidgets != null,
        _onChild = onChild,
        _onPieces = onPieces,
        _onWidgets = onWidgets;

  bool get hasOnChild => _onChild != null;

  List<String> defaultStyles(NodeMetadata meta, dom.Element e) =>
      _defaultStyles != null ? _defaultStyles(meta, e) : null;

  NodeMetadata onChild(NodeMetadata meta, dom.Element e) =>
      _onChild != null ? _onChild(meta, e) : meta;

  Iterable<BuiltPiece> onPieces(
    NodeMetadata meta,
    Iterable<BuiltPiece> pieces,
  ) =>
      _onPieces != null ? _onPieces(meta, pieces) : pieces;

  Iterable<Widget> onWidgets(NodeMetadata meta, Iterable<Widget> widgets) =>
      (_onWidgets != null ? _onWidgets(meta, widgets) : null) ?? widgets;
}

typedef Iterable<String> BuildOpDefaultStyles(
  NodeMetadata meta,
  dom.Element e,
);
typedef NodeMetadata BuildOpOnChild(NodeMetadata meta, dom.Element e);
typedef Iterable<BuiltPiece> BuildOpOnPieces(
  NodeMetadata meta,
  Iterable<BuiltPiece> pieces,
);
typedef Iterable<Widget> BuildOpOnWidgets(
    NodeMetadata meta, Iterable<Widget> widgets);

class BuilderContext {
  final BuildContext context;
  final Widget origin;

  BuilderContext(this.context, this.origin);
}

abstract class BuiltPiece {
  bool get hasWidgets;

  TextBlock get block;
  Iterable<Widget> get widgets;
}

class BuiltPieceSimple extends BuiltPiece {
  final TextBlock block;
  final Iterable<Widget> widgets;

  BuiltPieceSimple({
    this.block,
    this.widgets,
  }) : assert((block == null) != (widgets == null));

  bool get hasWidgets => widgets != null;
}

class CssBorderSide {
  Color color;
  CssBorderStyle style;
  CssLength width;
}

enum CssBorderStyle { dashed, dotted, double, solid }

class CssBorders {
  CssBorderSide bottom;
  CssBorderSide left;
  CssBorderSide right;
  CssBorderSide top;
}

class CssMargin {
  CssLength bottom;
  CssLength end;
  CssLength left;
  CssLength right;
  CssLength start;
  CssLength top;

  CssMargin copyWith({
    CssLength bottom,
    CssLength end,
    CssLength left,
    CssLength right,
    CssLength start,
    CssLength top,
  }) =>
      CssMargin()
        ..bottom = bottom ?? this.bottom
        ..end = end ?? this.end
        ..left = left ?? this.left
        ..right = right ?? this.right
        ..start = start ?? this.start
        ..top = top ?? this.top;
}

class CssLength {
  final double number;
  final CssLengthUnit unit;

  CssLength(
    this.number, {
    this.unit = CssLengthUnit.px,
  })  : assert(!number.isNegative),
        assert(unit != null);

  bool get isNotEmpty => number > 0;

  double getValue(BuilderContext bc, TextStyleBuilders tsb) {
    double value;

    switch (this.unit) {
      case CssLengthUnit.em:
        value = tsb.build(bc).fontSize * number / 1;
        break;
      case CssLengthUnit.px:
        value = number;
        break;
    }

    if (value != null) {
      value = value * MediaQuery.of(bc.context).textScaleFactor;
    }

    return value;
  }
}

enum CssLengthUnit {
  em,
  px,
}

class NodeMetadata {
  Iterable<BuildOp> _buildOps;
  dom.Element _domElement;
  Iterable<BuildOp> _parentOps;
  TextStyleBuilders _tsb;

  Color color;
  bool decoOver;
  bool decoStrike;
  bool decoUnder;
  TextDecorationStyle decorationStyle;
  String fontFamily;
  String fontSize;
  bool fontStyleItalic;
  FontWeight fontWeight;
  bool _isBlockElement;
  bool isNotRenderable;
  List<String> _styles;
  bool _stylesFrozen = false;

  dom.Element get domElement => _domElement;

  bool get hasOps => _buildOps != null;

  bool get hasParents => _parentOps != null;

  Iterable<BuildOp> get ops => _buildOps;

  Iterable<BuildOp> get parents => _parentOps;

  TextStyleBuilders get tsb => _tsb;

  set domElement(dom.Element e) {
    assert(_domElement == null);
    _domElement = e;

    if (_buildOps != null) {
      final ops = _buildOps as List;
      ops.sort((a, b) => a.priority.compareTo(b.priority));
      _buildOps = List.unmodifiable(ops);
    }
  }

  set tsb(TextStyleBuilders tsb) {
    assert(_tsb == null);
    _tsb = tsb;
  }

  bool get isBlockElement {
    if (_isBlockElement == true) return true;
    return _buildOps?.where((o) => o.isBlockElement)?.length?.compareTo(0) == 1;
  }

  void styles(void f(String key, String value)) {
    _stylesFrozen = true;
    if (_styles == null) return;

    final iterator = _styles.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current;
      if (!iterator.moveNext()) return;
      f(key, iterator.current);
    }
  }
}

typedef NodeMetadata NodeMetadataCollector(NodeMetadata meta, dom.Element e);

@immutable
abstract class TextBit {
  TextBits get parent;

  String get data => null;
  bool get hasTrailingSpace => false;
  bool get isEmpty => false;
  bool get isNotEmpty => !isEmpty;
  VoidCallback get onTap => null;
  TextStyleBuilders get tsb => null;

  TextBit clone({TextBits parent});
  bool detach() => parent?._children?.remove(this);

  bool insertAfter(TextBit another) {
    final siblings = another?.parent?._children;
    if (siblings == null) return false;

    final indexOf = siblings.indexOf(another);
    if (indexOf == -1) return false; // detached?

    siblings.insert(indexOf + 1, this);
    return true;
  }

  bool insertBefore(TextBit another) {
    final siblings = another?.parent?._children;
    if (siblings == null) return false;

    final indexOf = siblings.indexOf(another);
    if (indexOf == -1) return false; // detached?

    siblings.insert(indexOf, this);
    return true;
  }

  static TextBit nextOf(TextBit bit) {
    var x = bit;
    var p = x?.parent;

    while (p != null) {
      final i = p._children.indexOf(x);
      if (i != -1) {
        for (var j = i + 1; j < p._children.length; j++) {
          final candidate = p._children[j];
          if (candidate is TextBits) {
            final first = candidate.first;
            if (first != null) return first;
          } else {
            return candidate;
          }
        }
      }

      x = p;
      p = p.parent;
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

abstract class TextBits extends TextBit {
  Iterable<TextBit> get bits;
  TextBit get first;
  TextBit get last;
  List<TextBit> get _children;

  void addBit(TextBit bit, {int index});
  TextBits sub(TextStyleBuilders tsb);
}

class DataBit extends TextBit {
  final TextBits parent;
  final String data;
  final VoidCallback onTap;
  final TextStyleBuilders tsb;

  DataBit(this.parent, this.data, this.tsb, {this.onTap})
      : assert(parent != null),
        assert(data != null),
        assert(tsb != null);

  @override
  DataBit clone({
    TextBits parent,
    String data,
    VoidCallback onTap,
    TextStyleBuilders tsb,
  }) {
    parent ??= this.parent;
    return DataBit(
      parent,
      data ?? this.data,
      tsb ?? this.tsb._clone(parent: parent.tsb),
      onTap: onTap ?? this.onTap,
    );
  }
}

class SpaceBit extends TextBit {
  final TextBits parent;

  final _buffer = StringBuffer();

  SpaceBit(this.parent, {String data}) : assert(parent != null) {
    if (data != null) _buffer.write(data);
  }

  String get data => _buffer.isEmpty ? null : _buffer.toString();

  bool get hasTrailingSpace => _buffer.isEmpty;

  @override
  SpaceBit clone({TextBits parent}) =>
      SpaceBit(parent ?? this.parent, data: data);
}

class WidgetBit extends TextBit {
  final TextBits parent;
  final WidgetSpan widgetSpan;

  WidgetBit(this.parent, this.widgetSpan)
      : assert(parent != null),
        assert(widgetSpan != null);

  @override
  WidgetBit clone({
    TextBits parent,
    PlaceholderAlignment alignment,
    TextBaseline baseline,
    Widget child,
  }) =>
      WidgetBit(
        parent ?? this.parent,
        WidgetSpan(
          alignment: alignment ?? this.widgetSpan.alignment,
          baseline: baseline ?? this.widgetSpan.baseline,
          child: child ?? this.widgetSpan.child,
        ),
      );
}

class TextBlock extends TextBits {
  final TextBits parent;
  final TextStyleBuilders tsb;

  @override
  final _children = <TextBit>[];

  TextBlock(this.tsb, {this.parent}) : assert(tsb != null);

  @override
  Iterable<TextBit> get bits sync* {
    for (final child in _children) {
      if (child is TextBits) {
        yield* child.bits;
      } else {
        yield child;
      }
    }
  }

  @override
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

  @override
  TextBit get last {
    for (final child in _children.reversed) {
      final last = child is TextBits ? child.last : child;
      if (last != null) return last;
    }

    return null;
  }

  @override
  void addBit(TextBit bit, {int index}) =>
      _children.insert(index ?? _children.length, bit);

  bool addSpace([String data]) {
    final tail = TextBit.tailOf(this);
    if (tail == null) {
      if (data == null) return false;
    } else if (tail is SpaceBit) {
      if (data == null) return false;
      tail._buffer.write(data);
      return true;
    }

    addBit(SpaceBit(this, data: data));
    return true;
  }

  void addText(String data) => addBit(DataBit(this, data, tsb));

  void addWidget(WidgetSpan ws) => addBit(WidgetBit(this, ws));

  @override
  TextBlock clone({TextBits parent}) {
    final cloned = TextBlock(tsb._clone(parent: parent.tsb), parent: parent);
    cloned._children.addAll(_children.map((c) => c.clone(parent: cloned)));
    return cloned;
  }

  void rebuildBits(TextBit f(TextBit bit)) {
    final l = _children.length;
    for (var i = 0; i < l; i++) {
      final child = _children[i];
      if (child is TextBlock) {
        child.rebuildBits(f);
      } else {
        _children[i] = f(child);
      }
    }
  }

  TextBit removeLast() {
    while (true) {
      if (_children.isEmpty) return null;

      final lastChild = _children.last;
      if (lastChild is TextBlock) {
        final removed = lastChild.removeLast();
        if (removed != null) {
          return removed;
        } else {
          _children.removeLast();
        }
      } else {
        return _children.removeLast();
      }
    }
  }

  @override
  TextBlock sub(TextStyleBuilders tsb) {
    final sub = TextBlock(tsb, parent: this);
    _children.add(sub);
    return sub;
  }

  void trimRight() {
    while (isNotEmpty && hasTrailingSpace) removeLast();
  }

  void truncate() => _children.clear();
}

class TextStyleBuilders {
  final _builders = <Function>[];
  final _inputs = [];
  final TextStyleBuilders parent;

  BuilderContext _bc;
  TextStyle _output;
  TextAlign _textAlign;

  BuilderContext get bc => _bc;

  TextAlign get textAlign => _textAlign ?? parent?.textAlign;

  set textAlign(TextAlign v) => _textAlign = v;

  TextStyleBuilders({this.parent});

  void enqueue<T>(TextStyleBuilder<T> builder, T input) {
    assert(_output == null, "Cannot add builder after being built");
    _builders.add(builder);
    _inputs.add(input);
  }

  TextStyle build(BuilderContext bc) {
    _resetContextIfNeeded(bc);
    if (_output != null) return _output;

    if (parent == null) {
      _output = DefaultTextStyle.of(_bc.context).style;
    } else {
      _output = parent.build(_bc);
    }

    final l = _builders.length;
    for (int i = 0; i < l; i++) {
      _output = _builders[i](this, _output, _inputs[i]);
    }

    return _output;
  }

  TextStyleBuilders sub() => TextStyleBuilders(parent: this);

  TextStyleBuilders _clone({TextStyleBuilders parent}) {
    final cloned = TextStyleBuilders(parent: parent ?? this.parent);

    final l = _builders.length;
    for (var i = 0; i < l; i++) {
      cloned._builders.add(_builders[i]);
      cloned._inputs.add(_inputs[i]);
    }

    return cloned;
  }

  void _resetContextIfNeeded(BuilderContext bc) {
    if (bc == _bc) return;

    _bc = bc;
    _output = null;
    _textAlign = null;
  }
}

typedef TextStyle TextStyleBuilder<T>(
  TextStyleBuilders tsb,
  TextStyle textStyle,
  T input,
);
