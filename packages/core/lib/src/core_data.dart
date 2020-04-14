import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import 'builder.dart';
import 'core_helpers.dart';

part 'data/text_bits.dart';

class BuildOp {
  final bool isBlockElement;

  // op with lower priority will run first
  final int priority;

  final _BuildOpDefaultStyles _defaultStyles;
  final _BuildOpOnChild _onChild;
  final _BuildOpOnPieces _onPieces;
  final _BuildOpOnWidgets _onWidgets;

  BuildOp({
    _BuildOpDefaultStyles defaultStyles,
    bool isBlockElement,
    _BuildOpOnChild onChild,
    _BuildOpOnPieces onPieces,
    _BuildOpOnWidgets onWidgets,
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

typedef _BuildOpDefaultStyles = Iterable<String> Function(
    NodeMetadata meta, dom.Element e);
typedef _BuildOpOnChild = NodeMetadata Function(
    NodeMetadata meta, dom.Element e);
typedef _BuildOpOnPieces = Iterable<BuiltPiece> Function(
    NodeMetadata meta, Iterable<BuiltPiece> pieces);
typedef _BuildOpOnWidgets = Iterable<Widget> Function(
    NodeMetadata meta, Iterable<Widget> widgets);

class BuiltPiece {
  final TextBits text;
  final Iterable<Widget> widgets;

  BuiltPiece.text(this.text) : widgets = null;

  BuiltPiece.widgets(this.widgets) : text = null;

  bool get hasWidgets => widgets != null;
}

class CssBorderSide {
  Color color;
  TextDecorationStyle style;
  CssLength width;
}

class CssBorders {
  CssBorderSide bottom;
  CssBorderSide left;
  CssBorderSide right;
  CssBorderSide top;
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

  double getValue(BuildContext context, TextStyleBuilders tsb) {
    double value;

    switch (this.unit) {
      case CssLengthUnit.em:
        value = tsb.build(context).fontSize * number / 1;
        break;
      case CssLengthUnit.px:
        value = number;
        break;
    }

    if (value != null) {
      value = value * MediaQuery.of(context).textScaleFactor;
    }

    return value;
  }
}

class CssLengthBox {
  final CssLength bottom;
  final CssLength inlineEnd;
  final CssLength inlineStart;
  final CssLength left;
  final CssLength right;
  final CssLength top;

  const CssLengthBox({
    this.bottom,
    this.inlineEnd,
    this.inlineStart,
    this.left,
    this.right,
    this.top,
  });

  CssLengthBox copyWith({
    CssLength bottom,
    CssLength inlineEnd,
    CssLength inlineStart,
    CssLength left,
    CssLength right,
    CssLength top,
  }) =>
      CssLengthBox(
        bottom: bottom ?? this.bottom,
        inlineEnd: inlineEnd ?? this.inlineEnd,
        inlineStart: inlineStart ?? this.inlineStart,
        left: left ?? this.left,
        right: right ?? this.right,
        top: top ?? this.top,
      );
}

enum CssLengthUnit {
  em,
  px,
}

typedef NodeMetadataCollector = NodeMetadata Function(
    NodeMetadata meta, dom.Element e);

class TextStyleBuilders {
  final _builders = <Function>[];
  final _inputs = [];
  final TextStyleBuilders parent;

  GestureRecognizer recognizer;

  BuildContext _context;
  TextStyle _output;
  TextAlign _textAlign;

  BuildContext get context => _context;

  TextAlign get textAlign => _textAlign ?? parent?.textAlign;

  set textAlign(TextAlign v) => _textAlign = v;

  TextStyleBuilders({this.parent});

  void enqueue<T>(
    TextStyle Function(TextStyleBuilders, TextStyle, T) builder,
    T input,
  ) {
    assert(_output == null, "Cannot add builder after being built");
    _builders.add(builder);
    _inputs.add(input);
  }

  TextStyle build(BuildContext context) {
    _resetContextIfNeeded(context);
    if (_output != null) return _output;

    if (parent == null) {
      _output = DefaultTextStyle.of(_context).style;
    } else {
      _output = parent.build(_context);
    }

    final l = _builders.length;
    for (int i = 0; i < l; i++) {
      _output = _builders[i](this, _output, _inputs[i]);
    }

    return _output;
  }

  TextStyleBuilders sub() => TextStyleBuilders(parent: this);

  void _resetContextIfNeeded(BuildContext context) {
    if (context == _context) return;

    _context = context;
    _output = null;
    _textAlign = null;
  }
}
