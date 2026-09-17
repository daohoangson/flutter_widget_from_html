part of '../core_ops.dart';

const kCssPadding = 'padding';

WidgetPlaceholder _paddingInlineAfter(BuildTree tree, CssLengthBox box) =>
    WidgetPlaceholder(
      builder: (context, _) {
        final resolved = tree.inheritanceResolvers.resolve(context);
        final right = box.getRight(resolved);
        return _paddingInlineSizedBox(right?.getValue(resolved));
      },
      debugLabel: '${tree.element.localName}--paddingInlineAfter',
    );

WidgetPlaceholder _paddingInlineBefore(BuildTree tree, CssLengthBox box) =>
    WidgetPlaceholder(
      builder: (context, _) {
        final resolved = tree.inheritanceResolvers.resolve(context);
        final left = box.getLeft(resolved);
        return _paddingInlineSizedBox(left?.getValue(resolved));
      },
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

          const bottom = PlaceholderAlignment.bottom;
          if (padding.mayHaveLeft) {
            final before = _paddingInlineBefore(tree, padding);
            tree.prepend(WidgetBit.inline(tree, before, alignment: bottom));
          }

          if (padding.mayHaveRight) {
            final after = _paddingInlineAfter(tree, padding);
            tree.append(WidgetBit.inline(tree, after, alignment: bottom));
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
        max(padding.getLeft(resolved)?.getValue(resolved) ?? 0.0, 0.0),
        max(padding.top?.getValue(resolved) ?? 0.0, 0.0),
        max(padding.getRight(resolved)?.getValue(resolved) ?? 0.0, 0.0),
        max(padding.bottom?.getValue(resolved) ?? 0.0, 0.0),
      ),
    );
  }
}
