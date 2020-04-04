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

Iterable<Widget> _marginBuilder(
  BuilderContext bc,
  Iterable<Widget> children,
  _MarginBuilderInput input,
) {
  final direction = Directionality.of(bc.context);
  final marginLeft = input.marginLeft ??
      (direction == TextDirection.ltr ? input.marginStart : input.marginEnd);
  final marginRight = input.marginRight ??
      (direction == TextDirection.ltr ? input.marginEnd : input.marginStart);

  final tsb = input.meta.tsb;
  final padding = EdgeInsets.only(
    left: marginLeft?.getValue(bc, tsb) ?? 0.0,
    right: marginRight?.getValue(bc, tsb) ?? 0.0,
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

class _MarginBuilderInput {
  CssLength marginEnd;
  CssLength marginLeft;
  CssLength marginRight;
  CssLength marginStart;
  NodeMetadata meta;
  WidgetFactory wf;
}

class _MarginPlaceholder extends IWidgetPlaceholder {
  final TextStyleBuilders tsb;

  final _heights = <CssLength>[];

  _MarginPlaceholder({
    @required CssLength height,
    @required this.tsb,
  })  : assert(height != null),
        assert(tsb != null) {
    _heights.add(height);
  }

  @override
  Widget build(BuildContext context) {
    final bc = BuilderContext(context, this);
    var height = 0.0;

    for (final _height in _heights) {
      final h = _height.getValue(bc, tsb);
      if (h > height) height = h;
    }

    return SizedBox(height: height);
  }

  void mergeWith(_MarginPlaceholder other) => _heights.addAll(other._heights);

  @override
  Widget wrapWith<T>(WidgetPlaceholderBuilder<T> builder, T input) => this;
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
          if (t) ws[i++] = _MarginPlaceholder(height: m.top, tsb: tsb);

          if (lr) {
            for (final widget in widgets) {
              final input = _MarginBuilderInput()
                ..marginEnd = m.end
                ..marginLeft = m.left
                ..marginRight = m.right
                ..marginStart = m.start
                ..meta = meta
                ..wf = wf;

              ws[i++] = widget is IWidgetPlaceholder
                  ? (widget..wrapWith(_marginBuilder, input))
                  : WidgetPlaceholder(
                      builder: _marginBuilder,
                      children: [widget],
                      input: input,
                    );
            }
          } else {
            for (final widget in widgets) {
              ws[i++] = widget;
            }
          }

          if (b) ws[i++] = _MarginPlaceholder(height: m.bottom, tsb: tsb);

          return ws;
        },
      );
}

CssMargin _parseCssMargin(WidgetFactory wf, NodeMetadata meta) {
  CssMargin output;

  meta.styles((key, value) {
    switch (key) {
      case _kCssMargin:
        output = wf.parseCssMarginAll(value);
        break;

      case _kCssMarginBottom:
      case _kCssMarginEnd:
      case _kCssMarginLeft:
      case _kCssMarginRight:
      case _kCssMarginStart:
      case _kCssMarginTop:
        output = wf.parseCssMarginOne(output, key, value);
        break;
    }
  });

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
