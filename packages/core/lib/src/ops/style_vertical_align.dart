part of '../core_widget_factory.dart';

const _kCssVerticalAlign = 'vertical-align';
const _kCssVerticalAlignBaseline = 'baseline';
const _kCssVerticalAlignTop = 'top';
const _kCssVerticalAlignBottom = 'bottom';
const _kCssVerticalAlignMiddle = 'middle';
const _kCssVerticalAlignSub = 'sub';
const _kCssVerticalAlignSuper = 'super';

class _StyleVerticalAlign {
  final WidgetFactory wf;

  _StyleVerticalAlign(this.wf);

  BuildOp get buildOp => BuildOp(
        onPieces: (meta, pieces) {
          if (meta.isBlockElement) return pieces;

          String v = meta.style(_kCssVerticalAlign);
          if (v == null || v == _kCssVerticalAlignBaseline) return pieces;

          return pieces.map((piece) => _buildWidgetSpan(piece, v));
        },
      );

  BuiltPiece _buildWidgetSpan(BuiltPiece piece, String verticalAlign) {
    if (piece.hasWidgets) return piece;

    final alignment = _getPlaceholderAlignment(verticalAlign);
    if (alignment == null || alignment == PlaceholderAlignment.baseline) {
      return piece;
    }

    final text = piece.text;
    final replacement = (text.parent?.sub(text.tsb) ?? TextBits(text.tsb))
      ..detach();
    text.replaceWith(replacement);

    final built = wf.buildText(text);
    final newPiece = BuiltPiece.text(replacement);
    if (built == null) return newPiece;

    replacement.add(TextWidget(
      text,
      WidgetPlaceholder<_StyleVerticalAlign>(builder: (c, _, __) {
        // `sub` and `super` require additional offset
        final dy = (verticalAlign == _kCssVerticalAlignSub
            ? 2.5
            : (verticalAlign == _kCssVerticalAlignSuper ? -2.5 : 0.0));
        if (dy != 0.0) {
          return [
            Transform.translate(
              offset: Offset(0, text.tsb.build(c).fontSize / dy),
              child: built,
            )
          ];
        }

        return [built];
      }),
      alignment: alignment,
    ));

    return newPiece;
  }
}

PlaceholderAlignment _getPlaceholderAlignment(String verticalAlign) {
  switch (verticalAlign) {
    case _kCssVerticalAlignBaseline:
      return PlaceholderAlignment.baseline;
    case _kCssVerticalAlignTop:
    case _kCssVerticalAlignSuper:
      return PlaceholderAlignment.top;
    case _kCssVerticalAlignBottom:
    case _kCssVerticalAlignSub:
      return PlaceholderAlignment.bottom;
    case _kCssVerticalAlignMiddle:
      return PlaceholderAlignment.middle;
  }

  return null;
}
