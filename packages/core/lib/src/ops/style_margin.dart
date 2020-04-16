part of '../core_widget_factory.dart';

const _kCssMargin = 'margin';

Iterable<Widget> _marginHorizontalBuilder(
  BuildContext context,
  Iterable<Widget> children,
  _MarginHorizontalInput input,
) {
  final direction = Directionality.of(context);
  final marginLeft = input.marginLeft ??
      (direction == TextDirection.ltr
          ? input.marginInlineStart
          : input.marginInlineEnd);
  final marginRight = input.marginRight ??
      (direction == TextDirection.ltr
          ? input.marginInlineEnd
          : input.marginInlineStart);

  final tsb = input.meta.tsb;
  final padding = EdgeInsets.only(
    left: marginLeft?.getValue(context, tsb) ?? 0.0,
    right: marginRight?.getValue(context, tsb) ?? 0.0,
  );

  return children.map((child) {
    if (child is _MarginHorizontal) {
      final existing = child.padding as EdgeInsets;
      return _MarginHorizontal(
        child.child,
        existing.copyWith(
          left: existing.left + padding.left,
          right: existing.right + padding.right,
        ),
      );
    }

    return _MarginHorizontal(child, padding);
  }).toList();
}

class _MarginHorizontal extends Padding {
  _MarginHorizontal(Widget child, EdgeInsets padding)
      : super(child: child, padding: padding);
}

class _MarginHorizontalInput {
  CssLength marginInlineEnd;
  CssLength marginInlineStart;
  CssLength marginLeft;
  CssLength marginRight;
  NodeMetadata meta;
  WidgetFactory wf;
}

Iterable<Widget> _marginVerticalBuilder(
  BuildContext context,
  Iterable<Widget> widgets,
  _MarginVerticalInput input,
) {
  final widget = widgets?.isNotEmpty == true ? widgets.first : null;
  final existingHeight = widget is SizedBox ? widget.height : 0.0;
  final height = input.height.getValue(context, input.tsb);
  if (height > existingHeight) return [SizedBox(height: height)];
  return widgets;
}

class _MarginVerticalInput {
  final TextStyleBuilders tsb;
  final CssLength height;

  _MarginVerticalInput(this.tsb, this.height);
}

class _MarginVerticalPlaceholder
    extends WidgetPlaceholder<_MarginVerticalInput> {
  _MarginVerticalPlaceholder(TextStyleBuilders tsb, CssLength height)
      : assert(height != null),
        super(
          builder: _marginVerticalBuilder,
          input: _MarginVerticalInput(tsb, height),
        );

  void mergeWith(_MarginVerticalPlaceholder other) {
    final otherBuilders = other.builders.toList(growable: false);
    final otherInputs = other.inputs.toList(growable: false);
    for (var i = 0; i < otherBuilders.length; i++) {
      if (otherBuilders[i] == _marginVerticalBuilder &&
          otherInputs[i] is _MarginVerticalInput) {
        super.wrapWith<_MarginVerticalInput>(
            _marginVerticalBuilder, otherInputs[i]);
      }
    }
  }

  @override
  void wrapWith<T>(WidgetPlaceholderBuilder<T> builder, [T input]) => this;
}

class _StyleMargin {
  final WidgetFactory wf;

  _StyleMargin(this.wf);

  BuildOp get buildOp => BuildOp(
        onWidgets: (meta, widgets) {
          if (widgets?.isNotEmpty != true) return null;
          final m = wf.parseCssMargin(meta);
          if (m == null) return null;

          final t = m.top?.isNotEmpty == true;
          final lr = m.inlineEnd?.isNotEmpty == true ||
              m.left?.isNotEmpty == true ||
              m.right?.isNotEmpty == true ||
              m.inlineStart?.isNotEmpty == true;
          final b = m.bottom?.isNotEmpty == true;
          final ws = List<Widget>((t ? 1 : 0) + widgets.length + (b ? 1 : 0));
          final tsb = meta.tsb;

          var i = 0;
          if (t) ws[i++] = _MarginVerticalPlaceholder(tsb, m.top);

          if (lr) {
            for (final widget in widgets) {
              final input = _MarginHorizontalInput()
                ..marginInlineEnd = m.inlineEnd
                ..marginInlineStart = m.inlineStart
                ..marginLeft = m.left
                ..marginRight = m.right
                ..meta = meta
                ..wf = wf;

              ws[i++] = widget is WidgetPlaceholder
                  ? (widget..wrapWith(_marginHorizontalBuilder, input))
                  : WidgetPlaceholder(
                      builder: _marginHorizontalBuilder,
                      children: [widget],
                      input: input,
                    );
            }
          } else {
            for (final widget in widgets) {
              ws[i++] = widget;
            }
          }

          if (b) ws[i++] = _MarginVerticalPlaceholder(tsb, m.bottom);

          return ws;
        },
        priority: 99999,
      );
}
