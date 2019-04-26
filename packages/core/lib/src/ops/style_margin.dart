part of '../core_wf.dart';

const kCssMargin = 'margin';
const kCssMarginBottom = 'margin-bottom';
const kCssMarginLeft = 'margin-left';
const kCssMarginRight = 'margin-right';
const kCssMarginTop = 'margin-top';

List<Widget> fixOverlappingPaddings(List<Widget> widgets) {
  final fixed = <Widget>[];

  int i = 0;
  EdgeInsets prev;
  final length = widgets.length;
  for (final widget in widgets) {
    i++;
    if (!(widget is Padding)) {
      fixed.add(widget);
      continue;
    }

    final p = widget as Padding;
    final pp = p.padding as EdgeInsets;
    var v = pp;

    if (i == 1 && v.top > 0) {
      // remove padding at the top
      v = v.copyWith(top: 0);
    }

    if (i == length && v.bottom > 0) {
      // remove padding at the bottom
      v = v.copyWith(bottom: 0);
    }

    if (prev != null && prev.bottom > 0 && v.top > 0) {
      if (v.top > prev.bottom) {
        v = v.copyWith(top: v.top - prev.bottom);
      } else {
        v = v.copyWith(top: 0);
      }
    }

    fixed.add(v != pp
        ? v == const EdgeInsets.all(0)
            ? p.child
            : Padding(child: p.child, padding: v)
        : widget);
    prev = v;
  }

  return fixed;
}

class StyleMargin {
  final WidgetFactory wf;

  StyleMargin(this.wf);

  BuildOp get buildOp => BuildOp(
        onWidgets: (meta, widgets) {
          final padding = _StyleMarginParser(meta).parse();
          if (padding == null) return null;

          return wf.buildPadding(wf.buildColumn(widgets), padding);
        },
      );
}

final _valuesFourRegExp =
    RegExp(r'^([^\s]+)\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)$');
final _valuesTwoRegExp = RegExp(r'^([^\s]+)\s+([^\s]+)$');

class _StyleMarginParser {
  final NodeMetadata meta;

  _StyleMarginParser(this.meta);

  EdgeInsets parse() {
    EdgeInsets output;

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

  EdgeInsets _parseAll(String value) {
    final valuesFour = _valuesFourRegExp.firstMatch(value);
    if (valuesFour != null) {
      final t = _parseValue(valuesFour[1]);
      final r = _parseValue(valuesFour[2]);
      final b = _parseValue(valuesFour[3]);
      final l = _parseValue(valuesFour[4]);
      return EdgeInsets.fromLTRB(l, t, r, b);
    }

    final valuesTwo = _valuesTwoRegExp.firstMatch(value);
    if (valuesTwo != null) {
      final v = _parseValue(valuesTwo[1]);
      final h = _parseValue(valuesTwo[2]);
      return EdgeInsets.symmetric(horizontal: h, vertical: v);
    }

    return EdgeInsets.all(_parseValue(value));
  }

  EdgeInsets _parseOne(EdgeInsets existing, String key, String value) {
    final parsed = _parseValue(value);
    existing ??= EdgeInsets.all(0);

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

  double _parseValue(String str) {
    final parsed = parser.lengthParseValue(str);
    if (parsed == null) return 0;

    final value = parsed.getValue(meta.buildOpTextStyle);
    if (value < 0) return 0;

    return value;
  }
}
