part of '../core_widget_factory.dart';

class _TagA {
  final WidgetFactory wf;

  _TagA(this.wf);

  BuildOp get buildOp => BuildOp(
        defaultStyles: (meta, __) {
          final styles = {_kCssTextDecoration: _kCssTextDecorationUnderline};

          final color = wf.widget?.hyperlinkColor;
          if (color != null) styles[_kCssColor] = _convertColorToHex(color);

          return styles;
        },
        onPieces: (meta, pieces) {
          final onTap = _gestureTapCallback(meta);
          if (onTap == null) return pieces;

          for (final piece in pieces) {
            if (piece.widgets != null) {
              for (final widget in piece.widgets) {
                widget.wrapWith(
                    (child) => wf.buildGestureDetector(meta, child, onTap));
              }
            } else {
              for (final bit in piece.text.bits.toList(growable: false)) {
                if (bit is TextWidget) {
                  bit.widget.wrapWith(
                      (child) => wf.buildGestureDetector(meta, child, onTap));
                } else if (bit is TextData) {
                  bit.replaceWith(_TagATextData(bit, onTap, wf));
                }
              }
            }
          }

          return pieces;
        },
      );

  GestureTapCallback _gestureTapCallback(NodeMetadata meta) {
    final attrs = meta.domElement.attributes;
    final href = attrs.containsKey('href') ? attrs['href'] : null;
    return wf.gestureTapCallback(wf.constructFullUrl(href) ?? href);
  }
}

class _TagATextData extends TextBit<InlineSpan> {
  @override
  final String data;

  final GestureTapCallback onTap;

  @override
  final TextStyleBuilder tsb;

  final WidgetFactory wf;

  _TagATextData(TextBit bit, this.onTap, this.wf)
      : data = bit.data,
        tsb = bit.tsb,
        super(bit.parent);

  @override
  bool get canCompile => true;

  @override
  InlineSpan compile(TextStyleBuilder tsb) =>
      wf.buildGestureTapCallbackSpan(data, onTap, tsb.build().styleWithHeight);
}
