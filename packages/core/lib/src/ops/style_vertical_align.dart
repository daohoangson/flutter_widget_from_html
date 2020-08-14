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

          final v = meta.getStyleValue(_kCssVerticalAlign);
          if (v == null || v == _kCssVerticalAlignBaseline) return pieces;

          return pieces.map((piece) => _buildWidgetSpan(meta, piece, v));
        },
      );

  BuiltPiece _buildWidgetSpan(NodeMetadata meta, BuiltPiece piece, String v) {
    if (piece.hasWidgets) return piece;

    final alignment = _tryParse(v);
    if (alignment == null) return piece;

    final text = piece.text;
    final replacement = (text.parent?.sub(text.tsb) ?? TextBits(text.tsb))
      ..detach();
    text.replaceWith(replacement);

    final built = wf.buildText(meta, text);
    final newPiece = BuiltPiece.text(replacement);
    if (built == null) return newPiece;

    if (v == _kCssVerticalAlignSub || v == _kCssVerticalAlignSuper) {
      built.wrapWith(
        (child) => _build(
          meta,
          child,
          EdgeInsets.only(
            bottom: v == _kCssVerticalAlignSub ? .4 : 0,
            top: v == _kCssVerticalAlignSuper ? .4 : 0,
          ),
        ),
      );
    }
    replacement.add(TextWidget(replacement, built, alignment: alignment));

    return newPiece;
  }

  Widget _build(NodeMetadata meta, Widget child, EdgeInsets padding) {
    final fontSize = meta.tsb().build().style.fontSize;

    return wf.buildStack(
      meta,
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
      case _kCssVerticalAlignTop:
      case _kCssVerticalAlignSub:
        return PlaceholderAlignment.top;
      case _kCssVerticalAlignSuper:
      case _kCssVerticalAlignBottom:
        return PlaceholderAlignment.bottom;
      case _kCssVerticalAlignMiddle:
        return PlaceholderAlignment.middle;
    }

    return null;
  }
}
