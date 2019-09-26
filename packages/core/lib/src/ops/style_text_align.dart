part of '../core_widget_factory.dart';

const kCssTextAlign = 'text-align';
const kCssTextAlignCenter = 'center';
const kCssTextAlignJustify = 'justify';
const kCssTextAlignLeft = 'left';
const kCssTextAlignRight = 'right';

TextStyle _styleTextAlignBuilder(
  TextStyleBuilders tsb,
  TextStyle parent,
  TextAlign align,
) {
  tsb.textAlign = align;
  return parent;
}

class _StyleTextAlign {
  final WidgetFactory wf;

  _StyleTextAlign(this.wf);

  BuildOp get buildOp => BuildOp(
        isBlockElement: true,
        onPieces: (meta, pieces) {
          String v;
          meta.styles((k, _v) => k == kCssTextAlign ? v = _v : null);
          if (v == null) return pieces;

          // handle texts
          meta.tsb.enqueue(_styleTextAlignBuilder, _getTextAlign(v));

          // handle widgets
          final newPieces = <BuiltPiece>[];
          for (final p in pieces) {
            if (p.widgets?.isNotEmpty == true) {
              final alignment = _getAlignment(v);
              final widgets = p.widgets.map((w) => wf.buildAlign(w, alignment));
              newPieces.add(BuiltPieceSimple(widgets: widgets));
            } else {
              newPieces.add(p);
            }
          }

          return newPieces;
        },
      );
}

Alignment _getAlignment(String textAlign) {
  switch (textAlign) {
    case kCssTextAlignCenter:
      return Alignment.center;
    case kCssTextAlignJustify:
      return Alignment.centerLeft;
    case kCssTextAlignLeft:
      return Alignment.centerLeft;
    case kCssTextAlignRight:
      return Alignment.centerRight;
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
