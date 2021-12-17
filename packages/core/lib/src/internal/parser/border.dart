part of '../core_parser.dart';

const kCssBorder = 'border';
const kCssBorderInherit = 'inherit';

const kCssBorderRadius = 'border-radius';
const kCssBorderRadiusSuffix = 'radius';
const kCssBorderRadiusBottomLeft = 'border-bottom-left-radius';
const kCssBorderRadiusBottomRight = 'border-bottom-right-radius';
const kCssBorderRadiusTopLeft = 'border-top-left-radius';
const kCssBorderRadiusTopRight = 'border-top-right-radius';

final _elementBorder = Expando<CssBorder>();

CssBorder tryParseBorder(BuildMetadata meta) {
  final existing = _elementBorder[meta.element];
  if (existing != null) {
    return existing;
  }

  var border = const CssBorder();
  for (final style in meta.styles) {
    final key = style.property;
    if (!key.startsWith(kCssBorder)) {
      continue;
    }

    if (key.endsWith(kCssBorderRadiusSuffix)) {
      border = _tryParseBorderRadius(border, style);
    } else {
      border = _tryParseBorderSide(border, style);
    }
  }

  return _elementBorder[meta.element] = border;
}

CssBorder _tryParseBorderSide(CssBorder border, css.Declaration style) {
  final suffix = style.property.substring(kCssBorder.length);
  if (suffix.isEmpty && style.term == kCssBorderInherit) {
    return const CssBorder(inherit: true);
  }

  TextDecorationStyle? borderStyle;
  CssLength? width;
  Color? color;
  for (final expression in style.values) {
    final parsedStyle = tryParseTextDecorationStyle(expression);
    if (parsedStyle != null) {
      borderStyle = parsedStyle;
      continue;
    }

    final parsedWidth = tryParseCssLength(expression);
    if (parsedWidth != null) {
      width = parsedWidth;
      continue;
    }

    final parsedColor = tryParseColor(expression);
    if (parsedColor != null) {
      color = parsedColor;
      continue;
    }
  }

  final borderSide = borderStyle == null
      ? CssBorderSide.none
      : CssBorderSide(
          color: color,
          style: borderStyle,
          width: width,
        );

  if (suffix.isEmpty) {
    return CssBorder(all: borderSide);
  }

  switch (suffix) {
    case kSuffixBottom:
    case kSuffixBlockEnd:
      return border.copyWith(bottom: borderSide);
    case kSuffixInlineEnd:
      return border.copyWith(inlineEnd: borderSide);
    case kSuffixInlineStart:
      return border.copyWith(inlineStart: borderSide);
    case kSuffixLeft:
      return border.copyWith(left: borderSide);
    case kSuffixRight:
      return border.copyWith(right: borderSide);
    case kSuffixTop:
    case kSuffixBlockStart:
      return border.copyWith(top: borderSide);
  }

  return border;
}

CssBorder _tryParseBorderRadius(CssBorder border, css.Declaration style) {
  switch (style.property) {
    case kCssBorderRadius:
      final expressions = style.values;
      final slash = expressions.indexWhere((e) => e is css.OperatorSlash);
      // top-left x, y; top-right x, y; bottom-right x, y; bottom-left x, y;
      final values = List.filled(8, CssLength.zero);
      if (slash == -1) {
        final parsed = expressions
            .map((e) => tryParseCssLength(e) ?? CssLength.zero)
            .toList(growable: false);
        if (parsed.isNotEmpty) {
          for (var i = 0; i < values.length; i++) {
            values[i] = parsed[0];
          }
        }
        if (parsed.length > 1) {
          // second value: top-right
          values[2] = parsed[1];
          values[3] = parsed[1];
          // and bottom-left
          values[6] = parsed[1];
          values[7] = parsed[1];
        }
        if (parsed.length > 2) {
          // third-value: bottom-right
          values[4] = parsed[2];
          values[5] = parsed[2];
        }
        if (parsed.length > 3) {
          // forth-value: bottom-left
          values[6] = parsed[3];
          values[7] = parsed[3];
        }
      } else {
        final parsedX = expressions
            .take(slash)
            .map((e) => tryParseCssLength(e) ?? CssLength.zero)
            .toList(growable: false);
        if (parsedX.isNotEmpty) {
          for (var i = 0; i < values.length / 2; i++) {
            values[i * 2] = parsedX[0];
          }
        }
        if (parsedX.length > 1) {
          // second value: top-right X
          values[2] = parsedX[1];
          // and bottom-left X
          values[6] = parsedX[1];
        }
        if (parsedX.length > 2) {
          // third-value: bottom-right X
          values[4] = parsedX[2];
        }
        if (parsedX.length > 3) {
          // forth-value: bottom-left X
          values[6] = parsedX[3];
        }

        final parsedY = expressions
            .skip(slash + 1)
            .map((e) => tryParseCssLength(e) ?? CssLength.zero)
            .toList(growable: false);
        if (parsedY.isNotEmpty) {
          for (var i = 0; i < values.length / 2; i++) {
            values[i * 2 + 1] = parsedY[0];
          }
        }
        if (parsedY.length > 1) {
          // second value: top-right Y
          values[3] = parsedY[1];
          // and bottom-left
          values[7] = parsedY[1];
        }
        if (parsedY.length > 2) {
          // third-value: bottom-right Y
          values[5] = parsedY[2];
        }
        if (parsedY.length > 3) {
          // forth-value: bottom-left Y
          values[7] = parsedY[3];
        }
      }

      return border.copyWith(
        radiusTopLeft: _newCssRadius(values[0], values[1]),
        radiusTopRight: _newCssRadius(values[2], values[3]),
        radiusBottomRight: _newCssRadius(values[4], values[5]),
        radiusBottomLeft: _newCssRadius(values[6], values[7]),
      );
    case kCssBorderRadiusBottomLeft:
      return border.copyWith(radiusBottomLeft: _tryParseRadius(style));
    case kCssBorderRadiusBottomRight:
      return border.copyWith(radiusBottomRight: _tryParseRadius(style));
    case kCssBorderRadiusTopLeft:
      return border.copyWith(radiusTopLeft: _tryParseRadius(style));
    case kCssBorderRadiusTopRight:
      return border.copyWith(radiusTopRight: _tryParseRadius(style));
  }

  return border;
}

CssRadius _newCssRadius(CssLength x, CssLength y) =>
    x == CssLength.zero && y == CssLength.zero
        ? CssRadius.zero
        : CssRadius(x, y);

CssRadius _tryParseRadius(css.Declaration style) {
  final expressions = style.values;
  if (expressions.length == 2) {
    final x = tryParseCssLength(expressions[0]) ?? CssLength.zero;
    final y = tryParseCssLength(expressions[1]) ?? CssLength.zero;
    if (x == CssLength.zero && y == CssLength.zero) {
      return CssRadius.zero;
    }
    return CssRadius(x, y);
  } else if (expressions.length == 1) {
    final r = tryParseCssLength(expressions.first) ?? CssLength.zero;
    if (r == CssLength.zero) {
      return CssRadius.zero;
    }
    return CssRadius(r, r);
  }

  return CssRadius.zero;
}
