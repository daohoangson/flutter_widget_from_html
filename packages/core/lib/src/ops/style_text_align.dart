part of '../core_widget_factory.dart';

const kCssTextAlign = 'text-align';
const kCssTextAlignCenter = 'center';
const kCssTextAlignJustify = 'justify';
const kCssTextAlignLeft = 'left';
const kCssTextAlignRight = 'right';

class _StyleTextAlign {
  final WidgetFactory wf;

  _StyleTextAlign(this.wf);

  BuildOp get buildOp => BuildOp(
        onPieces: (meta, pieces) {
          String v;
          meta.styles((k, _v) => k == kCssTextAlign ? v = _v : null);
          if (v == null) return pieces;

          final widgets = <Widget>[];
          for (final p in pieces) {
            if (p.block?.detach() == true) {
              widgets.add(wf.buildText(p.block, textAlign: _getTextAlign(v)));
              continue;
            }

            if (p.widgets?.isNotEmpty == true) {
              final alignment = _getAlignment(v);
              widgets.addAll(p.widgets.map((w) => wf.buildAlign(w, alignment)));
            }
          }

          return <BuiltPiece>[BuiltPieceSimple(widgets: widgets)];
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
