import 'package:flutter/widgets.dart';

NodeMetadata lazySet(
  NodeMetadata meta, {
  BuildOp buildOp,
  Color color,
  bool decorationLineThrough,
  bool decorationOverline,
  bool decorationUnderline,
  String fontFamily,
  double fontSize,
  bool fontStyleItalic,
  FontWeight fontWeight,
  bool isBlockElement,
  bool isNotRenderable,
  EdgeInsetsGeometry margin,
  StyleType style,
  bool textSpaceCollapse,
}) {
  meta ??= NodeMetadata();

  if (buildOp != null) meta.buildOp = buildOp;
  if (color != null) meta.color = color;
  if (decorationLineThrough != null)
    meta.decorationLineThrough = decorationLineThrough;
  if (decorationOverline != null) meta.decorationOverline = decorationOverline;
  if (decorationUnderline != null)
    meta.decorationUnderline = decorationUnderline;
  if (fontFamily != null) meta.fontFamily = fontFamily;
  if (fontSize != null) meta.fontSize = fontSize;
  if (fontStyleItalic != null) meta.fontStyleItalic = fontStyleItalic;
  if (fontWeight != null) meta.fontWeight = fontWeight;
  if (isBlockElement != null) meta._isBlockElement = isBlockElement;
  if (isNotRenderable != null) meta.isNotRenderable = isNotRenderable;
  if (margin != null) meta.margin = margin;
  if (style != null) meta.style = style;
  if (textSpaceCollapse != null) meta.textSpaceCollapse = textSpaceCollapse;

  return meta;
}

class BuildOp {
  final BuildOpOnPieces onPieces;
  final BuildOpOnProcess onProcess;
  final BuildOpOnWidgets onWidgets;

  BuildOp({
    this.onPieces,
    this.onProcess,
    this.onWidgets,
  });

  bool get isBlockElement => onWidgets != null;
}

typedef List<BuiltPiece> BuildOpOnPieces(
  NodeMetadata meta,
  List<BuiltPiece> pieces,
);
typedef void BuildOpOnProcess(
  NodeMetadata meta,
  BuildOpOnProcessAddSpan addSpan,
  BuildOpOnProcessAddWidgets addWidgets,
  BuildOpOnProcessWrite write,
);
typedef void BuildOpOnProcessAddSpan(TextSpan span);
typedef void BuildOpOnProcessAddWidgets(List<Widget> widgets);
typedef void BuildOpOnProcessWrite(String text);
typedef List<Widget> BuildOpOnWidgets(NodeMetadata meta, List<Widget> widgets);

abstract class BuiltPiece {
  bool get hasText;
  bool get hasTextSpan;
  bool get hasWidgets;

  String get text;
  TextAlign get textAlign;
  TextSpan get textSpan;
  List<Widget> get widgets;

  set textAlign(TextAlign textAlign);
}

class BuiltPieceSimple extends BuiltPiece {
  final String text;
  TextAlign textAlign;
  final TextSpan textSpan;
  final List<Widget> widgets;

  BuiltPieceSimple({this.text, this.textSpan, this.widgets});

  bool get hasText => text != null;
  bool get hasTextSpan => textSpan != null;
  bool get hasWidgets => widgets != null;
}

class NodeMetadata {
  BuildOp buildOp;
  Color color;
  bool decorationLineThrough;
  bool decorationOverline;
  bool decorationUnderline;
  String fontFamily;
  double fontSize;
  bool fontStyleItalic;
  FontWeight fontWeight;
  bool _isBlockElement;
  bool isNotRenderable;
  EdgeInsetsGeometry margin;
  StyleType style;
  bool textSpaceCollapse;

  bool get hasStyling =>
      color != null ||
      fontFamily != null ||
      fontSize != null ||
      fontWeight != null ||
      hasDecoration ||
      hasFontStyle ||
      style != null ||
      textSpaceCollapse != null;

  bool get hasDecoration =>
      decorationLineThrough != null ||
      decorationOverline != null ||
      decorationUnderline != null;

  bool get hasFontStyle => fontStyleItalic != null;

  bool get isBlockElement =>
      buildOp?.isBlockElement == true ||
      _isBlockElement == true ||
      margin != null;
}

enum StyleType {
  Heading1,
  Heading2,
  Heading3,
  Heading4,
  Heading5,
  Heading6,
}
