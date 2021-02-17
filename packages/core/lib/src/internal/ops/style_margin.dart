part of '../core_ops.dart';

const kCssMargin = 'margin';

Widget _marginHorizontalBuilder(Widget w, CssLengthBox b, TextStyleHtml? tsh) =>
    Padding(
      child: w,
      padding: EdgeInsets.only(
        left: b.getValueLeft(tsh) ?? 0.0,
        right: b.getValueRight(tsh) ?? 0.0,
      ),
    );

class StyleMargin {
  static const kPriorityBoxModel9k = 9000;

  final WidgetFactory wf;

  StyleMargin(this.wf);

  BuildOp get buildOp => BuildOp(
        onTree: (meta, tree) {
          if (meta.willBuildSubtree) return;
          final m = tryParseCssLengthBox(meta, kCssMargin);
          if (m?.hasLeftOrRight != true) return;

          return wrapTree(
            tree,
            append: (p) => WidgetBit.inline(p, _paddingInlineAfter(p.tsb, m)),
            prepend: (p) => WidgetBit.inline(p, _paddingInlineBefore(p.tsb, m)),
          );
        },
        onWidgets: (meta, widgets) {
          if (widgets.isNotEmpty != true) return null;
          final m = tryParseCssLengthBox(meta, kCssMargin);
          if (m == null) return null;
          final tsb = meta.tsb();

          return [
            if (m.top?.isNotEmpty ?? false) HeightPlaceholder(m.top, tsb),
            for (final widget in widgets)
              if (m.hasLeftOrRight)
                widget.wrapWith(
                    (c, w) => _marginHorizontalBuilder(w, m, tsb.build(c)))
              else
                widget,
            if (m.bottom?.isNotEmpty ?? false) HeightPlaceholder(m.bottom, tsb),
          ];
        },
        onWidgetsIsOptional: true,
        priority: kPriorityBoxModel9k,
      );
}
