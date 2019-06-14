part of '../core_widget_factory.dart';

const kCssBackgroundColor = 'background-color';

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

        final box = _buildBox(widgets, bgColor);
        if (box == null) return null;

        return [box];
      });

  BuiltPiece _buildBlock(BuiltPiece piece, Color bgColor) => piece
    ..block.rebuildBits((bit) => bit.style != null
        ? bit.rebuild(
            style: bit.style.copyWith(background: Paint()..color = bgColor),
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
