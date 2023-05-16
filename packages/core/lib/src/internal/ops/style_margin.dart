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
        debugLabel: kCssMargin,
        mustBeBlock: false,
        onFlattening: (tree) {
          final margin = tryParseCssLengthBox(tree, kCssMargin);
          if (margin == null) {
            return;
          }

          if (margin.mayHaveLeft) {
            final before = _paddingInlineBefore(tree.styleBuilder, margin);
            tree.prepend(WidgetBit.inline(tree, before));
          }

          if (margin.mayHaveRight) {
            final after = _paddingInlineAfter(tree.styleBuilder, margin);
            tree.append(WidgetBit.inline(tree, after));
          }
        },
        onBuilt: (tree, placeholder) {
          final margin = tryParseCssLengthBox(tree, kCssMargin);
          if (margin == null) {
            return null;
          }

          final styleBuilder = tree.styleBuilder;
          return wf.buildColumnPlaceholder(tree, [
            if (margin.top?.isPositive ?? false)
              HeightPlaceholder(margin.top!, styleBuilder),
            if (margin.mayHaveLeft || margin.mayHaveRight)
              placeholder.wrapWith(
                (context, child) => _marginHorizontalBuilder(
                  child,
                  margin,
                  styleBuilder.build(context),
                ),
              )
            else
              placeholder,
            if (margin.bottom?.isPositive ?? false)
              HeightPlaceholder(margin.bottom!, styleBuilder),
          ]);
        },
        priority: kPriorityBoxModel9k,
      );
}
