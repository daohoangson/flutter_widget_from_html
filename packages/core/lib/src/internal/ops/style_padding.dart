part of '../core_ops.dart';

const kCssPadding = 'padding';

WidgetPlaceholder _paddingInlineAfter(BuildTree tree, CssLengthBox b) =>
    WidgetPlaceholder(
      builder: (c, _) =>
          _paddingInlineSizedBox(b.getValueRight(tree.styleBuilder.build(c))),
      debugLabel: '${tree.element.localName}--paddingInlineAfter',
    );

WidgetPlaceholder _paddingInlineBefore(BuildTree tree, CssLengthBox b) =>
    WidgetPlaceholder(
      builder: (c, _) =>
          _paddingInlineSizedBox(b.getValueLeft(tree.styleBuilder.build(c))),
      debugLabel: '${tree.element.localName}--paddingInlineBefore',
    );

Widget _paddingInlineSizedBox(double? width) =>
    width != null && width > 0 ? SizedBox(width: width) : widget0;

class StylePadding {
  static const kPriorityBoxModel5k = 5000;

  final WidgetFactory wf;

  StylePadding(this.wf);

  BuildOp get buildOp => BuildOp(
        debugLabel: kCssPadding,
        mustBeBlock: false,
        onFlattening: (tree) {
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
        onBuilt: (tree, child) {
          final padding = tryParseCssLengthBox(tree, kCssPadding);
          if (padding == null) {
            return null;
          }

          return WidgetPlaceholder(
            builder: (ctx, w) => _build(tree, ctx, w, padding),
            debugLabel: '${tree.element.localName}--paddingBlock',
            child: child,
          );
        },
        priority: kPriorityBoxModel5k,
      );

  Widget? _build(
    BuildTree tree,
    BuildContext context,
    Widget child,
    CssLengthBox padding,
  ) {
    final style = tree.styleBuilder.build(context);
    return wf.buildPadding(
      tree,
      child,
      EdgeInsets.fromLTRB(
        max(padding.getValueLeft(style) ?? 0.0, 0.0),
        max(padding.top?.getValue(style) ?? 0.0, 0.0),
        max(padding.getValueRight(style) ?? 0.0, 0.0),
        max(padding.bottom?.getValue(style) ?? 0.0, 0.0),
      ),
    );
  }
}
