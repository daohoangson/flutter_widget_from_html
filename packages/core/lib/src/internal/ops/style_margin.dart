part of '../core_ops.dart';

const kCssMargin = 'margin';

Widget _marginHorizontalBuilder(Widget w, CssLengthBox b, TextStyleHtml tsh) =>
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
          if (widgets?.isNotEmpty != true) return null;
          final m = tryParseCssLengthBox(meta, kCssMargin);
          if (m == null) return null;

          final t = m.top?.isNotEmpty == true;
          final b = m.bottom?.isNotEmpty == true;
          final ws = List<WidgetPlaceholder>(
              (t ? 1 : 0) + widgets.length + (b ? 1 : 0));
          final tsb = meta.tsb();

          var i = 0;
          if (t) ws[i++] = HeightPlaceholder(m.top, tsb);

          for (final widget in widgets) {
            if (m.hasLeftOrRight) {
              widget.wrapWith(
                  (c, w) => _marginHorizontalBuilder(w, m, tsb.build(c)));
            }

            ws[i++] = widget;
          }

          if (b) ws[i++] = HeightPlaceholder(m.bottom, tsb);

          return ws;
        },
        onWidgetsIsOptional: true,
        priority: kPriorityBoxModel9k,
      );
}
