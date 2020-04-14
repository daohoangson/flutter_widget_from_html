part of '../core_widget_factory.dart';

const _kCssPadding = 'padding';

class _StylePadding {
  final WidgetFactory wf;

  _StylePadding(this.wf);

  BuildOp get buildOp => BuildOp(
        onWidgets: (meta, widgets) {
          if (widgets?.isNotEmpty != true) return null;
          final padding = wf.parseCssPadding(meta);
          if (padding == null) return null;

          final input = _PaddingInput()
            ..meta = meta
            ..padding = padding;

          if (widgets.length == 1) {
            final widget = widgets.first;
            if (widget is WidgetPlaceholder) {
              return [widget..wrapWith(_build, input)];
            }
          }

          return [
            WidgetPlaceholder(
              builder: _build,
              children: widgets,
              input: input,
            )
          ];
        },
        priority: kBuildOpPriorityPadding,
      );

  Iterable<Widget> _build(
    BuildContext context,
    Iterable<Widget> children,
    _PaddingInput input,
  ) {
    final direction = Directionality.of(context);
    final padding = input.padding;
    final tsb = input.meta.tsb;
    final top = padding.top?.getValue(context, tsb);
    final right = (padding.right ??
            (direction == TextDirection.ltr
                ? padding.inlineEnd
                : padding.inlineStart))
        ?.getValue(context, tsb);
    final bottom = padding.bottom?.getValue(context, tsb);
    final left = (padding.left ??
            (direction == TextDirection.ltr
                ? padding.inlineStart
                : padding.inlineEnd))
        ?.getValue(context, tsb);

    return _listOrNull(wf.buildPadding(wf.buildColumn(children),
        EdgeInsets.fromLTRB(left ?? 0, top ?? 0, right ?? 0, bottom ?? 0)));
  }
}

class _PaddingInput {
  NodeMetadata meta;
  CssLengthBox padding;
}
