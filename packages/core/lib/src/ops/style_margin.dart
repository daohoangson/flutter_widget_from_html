part of '../core_widget_factory.dart';

const _kCssMargin = 'margin';

Iterable<Widget> _marginHorizontalBuilder(
  BuildContext context,
  Iterable<Widget> children,
  _MarginHorizontalInput input,
) {
  final direction = Directionality.of(context);
  final margin = input.margin;
  final tsb = input.tsb;
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
  final CssLengthBox margin;
  final TextStyleBuilder tsb;
  final WidgetFactory wf;
  _MarginHorizontalInput(this.margin, this.tsb, this.wf);
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

@immutable
class _MarginVerticalInput {
  final CssLength height;
  final TextStyleBuilder tsb;
  _MarginVerticalInput(this.height, this.tsb);
}

class _MarginVerticalPlaceholder
    extends WidgetPlaceholder<_MarginVerticalInput> {
  _MarginVerticalPlaceholder(TextStyleBuilder tsb, CssLength height)
      : assert(height != null),
        super(
          builder: _marginVerticalBuilder,
          input: _MarginVerticalInput(height, tsb),
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
          if (!wf.widget.useWidgetSpan) return pieces;
          if (meta.isBlockElement) return pieces;
          final m = wf.parseCssLengthBox(meta, _kCssMargin);
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
          final m = wf.parseCssLengthBox(meta, _kCssMargin);
          if (m == null) return null;

          final t = m.top?.isNotEmpty == true;
          final b = m.bottom?.isNotEmpty == true;
          final ws = List<WidgetPlaceholder>(
              (t ? 1 : 0) + widgets.length + (b ? 1 : 0));
          final tsb = meta.tsb();

          var i = 0;
          if (t) ws[i++] = _MarginVerticalPlaceholder(tsb, m.top);

          for (final widget in widgets) {
            if (m.hasLeftOrRight) {
              widget.wrapWith(
                _marginHorizontalBuilder,
                _MarginHorizontalInput(m, tsb, wf),
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
