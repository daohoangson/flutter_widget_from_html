part of '../core_parser.dart';

const kCssColor = 'color';
const kCssColorCurrentColor = 'currentcolor';
const kCssColorTransparent = 'transparent';

CssColor? tryParseColor(css.Expression? expression) {
  if (expression == null) {
    return null;
  }

  if (expression is css.FunctionTerm) {
    switch (expression.text) {
      case 'hsl':
      case 'hsla':
        final params = expression.params;
        if (params.length >= 3) {
          final param0 = params[0];
          final double? h;
          if (param0 is css.NumberTerm) {
            h = _parseColorHue(param0.number);
          } else if (param0 is css.AngleTerm) {
            h = _parseColorHue(param0.angle, param0.unit);
          } else {
            h = null;
          }

          final param1 = params[1];
          final double? s;
          if (param1 is css.PercentageTerm) {
            s = param1.valueAsDouble.clamp(0.0, 1.0);
          } else {
            s = null;
          }

          final param2 = params[2];
          final double? l;
          if (param2 is css.PercentageTerm) {
            l = param2.valueAsDouble.clamp(0.0, 1.0);
          } else {
            l = null;
          }

          final hslA = params.length >= 4 ? _parseColorAlpha(params[3]) : 1.0;
          if (h != null && s != null && l != null && hslA != null) {
            final hslValue = HSLColor.fromAHSL(hslA, h, s, l).toColor();
            return CssColor.value(hslValue);
          }
        }
      case 'rgb':
      case 'rgba':
        final params = expression.params;
        if (params.length >= 3) {
          final r = _parseColorRgbElement(params[0]);
          final g = _parseColorRgbElement(params[1]);
          final b = _parseColorRgbElement(params[2]);
          final rgbA = params.length >= 4 ? _parseColorAlpha(params[3]) : 1.0;
          if (r != null && g != null && b != null && rgbA != null) {
            final rgbValue = Color.fromARGB((rgbA * 255).ceil(), r, g, b);
            return CssColor.value(rgbValue);
          }
        }
    }
  } else if (expression is css.HexColorTerm) {
    // cannot use expression.value directory due to issue with #f00 etc.
    final hex = expression.text.toUpperCase();
    switch (hex.length) {
      case 3:
        return CssColor(int.parse('0xFF${_x2(hex)}'));
      case 4:
        final alpha = hex[3];
        final rgb = hex.substring(0, 3);
        return CssColor(int.parse('0x${_x2(alpha)}${_x2(rgb)}'));
      case 6:
        return CssColor(int.parse('0xFF$hex'));
      case 8:
        final alpha = hex.substring(6, 8);
        final rgb = hex.substring(0, 6);
        return CssColor(int.parse('0x$alpha$rgb'));
    }
  } else if (expression is css.LiteralTerm) {
    switch (expression.valueAsString) {
      case kCssColorCurrentColor:
        return CssColor.current();
      case kCssColorTransparent:
        return CssColor.transparent();
    }
  }

  return null;
}

double? _parseColorAlpha(css.Expression expression) {
  final double? value;
  if (expression is css.NumberTerm) {
    value = expression.number.toDouble();
  } else if (expression is css.PercentageTerm) {
    value = expression.valueAsDouble;
  } else {
    value = null;
  }
  return value?.clamp(0, 1);
}

double _parseColorHue(num number, [int? unit]) {
  final v = number is double ? number : number.toDouble();

  double deg;
  switch (unit) {
    case css.TokenKind.UNIT_ANGLE_RAD:
      final rad = v;
      deg = rad * (180 / pi);
    case css.TokenKind.UNIT_ANGLE_GRAD:
      final grad = v;
      deg = grad * 0.9;
    case css.TokenKind.UNIT_ANGLE_TURN:
      final turn = v;
      deg = turn * 360;
    default:
      deg = v;
  }

  while (deg < 0) {
    deg += 360;
  }

  return deg % 360;
}

int? _parseColorRgbElement(css.Expression expression) {
  final int? value;
  if (expression is css.NumberTerm) {
    value = expression.number.ceil();
  } else if (expression is css.PercentageTerm) {
    value = (expression.valueAsDouble * 255.0).ceil();
  } else {
    value = null;
  }
  return value?.clamp(0, 255);
}

String _x2(String value) {
  final sb = StringBuffer();
  for (var i = 0; i < value.length; i++) {
    sb.write(value[i] * 2);
  }
  return sb.toString();
}
