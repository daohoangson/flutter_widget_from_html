part of '../core_widget_factory.dart';

const _kCssPadding = 'padding';

WidgetPlaceholder _paddingInlineAfter(TextStyleBuilder tsb, CssLengthBox box) =>
    WidgetPlaceholder<CssLengthBox>(
      child: _paddingInlineSizedBox(box.getValueRight(tsb.build())),
      generator: box,
    );

WidgetPlaceholder _paddingInlineBefore(TextStyleBuilder tsb, CssLengthBox b) =>
    WidgetPlaceholder<CssLengthBox>(
      child: _paddingInlineSizedBox(b.getValueLeft(tsb.build())),
      generator: b,
    );

Widget _paddingInlineSizedBox(double width) =>
    width != null && width > 0 ? SizedBox(width: width) : widget0;

class _StylePadding {
  final WidgetFactory wf;

  _StylePadding(this.wf);

  BuildOp get buildOp => BuildOp(
        isBlockElement: false,
        onPieces: (meta, pieces) {
          if (meta.isBlockElement) return pieces;
          final padding = wf.parseCssLengthBox(meta, _kCssPadding);
          if (padding?.hasLeftOrRight != true) return pieces;

          return _wrapTextBits(
            pieces,
            appendBuilder: (parent) =>
                TextWidget(parent, _paddingInlineAfter(parent.tsb, padding)),
            prependBuilder: (parent) =>
                TextWidget(parent, _paddingInlineBefore(parent.tsb, padding)),
          );
        },
        onWidgets: (meta, widgets) {
          if (widgets?.isNotEmpty != true) return null;
          final padding = wf.parseCssLengthBox(meta, _kCssPadding);
          if (padding == null) return null;

          return _listOrNull(wf.buildColumnPlaceholder(widgets)?.wrapWith(
              (child) => _build(child, padding, meta.tsb().build())));
        },
        priority: 9999,
      );

  Widget _build(Widget child, CssLengthBox padding, TextStyleHtml tsh) =>
      wf.buildPadding(
        child,
        EdgeInsets.fromLTRB(
          padding.getValueLeft(tsh) ?? 0,
          padding.top?.getValue(tsh) ?? 0,
          padding.getValueRight(tsh) ?? 0,
          padding.bottom?.getValue(tsh) ?? 0,
        ),
      );
}
