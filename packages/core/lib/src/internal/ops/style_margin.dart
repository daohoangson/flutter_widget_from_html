part of '../core_ops.dart';

const kCssMargin = 'margin';

Widget _marginHorizontalBuilder(
  Widget widget,
  CssLengthBox box,
  InheritedProperties resolved,
) {
  final left = box.getLeft(resolved);
  final leftValue = max(left?.getValue(resolved) ?? 0.0, 0.0);
  final right = box.getRight(resolved);
  final rightValue = max(right?.getValue(resolved) ?? 0.0, 0.0);

  return HorizontalMargin(
    left: left?.unit == CssLengthUnit.auto ? double.infinity : leftValue,
    right: right?.unit == CssLengthUnit.auto ? double.infinity : rightValue,
    child: widget,
  );
}

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
