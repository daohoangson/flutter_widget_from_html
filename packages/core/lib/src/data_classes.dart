import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

NodeMetadata lazySet(
  NodeMetadata meta, {
  BuildOp buildOp,
  Color color,
  bool decorationLineThrough,
  bool decorationOverline,
  TextDecorationStyle decorationStyle,
  CssBorderStyle decorationStyleFromCssBorderStyle,
  bool decorationUnderline,
  String fontFamily,
  String fontSize,
  bool fontStyleItalic,
  FontWeight fontWeight,
  Iterable<String> inlineStyles,
  bool isBlockElement,
  bool isNotRenderable,
  StyleType style,
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
  if (decorationLineThrough != null)
    meta.decorationLineThrough = decorationLineThrough;
  if (decorationOverline != null) meta.decorationOverline = decorationOverline;
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
  if (decorationUnderline != null)
    meta.decorationUnderline = decorationUnderline;
  if (fontFamily != null) meta.fontFamily = fontFamily;
  if (fontSize != null) meta.fontSize = fontSize;
  if (fontStyleItalic != null) meta.fontStyleItalic = fontStyleItalic;
  if (fontWeight != null) meta.fontWeight = fontWeight;
  if (inlineStyles != null) {
    if (inlineStyles.length % 2 != 0) {
      throw new ArgumentError('inlineStyles must have an even number of items');
    }
    if (meta._inlineStylesFrozen) {
      throw new StateError('inlineStyles has already been frozen');
    }
    meta._inlineStyles ??= [];
    meta._inlineStyles.addAll(inlineStyles);
  }
  if (isBlockElement != null) meta._isBlockElement = isBlockElement;
  if (isNotRenderable != null) meta.isNotRenderable = isNotRenderable;
  if (style != null) meta.style = style;

  return meta;
}

class BuildOp {
  // op with lower priority will run first
  final int priority;

  final BuildOpCollectMetadata _collectMetadata;
  final BuildOpOnPieces _onPieces;
  final BuildOpOnWidgets _onWidgets;

  BuildOp({
    BuildOpCollectMetadata collectMetadata,
    BuildOpOnPieces onPieces,
    BuildOpOnWidgets onWidgets,
    this.priority = 10,
  })  : _collectMetadata = collectMetadata,
        _onPieces = onPieces,
        _onWidgets = onWidgets;

  bool get isBlockElement => _onWidgets != null;

  void collectMetadata(NodeMetadata meta) =>
      _collectMetadata != null ? _collectMetadata(meta) : null;

  Iterable<BuiltPiece> onPieces(
    NodeMetadata meta,
    Iterable<BuiltPiece> pieces,
  ) =>
      _onPieces != null ? _onPieces(meta, pieces) : pieces;

  Iterable<Widget> onWidgets(NodeMetadata meta, Iterable<Widget> widgets) {
    if (_onWidgets == null) return widgets;

    final widget = _onWidgets(meta, widgets);
    if (widget == null) return widgets;

    return <Widget>[widget];
  }
}

typedef void BuildOpCollectMetadata(NodeMetadata meta);
typedef Iterable<BuiltPiece> BuildOpOnPieces(
  NodeMetadata meta,
  Iterable<BuiltPiece> pieces,
);
typedef Widget BuildOpOnWidgets(NodeMetadata meta, Iterable<Widget> widgets);

abstract class BuiltPiece {
  bool get hasText;
  bool get hasTextSpan;
  bool get hasWidgets;

  String get text;
  TextSpan get textSpan;
  TextStyle get textStyle;
  Iterable<Widget> get widgets;
}

class BuiltPieceSimple extends BuiltPiece {
  final String text;
  final TextSpan textSpan;
  final TextStyle textStyle;
  final Iterable<Widget> widgets;

  BuiltPieceSimple({this.text, this.textSpan, this.textStyle, this.widgets});

  bool get hasText => text != null;
  bool get hasTextSpan => textSpan != null;
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

class CssLength {
  final double number;
  final CssLengthUnit unit;

  CssLength(this.number, {this.unit});

  double getValue(TextStyle parent) {
    if (number == 0) return 0;

    switch (this.unit) {
      case CssLengthUnit.em:
        return parent.fontSize * number / 1;
      case CssLengthUnit.px:
      default:
        return number;
    }
  }
}

enum CssLengthUnit {
  em,
  px,
}

class NodeMetadata {
  dom.Element _buildOpElement;
  TextStyle _buildOpTextStyle;
  Iterable<BuildOp> _buildOps;
  Color color;
  bool decorationLineThrough;
  bool decorationOverline;
  TextDecorationStyle decorationStyle;
  bool decorationUnderline;
  String fontFamily;
  String fontSize;
  bool fontStyleItalic;
  FontWeight fontWeight;
  List<String> _inlineStyles;
  bool _inlineStylesFrozen = false;
  bool _isBlockElement;
  bool isNotRenderable;
  StyleType style;

  dom.Element get buildOpElement => _buildOpElement;

  TextStyle get buildOpTextStyle => _buildOpTextStyle;

  bool get hasStyling =>
      color != null ||
      fontFamily != null ||
      fontSize != null ||
      fontWeight != null ||
      hasDecoration ||
      hasFontStyle ||
      style != null;

  bool get hasDecoration =>
      decorationLineThrough != null ||
      decorationOverline != null ||
      decorationUnderline != null;

  bool get hasFontStyle => fontStyleItalic != null;

  bool get isBlockElement {
    if (_isBlockElement == true) return true;
    return _buildOps?.where((o) => o.isBlockElement)?.length?.compareTo(0) == 1;
  }

  void forEachInlineStyle(void f(String key, String value)) {
    _inlineStylesFrozen = true;
    if (_inlineStyles == null) return;

    final iterator = _inlineStyles.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current;
      if (!iterator.moveNext()) return;
      f(key, iterator.current);
    }
  }

  void forEachOp(void f(BuildOp element)) => _buildOps?.forEach(f);

  Iterable<BuildOp> freezeOps(dom.Element e) {
    if (_buildOps == null) return null;

    _buildOpElement = e;

    final ops = _buildOps as List;
    ops.sort((a, b) => a.priority.compareTo(b.priority));
    _buildOps = List.unmodifiable(ops);

    return _buildOps;
  }

  freezeTextStyle(TextStyle textStyle) {
    if (_buildOpTextStyle != null) {
      throw new StateError('TextStyle has already been set');
    }

    _buildOpTextStyle = textStyle;
  }
}

enum StyleType {
  Heading1,
  Heading2,
  Heading3,
  Heading4,
  Heading5,
  Heading6,
}
