part of '../core_widget_factory.dart';

const _kCssColor = 'color';

final _colorHexRegExp = RegExp(r'^#([a-f0-9]{3,8})$', caseSensitive: false);
final _colorRgbRegExp = RegExp(
    r'^(rgba?)\(([0-9]+)[,\s]+([0-9]+)[,\s]+([0-9]+)([,\s]+([0-9.]+))?\)$');

String _convertColorToHex(Color value) {
  final r = value.red.toRadixString(16).padLeft(2, '0');
  final g = value.green.toRadixString(16).padLeft(2, '0');
  final b = value.blue.toRadixString(16).padLeft(2, '0');
  final a = value.alpha.toRadixString(16).padLeft(2, '0');
  return '#$r$g$b$a';
}

Color _parseColor(String value) {
  if (value == null) return null;

  final hexMatch = _colorHexRegExp.firstMatch(value);
  if (hexMatch != null) {
    final hex = hexMatch[1].toUpperCase();
    switch (hex.length) {
      case 3:
        return Color(int.parse('0xFF${_x2(hex)}'));
      case 4:
        final alpha = hex[3];
        final rgb = hex.substring(0, 3);
        return Color(int.parse('0x${_x2(alpha)}${_x2(rgb)}'));
      case 6:
        return Color(int.parse('0xFF$hex'));
      case 8:
        final alpha = hex.substring(6, 8);
        final rgb = hex.substring(0, 6);
        return Color(int.parse('0x$alpha$rgb'));
    }
  }

  final valueLowerCase = value.toLowerCase();
  final rgbMatch = _colorRgbRegExp.firstMatch(valueLowerCase);
  if (rgbMatch != null) {
    final rgbType = rgbMatch[1];
    final rgbR = int.tryParse(rgbMatch[2]);
    final rgbG = int.tryParse(rgbMatch[3]);
    final rgbB = int.tryParse(rgbMatch[4]);
    final rgbA =
        double.tryParse(rgbType == 'rgba' ? (rgbMatch[6] ?? '') : '1.0');
    if (rgbR != null &&
        rgbR >= 0 &&
        rgbR <= 255 &&
        rgbG != null &&
        rgbG >= 0 &&
        rgbG <= 255 &&
        rgbB != null &&
        rgbB >= 0 &&
        rgbB <= 255 &&
        rgbA != null &&
        rgbA >= 0 &&
        rgbA <= 1) {
      return Color.fromARGB((255 * rgbA).ceil(), rgbR, rgbG, rgbB);
    }
  }

  return null;
}

String _x2(String value) {
  final sb = StringBuffer();
  for (var i = 0; i < value.length; i++) {
    sb.write(value[i] * 2);
  }
  return sb.toString();
}
