part of '../core_ops.dart';

const kCssMargin = 'margin';

Widget _marginHorizontalBuilder(Widget w, CssLengthBox b, HtmlStyle style) =>
    Padding(
      padding: EdgeInsets.only(
        left: max(b.getValueLeft(style) ?? 0.0, 0.0),
        right: max(b.getValueRight(style) ?? 0.0, 0.0),
      ),
      child: w,
    );

class StyleMargin {
  static const kPriorityBoxModel9k = 9000;

  final WidgetFactory wf;

  StyleMargin(this.wf);

  BuildOp get buildOp => BuildOp(
        onTreeFlattening: (tree) {
          final margin = tryParseCssLengthBox(tree, kCssMargin);
          if (margin == null) {
            return false;
          }

          if (margin.mayHaveLeft) {
            final before = _paddingInlineBefore(tree.styleBuilder, margin);
            tree.prepend(WidgetBit.inline(tree, before));
          }

          if (margin.mayHaveRight) {
            final after = _paddingInlineAfter(tree.styleBuilder, margin);
            tree.append(WidgetBit.inline(tree, after));
          }

          return true;
        },
        onWidgets: (tree, widgets) {
          final m = tryParseCssLengthBox(tree, kCssMargin);
          if (m == null) {
            return null;
          }

          final styleBuilder = tree.styleBuilder;
          return [
            if (m.top?.isPositive ?? false)
              HeightPlaceholder(m.top!, styleBuilder),
            for (final widget in widgets)
              if (m.mayHaveLeft || m.mayHaveRight)
                widget.wrapWith(
                  (c, w) =>
                      _marginHorizontalBuilder(w, m, styleBuilder.build(c)),
                )
              else
                widget,
            if (m.bottom?.isPositive ?? false)
              HeightPlaceholder(m.bottom!, styleBuilder),
          ];
        },
        onWidgetsIsOptional: true,
        priority: kPriorityBoxModel9k,
      );
}
