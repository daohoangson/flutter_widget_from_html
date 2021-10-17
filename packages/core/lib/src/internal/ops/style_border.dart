part of '../core_ops.dart';

const kCssBoxSizing = 'box-sizing';
const kCssBoxSizingContentBox = 'content-box';
const kCssBoxSizingBorderBox = 'border-box';

class StyleBorder {
  static const kPriorityBoxModel5k = 5000;

  final WidgetFactory wf;

  static final _skipBuilding = Expando<bool>();

  StyleBorder(this.wf);

  BuildOp get buildOp => BuildOp(
        onTreeFlattening: (meta, tree) {
          if (_skipBuilding[meta] == true) {
            return;
          }

          final border = tryParseBorder(meta);
          if (border.isNoOp) {
            return;
          }

          _skipBuilding[meta] = true;
          final copied = tree.copyWith() as BuildTree;
          final built =
              wf.buildColumnPlaceholder(meta, copied.build())?.wrapWith(
                    (context, child) =>
                        _buildBorder(meta, context, child, border),
                  );
          if (built == null) {
            return;
          }

          WidgetBit.inline(
            tree.parent!,
            built,
            alignment: PlaceholderAlignment.baseline,
          ).insertBefore(tree);
          tree.detach();
        },
        onWidgets: (meta, widgets) {
          if (_skipBuilding[meta] == true || widgets.isEmpty) {
            return widgets;
          }

          final border = tryParseBorder(meta);
          if (border.isNoOp) {
            return widgets;
          }

          return [
            WidgetPlaceholder(
              border,
              child: wf.buildColumnPlaceholder(meta, widgets),
            ).wrapWith(
              (context, child) => _buildBorder(meta, context, child, border),
            )
          ];
        },
        onWidgetsIsOptional: true,
        priority: kPriorityBoxModel5k,
      );

  Widget? _buildBorder(
    BuildMetadata meta,
    BuildContext context,
    Widget child,
    CssBorder cssBorder,
  ) {
    final tsh = meta.tsb.build(context);
    final border = cssBorder.getBorder(tsh);
    final borderRadius = cssBorder.getBorderRadius(tsh);
    return wf.buildDecoration(
      meta,
      child,
      border: border,
      borderRadius: borderRadius,
      isBorderBox: meta[kCssBoxSizing]?.term == kCssBoxSizingBorderBox,
    );
  }

  static void skip(BuildMetadata meta) {
    assert(_skipBuilding[meta] != true, 'Built ${meta.element} already');
    _skipBuilding[meta] = true;
  }
}
