part of '../core_widget_factory.dart';

const kCssMargin = 'margin';
const kCssMarginBottom = 'margin-bottom';
const kCssMarginLeft = 'margin-left';
const kCssMarginRight = 'margin-right';
const kCssMarginTop = 'margin-top';

Iterable<Widget> _marginBuilder(
  BuildContext context,
  Iterable<Widget> children,
  _MarginBuilderInput input,
) {
  final style = input.meta.textStyle(context);
  final padding = EdgeInsets.only(
    left: input.marginLeft?.getValue(style, context: context) ?? 0.0,
    right: input.marginRight?.getValue(style, context: context) ?? 0.0,
  );

  return children.map((child) => input.wf.buildPadding(child, padding));
}

class _MarginBuilderInput {
  CssLength marginLeft;
  CssLength marginRight;
  NodeMetadata meta;
  WidgetFactory wf;
}

class SpacingPlaceholder extends StatelessWidget implements IWidgetPlaceholder {
  final NodeMetadata meta;

  final _heights = <CssLength>[];

  SpacingPlaceholder({
    CssLength height,
    Key key,
    this.meta,
  })  : assert(height != null),
        assert(meta != null),
        super(key: key) {
    _heights.add(height);
  }

  @override
  Widget build(BuildContext context) {
    final style = meta.textStyle(context);
    var height = 0.0;

    for (final _height in _heights) {
      final h = _height.getValue(style, context: context);
      if (h > height) height = h;
    }

    return SizedBox(height: height);
  }

  void mergeWith(SpacingPlaceholder other) => _heights.addAll(other._heights);

  @override
  Widget wrapWith<T>(WidgetPlaceholderBuilder<T> builder, T input) => this;
}

class _StyleMargin {
  final WidgetFactory wf;

  _StyleMargin(this.wf);

  BuildOp get buildOp => BuildOp(
        onWidgets: (meta, widgets) {
          if (widgets?.isNotEmpty != true) return null;
          final margin = _StyleMarginParser(meta).parse();
          if (margin == null) return null;

          return <Widget>[]
            ..add(margin.top?.isNotEmpty == true
                ? SpacingPlaceholder(height: margin.top, meta: meta)
                : null)
            ..addAll(margin.left?.isNotEmpty == true ||
                    margin.right?.isNotEmpty == true
                ? widgets.map((widget) {
                    final input = _MarginBuilderInput()
                      ..marginLeft = margin.left
                      ..marginRight = margin.right
                      ..meta = meta
                      ..wf = wf;

                    if (widget is IWidgetPlaceholder)
                      return widget..wrapWith(_marginBuilder, input);

                    return WidgetPlaceholder(
                      builder: _marginBuilder,
                      children: [widget],
                      input: input,
                      wf: wf,
                    );
                  })
                : widgets)
            ..add(margin.bottom?.isNotEmpty == true
                ? SpacingPlaceholder(height: margin.bottom, meta: meta)
                : null);
        },
      );
}

final _valuesFourRegExp =
    RegExp(r'^([^\s]+)\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)$');
final _valuesTwoRegExp = RegExp(r'^([^\s]+)\s+([^\s]+)$');

class _StyleMarginParser {
  final NodeMetadata meta;

  _StyleMarginParser(this.meta);

  CssMargin parse() {
    CssMargin output;

    meta.styles((key, value) {
      switch (key) {
        case kCssMargin:
          output = _parseAll(value);
          break;

        case kCssMarginBottom:
        case kCssMarginLeft:
        case kCssMarginRight:
        case kCssMarginTop:
          output = _parseOne(output, key, value);
          break;
      }
    });

    return output;
  }

  CssMargin _parseAll(String value) {
    final valuesFour = _valuesFourRegExp.firstMatch(value);
    if (valuesFour != null) {
      return CssMargin()
        ..top = _parseValue(valuesFour[1])
        ..right = _parseValue(valuesFour[2])
        ..bottom = _parseValue(valuesFour[3])
        ..left = _parseValue(valuesFour[4]);
    }

    final valuesTwo = _valuesTwoRegExp.firstMatch(value);
    if (valuesTwo != null) {
      final topBottom = _parseValue(valuesTwo[1]);
      final leftRight = _parseValue(valuesTwo[2]);
      return CssMargin()
        ..bottom = topBottom
        ..left = leftRight
        ..right = leftRight
        ..top = topBottom;
    }

    final all = _parseValue(value);
    return CssMargin()
      ..bottom = all
      ..left = all
      ..right = all
      ..top = all;
  }

  CssMargin _parseOne(CssMargin existing, String key, String value) {
    final parsed = _parseValue(value);
    if (parsed == null) return existing;

    existing ??= CssMargin();

    switch (key) {
      case kCssMarginBottom:
        return existing.copyWith(bottom: parsed);
      case kCssMarginLeft:
        return existing.copyWith(left: parsed);
      case kCssMarginRight:
        return existing.copyWith(right: parsed);
      default:
        return existing.copyWith(top: parsed);
    }
  }

  CssLength _parseValue(String str) => parseCssLength(str);
}
