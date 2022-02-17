part of '../core_ops.dart';

const kCssPadding = 'padding';

WidgetPlaceholder _paddingInlineAfter(
  HtmlStyleBuilder styleBuilder,
  CssLengthBox b,
) =>
    WidgetPlaceholder(
      builder: (c, _) =>
          _paddingInlineSizedBox(b.getValueRight(styleBuilder.build(c))),
      localName: kCssPadding,
    );

WidgetPlaceholder _paddingInlineBefore(
  HtmlStyleBuilder styleBuilder,
  CssLengthBox b,
) =>
    WidgetPlaceholder(
      builder: (c, _) =>
          _paddingInlineSizedBox(b.getValueLeft(styleBuilder.build(c))),
      localName: kCssPadding,
    );

Widget _paddingInlineSizedBox(double? width) =>
    width != null && width > 0 ? SizedBox(width: width) : widget0;

class StylePadding {
  static const kPriorityBoxModel3k = 3000;

  final WidgetFactory wf;

  StylePadding(this.wf);

  BuildOp get buildOp => BuildOp(
        onTreeFlattening: (tree) {
          final padding = tryParseCssLengthBox(tree, kCssPadding);
          if (padding == null) {
            return false;
          }

          if (padding.mayHaveLeft) {
            final before = _paddingInlineBefore(tree.styleBuilder, padding);
            tree.prepend(WidgetBit.inline(tree, before));
          }

          if (padding.mayHaveRight) {
            final after = _paddingInlineAfter(tree.styleBuilder, padding);
            tree.append(WidgetBit.inline(tree, after));
          }

          return true;
        },
        onWidgets: (tree, widgets) {
          final padding = tryParseCssLengthBox(tree, kCssPadding);
          if (padding == null) {
            return null;
          }

          if (widgets.isEmpty) {
            return widgets;
          }

          return [
            WidgetPlaceholder(
              localName: kCssPadding,
              child: wf.buildColumnPlaceholder(tree, widgets),
            ).wrapWith(
              (context, child) => _build(tree, context, child, padding),
            )
          ];
        },
        onWidgetsIsOptional: true,
        priority: kPriorityBoxModel3k,
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
