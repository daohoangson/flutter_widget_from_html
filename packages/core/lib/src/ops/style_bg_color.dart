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

        for (final piece in pieces) {
          if (piece.hasWidgets) continue;
          _buildBlock(piece, bgColor);
        }

        return pieces;
      },
      onWidgets: (meta, widgets) {
        final bgColor = _parseColor(meta);
        if (bgColor == null) return null;

        return listOfNonNullOrNothing(_buildBox(widgets, bgColor));
      });

  void _buildBlock(BuiltPiece piece, Color bgColor) {
    for (final bit in piece.block.bits) {
      bit.tsb?.enqueue(_styleBgColorTextStyleBuilder, bgColor);
    }
  }

  Widget _buildBox(Iterable<Widget> widgets, Color bgColor) =>
      wf.buildDecoratedBox(wf.buildBody(widgets), color: bgColor);

  Color _parseColor(NodeMetadata meta) {
    String value;
    meta.styles((k, v) => k == kCssBackgroundColor ? value = v : null);
    if (value == null) return null;

    return parseColor(value);
  }
}
