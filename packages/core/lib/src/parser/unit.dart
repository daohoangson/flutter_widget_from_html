part of '../parser.dart';

final _kUnitPixelRegex = RegExp(r'^(\d+)px$');

double unitParseValue(String value) {
  if (value == null) return null;

  // TODO: add support for other units
  final px = _kUnitPixelRegex.firstMatch(value);
  if (px == null) return null;

  return double.tryParse(px[1]);
}
