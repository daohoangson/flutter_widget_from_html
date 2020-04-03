part of '../widget_factory.dart';

TextStyle _tagAExtendedAccentColor(
  TextStyleBuilders tsb,
  TextStyle parent,
  _,
) =>
    parent.copyWith(color: Theme.of(tsb.bc.context).accentColor);

class _TagAExtended {
  BuildOp get buildOp => BuildOp(
        onPieces: (meta, pieces) {
          var hasStyleColor = false;
          meta.styles((k, _) => hasStyleColor |= (k == 'color'));

          if (!hasStyleColor) meta.tsb.enqueue(_tagAExtendedAccentColor, null);

          return pieces;
        },
      );
}
