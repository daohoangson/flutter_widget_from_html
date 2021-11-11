part of '../core_ops.dart';

const kAttributeAHref = 'href';
const kAttributeAName = 'name';
const kTagA = 'a';

class TagA {
  final WidgetFactory wf;

  TagA(this.wf);

  BuildOp get buildOp => BuildOp(
        defaultStyles: (_) {
          final styles = {kCssTextDecoration: kCssTextDecorationUnderline};

          return styles;
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
              _TagABit(bit.parent, onTap).insertAfter(bit);
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

class _TagABit extends BuildBit {
  final GestureTapCallback onTap;

  const _TagABit(BuildTree? parent, this.onTap) : super(parent);

  @override
  bool? get swallowWhitespace => null;

  @override
  void onFlatten(FlattenState flattener) {
    final recognizer = flattener.recognizer;
    if (recognizer is TapGestureRecognizer) {
      recognizer.onTap = onTap;
      flattener.recognizer = recognizer;
      return;
    }

    flattener.recognizer = TapGestureRecognizer()..onTap = onTap;
  }

  @override
  BuildBit copyWith({BuildTree? parent, TextStyleBuilder? tsb}) =>
      _TagABit(parent ?? this.parent, onTap);
}
