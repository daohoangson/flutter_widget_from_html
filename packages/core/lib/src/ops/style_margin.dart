part of '../core_widget_factory.dart';

const _kCssMargin = 'margin';
const _kCssMarginBottom = 'margin-bottom';
const _kCssMarginEnd = 'margin-end';
const _kCssMarginLeft = 'margin-left';
const _kCssMarginRight = 'margin-right';
const _kCssMarginStart = 'margin-start';
const _kCssMarginTop = 'margin-top';

final _valuesFourRegExp =
    RegExp(r'^([^\s]+)\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)$');
final _valuesTwoRegExp = RegExp(r'^([^\s]+)\s+([^\s]+)$');

Iterable<Widget> _marginHorizontalBuilder(
  BuildContext context,
  Iterable<Widget> children,
  _MarginHorizontalInput input,
) {
  final direction = Directionality.of(context);
  final marginLeft = input.marginLeft ??
      (direction == TextDirection.ltr ? input.marginStart : input.marginEnd);
  final marginRight = input.marginRight ??
      (direction == TextDirection.ltr ? input.marginEnd : input.marginStart);

  final tsb = input.meta.tsb;
  final padding = EdgeInsets.only(
    left: marginLeft?.getValue(context, tsb) ?? 0.0,
    right: marginRight?.getValue(context, tsb) ?? 0.0,
  );

  return children.map((child) {
    if (child is Padding) {
      final existing = child.padding as EdgeInsets;
      return input.wf.buildPadding(
        child.child,
        existing.copyWith(
          left: existing.left + padding.left,
          right: existing.right + padding.right,
        ),
      );
    }

    return input.wf.buildPadding(child, padding);
  });
}

class _MarginHorizontalInput {
  CssLength marginEnd;
  CssLength marginLeft;
  CssLength marginRight;
  CssLength marginStart;
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
          final lr = m.end?.isNotEmpty == true ||
              m.left?.isNotEmpty == true ||
              m.right?.isNotEmpty == true ||
              m.start?.isNotEmpty == true;
          final b = m.bottom?.isNotEmpty == true;
          final ws = List<Widget>((t ? 1 : 0) + widgets.length + (b ? 1 : 0));
          final tsb = meta.tsb;

          var i = 0;
          if (t) ws[i++] = _MarginVerticalPlaceholder(tsb, m.top);

          if (lr) {
            for (final widget in widgets) {
              final input = _MarginHorizontalInput()
                ..marginEnd = m.end
                ..marginLeft = m.left
                ..marginRight = m.right
                ..marginStart = m.start
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
      );
}

CssMargin _parseCssMargin(WidgetFactory wf, NodeMetadata meta) {
  CssMargin output;

  for (final style in meta.styles) {
    switch (style.key) {
      case _kCssMargin:
        output = wf.parseCssMarginAll(style.value);
        break;

      case _kCssMarginBottom:
      case _kCssMarginEnd:
      case _kCssMarginLeft:
      case _kCssMarginRight:
      case _kCssMarginStart:
      case _kCssMarginTop:
        output = wf.parseCssMarginOne(output, style.key, style.value);
        break;
    }
  }

  return output;
}

CssMargin _parseCssMarginAll(WidgetFactory wf, String value) {
  final valuesFour = _valuesFourRegExp.firstMatch(value);
  if (valuesFour != null) {
    return CssMargin()
      ..top = wf.parseCssLength(valuesFour[1])
      ..end = wf.parseCssLength(valuesFour[2])
      ..bottom = wf.parseCssLength(valuesFour[3])
      ..start = wf.parseCssLength(valuesFour[4]);
  }

  final valuesTwo = _valuesTwoRegExp.firstMatch(value);
  if (valuesTwo != null) {
    final topBottom = wf.parseCssLength(valuesTwo[1]);
    final leftRight = wf.parseCssLength(valuesTwo[2]);
    return CssMargin()
      ..bottom = topBottom
      ..end = leftRight
      ..start = leftRight
      ..top = topBottom;
  }

  final all = wf.parseCssLength(value);
  return CssMargin()
    ..bottom = all
    ..end = all
    ..start = all
    ..top = all;
}

CssMargin _parseCssMarginOne(
    WidgetFactory wf, CssMargin existing, String key, String value) {
  final parsed = wf.parseCssLength(value);
  if (parsed == null) return existing;

  existing ??= CssMargin();

  switch (key) {
    case _kCssMarginBottom:
      return existing.copyWith(bottom: parsed);
    case _kCssMarginEnd:
      return existing.copyWith(end: parsed);
    case _kCssMarginLeft:
      return existing.copyWith(left: parsed);
    case _kCssMarginRight:
      return existing.copyWith(right: parsed);
    case _kCssMarginStart:
      return existing.copyWith(start: parsed);
    case _kCssMarginTop:
      return existing.copyWith(top: parsed);
  }

  return existing;
}
