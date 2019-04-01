part of '../parser.dart';

const _kMargin = "margin";
const _kMarginBottom = "margin-bottom";
const _kMarginLeft = "margin-left";
const _kMarginRight = "margin-right";
const _kMarginTop = "margin-top";

final _kMarginValuesFourRegex =
    RegExp(r'^([^\s]+)\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)$');
final _kMarginValuesTwoRegex = RegExp(r'^([^\s]+)\s+([^\s]+)$');

EdgeInsetsGeometry _marginParseAll(String value) {
  final valuesFour = _kMarginValuesFourRegex.firstMatch(value);
  if (valuesFour != null) {
    final t = _unitParseValue(valuesFour.group(1));
    final r = _unitParseValue(valuesFour.group(2));
    final b = _unitParseValue(valuesFour.group(3));
    final l = _unitParseValue(valuesFour.group(4));
    if (t == null && r == null && b == null && l == null) return null;
    return EdgeInsets.fromLTRB(l, t, r, b);
  }

  final valuesTwo = _kMarginValuesTwoRegex.firstMatch(value);
  if (valuesTwo != null) {
    final v = _unitParseValue(valuesTwo.group(1));
    final h = _unitParseValue(valuesTwo.group(2));
    if (v == null && h == null) return null;
    return EdgeInsets.symmetric(horizontal: h, vertical: v);
  }

  final all = _unitParseValue(value);
  return all == null ? null : EdgeInsets.all(all);
}

EdgeInsetsGeometry _marginParseOne(
    NodeMetadata meta, String key, String value) {
  final parsed = _unitParseValue(value);
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
