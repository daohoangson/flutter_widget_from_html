part of '../core_widget_factory.dart';

class _TagA {
  final WidgetFactory wf;

  _TagA(this.wf);

  BuildOp get buildOp => BuildOp(
        defaultStyles: (meta, __) {
          final styles = [_kCssTextDecoration, _kCssTextDecorationUnderline];

          if (wf.hyperlinkColor != null) {
            styles.addAll([
              _kCssColor,
              _convertColorToHex(wf.hyperlinkColor),
            ]);
          }

          return styles;
        },
        onPieces: (meta, pieces) {
          final onTap = _buildGestureTapCallback(meta);
          if (onTap == null) return pieces;

          final recognizer =
              TapGestureRecognizer(debugOwner: meta.domElement.outerHtml)
                ..onTap = onTap;

          return pieces.map(
            (piece) => piece.hasWidgets
                ? BuiltPiece.widgets(WidgetPlaceholder.wrap(
                    piece.widgets, wf.buildGestureDetectors, onTap))
                : _buildBlock(meta, piece, onTap, recognizer),
          );
        },
      );

  BuiltPiece _buildBlock(
    NodeMetadata meta,
    BuiltPiece piece,
    GestureTapCallback onTap,
    GestureRecognizer recognizer,
  ) =>
      piece
        ..text.bits.forEach((bit) => bit is TextWidget
            ? bit.widget?.wrapWith(wf.buildGestureDetectors, onTap)
            : bit.tsb?.recognizer = recognizer);

  GestureTapCallback _buildGestureTapCallback(NodeMetadata meta) {
    final attrs = meta.domElement.attributes;
    final href = attrs.containsKey('href') ? attrs['href'] : null;
    final url = wf.constructFullUrl(href);
    return wf.buildGestureTapCallbackForUrl(url);
  }
}
