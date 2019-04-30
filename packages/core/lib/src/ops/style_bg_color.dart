part of '../core_widget_factory.dart';

const kCssBackgroundColor = 'background-color';

class StyleBgColor {
  final WidgetFactory wf;

  StyleBgColor(this.wf);

  BuildOp get buildOp => BuildOp(
        onPieces: (meta, pieces) {
          String value;
          meta.styles((k, v) => k == kCssBackgroundColor ? value = v : null);
          if (value == null) return pieces;

          final bgColor = colorParseValue(value);
          if (bgColor == null) return pieces;

          return pieces.map(
            (piece) =>
                (piece.hasWidgets
                    ? _buildWidgets(piece.widgets, bgColor)
                    : _buildBlock(piece, bgColor)) ??
                piece,
          );
        },
      );

  BuiltPiece _buildBlock(BuiltPiece piece, Color bgColor) => piece
    ..block.rebuildBits((bit) => bit.rebuild(
          style: bit.style.copyWith(background: Paint()..color = bgColor),
        ));

  BuiltPiece _buildWidgets(Iterable<Widget> widgets, Color bgColor) {
    final column = wf.buildColumn(widgets);
    final box = wf.buildDecoratedBox(column, color: bgColor);
    if (box == null) return null;

    return BuiltPieceSimple(widgets: <Widget>[box]);
  }
}
