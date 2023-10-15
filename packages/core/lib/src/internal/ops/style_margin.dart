part of '../core_ops.dart';

const kCssMargin = 'margin';

Widget _marginHorizontalBuilder(
  Widget widget,
  CssLengthBox box,
  InheritedProperties resolved,
) =>
    Padding(
      padding: EdgeInsets.only(
        left: max(box.getValueLeft(resolved) ?? 0.0, 0.0),
        right: max(box.getValueRight(resolved) ?? 0.0, 0.0),
      ),
      child: widget,
    );

class StyleMargin {
  final WidgetFactory wf;

  StyleMargin(this.wf);

  BuildOp get buildOp => BuildOp(
        alwaysRenderBlock: false,
        debugLabel: kCssMargin,
        onRenderBlock: (tree, placeholder) {
          final margin = tryParseCssLengthBox(tree, kCssMargin);
          if (margin == null) {
            return placeholder;
          }

          final marginTop = margin.top;
          final marginBottom = margin.bottom;
          final inheritanceResolvers = tree.inheritanceResolvers;
          final column = wf.buildColumnPlaceholder(tree, [
            if (marginTop != null && marginTop.isPositive)
              HeightPlaceholder(
                marginTop,
                inheritanceResolvers,
                debugLabel: '${tree.element.localName}--marginTop',
              ),
            if (margin.mayHaveLeft || margin.mayHaveRight)
              placeholder.wrapWith(
                (context, child) {
                  final resolved = inheritanceResolvers.resolve(context);
                  return _marginHorizontalBuilder(child, margin, resolved);
                },
              )
            else
              placeholder,
            if (marginBottom != null && marginBottom.isPositive)
              HeightPlaceholder(
                marginBottom,
                inheritanceResolvers,
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

          const bottom = PlaceholderAlignment.bottom;
          if (margin.mayHaveLeft) {
            final before = _paddingInlineBefore(tree, margin);
            tree.prepend(WidgetBit.inline(tree, before, alignment: bottom));
          }

          if (margin.mayHaveRight) {
            final after = _paddingInlineAfter(tree, margin);
            tree.append(WidgetBit.inline(tree, after, alignment: bottom));
          }
        },
        priority: BoxModel.margin,
      );
}
