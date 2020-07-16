part of '../core_widget_factory.dart';

const _kAttributeAlign = 'align';
const _kCssTextAlign = 'text-align';
const _kCssTextAlignCenter = 'center';
const _kCssTextAlignJustify = 'justify';
const _kCssTextAlignLeft = 'left';
const _kCssTextAlignRight = 'right';

class _StyleTextAlign {
  final WidgetFactory wf;

  _StyleTextAlign(this.wf);

  BuildOp get buildOp => BuildOp(
        isBlockElement: true,
        onPieces: (meta, pieces) {
          final v = meta.style(_kCssTextAlign);
          if (v != null) {
            final textAlign = _getTextAlign(v);
            if (textAlign != null) meta.tsb.enqueue(tsb, textAlign);
          }

          return pieces;
        },
      );

  static TextAlign _getTextAlign(String v) {
    switch (v) {
      case _kCssTextAlignCenter:
        return TextAlign.center;
      case _kCssTextAlignJustify:
        return TextAlign.justify;
      case _kCssTextAlignLeft:
        return TextAlign.left;
      case _kCssTextAlignRight:
        return TextAlign.right;
    }

    return null;
  }

  static TextStyleHtml tsb(BuildContext _, TextStyleHtml p, TextAlign v) =>
      p.copyWith(align: v);
}
