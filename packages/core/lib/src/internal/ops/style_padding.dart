part of '../core_ops.dart';

const kCssPadding = 'padding';

WidgetPlaceholder _paddingInlineAfter(HtmlStyleBuilder tsb, CssLengthBox b) =>
    WidgetPlaceholder(
      builder: (c, _) => _paddingInlineSizedBox(b.getValueRight(tsb.build(c))),
      localName: kCssPadding,
    );

WidgetPlaceholder _paddingInlineBefore(HtmlStyleBuilder tsb, CssLengthBox b) =>
    WidgetPlaceholder(
      builder: (c, _) => _paddingInlineSizedBox(b.getValueLeft(tsb.build(c))),
      localName: kCssPadding,
    );

Widget _paddingInlineSizedBox(double? width) =>
    width != null && width > 0 ? SizedBox(width: width) : widget0;

class StylePadding {
  static const kPriorityBoxModel3k = 3000;

  final WidgetFactory wf;

  StylePadding(this.wf);

  BuildOp get buildOp => BuildOp(
        onTreeFlattening: (meta, tree) {
          final padding = tryParseCssLengthBox(meta, kCssPadding);
          if (padding == null) {
            return;
          }

          if (padding.mayHaveLeft) {
            tree.prepend(
              WidgetBit.inline(tree, _paddingInlineBefore(tree.tsb, padding)),
            );
          }

          if (padding.mayHaveRight) {
            tree.append(
              WidgetBit.inline(tree, _paddingInlineAfter(tree.tsb, padding)),
            );
          }
        },
        onWidgets: (meta, widgets) {
          if (widgets.isEmpty) {
            return widgets;
          }

          final padding = tryParseCssLengthBox(meta, kCssPadding);
          if (padding == null) {
            return null;
          }

          return [
            WidgetPlaceholder(
              localName: kCssPadding,
              child: wf.buildColumnPlaceholder(meta, widgets),
            ).wrapWith(
              (context, child) => _build(meta, context, child, padding),
            )
          ];
        },
        onWidgetsIsOptional: true,
        priority: kPriorityBoxModel3k,
      );

  Widget? _build(
    BuildMetadata meta,
    BuildContext context,
    Widget child,
    CssLengthBox padding,
  ) {
    final tsh = meta.tsb.build(context);
    return wf.buildPadding(
      meta,
      child,
      EdgeInsets.fromLTRB(
        max(padding.getValueLeft(tsh) ?? 0.0, 0.0),
        max(padding.top?.getValue(tsh) ?? 0.0, 0.0),
        max(padding.getValueRight(tsh) ?? 0.0, 0.0),
        max(padding.bottom?.getValue(tsh) ?? 0.0, 0.0),
      ),
    );
  }
}
