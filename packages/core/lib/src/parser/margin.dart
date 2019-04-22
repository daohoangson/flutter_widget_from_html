part of '../parser.dart';

const _kMargin = "margin";
const _kMarginBottom = "margin-bottom";
const _kMarginLeft = "margin-left";
const _kMarginRight = "margin-right";
const _kMarginTop = "margin-top";

final _kMarginValuesFourRegex =
    RegExp(r'^([^\s]+)\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)$');
final _kMarginValuesTwoRegex = RegExp(r'^([^\s]+)\s+([^\s]+)$');

EdgeInsetsGeometry marginParseAll(String value) {
  final valuesFour = _kMarginValuesFourRegex.firstMatch(value);
  if (valuesFour != null) {
    final t = marginParseValue(valuesFour[1]);
    final r = marginParseValue(valuesFour[2]);
    final b = marginParseValue(valuesFour[3]);
    final l = marginParseValue(valuesFour[4]);
    if (t == 0 && r == 0 && b == 0 && l == 0) return null;
    return EdgeInsets.fromLTRB(l, t, r, b);
  }

  final valuesTwo = _kMarginValuesTwoRegex.firstMatch(value);
  if (valuesTwo != null) {
    final v = marginParseValue(valuesTwo[1]);
    final h = marginParseValue(valuesTwo[2]);
    if (v == 0 && h == 0) return null;
    return EdgeInsets.symmetric(horizontal: h, vertical: v);
  }

  final all = marginParseValue(value);
  return all == 0 ? null : EdgeInsets.all(all);
}

EdgeInsetsGeometry marginParseOne(NodeMetadata meta, String key, String value) {
  final parsed = unitParseValue(value);
  if (parsed == null) return meta.margin;

  final existing = meta.margin ?? EdgeInsets.all(0);

  switch (key) {
    case _kMarginBottom:
      return existing.add(EdgeInsets.only(bottom: parsed));
    case _kMarginLeft:
      return existing.add(EdgeInsets.only(left: parsed));
    case _kMarginRight:
      return existing.add(EdgeInsets.only(right: parsed));
    default:
      return existing.add(EdgeInsets.only(top: parsed));
  }
}

double marginParseValue(String str) {
  final d = unitParseValue(str);
  return (d == null || d < 0) ? 0 : d;
}
