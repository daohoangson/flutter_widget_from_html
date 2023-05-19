part of '../core_ops.dart';

class StyleBorder {
  static const kPriorityBoxModel7k = 7000;

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
      mustBeBlock: false,
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
          debugLabel: '${tree.element.localName}--$kCssBorder',
        );
      },
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
    );
  }

  static void skip(BuildTree tree) => _skipBuilding[tree] = true;
}
