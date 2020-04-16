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

    // `sub` and `super` require additional offset
    // so we will use `Stack` with extra padding to avoid overlapping
    final useStack = verticalAlign == _kCssVerticalAlignSub ||
        verticalAlign == _kCssVerticalAlignSuper;

    final text = piece.text;
    final replacement = (text.parent?.sub(text.tsb) ?? TextBits(text.tsb))
      ..detach();
    text.replaceWith(replacement);

    final built = wf.buildText(text);
    final newPiece = BuiltPiece.text(replacement);
    if (built == null) return newPiece;

    replacement.add(TextWidget(
      text,
      useStack
          ? WidgetPlaceholder<_StyleVerticalAlign>(
              builder: (context, _, __) => [
                    Stack(children: <Widget>[
                      wf.buildPadding(
                        Opacity(child: built, opacity: 0),
                        EdgeInsets.symmetric(
                            vertical: text.tsb.build(context).fontSize / 2),
                      ),
                      Positioned(
                        child: built,
                        left: 0,
                        right: 0,
                        bottom:
                            alignment == PlaceholderAlignment.top ? null : 0,
                        top:
                            alignment == PlaceholderAlignment.bottom ? null : 0,
                      )
                    ]),
                  ])
          : built,
      alignment: useStack ? PlaceholderAlignment.middle : alignment,
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
