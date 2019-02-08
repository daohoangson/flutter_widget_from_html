part of '../parser.dart';

final _kMarginValuesFourRegex =
    RegExp(r'^([^\s]+)\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)$');
final _kMarginValuesTwoRegex = RegExp(r'^([^\s]+)\s+([^\s]+)$');
final _kMarginValuePixelRegex = RegExp(r'^(\d+)px$');

EdgeInsetsGeometry _marginParseAll(String value) {
  final valuesFour = _kMarginValuesFourRegex.firstMatch(value);
  if (valuesFour != null) {
    final t = _marginParseValue(valuesFour.group(1));
    final r = _marginParseValue(valuesFour.group(2));
    final b = _marginParseValue(valuesFour.group(3));
    final l = _marginParseValue(valuesFour.group(4));
    if (t == null && r == null && b == null && l == null) return null;
    return EdgeInsets.fromLTRB(l, t, r, b);
  }

  final valuesTwo = _kMarginValuesTwoRegex.firstMatch(value);
  if (valuesTwo != null) {
    final v = _marginParseValue(valuesTwo.group(1));
    final h = _marginParseValue(valuesTwo.group(2));
    if (v == null && h == null) return null;
    return EdgeInsets.symmetric(horizontal: h, vertical: v);
  }

  final all = _marginParseValue(value);
  return all == null ? null : EdgeInsets.all(all);
}

EdgeInsetsGeometry _marginParseOne(
    NodeMetadata meta, String key, String value) {
  final parsed = _marginParseValue(value);
  if (parsed == null) return meta.margin;

  final existing = meta.margin ?? EdgeInsets.all(0);

  switch (key) {
    case 'margin-bottom':
      return existing.add(EdgeInsets.only(bottom: parsed));
    case 'margin-left':
      return existing.add(EdgeInsets.only(left: parsed));
    case 'margin-right':
      return existing.add(EdgeInsets.only(right: parsed));
    case 'margin-top':
      return existing.add(EdgeInsets.only(top: parsed));
    default:
      return meta.margin;
  }
}

double _marginParseValue(String value) {
  final px = _kMarginValuePixelRegex.firstMatch(value);
  if (px == null) {
    // TODO: add support for other units
    return null;
  }

  return double.tryParse(px.group(1));
}
