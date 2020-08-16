part of '../core_ops.dart';

const kAttributeAHref = 'href';
const kTagA = 'a';

class TagA {
  final WidgetFactory wf;
  final Color Function() colorCallback;

  TagA(this.wf, this.colorCallback);

  BuildOp get buildOp => BuildOp(
        defaultStyles: (meta, __) {
          final styles = {kCssTextDecoration: kCssTextDecorationUnderline};

          final color = colorCallback?.call();
          if (color != null) styles[kCssColor] = convertColorToHex(color);

          return styles;
        },
        onPieces: (meta, pieces) {
          final onTap = _gestureTapCallback(meta);
          if (onTap == null) return pieces;

          for (final piece in pieces) {
            if (piece.hasWidgets) {
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
    final href =
        attrs.containsKey(kAttributeAHref) ? attrs[kAttributeAHref] : null;
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
