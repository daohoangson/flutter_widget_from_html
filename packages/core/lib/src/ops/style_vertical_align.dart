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
          if (!wf.widget.useWidgetSpan) return pieces;
          if (meta.isBlockElement) return pieces;

          final v = meta.style(_kCssVerticalAlign);
          if (v == null || v == _kCssVerticalAlignBaseline) return pieces;

          return pieces.map((piece) => _buildWidgetSpan(piece, v));
        },
      );

  BuiltPiece _buildWidgetSpan(BuiltPiece piece, String value) {
    if (piece.hasWidgets) return piece;

    final alignment = _tryParse(value);
    if (alignment == null) return piece;

    final text = piece.text;
    final replacement = (text.parent?.sub(text.tsb) ?? TextBits(text.tsb))
      ..detach();
    text.replaceWith(replacement);

    final built = wf.buildText(text);
    final newPiece = BuiltPiece.text(replacement);
    if (built == null) return newPiece;

    if (value == _kCssVerticalAlignSub || value == _kCssVerticalAlignSuper) {
      built.wrapWith(
        _build,
        _VerticalAlignInput(
          padding: EdgeInsets.only(
            bottom: value == _kCssVerticalAlignSub ? .4 : 0,
            top: value == _kCssVerticalAlignSuper ? .4 : 0,
          ),
          tsb: text.tsb,
          wf: wf,
        ),
      );
    }
    replacement.add(TextWidget(text, built, alignment: alignment));

    return newPiece;
  }

  static Iterable<Widget> _build(
    BuildContext context,
    Iterable<Widget> widgets,
    _VerticalAlignInput input,
  ) {
    final child = input.wf.buildColumn(widgets);
    final fontSize = input.tsb.build(context).style.fontSize;
    final padding = input.padding;

    return [
      Stack(children: <Widget>[
        input.wf.buildPadding(
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

@immutable
class _VerticalAlignInput {
  final EdgeInsets padding;
  final TextStyleBuilder tsb;
  final WidgetFactory wf;

  _VerticalAlignInput({this.padding, this.tsb, this.wf});
}
