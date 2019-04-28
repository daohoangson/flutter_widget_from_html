part of '../core_widget_factory.dart';

const kCssColor = 'color';

final _colorRegExp = RegExp(r'^#([a-f0-9]{3,8})$', caseSensitive: false);

String _x2(String value) {
  final sb = StringBuffer();
  for (var i = 0; i < value.length; i++) {
    sb.write(value[i] * 2);
  }
  return sb.toString();
}

Color colorParseValue(String value) {
  final match = _colorRegExp.firstMatch(value);
  if (match == null) return null;

  final hex = match[1].toUpperCase();
  switch (hex.length) {
    case 3:
      return Color(int.parse("0xFF${_x2(hex)}"));
    case 4:
      final alpha = hex[3];
      final rgb = hex.substring(0, 3);
      return Color(int.parse("0x${_x2(alpha)}${_x2(rgb)}"));
    case 6:
      return Color(int.parse("0xFF$hex"));
    case 8:
      final alpha = hex.substring(6, 8);
      final rgb = hex.substring(0, 6);
      return Color(int.parse("0x$alpha$rgb"));
  }

  return null;
}
