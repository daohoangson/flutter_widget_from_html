part of '../core_widget_factory.dart';

const _kCssColor = 'color';

final _colorHexRegExp = RegExp(r'^#([a-f0-9]{3,8})$', caseSensitive: false);
final _colorRgbRegExp = RegExp(
    r'^(rgba?)\(([0-9.]+%?)[,\s]+([0-9.]+%?)[,\s]+([0-9.]+%?)([,\s/]+([0-9.]+%?))?\)$');

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
    final rgbR = _parseColorPart(rgbMatch[2], 0, 255);
    final rgbG = _parseColorPart(rgbMatch[3], 0, 255);
    final rgbB = _parseColorPart(rgbMatch[4], 0, 255);
    final rgbA = _parseColorPart(rgbMatch[6] ?? '1', 0, 1);
    if (rgbR != null && rgbG != null && rgbB != null && rgbA != null) {
      return Color.fromARGB(
        (255 * rgbA).ceil(),
        rgbR.toInt(),
        rgbG.toInt(),
        rgbB.toInt(),
      );
    }
  }

  return null;
}

double _parseColorPart(String value, double min, double max) {
  double v;

  if (value.endsWith('%')) {
    final p = double.tryParse(value.substring(0, value.length - 1));
    if (p == null || p < 0) return null;
    v = p / 100.0 * max;
  }

  v ??= double.tryParse(value);

  if (v < min || v > max) return null;
  return v;
}

String _x2(String value) {
  final sb = StringBuffer();
  for (var i = 0; i < value.length; i++) {
    sb.write(value[i] * 2);
  }
  return sb.toString();
}
