part of '../core_widget_factory.dart';

const kCssVerticalAlign = 'vertical-align';
const kCssVerticalAlignBaseline = 'baseline';
const kCssVerticalAlignTop = 'top';
const kCssVerticalAlignBottom = 'bottom';
const kCssVerticalAlignMiddle = 'middle';
const kCssVerticalAlignSub = 'sub';
const kCssVerticalAlignSuper = 'super';

class _StyleVerticalAlign {
  final WidgetFactory wf;

  _StyleVerticalAlign(this.wf);

  BuildOp get buildOp => BuildOp(
        onPieces: (meta, pieces) {
          if (meta.isBlockElement) return pieces;

          String v;
          meta.styles((k, _v) => k == kCssVerticalAlign ? v = _v : null);
          if (v == null || v == kCssVerticalAlignBaseline) return pieces;

          return pieces.map((piece) => _buildWidgetSpan(piece, v));
        },
      );

  BuiltPiece _buildWidgetSpan(BuiltPiece piece, String verticalAlign) {
    if (piece.hasWidgets) return piece;

    final alignment = _getPlaceholderAlignment(verticalAlign);
    if (alignment == null || alignment == PlaceholderAlignment.baseline)
      return piece;

    final text = piece.text;
    final replacement = text.parent.sub(text.tsb)..detach();
    text.replaceWith(replacement);

    replacement.add(WidgetBit(
      text,
      WidgetPlaceholder<_StyleVerticalAlign>(builder: (bc, _, __) {
        var built = wf.buildText(bc, null, text);

        // `sub` and `super` require additional offset
        final dy = (verticalAlign == kCssVerticalAlignSub
            ? 2.5
            : (verticalAlign == kCssVerticalAlignSuper ? -2.5 : 0.0));
        if (dy != 0.0) {
          built = [
            Transform.translate(
              offset: Offset(0, text.tsb.build(bc).fontSize / dy),
              child: wf.buildColumn(wf.buildText(bc, null, text)),
            )
          ];
        }

        return built;
      }),
      alignment: alignment,
    ));

    return BuiltPieceSimple(text: replacement);
  }
}

PlaceholderAlignment _getPlaceholderAlignment(String verticalAlign) {
  switch (verticalAlign) {
    case kCssVerticalAlignBaseline:
      return PlaceholderAlignment.baseline;
    case kCssVerticalAlignTop:
    case kCssVerticalAlignSuper:
      return PlaceholderAlignment.top;
    case kCssVerticalAlignBottom:
    case kCssVerticalAlignSub:
      return PlaceholderAlignment.bottom;
    case kCssVerticalAlignMiddle:
      return PlaceholderAlignment.middle;
  }

  return null;
}
