part of '../core_wf.dart';

const kCssTextAlign = 'text-align';
const kCssTextAlignCenter = 'center';
const kCssTextAlignJustify = 'justify';
const kCssTextAlignLeft = 'left';
const kCssTextAlignRight = 'right';

class StyleTextAlign {
  final WidgetFactory wf;

  StyleTextAlign(this.wf);

  BuildOp get buildOp => BuildOp(
        onPieces: (meta, pieces) {
          final v = _parseValue(meta);
          if (v == null) return pieces;

          final widgets = pieces.map(
            (piece) => piece.hasWidgets
                ? wf.buildAlign(wf.buildColumn(piece.widgets), _getAlignment(v))
                : wf.buildTextWidget(
                    piece.hasTextSpan ? piece.textSpan : piece.text,
                    textAlign: _getTextAlign(v),
                  ),
          );

          return <BuiltPiece>[BuiltPieceSimple(widgets: widgets)];
        },
      );
}

Alignment _getAlignment(String textAlign) {
  switch (textAlign) {
    case kCssTextAlignCenter:
      return Alignment.topCenter;
    case kCssTextAlignJustify:
      return Alignment.topLeft;
    case kCssTextAlignLeft:
      return Alignment.topLeft;
    case kCssTextAlignRight:
      return Alignment.topRight;
  }

  return null;
}

TextAlign _getTextAlign(String textAlign) {
  switch (textAlign) {
    case kCssTextAlignCenter:
      return TextAlign.center;
    case kCssTextAlignJustify:
      return TextAlign.justify;
    case kCssTextAlignLeft:
      return TextAlign.left;
    case kCssTextAlignRight:
      return TextAlign.right;
  }

  return null;
}

String _parseValue(NodeMetadata meta) {
  String value;

  final e = meta.buildOpElement;
  meta.forEachInlineStyle((k, v) => k == kCssTextAlign ? value = v : null);

  return value;
}
