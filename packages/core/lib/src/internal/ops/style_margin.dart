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
  final WidgetFactory wf;

  StyleMargin(this.wf);

  BuildOp get buildOp => BuildOp(
        debugLabel: kCssMargin,
        mustBeBlock: false,
        onRenderBlock: (tree, placeholder) {
          final margin = tryParseCssLengthBox(tree, kCssMargin);
          if (margin == null) {
            return placeholder;
          }

          final marginTop = margin.top;
          final marginBottom = margin.bottom;
          final styleBuilder = tree.styleBuilder;
          final column = wf.buildColumnPlaceholder(tree, [
            if (marginTop != null && marginTop.isPositive)
              HeightPlaceholder(
                marginTop,
                styleBuilder,
                debugLabel: '${tree.element.localName}--marginTop',
              ),
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
            if (marginBottom != null && marginBottom.isPositive)
              HeightPlaceholder(
                marginBottom,
                styleBuilder,
                debugLabel: '${tree.element.localName}--marginBottom',
              ),
          ]);
          return column ?? placeholder;
        },
        onRenderInline: (tree) {
          final margin = tryParseCssLengthBox(tree, kCssMargin);
          if (margin == null) {
            return;
          }

          if (margin.mayHaveLeft) {
            final before = _paddingInlineBefore(tree, margin);
            tree.prepend(WidgetBit.inline(tree, before));
          }

          if (margin.mayHaveRight) {
            final after = _paddingInlineAfter(tree, margin);
            tree.append(WidgetBit.inline(tree, after));
          }
        },
        priority: BoxModel.margin,
      );
}
