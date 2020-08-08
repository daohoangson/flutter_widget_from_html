part of '../core_widget_factory.dart';

const _kCssPadding = 'padding';

WidgetPlaceholder _paddingInlineAfter(
  TextStyleBuilder tsb,
  CssLengthBox box,
) =>
    WidgetPlaceholder(builder: (context, children, _) {
      final direction = Directionality.of(context);
      final width = box.right(direction)?.getValue(context, tsb);
      if (width == null || width <= 0) return null;

      return SizedBox(width: width);
    });

WidgetPlaceholder _paddingInlineBefore(
  TextStyleBuilder tsb,
  CssLengthBox box,
) =>
    WidgetPlaceholder(builder: (context, children, _) {
      final direction = Directionality.of(context);
      final width = box.left(direction)?.getValue(context, tsb);
      if (width == null || width <= 0) return null;

      return SizedBox(width: width);
    });

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

          final input = _PaddingInput(padding, meta.tsb());
          return _listOrNull(wf.buildColumn(widgets)?.wrapWith(_build, input));
        },
        priority: 9999,
      );

  Widget _build(BuildContext _, Widget child, _PaddingInput input) =>
      Builder(builder: (context) {
        final direction = Directionality.of(context);
        final padding = input.padding;
        final tsb = input.tsb;
        final t = padding.top?.getValue(context, tsb);
        final r = padding.right(direction)?.getValue(context, tsb);
        final b = padding.bottom?.getValue(context, tsb);
        final l = padding.left(direction)?.getValue(context, tsb);
        final edgeInsets = EdgeInsets.fromLTRB(l ?? 0, t ?? 0, r ?? 0, b ?? 0);
        return wf.buildPadding(child, edgeInsets);
      });
}

@immutable
class _PaddingInput {
  final CssLengthBox padding;
  final TextStyleBuilder tsb;
  _PaddingInput(this.padding, this.tsb);
}
