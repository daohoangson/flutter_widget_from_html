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

      return [SizedBox(width: width)];
    });

WidgetPlaceholder _paddingInlineBefore(
  TextStyleBuilder tsb,
  CssLengthBox box,
) =>
    WidgetPlaceholder(builder: (context, children, _) {
      final direction = Directionality.of(context);
      final width = box.left(direction)?.getValue(context, tsb);
      if (width == null || width <= 0) return null;

      return [SizedBox(width: width)];
    });

class _StylePadding {
  final WidgetFactory wf;

  _StylePadding(this.wf);

  BuildOp get buildOp => BuildOp(
        isBlockElement: false,
        onPieces: (meta, pieces) {
          if (meta.isBlockElement) return pieces;
          final padding = wf.parseCssPadding(meta);
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
          final padding = wf.parseCssPadding(meta);
          if (padding == null) return null;

          final input = _PaddingInput()
            ..meta = meta
            ..padding = padding;

          return _listOrNull(wf.buildColumn(widgets)?.wrapWith(_build, input));
        },
        priority: 9999,
      );

  Iterable<Widget> _build(
    BuildContext context,
    Iterable<Widget> children,
    _PaddingInput input,
  ) {
    final direction = Directionality.of(context);
    final padding = input.padding;
    final tsb = input.meta.tsb();
    final top = padding.top?.getValue(context, tsb);
    final right = padding.right(direction)?.getValue(context, tsb);
    final bottom = padding.bottom?.getValue(context, tsb);
    final left = padding.left(direction)?.getValue(context, tsb);

    return _listOrNull(wf.buildPadding(wf.buildColumn(children),
        EdgeInsets.fromLTRB(left ?? 0, top ?? 0, right ?? 0, bottom ?? 0)));
  }
}

class _PaddingInput {
  NodeMetadata meta;
  CssLengthBox padding;
}
