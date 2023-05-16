part of '../core_ops.dart';

const kCssPadding = 'padding';

WidgetPlaceholder _paddingInlineAfter(
  HtmlStyleBuilder styleBuilder,
  CssLengthBox b,
) =>
    WidgetPlaceholder(
      builder: (c, _) =>
          _paddingInlineSizedBox(b.getValueRight(styleBuilder.build(c))),
      debugLabel: kCssPadding,
    );

WidgetPlaceholder _paddingInlineBefore(
  HtmlStyleBuilder styleBuilder,
  CssLengthBox b,
) =>
    WidgetPlaceholder(
      builder: (c, _) =>
          _paddingInlineSizedBox(b.getValueLeft(styleBuilder.build(c))),
      debugLabel: kCssPadding,
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
            final before = _paddingInlineBefore(tree.styleBuilder, padding);
            tree.prepend(WidgetBit.inline(tree, before));
          }

          if (padding.mayHaveRight) {
            final after = _paddingInlineAfter(tree.styleBuilder, padding);
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
            debugLabel: kCssPadding,
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
