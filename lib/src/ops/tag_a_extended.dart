part of '../widget_factory.dart';

TextStyle _tagAExtendedAccentColor(
  TextStyleBuilders tsb,
  TextStyle parent,
  _,
) =>
    parent.copyWith(color: Theme.of(tsb.context).accentColor);

class _TagAExtended {
  BuildOp get buildOp => BuildOp(
        onPieces: (meta, pieces) {
          if (meta.style('color') == null) {
            meta.tsb.enqueue(_tagAExtendedAccentColor, null);
          }

          return pieces;
        },
      );
}
