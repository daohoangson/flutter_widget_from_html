part of '../core_widget_factory.dart';

const kCssBackgroundColor = 'background-color';

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
        final bgColor = _parseColor(meta);
        if (bgColor == null) return pieces;

        return pieces.map((p) => p.hasWidgets ? p : _buildBlock(p, bgColor));
      },
      onWidgets: (meta, widgets) {
        final bgColor = _parseColor(meta);
        if (bgColor == null) return null;

        return [IWidgetPlaceholder.wrapOne(widgets, _build, bgColor)];
      });

  Iterable<Widget> _build(BuilderContext _, Iterable<Widget> ws, Color c) =>
      [wf.buildDecoratedBox(wf.buildBody(ws), color: c)];

  BuiltPiece _buildBlock(BuiltPiece piece, Color bgColor) => piece
    ..block.rebuildBits((bit) => bit is DataBit
        ? bit.rebuild(
            tsb: bit.tsb.sub()..enqueue(_styleBgColorTextStyleBuilder, bgColor),
          )
        : bit);

  Color _parseColor(NodeMetadata meta) {
    String value;
    meta.styles((k, v) => k == kCssBackgroundColor ? value = v : null);
    if (value == null) return null;

    return parseColor(value);
  }
}
