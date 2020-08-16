part of '../ops.dart';

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
  final WidgetFactory wf;

  StyleMargin(this.wf);

  BuildOp get buildOp => BuildOp(
        isBlockElement: false,
        onPieces: (meta, pieces) {
          if (meta.isBlockElement) return pieces;
          final m = wf.parseCssLengthBox(meta, kCssMargin);
          if (m?.hasLeftOrRight != true) return pieces;

          return _wrapTextBits(
            pieces,
            appendBuilder: (parent) =>
                TextWidget(parent, _paddingInlineAfter(parent.tsb, m)),
            prependBuilder: (parent) =>
                TextWidget(parent, _paddingInlineBefore(parent.tsb, m)),
          );
        },
        onWidgets: (meta, widgets) {
          if (widgets?.isNotEmpty != true) return null;
          final m = wf.parseCssLengthBox(meta, kCssMargin);
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
                (child) => _marginHorizontalBuilder(child, m, tsb.build()),
              );
            }

            ws[i++] = widget;
          }

          if (b) ws[i++] = HeightPlaceholder(m.bottom, tsb);

          return ws;
        },
        priority: 99999,
      );
}
