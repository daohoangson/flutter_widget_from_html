part of '../core_ops.dart';

const kCssBoxSizing = 'box-sizing';
const kCssBoxSizingContentBox = 'content-box';
const kCssBoxSizingBorderBox = 'border-box';

class StyleBorder {
  static const kPriorityBoxModel7k = 7000;

  final WidgetFactory wf;

  late final BuildOp inlineOp;
  late final BuildOp blockOp;

  static final _skipBuilding = Expando<bool>();

  StyleBorder(this.wf) {
    inlineOp = BuildOp(
      onTreeFlattening: (tree) {
        if (_skipBuilding[tree] == true) {
          return;
        }

        final border = tryParseBorder(tree);
        if (border.isNoOp) {
          return;
        }

        final built = tree.build()?.wrapWith(
              (context, child) => _buildBorder(tree, context, child, border),
            );
        if (built == null) {
          return;
        }

        const baseline = PlaceholderAlignment.baseline;
        tree.replaceWith(WidgetBit.inline(tree, built, alignment: baseline));
      },
      priority: 0,
    );

    blockOp = BuildOp(
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
      priority: kPriorityBoxModel7k,
    );
  }

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
