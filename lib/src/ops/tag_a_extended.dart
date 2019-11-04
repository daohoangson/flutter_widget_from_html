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
          var hasCssColor = false;
          meta.styles((k, _) => hasCssColor |= k == core.kCssColor);

          if (!hasCssColor) meta.tsb.enqueue(_tagAExtendedAccentColor, null);

          return pieces;
        },
      );
}
