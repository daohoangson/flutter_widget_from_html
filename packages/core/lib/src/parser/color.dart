part of '../core_helpers.dart';

const kCssColor = 'color';

final _colorRegExp = RegExp(r'^#([a-f0-9]{3,8})$', caseSensitive: false);

Color parseColor(String value) {
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

String convertColorToHex(Color value) {
  final r = value.red.toRadixString(16).padLeft(2, '0');
  final g = value.green.toRadixString(16).padLeft(2, '0');
  final b = value.blue.toRadixString(16).padLeft(2, '0');
  final a = value.alpha.toRadixString(16).padLeft(2, '0');
  return "#$r$g$b$a";
}

String _x2(String value) {
  final sb = StringBuffer();
  for (var i = 0; i < value.length; i++) {
    sb.write(value[i] * 2);
  }
  return sb.toString();
}
