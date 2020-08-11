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
          final onTap = _buildGestureTapCallback(meta);
          if (onTap == null) return pieces;

          for (final piece in pieces) {
            if (piece.hasWidgets) {
              for (final placeholder in piece.widgets) {
                placeholder.wrapWith((w) => wf.buildGestureDetector(w, onTap));
              }
            } else {
              for (final bit in piece.text.bits.toList(growable: false)) {
                if (bit is TextWidget) {
                  bit.widget.wrapWith((w) => wf.buildGestureDetector(w, onTap));
                } else if (bit is TextData) {
                  bit.replaceWith(_TagATextData(bit, onTap, wf));
                }
              }
            }
          }

          return pieces;
        },
      );

  GestureTapCallback _buildGestureTapCallback(NodeMetadata meta) {
    final attrs = meta.domElement.attributes;
    final href = attrs.containsKey('href') ? attrs['href'] : null;
    return wf.buildGestureTapCallbackForUrl(wf.constructFullUrl(href) ?? href);
  }
}

class _TagATextData extends TextData {
  final TextData bit;
  final GestureTapCallback onTap;
  final WidgetFactory wf;

  _TagATextData(this.bit, this.onTap, this.wf)
      : super(bit.parent, bit.data, bit.tsb);

  @override
  bool get hasBuilder => true;

  @override
  TextSpanBuilder prepareBuilder(TextStyleBuilder tsb) =>
      TextSpanBuilder((context) => wf.buildGestureTapCallbackSpan(
          bit.data, onTap, tsb.build(context).styleWithHeight));
}
