part of '../core_parser.dart';

const kCssBorder = 'border';
const kCssBorderBottom = 'border-bottom';
const kCssBorderTop = 'border-top';

final _borderValuesThreeRegExp = RegExp(r'^(.+)\s+(.+)\s+(.+)$');
final _borderValuesTwoRegExp = RegExp(r'^(.+)\s+(.+)$');

CssBorderSide tryParseCssBorderSide(String value) {
  final valuesThree = _borderValuesThreeRegExp.firstMatch(value);
  if (valuesThree != null) {
    final width = tryParseCssLength(valuesThree[1]);
    if (width == null || width.number <= 0) return null;
    return CssBorderSide(
      color: tryParseColor(valuesThree[3]),
      style: tryParseCssBorderStyle(valuesThree[2]),
      width: width,
    );
  }

  final valuesTwo = _borderValuesTwoRegExp.firstMatch(value);
  if (valuesTwo != null) {
    final width = tryParseCssLength(valuesTwo[1]);
    if (width == null || width.number <= 0) return null;
    return CssBorderSide(
      style: tryParseCssBorderStyle(valuesTwo[2]),
      width: width,
    );
  }

  final width = tryParseCssLength(value);
  if (width == null || width.number <= 0) return null;
  return CssBorderSide(
    style: TextDecorationStyle.solid,
    width: width,
  );
}

TextDecorationStyle tryParseCssBorderStyle(String value) {
  switch (value) {
    case 'dotted':
      return TextDecorationStyle.dotted;
    case 'dashed':
      return TextDecorationStyle.dashed;
    case 'double':
      return TextDecorationStyle.double;
  }

  return TextDecorationStyle.solid;
}
