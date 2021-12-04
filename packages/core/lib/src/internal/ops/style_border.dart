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
            return false;
          }

          final border = tryParseBorder(meta);
          if (border.isNoOp) {
            return false;
          }

          final built = wf.buildColumnPlaceholder(meta, tree.build())?.wrapWith(
                (context, child) => _buildBorder(meta, context, child, border),
              );
          if (built == null) {
            return false;
          }

          const baseline = PlaceholderAlignment.baseline;
          tree.replaceWith(WidgetBit.inline(tree, built, alignment: baseline));
          return true;
        },
        onWidgets: (meta, widgets) {
          if (_skipBuilding[meta] == true || widgets.isEmpty) {
            return null;
          }

          final border = tryParseBorder(meta);
          if (border.isNoOp) {
            return null;
          }

          return [
            WidgetPlaceholder(
              localName: kCssBorder,
              child: wf.buildColumnPlaceholder(meta, widgets),
            ).wrapWith((c, w) => _buildBorder(meta, c, w, border))
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

  static void skip(BuildMetadata meta) => _skipBuilding[meta] = true;
}
