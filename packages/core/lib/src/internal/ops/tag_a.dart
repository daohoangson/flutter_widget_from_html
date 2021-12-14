part of '../core_ops.dart';

const kAttributeAHref = 'href';
const kAttributeAName = 'name';
const kTagA = 'a';

class TagA {
  final WidgetFactory wf;

  TagA(this.wf);

  BuildOp get buildOp => BuildOp(
        defaultStyles: (_) => const {
          kCssTextDecoration: kCssTextDecorationUnderline,
        },
        onTreeFlattening: (meta, tree) {
          final onTap = _gestureTapCallback(meta);
          if (onTap == null) {
            return;
          }

          for (final bit in tree.bits.toList(growable: false)) {
            if (bit is WidgetBit) {
              bit.child.wrapWith(
                (_, child) => wf.buildGestureDetector(meta, child, onTap),
              );
            } else if (bit is! WhitespaceBit) {
              _TagABit(bit.parent, bit.tsb, onTap).insertAfter(bit);
            }
          }
        },
        onWidgets: (meta, widgets) {
          final onTap = _gestureTapCallback(meta);
          if (onTap == null) {
            return widgets;
          }

          return listOrNull(
            wf.buildColumnPlaceholder(meta, widgets)?.wrapWith(
                  (_, child) => wf.buildGestureDetector(meta, child, onTap),
                ),
          );
        },
        onWidgetsIsOptional: true,
      );

  GestureTapCallback? _gestureTapCallback(BuildMetadata meta) {
    final href = meta.element.attributes[kAttributeAHref];
    return href != null
        ? wf.gestureTapCallback(wf.urlFull(href) ?? href)
        : null;
  }
}

class _TagABit extends BuildBit<GestureRecognizer?, GestureRecognizer> {
  final GestureTapCallback onTap;

  const _TagABit(BuildTree? parent, TextStyleBuilder tsb, this.onTap)
      : super(parent, tsb);

  @override
  bool? get swallowWhitespace => null;

  @override
  GestureRecognizer buildBit(GestureRecognizer? recognizer) {
    if (recognizer is TapGestureRecognizer) {
      recognizer.onTap = onTap;
      return recognizer;
    }

    return TapGestureRecognizer()..onTap = onTap;
  }

  @override
  BuildBit copyWith({BuildTree? parent, TextStyleBuilder? tsb}) =>
      _TagABit(parent ?? this.parent, tsb ?? this.tsb, onTap);
}
