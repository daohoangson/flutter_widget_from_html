part of '../core_ops.dart';

const kCssPadding = 'padding';

WidgetPlaceholder _paddingInlineAfter(BuildTree tree, CssLengthBox box) =>
    WidgetPlaceholder(
      builder: (context, _) => _paddingInlineSizedBox(
        box.getValueRight(tree.inheritanceResolvers.resolve(context)),
      ),
      debugLabel: '${tree.element.localName}--paddingInlineAfter',
    );

WidgetPlaceholder _paddingInlineBefore(BuildTree tree, CssLengthBox box) =>
    WidgetPlaceholder(
      builder: (context, _) => _paddingInlineSizedBox(
        box.getValueLeft(tree.inheritanceResolvers.resolve(context)),
      ),
      debugLabel: '${tree.element.localName}--paddingInlineBefore',
    );

Widget _paddingInlineSizedBox(double? width) =>
    width != null && width > 0 ? SizedBox(width: width) : widget0;

class StylePadding {
  final WidgetFactory wf;

  StylePadding(this.wf);

  BuildOp get buildOp => BuildOp(
        alwaysRenderBlock: false,
        debugLabel: kCssPadding,
        onRenderBlock: (tree, placeholder) {
          final padding = tryParseCssLengthBox(tree, kCssPadding);
          if (padding == null) {
            return placeholder;
          }

          return WidgetPlaceholder(
            builder: (context, child) => _build(tree, context, child, padding),
            debugLabel: '${tree.element.localName}--paddingBlock',
            child: placeholder,
          );
        },
        onRenderInline: (tree) {
          final padding = tryParseCssLengthBox(tree, kCssPadding);
          if (padding == null) {
            return;
          }

          if (padding.mayHaveLeft) {
            final before = _paddingInlineBefore(tree, padding);
            tree.prepend(WidgetBit.inline(tree, before));
          }

          if (padding.mayHaveRight) {
            final after = _paddingInlineAfter(tree, padding);
            tree.append(WidgetBit.inline(tree, after));
          }
        },
        priority: BoxModel.padding,
      );

  Widget? _build(
    BuildTree tree,
    BuildContext context,
    Widget child,
    CssLengthBox padding,
  ) {
    final resolved = tree.inheritanceResolvers.resolve(context);
    return wf.buildPadding(
      tree,
      child,
      EdgeInsets.fromLTRB(
        max(padding.getValueLeft(resolved) ?? 0.0, 0.0),
        max(padding.top?.getValue(resolved) ?? 0.0, 0.0),
        max(padding.getValueRight(resolved) ?? 0.0, 0.0),
        max(padding.bottom?.getValue(resolved) ?? 0.0, 0.0),
      ),
    );
  }
}
