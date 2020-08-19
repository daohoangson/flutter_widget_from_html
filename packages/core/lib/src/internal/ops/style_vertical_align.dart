part of '../core_ops.dart';

const kCssVerticalAlign = 'vertical-align';
const kCssVerticalAlignBaseline = 'baseline';
const kCssVerticalAlignTop = 'top';
const kCssVerticalAlignBottom = 'bottom';
const kCssVerticalAlignMiddle = 'middle';
const kCssVerticalAlignSub = 'sub';
const kCssVerticalAlignSuper = 'super';

class StyleVerticalAlign {
  final WidgetFactory wf;

  StyleVerticalAlign(this.wf);

  BuildOp get buildOp => BuildOp(
        onPieces: (meta, pieces) {
          if (meta.isBlockElement) return pieces;

          final v = meta[kCssVerticalAlign];
          if (v == null || v == kCssVerticalAlignBaseline) return pieces;

          return pieces.map((piece) => _buildWidgetSpan(meta, piece, v));
        },
      );

  BuiltPiece _buildWidgetSpan(BuildMetadata meta, BuiltPiece piece, String v) {
    if (piece.widgets != null) return piece;

    final alignment = _tryParse(v);
    if (alignment == null) return piece;

    final text = piece.text;
    final replacement = (text.parent?.sub(text.tsb) ?? TextBits(text.tsb))
      ..detach();
    text.replaceWith(replacement);

    final built = wf.buildText(meta, text);
    final newPiece = BuiltPiece.text(replacement);
    if (built == null) return newPiece;

    if (v == kCssVerticalAlignSub || v == kCssVerticalAlignSuper) {
      built.wrapWith(
        (context, child) => _build(
          context,
          meta,
          child,
          EdgeInsets.only(
            bottom: v == kCssVerticalAlignSub ? .4 : 0,
            top: v == kCssVerticalAlignSuper ? .4 : 0,
          ),
        ),
      );
    }
    replacement.add(TextWidget(replacement, built, alignment: alignment));

    return newPiece;
  }

  Widget _build(BuildContext context, BuildMetadata meta, Widget child,
      EdgeInsets padding) {
    final tsh = meta.tsb().build(context);
    final fontSize = tsh.style.fontSize;

    return wf.buildStack(
      meta,
      tsh,
      <Widget>[
        wf.buildPadding(
          meta,
          Opacity(child: child, opacity: 0),
          EdgeInsets.only(
            bottom: fontSize * padding.bottom,
            top: fontSize * padding.top,
          ),
        ),
        Positioned(
          child: child,
          bottom: padding.top > 0 ? null : 0,
          top: padding.bottom > 0 ? null : 0,
        )
      ],
    );
  }

  static PlaceholderAlignment _tryParse(String value) {
    switch (value) {
      case kCssVerticalAlignTop:
      case kCssVerticalAlignSub:
        return PlaceholderAlignment.top;
      case kCssVerticalAlignSuper:
      case kCssVerticalAlignBottom:
        return PlaceholderAlignment.bottom;
      case kCssVerticalAlignMiddle:
        return PlaceholderAlignment.middle;
    }

    return null;
  }
}
