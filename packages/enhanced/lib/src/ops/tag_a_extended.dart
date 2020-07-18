part of '../widget_factory.dart';

class _TagAExtended {
  BuildOp get buildOp => BuildOp(
        onPieces: (meta, pieces) {
          if (meta.style('color') == null) meta.tsb.enqueue(_tsb);
          return pieces;
        },
      );

  static Color _color(BuildContext context) => Theme.of(context).accentColor;

  static TextStyleHtml _tsb(BuildContext context, TextStyleHtml p, _) =>
      p.copyWith(style: p.style.copyWith(color: _color(context)));
}
