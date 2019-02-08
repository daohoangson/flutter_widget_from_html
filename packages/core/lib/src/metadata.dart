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
  final bool hasStyling;
  final bool _isBlockElement;
  final BuildOpOnPieces onPieces;
  final BuildOpOnProcess onProcess;
  final BuildOpOnWidgets onWidgets;

  BuildOp({
    this.hasStyling,
    bool isBlockElement,
    this.onPieces,
    this.onProcess,
    this.onWidgets,
  }) : this._isBlockElement = isBlockElement;

  bool get isBlockElement =>
      _isBlockElement != null ? _isBlockElement : onWidgets != null;
}

typedef List<BuiltPiece> BuildOpOnPieces(List<BuiltPiece> pieces);
typedef void BuildOpOnProcess(BuildOpOnProcessAddSpan addSpan,
    BuildOpOnProcessAddWidgets addWidgets, BuildOpOnProcessWrite write);
typedef void BuildOpOnProcessAddSpan(TextSpan span);
typedef void BuildOpOnProcessAddWidgets(List<Widget> widgets);
typedef void BuildOpOnProcessWrite(String text);
typedef List<Widget> BuildOpOnWidgets(List<Widget> widgets);

abstract class BuiltPiece {
  bool get hasText;
  bool get hasTextSpan;
  bool get hasWidgets;

  TextStyle get style;
  String get text;
  TextSpan get textSpan;
  TextSpan get textSpanTrimmedLeft;
  List<Widget> get widgets;
}

class BuiltPieceSimple extends BuiltPiece {
  final TextStyle style;
  final String text;
  final TextSpan textSpan;
  final List<Widget> widgets;

  BuiltPieceSimple({this.style, this.text, this.textSpan, this.widgets});

  bool get hasText => text != null;
  bool get hasTextSpan => textSpan != null;
  bool get hasWidgets => widgets != null;
  TextSpan get textSpanTrimmedLeft => textSpan;
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
      buildOp?.hasStyling == true ||
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
