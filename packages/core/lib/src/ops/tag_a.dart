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

          return pieces.map(
            (piece) => piece.hasWidgets
                ? BuiltPiece.widgets(WidgetPlaceholder.wrap(
                    piece.widgets, wf.buildGestureDetectors, onTap))
                : _buildBlock(meta, piece, onTap),
          );
        },
      );

  BuiltPiece _buildBlock(
    NodeMetadata meta,
    BuiltPiece piece,
    GestureTapCallback onTap,
  ) =>
      piece
        ..text.bits.toList(growable: false).forEach((bit) => bit is TextWidget
            ? bit.widget?.wrapWith(wf.buildGestureDetectors, onTap)
            : bit is TextData
                ? bit.replaceWith(_TagATextData(bit, onTap, wf))
                : null);

  GestureTapCallback _buildGestureTapCallback(NodeMetadata meta) {
    final attrs = meta.domElement.attributes;
    final href = attrs.containsKey('href') ? attrs['href'] : null;
    final url = wf.constructFullUrl(href);
    return wf.buildGestureTapCallbackForUrl(url);
  }
}

class _TagATextData extends TextData {
  final TextData bit;
  final GestureTapCallback onTap;
  final WidgetFactory wf;

  _TagATextData(this.bit, this.onTap, this.wf)
      : super(bit.parent, bit.data, bit.tsb);

  @override
  bool get canCompile => true;

  @override
  InlineSpan compile(TextStyle style) =>
      wf.buildGestureTapCallbackSpan(bit.data, onTap, style);
}
