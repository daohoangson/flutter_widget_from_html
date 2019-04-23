import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

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
  StyleType style,
}) {
  meta ??= NodeMetadata();

  if (buildOp != null) {
    meta.buildOps ??= [];
    if (meta.buildOps.indexOf(buildOp) == -1) {
      meta.buildOps.add(buildOp);
    }
  }
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

  List<Widget> onWidgets(NodeMetadata meta, List<Widget> widgets) {
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
typedef Widget BuildOpOnWidgets(NodeMetadata meta, List<Widget> widgets);

abstract class BuiltPiece {
  bool get hasText;
  bool get hasTextSpan;
  bool get hasWidgets;

  String get text;
  TextSpan get textSpan;
  TextStyle get textStyle;
  List<Widget> get widgets;
}

class BuiltPieceSimple extends BuiltPiece {
  final String text;
  final TextSpan textSpan;
  final TextStyle textStyle;
  final List<Widget> widgets;

  BuiltPieceSimple({this.text, this.textSpan, this.textStyle, this.widgets});

  bool get hasText => text != null;
  bool get hasTextSpan => textSpan != null;
  bool get hasWidgets => widgets != null;
}

class NodeMetadata {
  dom.Element _buildOpElement;
  List<BuildOp> buildOps;
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
  StyleType style;

  dom.Element get buildOpElement => _buildOpElement;

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
    return buildOps?.where((o) => o.isBlockElement)?.length?.compareTo(0) == 1;
  }

  void forEachOp(void f(BuildOp element)) => buildOps?.forEach(f);

  List<BuildOp> freezeOps(dom.Element e) {
    if (buildOps == null) return null;

    _buildOpElement = e;
    buildOps.sort((a, b) => a.priority.compareTo(b.priority));
    buildOps = List.unmodifiable(buildOps);

    return buildOps;
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
