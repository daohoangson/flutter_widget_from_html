part of '../core_ops.dart';

const kCssMargin = 'margin';

Widget _marginHorizontalBuilder(Widget w, CssLengthBox b, TextStyleHtml tsh) =>
    Padding(
      padding: EdgeInsets.only(
        left: max(b.getValueLeft(tsh) ?? 0.0, 0.0),
        right: max(b.getValueRight(tsh) ?? 0.0, 0.0),
      ),
      child: w,
    );

class StyleMargin {
  static const kPriorityBoxModel9k = 9000;

  final WidgetFactory wf;

  StyleMargin(this.wf);

  BuildOp get buildOp => BuildOp(
        onTreeFlattening: (meta, tree) {
          final m = tryParseCssLengthBox(meta, kCssMargin);
          if (m == null) {
            return;
          }

          final mayHaveLeft = m.mayHaveLeft;
          final mayHaveRight = m.mayHaveRight;
          if (!mayHaveLeft && !mayHaveRight) {
            return;
          }

          return wrapTree(
            tree,
            append: mayHaveRight
                ? (p) => WidgetBit.inline(p, _paddingInlineAfter(p.tsb, m))
                : null,
            prepend: mayHaveLeft
                ? (p) => WidgetBit.inline(p, _paddingInlineBefore(p.tsb, m))
                : null,
          );
        },
        onWidgets: (meta, widgets) {
          final m = tryParseCssLengthBox(meta, kCssMargin);
          if (m == null) {
            return widgets;
          }

          final tsb = meta.tsb;
          return [
            if (m.top?.isPositive ?? false) HeightPlaceholder(m.top!, tsb),
            for (final widget in widgets)
              if (m.mayHaveLeft || m.mayHaveRight)
                widget.wrapWith(
                  (c, w) => _marginHorizontalBuilder(w, m, tsb.build(c)),
                )
              else
                widget,
            if (m.bottom?.isPositive ?? false)
              HeightPlaceholder(m.bottom!, tsb),
          ];
        },
        onWidgetsIsOptional: true,
        priority: kPriorityBoxModel9k,
      );
}
