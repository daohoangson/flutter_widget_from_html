part of '../core_widget_factory.dart';

const _kCssBorder = 'border';
const _kCssBorderBottom = 'border-bottom';
const _kCssBorderTop = 'border-top';

final _borderValuesThreeRegExp = RegExp(r'^(.+)\s+(.+)\s+(.+)$');
final _borderValuesTwoRegExp = RegExp(r'^(.+)\s+(.+)$');

CssBorderSide parseCssBorderSide(String value) {
  final valuesThree = _borderValuesThreeRegExp.firstMatch(value);
  if (valuesThree != null) {
    final width = parseCssLength(valuesThree[1]);
    if (width == null || width.number <= 0) return null;
    return CssBorderSide()
      ..color = parseColor(valuesThree[3])
      ..style = parseCssBorderStyle(valuesThree[2])
      ..width = width;
  }

  final valuesTwo = _borderValuesTwoRegExp.firstMatch(value);
  if (valuesTwo != null) {
    final width = parseCssLength(valuesTwo[1]);
    if (width == null || width.number <= 0) return null;
    return CssBorderSide()
      ..style = parseCssBorderStyle(valuesTwo[2])
      ..width = width;
  }

  final width = parseCssLength(value);
  if (width == null || width.number <= 0) return null;
  return CssBorderSide()
    ..style = CssBorderStyle.solid
    ..width = width;
}

CssBorderStyle parseCssBorderStyle(String value) {
  switch (value) {
    case 'dotted':
      return CssBorderStyle.dotted;
    case 'dashed':
      return CssBorderStyle.dashed;
    case 'double':
      return CssBorderStyle.double;
  }

  return CssBorderStyle.solid;
}
