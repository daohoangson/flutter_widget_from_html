part of '../core_ops.dart';

const kAttributeAHref = 'href';
const kTagA = 'a';

class TagA {
  final WidgetFactory wf;
  final Color Function() colorCallback;

  TagA(this.wf, this.colorCallback);

  BuildOp get buildOp => BuildOp(
        defaultStyles: (_) {
          final styles = {kCssTextDecoration: kCssTextDecorationUnderline};

          final color = colorCallback?.call();
          if (color != null) styles[kCssColor] = convertColorToHex(color);

          return styles;
        },
        onTree: (meta, tree) {
          if (meta.willBuildSubtree) return;

          final onTap = _gestureTapCallback(meta);
          if (onTap == null) return;

          for (final bit in tree.bits.toList(growable: false)) {
            if (bit is WidgetBit) {
              bit.child.wrapWith(
                  (_, child) => wf.buildGestureDetector(meta, child, onTap));
            } else if (bit.tsb != null) {
              _TagABit(bit.parent, bit.tsb, onTap).insertAfter(bit);
            }
          }
        },
        onWidgets: (meta, widgets) {
          final onTap = _gestureTapCallback(meta);
          if (onTap == null) return widgets;

          return listOrNull(wf.buildColumnPlaceholder(meta, widgets)?.wrapWith(
              (_, child) => wf.buildGestureDetector(meta, child, onTap)));
        },
        onWidgetsIsOptional: true,
      );

  GestureTapCallback _gestureTapCallback(BuildMetadata meta) {
    final href = meta.element.attributes[kAttributeAHref];
    return wf.gestureTapCallback(wf.urlFull(href) ?? href);
  }
}

class _TagABit extends BuildBit<GestureRecognizer, GestureRecognizer> {
  final GestureTapCallback onTap;

  _TagABit(BuildTree parent, TextStyleBuilder tsb, this.onTap)
      : super(parent, tsb);

  @override
  bool get swallowWhitespace => null;

  @override
  GestureRecognizer buildBit(GestureRecognizer recognizer) {
    if (recognizer is TapGestureRecognizer) {
      recognizer.onTap = onTap;
      return recognizer;
    }

    return TapGestureRecognizer()..onTap = onTap;
  }

  @override
  BuildBit copyWith({BuildTree parent, TextStyleBuilder tsb}) =>
      _TagABit(parent ?? this.parent, tsb ?? this.tsb, onTap);
}
