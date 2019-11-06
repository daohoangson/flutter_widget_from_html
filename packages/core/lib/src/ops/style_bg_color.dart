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

        return listOfNonNullOrNothing(_buildBox(widgets, bgColor));
      });

  BuiltPiece _buildBlock(BuiltPiece piece, Color bgColor) => piece
    ..block.rebuildBits((bit) => bit is DataBit
        ? bit.rebuild(
            tsb: bit.tsb.sub()..enqueue(_styleBgColorTextStyleBuilder, bgColor),
          )
        : bit);

  Widget _buildBox(Iterable<Widget> widgets, Color bgColor) =>
      wf.buildDecoratedBox(wf.buildBody(widgets), color: bgColor);

  Color _parseColor(NodeMetadata meta) {
    String value;
    meta.styles((k, v) => k == kCssBackgroundColor ? value = v : null);
    if (value == null) return null;

    return parseColor(value);
  }
}
