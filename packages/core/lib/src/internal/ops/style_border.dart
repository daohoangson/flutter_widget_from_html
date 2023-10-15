part of '../core_ops.dart';

class StyleBorder {
  final WidgetFactory wf;

  static final _skipBuilding = Expando<bool>();

  StyleBorder(this.wf);

  BuildOp get buildOp => BuildOp(
        alwaysRenderBlock: false,
        debugLabel: kCssBorder,
        onParsed: (tree) {
          final parent = tree.parent;
          if (tree.isInline != true) {
            return tree;
          }

          final border = tryParseBorder(tree);
          if (border.isNoOp) {
            return tree;
          }

          skip(tree);
          return parent.sub()
            ..append(
              WidgetBit.inline(
                tree,
                WidgetPlaceholder(
                  builder: (context, child) {
                    final built = _buildBorder(tree, context, child, border);
                    return built ?? child;
                  },
                  debugLabel: '${tree.element.localName}--$kCssBorder',
                  child: tree.build(),
                ),
              ),
            );
        },
        onRenderBlock: (tree, placeholder) {
          if (_skipBuilding[tree] == true) {
            return placeholder;
          }

          final border = tryParseBorder(tree);
          if (border.isNoOp) {
            return placeholder;
          }

          skip(tree);
          return WidgetPlaceholder(
            builder: (ctx, _) => _buildBorder(tree, ctx, placeholder, border),
            debugLabel: '${tree.element.localName}--$kCssBorder',
          );
        },
        priority: BoxModel.border,
      );

  Widget? _buildBorder(
    BuildTree tree,
    BuildContext context,
    Widget child,
    CssBorder cssBorder,
  ) {
    final resolved = tree.inheritanceResolvers.resolve(context);
    final border = cssBorder.getBorder(resolved);
    final borderRadius = cssBorder.getBorderRadius(resolved);
    return wf.buildDecoration(
      tree,
      child,
      border: border,
      borderRadius: borderRadius,
    );
  }

  static void skip(BuildTree tree) => _skipBuilding[tree] = true;
}
