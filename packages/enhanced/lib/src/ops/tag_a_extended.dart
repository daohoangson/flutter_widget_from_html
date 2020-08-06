part of '../widget_factory.dart';

class _TagAExtended {
  BuildOp get buildOp => BuildOp(
        onPieces: (meta, pieces) {
          if (meta.style('color') == null) meta.tsb(_tsb);
          return pieces;
        },
      );

  static TextStyleHtml _tsb(BuildContext c, TextStyleHtml p, _) =>
      p.copyWith(style: p.style.copyWith(color: Theme.of(c).accentColor));
}
