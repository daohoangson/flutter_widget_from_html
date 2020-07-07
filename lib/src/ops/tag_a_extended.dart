part of '../widget_factory.dart';

class _TagAExtended {
  BuildOp get buildOp => BuildOp(
        onPieces: (meta, pieces) {
          if (meta.style('color') == null) meta.tsb.enqueue(_tsb);
          return pieces;
        },
      );

  static Color _color(TextStyleBuilders tsb) =>
      Theme.of(tsb.context).accentColor;

  static TextStyleHtml _tsb(TextStyleBuilders tsb, TextStyleHtml p, _) =>
      p.copyWith(style: p.style.copyWith(color: _color(tsb)));
}
