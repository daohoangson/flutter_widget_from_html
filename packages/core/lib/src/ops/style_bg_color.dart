part of '../core_wf.dart';

const kCssBackgroundColor = 'background-color';

class StyleBgColor {
  final WidgetFactory wf;

  StyleBgColor(this.wf);

  BuildOp get buildOp => BuildOp(
        onPieces: (meta, pieces) {
          String value;
          meta.forEachInlineStyle(
            (k, v) => k == kCssBackgroundColor ? value = v : null,
          );
          if (value == null) return pieces;

          final bgColor = parser.colorParseValue(value);
          if (bgColor == null) return pieces;

          return pieces.map(
            (piece) =>
                (piece.hasWidgets
                    ? _buildWidgets(bgColor, piece.widgets)
                    : _buildTextSpan(bgColor, piece.textSpan)) ??
                piece,
          );
        },
      );

  BuiltPiece _buildTextSpan(Color bgColor, TextSpan textSpan) =>
      BuiltPieceSimple(
        textSpan: wf.buildTextSpanAgain(
          textSpan,
          textSpan.style.copyWith(background: Paint()..color = bgColor),
        ),
      );

  BuiltPiece _buildWidgets(Color bgColor, Iterable<Widget> widgets) {
    final column = wf.buildColumn(widgets);
    final box = wf.buildDecoratedBox(column, color: bgColor);
    if (box == null) return null;

    return BuiltPieceSimple(widgets: <Widget>[box]);
  }
}
