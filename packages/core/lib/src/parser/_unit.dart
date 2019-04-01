part of '../parser.dart';

final _kUnitPixelRegex = RegExp(r'^(\d+)px$');

double _unitParseValue(String value) {
  final px = _kUnitPixelRegex.firstMatch(value);
  if (px == null) {
    // TODO: add support for other units
    return null;
  }

  return double.tryParse(px.group(1));
}
