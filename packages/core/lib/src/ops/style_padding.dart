part of '../core_widget_factory.dart';

const _kCssPadding = 'padding';

WidgetPlaceholder _paddingInlineAfter(
  TextStyleBuilder tsb,
  CssLengthBox box,
) =>
    WidgetPlaceholder<CssLengthBox>(
      child: Builder(builder: (context) {
        final direction = Directionality.of(context);
        final width = box.right(direction)?.getValue(context, tsb);
        if (width == null || width <= 0) return widget0;

        return SizedBox(width: width);
      }),
      generator: box,
    );

WidgetPlaceholder _paddingInlineBefore(
  TextStyleBuilder tsb,
  CssLengthBox box,
) =>
    WidgetPlaceholder<CssLengthBox>(
      child: Builder(builder: (context) {
        final direction = Directionality.of(context);
        final width = box.left(direction)?.getValue(context, tsb);
        if (width == null || width <= 0) return widget0;

        return SizedBox(width: width);
      }),
      generator: box,
    );

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

          return _listOrNull(wf
              .buildColumn(widgets)
              ?.wrapWith((child) => _build(child, padding, meta.tsb())));
        },
        priority: 9999,
      );

  Widget _build(Widget child, CssLengthBox padding, TextStyleBuilder tsb) =>
      Builder(builder: (context) {
        final direction = Directionality.of(context);
        final t = padding.top?.getValue(context, tsb);
        final r = padding.right(direction)?.getValue(context, tsb);
        final b = padding.bottom?.getValue(context, tsb);
        final l = padding.left(direction)?.getValue(context, tsb);
        final edgeInsets = EdgeInsets.fromLTRB(l ?? 0, t ?? 0, r ?? 0, b ?? 0);
        return wf.buildPadding(child, edgeInsets);
      });
}
