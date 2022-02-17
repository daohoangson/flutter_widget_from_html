part of '../core_ops.dart';

const kCssBoxSizing = 'box-sizing';
const kCssBoxSizingContentBox = 'content-box';
const kCssBoxSizingBorderBox = 'border-box';

class StyleBorder {
  static const kPriorityBoxModel5k = 5000;

  final WidgetFactory wf;

  static final _skipBuilding = Expando<bool>();

  StyleBorder(this.wf);

  BuildOp get inlineOp => BuildOp(
        onTreeFlattening: (tree) {
          if (_skipBuilding[tree] == true) {
            return false;
          }

          final border = tryParseBorder(tree);
          if (border.isNoOp) {
            return false;
          }

          final built = wf.buildColumnPlaceholder(tree, tree.build())?.wrapWith(
                (context, child) => _buildBorder(tree, context, child, border),
              );
          if (built == null) {
            return false;
          }

          const baseline = PlaceholderAlignment.baseline;
          tree.replaceWith(WidgetBit.inline(tree, built, alignment: baseline));
          return true;
        },
        priority: 0,
      );

  BuildOp get blockOp => BuildOp(
        onWidgets: (tree, widgets) {
          if (_skipBuilding[tree] == true || widgets.isEmpty) {
            return null;
          }

          final border = tryParseBorder(tree);
          if (border.isNoOp) {
            return null;
          }

          return [
            WidgetPlaceholder(
              localName: kCssBorder,
              child: wf.buildColumnPlaceholder(tree, widgets),
            ).wrapWith((c, w) => _buildBorder(tree, c, w, border))
          ];
        },
        onWidgetsIsOptional: true,
        priority: kPriorityBoxModel5k,
      );

  Widget? _buildBorder(
    BuildTree tree,
    BuildContext context,
    Widget child,
    CssBorder cssBorder,
  ) {
    final style = tree.styleBuilder.build(context);
    final border = cssBorder.getBorder(style);
    final borderRadius = cssBorder.getBorderRadius(style);
    return wf.buildDecoration(
      tree,
      child,
      border: border,
      borderRadius: borderRadius,
      isBorderBox: tree[kCssBoxSizing]?.term == kCssBoxSizingBorderBox,
    );
  }

  static void skip(BuildTree tree) => _skipBuilding[tree] = true;
}
