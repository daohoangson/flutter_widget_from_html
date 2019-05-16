part of '../core_helpers.dart';

const kCssBorder = 'border';
const kCssBorderBottom = 'border-bottom';
const kCssBorderTop = 'border-top';

final _borderValuesThreeRegExp = RegExp(r'^(.+)\s+(.+)\s+(.+)$');
final _borderValuesTwoRegExp = RegExp(r'^(.+)\s+(.+)$');

CssBorderSide borderParse(String value) {
  final valuesThree = _borderValuesThreeRegExp.firstMatch(value);
  if (valuesThree != null) {
    final width = lengthParseValue(valuesThree[1]);
    if (width == null || width.number <= 0) return null;
    return CssBorderSide()
      ..color = colorParseValue(valuesThree[3])
      ..style = borderStyleParseValue(valuesThree[2])
      ..width = width;
  }

  final valuesTwo = _borderValuesTwoRegExp.firstMatch(value);
  if (valuesTwo != null) {
    final width = lengthParseValue(valuesTwo[1]);
    if (width == null || width.number <= 0) return null;
    return CssBorderSide()
      ..style = borderStyleParseValue(valuesTwo[2])
      ..width = width;
  }

  final width = lengthParseValue(value);
  if (width == null || width.number <= 0) return null;
  return CssBorderSide()
    ..style = CssBorderStyle.solid
    ..width = width;
}

CssBorderStyle borderStyleParseValue(String value) {
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
