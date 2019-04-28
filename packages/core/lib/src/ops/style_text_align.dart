part of '../core_widget_factory.dart';

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
          String v;
          meta.styles((k, _v) => k == kCssTextAlign ? v = _v : null);
          if (v == null) return pieces;

          final widgets = pieces.map(
            (p) => p.hasWidgets
                ? wf.buildAlign(wf.buildColumn(p.widgets), _getAlignment(v))
                : wf.buildText(block: p.block, textAlign: _getTextAlign(v)),
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
