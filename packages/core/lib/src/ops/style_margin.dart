part of '../core_widget_factory.dart';

const _kCssMargin = 'margin';

Iterable<Widget> _marginHorizontalBuilder(
  BuildContext context,
  Iterable<Widget> children,
  _MarginHorizontalInput input,
) {
  final direction = Directionality.of(context);
  final margin = input.margin;
  final tsb = input.meta.tsb;
  final padding = EdgeInsets.only(
    left: margin.left(direction)?.getValue(context, tsb) ?? 0.0,
    right: margin.right(direction)?.getValue(context, tsb) ?? 0.0,
  );

  return children.map((child) => _MarginHorizontal(child, padding));
}

class _MarginHorizontal extends Padding {
  _MarginHorizontal(Widget child, EdgeInsets padding)
      : super(child: child, padding: padding);
}

class _MarginHorizontalInput {
  CssLengthBox margin;
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
  _MarginVerticalPlaceholder wrapWith<T>(WidgetPlaceholderBuilder<T> builder,
          [T input]) =>
      this;
}

class _StyleMargin {
  final WidgetFactory wf;

  _StyleMargin(this.wf);

  BuildOp get buildOp => BuildOp(
        isBlockElement: false,
        onPieces: (meta, pieces) {
          if (meta.isBlockElement) return pieces;
          final margin = wf.parseCssMargin(meta);
          if (margin?.hasLeftOrRight != true) return pieces;

          return _wrapTextBits(
            pieces,
            appendBuilder: (parent) =>
                TextWidget(parent, _paddingInlineAfter(parent.tsb, margin)),
            prependBuilder: (parent) =>
                TextWidget(parent, _paddingInlineBefore(parent.tsb, margin)),
          );
        },
        onWidgets: (meta, widgets) {
          if (widgets?.isNotEmpty != true) return null;
          final m = wf.parseCssMargin(meta);
          if (m == null) return null;

          final t = m.top?.isNotEmpty == true;
          final b = m.bottom?.isNotEmpty == true;
          final ws = List<WidgetPlaceholder>(
              (t ? 1 : 0) + widgets.length + (b ? 1 : 0));
          final tsb = meta.tsb;

          var i = 0;
          if (t) ws[i++] = _MarginVerticalPlaceholder(tsb, m.top);

          for (final widget in widgets) {
            if (m.hasLeftOrRight) {
              widget.wrapWith(
                _marginHorizontalBuilder,
                _MarginHorizontalInput()
                  ..margin = m
                  ..meta = meta
                  ..wf = wf,
              );
            }

            ws[i++] = widget;
          }

          if (b) ws[i++] = _MarginVerticalPlaceholder(tsb, m.bottom);

          return ws;
        },
        priority: 99999,
      );
}
