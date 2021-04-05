part of '../core_parser.dart';

const kCssColor = 'color';

Color? tryParseColor(css.Expression? expression) {
  if (expression == null) return null;

  if (expression is css.FunctionTerm) {
    switch (expression.text) {
      case 'hsl':
      case 'hsla':
        final params = expression.params;
        assert(params.length >= 3);

        final hslH_ = params[0];
        final hslH = hslH_ is css.NumberTerm
            ? _parseColorHue(hslH_.value)
            : hslH_ is css.AngleTerm
                ? _parseColorHue(hslH_.value, hslH_.unit)
                : null;
        final hslS_ = params[1];
        final hslS =
            hslS_ is css.PercentageTerm ? ((hslS_.value as num) / 100.0) : null;
        final hslL_ = params[2];
        final hslL =
            hslL_ is css.PercentageTerm ? ((hslL_.value as num) / 100.0) : null;
        final hslA = params.length >= 4 ? _parseColorAlpha(params[3]) : null;
        if (hslH != null && hslS != null && hslL != null) {
          return HSLColor.fromAHSL(hslA ?? 1.0, hslH, hslS, hslL).toColor();
        }
        break;
      case 'rgb':
      case 'rgba':
        final params = expression.params;
        assert(params.length >= 3);

        final rgbR = _parseColorRgbElement(params[0]);
        final rgbG = _parseColorRgbElement(params[1]);
        final rgbB = _parseColorRgbElement(params[2]);
        final rgbA = params.length >= 4 ? _parseColorAlpha(params[3]) : null;
        if (rgbR != null && rgbG != null && rgbB != null) {
          return Color.fromARGB(((rgbA ?? 1.0) * 255).ceil(), rgbR, rgbG, rgbB);
        }
        break;
    }
  } else if (expression is css.HexColorTerm) {
    // cannot use expression.value directory due to issue with #f00 etc.
    final hex = expression.text.toUpperCase();
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
  } else if (expression is css.LiteralTerm) {
    switch (expression.valueAsString) {
      // TODO: add support for `currentcolor`
      case 'transparent':
        return Color(0x00000000);
    }
  }

  return null;
}

double? _parseColorAlpha(css.Expression expression) {
  final value = expression is css.NumberTerm
      ? (expression.value as num).toDouble()
      : expression is css.PercentageTerm
          ? (expression.value as num) / 100.0
          : null;
  if (value == null) return null;
  if (value < 0.0 || value > 1.0) return null;
  return value;
}

double _parseColorHue(num number, [int? unit]) {
  final v = number is double ? number : number.toDouble();

  double deg;
  switch (unit) {
    case css.TokenKind.UNIT_ANGLE_RAD:
      final rad = v;
      deg = rad * (180 / pi);
      break;
    case css.TokenKind.UNIT_ANGLE_GRAD:
      final grad = v;
      deg = grad * 0.9;
      break;
    case css.TokenKind.UNIT_ANGLE_TURN:
      final turn = v;
      deg = turn * 360;
      break;
    default:
      deg = v;
  }

  while (deg < 0) {
    deg += 360;
  }

  return deg % 360;
}

int? _parseColorRgbElement(css.Expression expression) {
  final value = expression is css.NumberTerm
      ? (expression.value as num).ceil()
      : expression is css.PercentageTerm
          ? ((expression.value as num) / 100.0 * 255.0).ceil()
          : null;
  if (value == null) return null;
  if (value < 0 || value > 255) return null;
  return value;
}

String _x2(String value) {
  final sb = StringBuffer();
  for (var i = 0; i < value.length; i++) {
    sb.write(value[i] * 2);
  }
  return sb.toString();
}
