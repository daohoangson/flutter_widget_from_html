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

          final v = meta.style(_kCssVerticalAlign);
          if (v == null || v == _kCssVerticalAlignBaseline) return pieces;

          return pieces.map((piece) => _buildWidgetSpan(piece, v));
        },
      );

  BuiltPiece _buildWidgetSpan(BuiltPiece piece, String verticalAlign) {
    if (piece.hasWidgets) return piece;

    final text = piece.text;
    final input = _buildInput(verticalAlign, text.tsb);
    if (input == null || input.alignment == PlaceholderAlignment.baseline) {
      return piece;
    }

    final replacement = (text.parent?.sub(text.tsb) ?? TextBits(text.tsb))
      ..detach();
    text.replaceWith(replacement);

    final built = wf.buildText(text);
    final newPiece = BuiltPiece.text(replacement);
    if (built == null) return newPiece;

    replacement.add(TextWidget(
        text,
        input.padding != null
            ? built is WidgetPlaceholder
                ? (built..wrapWith(_build, input))
                : WidgetPlaceholder(
                    builder: _build,
                    children: [built],
                    input: input,
                  )
            : built,
        alignment: input.alignment));

    return newPiece;
  }

  Iterable<Widget> _build(
    BuildContext context,
    Iterable<Widget> widgets,
    _VerticalAlignInput input,
  ) {
    final child = wf.buildColumn(widgets);
    final fontSize = input.tsb.build(context).style.fontSize;
    final padding = input.padding;
    assert(padding != null);

    return [
      Stack(children: <Widget>[
        wf.buildPadding(
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
      ]),
    ];
  }
}

_VerticalAlignInput _buildInput(String verticalAlign, TextStyleBuilders tsb) {
  switch (verticalAlign) {
    case _kCssVerticalAlignTop:
      return _VerticalAlignInput(PlaceholderAlignment.top);
    case _kCssVerticalAlignBottom:
      return _VerticalAlignInput(PlaceholderAlignment.bottom);
    case _kCssVerticalAlignMiddle:
      return _VerticalAlignInput(PlaceholderAlignment.middle);
    case _kCssVerticalAlignSub:
      return _VerticalAlignInput(
        PlaceholderAlignment.top,
        padding: EdgeInsets.only(bottom: .4),
        tsb: tsb,
      );
    case _kCssVerticalAlignSuper:
      return _VerticalAlignInput(
        PlaceholderAlignment.bottom,
        padding: EdgeInsets.only(top: .4),
        tsb: tsb,
      );
  }

  return null;
}

@immutable
class _VerticalAlignInput {
  final PlaceholderAlignment alignment;
  final EdgeInsets padding;
  final TextStyleBuilders tsb;

  _VerticalAlignInput(this.alignment, {this.padding, this.tsb})
      : assert((padding == null) == (tsb == null));
}
