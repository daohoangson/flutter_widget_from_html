part of '../core_widget_factory.dart';

const _kCssBackgroundColor = 'background-color';

TextStyle _styleBgColorTextStyleBuilder(
  TextStyleBuilders _,
  TextStyle parent,
  Color bgColor,
) =>
    parent.copyWith(background: Paint()..color = bgColor);

class _StyleBgColor {
  final WidgetFactory wf;

  _StyleBgColor(this.wf);

  BuildOp get buildOp => BuildOp(
        isBlockElement: false,
        onPieces: (meta, pieces) {
          if (meta.isBlockElement) return pieces;

          final bgColor = wf.parseColor(meta.style(_kCssBackgroundColor));
          if (bgColor == null) return pieces;

          return pieces.map((p) => p.hasWidgets ? p : _buildBlock(p, bgColor));
        },
        onWidgets: (meta, widgets) {
          final bgColor = wf.parseColor(meta.style(_kCssBackgroundColor));
          if (bgColor == null) return null;

          return [WidgetPlaceholder.wrapOne(widgets, _build, bgColor)];
        },
        priority: 15000,
      );

  Iterable<Widget> _build(BuildContext _, Iterable<Widget> ws, Color c) =>
      [wf.buildDecoratedBox(wf.buildBody(ws), color: c)];

  BuiltPiece _buildBlock(BuiltPiece piece, Color bgColor) => piece
    ..text.bits.forEach(
        (bit) => bit.tsb?.enqueue(_styleBgColorTextStyleBuilder, bgColor));
}
