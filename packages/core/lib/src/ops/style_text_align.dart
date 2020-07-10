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
          // handle texts
          final v = meta.style(_kCssTextAlign);
          meta.tsb.enqueue(tsb, _getTextAlign(v));

          // handle widgets
          final alignment = _getAlignment(v);
          if (alignment == null) return pieces;
          final newPieces = <BuiltPiece>[];
          for (final p in pieces) {
            if (p.widgets?.isNotEmpty == true) {
              newPieces.add(BuiltPiece.widgets(WidgetPlaceholder.wrap(
                  p.widgets, wf.buildAligns, alignment)));
            } else {
              newPieces.add(p);
            }
          }

          return newPieces;
        },
      );

  static Alignment _getAlignment(String textAlign) {
    switch (textAlign) {
      case _kCssTextAlignCenter:
        return Alignment.center;
      case _kCssTextAlignJustify:
        return Alignment.centerLeft;
      case _kCssTextAlignLeft:
        return Alignment.centerLeft;
      case _kCssTextAlignRight:
        return Alignment.centerRight;
    }

    return null;
  }

  static TextAlign _getTextAlign(String textAlign) {
    switch (textAlign) {
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

Widget _childOf(Widget widget) {
  var x = widget;
  while (x is SingleChildRenderObjectWidget) {
    x = (x as SingleChildRenderObjectWidget).child;
  }
  return x;
}
