part of '../core_ops.dart';

const kAttributeAHref = 'href';
const kTagA = 'a';

class TagA {
  final WidgetFactory wf;
  final Color Function() colorCallback;

  TagA(this.wf, this.colorCallback);

  BuildOp get buildOp => BuildOp(
        defaultStyles: (meta) {
          final styles = {kCssTextDecoration: kCssTextDecorationUnderline};

          final color = colorCallback?.call();
          if (color != null) styles[kCssColor] = convertColorToHex(color);

          return styles;
        },
        isBlockElement: false,
        onPieces: (meta, pieces) {
          if (meta.isBlockElement) return pieces;

          final onTap = _gestureTapCallback(meta);
          if (onTap == null) return pieces;

          for (final piece in pieces) {
            if (piece.widgets != null) {
              for (final widget in piece.widgets) {
                widget.wrapWith(
                    (_, child) => wf.buildGestureDetector(meta, child, onTap));
              }
            } else {
              for (final bit in piece.text.bits.toList(growable: false)) {
                if (bit is TextWidget) {
                  bit.child.wrapWith((_, child) =>
                      wf.buildGestureDetector(meta, child, onTap));
                } else if (bit is TextData) {
                  bit.replaceWith(_TagATextData(bit, onTap, wf));
                }
              }
            }
          }

          return pieces;
        },
        onWidgets: (meta, widgets) {
          final onTap = _gestureTapCallback(meta);
          if (onTap == null) return widgets;

          return listOrNull(wf.buildColumnPlaceholder(meta, widgets)?.wrapWith(
              (_, child) => wf.buildGestureDetector(meta, child, onTap)));
        },
      );

  GestureTapCallback _gestureTapCallback(BuildMetadata meta) {
    final attrs = meta.element.attributes;
    final href =
        attrs.containsKey(kAttributeAHref) ? attrs[kAttributeAHref] : null;
    return wf.gestureTapCallback(wf.urlFull(href) ?? href);
  }
}

class _TagATextData extends TextBit<TextStyleHtml, InlineSpan> {
  final String data;

  final GestureTapCallback onTap;

  @override
  final TextStyleBuilder tsb;

  final WidgetFactory wf;

  _TagATextData(TextData bit, this.onTap, this.wf)
      : data = bit.compile(null),
        tsb = bit.tsb,
        super(bit.parent);

  @override
  InlineSpan compile(TextStyleHtml tsh) =>
      wf.buildGestureTapCallbackSpan(data, onTap, tsh.styleWithHeight);
}
