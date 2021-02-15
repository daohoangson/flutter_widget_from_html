part of '../core_ops.dart';

const kCssBoxSizing = 'box-sizing';
const kCssBoxSizingContentBox = 'content-box';
const kCssBoxSizingBorderBox = 'border-box';

class StyleBorder {
  static const kPriorityBoxModel7k = 7000;

  final WidgetFactory wf;

  static final _skipBuilding = Expando<bool>();

  StyleBorder(this.wf);

  BuildOp get buildOp => BuildOp(
        onTree: (meta, tree) {
          if (meta.willBuildSubtree) return;
          final border = tryParseBorder(meta);
          if (border.isNone) return;

          _skipBuilding[meta] = true;
          final copied = tree.copyWith() as BuildTree;
          final built = wf
              .buildColumnPlaceholder(meta, copied.build())
              ?.wrapWith((context, child) =>
                  _buildBorder(meta, context, child, border));
          if (built == null) return;

          tree.replaceWith(WidgetBit.inline(tree, built));
        },
        onWidgets: (meta, widgets) {
          if (_skipBuilding[meta] == true || widgets?.isNotEmpty != true) {
            return widgets;
          }
          final border = tryParseBorder(meta);
          if (border.isNone) return widgets;

          _skipBuilding[meta] = true;
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
        priority: kPriorityBoxModel7k,
      );

  Widget _buildBorder(
    BuildMetadata meta,
    BuildContext context,
    Widget child,
    CssBorder border,
  ) {
    final tsh = meta.tsb().build(context);
    return wf.buildBorder(
      meta,
      child,
      border.getValue(tsh),
      isBorderBox: meta[kCssBoxSizing] == kCssBoxSizingBorderBox,
    );
  }

  static void skip(BuildMetadata meta) {
    assert(_skipBuilding[meta] != true, 'Built ${meta.element} already');
    _skipBuilding[meta] = true;
  }
}
