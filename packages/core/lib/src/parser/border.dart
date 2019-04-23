part of '../parser.dart';

class BorderParsed {
  Color color;
  double width;
}

final _borderValueRegExp = RegExp(r'^(.+)\s+(.+)\s+(.+)$');

BorderParsed borderParseAll(String value) {
  final match = _borderValueRegExp.firstMatch(value);
  if (match == null) return borderParseValue(value);

  final width = unitParseValue(match[1]);
  if (width == null || width < 0) return null;

  final color = colorParseValue(match[3]);

  return BorderParsed()
    ..color = color
    ..width = width;
}

BorderParsed borderParseValue(String str) {
  final width = unitParseValue(str);
  if (width == null || width < 0) return null;

  return BorderParsed()..width = width;
}
