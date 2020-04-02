part of '../core_widget_factory.dart';

class _TagA {
  final WidgetFactory wf;

  _TagA(this.wf);

  BuildOp get buildOp => BuildOp(
        defaultStyles: (meta, __) {
          final styles = [kCssTextDecoration, kCssTextDecorationUnderline];

          if (wf.hyperlinkColor != null) {
            styles.addAll([
              kCssColor,
              convertColorToHex(wf.hyperlinkColor),
            ]);
          }

          return styles;
        },
        onPieces: (meta, pieces) {
          final onTap = _buildGestureTapCallback(meta);
          if (onTap == null) return pieces;

          return pieces.map(
            (piece) => piece.hasWidgets
                ? BuiltPieceSimple(
                    widgets: IWidgetPlaceholder.wrap(
                        piece.widgets, wf.buildGestureDetectors, wf, onTap),
                  )
                : _buildBlock(meta, piece, onTap),
          );
        },
      );

  BuiltPiece _buildBlock(
    NodeMetadata meta,
    BuiltPiece piece,
    GestureTapCallback onTap,
  ) {
    GestureRecognizer recognizer;
    for (final bit in piece.text.bits) {
      if (bit.hasWidget) {
        bit.widget?.wrapWith(wf.buildGestureDetectors, onTap);
      } else {
        recognizer ??=
            (TapGestureRecognizer(debugOwner: meta.domElement.outerHtml)
              ..onTap = onTap);
        bit.tsb?.recognizer = recognizer;
      }
    }

    return piece;
  }

  GestureTapCallback _buildGestureTapCallback(NodeMetadata meta) {
    final attrs = meta.domElement.attributes;
    final href = attrs.containsKey('href') ? attrs['href'] : null;
    final url = wf.constructFullUrl(href);
    return wf.buildGestureTapCallbackForUrl(url);
  }
}
