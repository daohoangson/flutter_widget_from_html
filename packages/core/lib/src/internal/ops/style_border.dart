part of '../core_ops.dart';

const kCssBoxSizing = 'box-sizing';
const kCssBoxSizingContentBox = 'content-box';
const kCssBoxSizingBorderBox = 'border-box';

class StyleBorder {
  static const kPriorityBoxModel5k = 5000;

  final WidgetFactory wf;

  late final BuildOp inlineOp;
  late final BuildOp blockOp;

  static final _skipBuilding = Expando<bool>();

  StyleBorder(this.wf) {
    inlineOp = BuildOp(
      debugLabel: '$kCssBorder--inline',
      onFlattening: (tree) {
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
      debugLabel: '$kCssBorder--block',
      onBuilt: (tree, child) {
        if (_skipBuilding[tree] == true) {
          return null;
        }

        final border = tryParseBorder(tree);
        if (border.isNoOp) {
          return null;
        }

        return WidgetPlaceholder(
          builder: (ctx, _) => _buildBorder(tree, ctx, child, border),
          debugLabel: kCssBorder,
        );
      },
      onWidgetsIsOptional: true,
      priority: kPriorityBoxModel5k,
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
