part of '../core_parser.dart';

CssLength? tryParseCssLength(css.Expression expression) {
  if (expression is css.EmTerm) {
    return CssLength((expression.value as num).toDouble(), CssLengthUnit.em);
  } else if (expression is css.LengthTerm) {
    final number = (expression.value as num).toDouble();
    switch (expression.unit) {
      case css.TokenKind.UNIT_LENGTH_PT:
        return CssLength(number, CssLengthUnit.pt);
      case css.TokenKind.UNIT_LENGTH_PX:
        return CssLength(number, CssLengthUnit.px);
    }
  } else if (expression is css.LiteralTerm) {
    if (expression is css.NumberTerm) {
      if (expression.value == 0) {
        return CssLength(0);
      }
    } else if (expression is css.PercentageTerm) {
      return CssLength(
          (expression.value as num).toDouble(), CssLengthUnit.percentage);
    }

    switch (expression.valueAsString) {
      case 'auto':
        return CssLength(1, CssLengthUnit.auto);
    }
  }

  return null;
}

CssLengthBox? _parseCssLengthBoxAll(List<css.Expression> expressions) {
  switch (expressions.length) {
    case 4:
      return CssLengthBox(
        top: tryParseCssLength(expressions[0]),
        inlineEnd: tryParseCssLength(expressions[1]),
        bottom: tryParseCssLength(expressions[2]),
        inlineStart: tryParseCssLength(expressions[3]),
      );
    case 2:
      final topBottom = tryParseCssLength(expressions[0]);
      final leftRight = tryParseCssLength(expressions[1]);
      return CssLengthBox(
        top: topBottom,
        inlineEnd: leftRight,
        bottom: topBottom,
        inlineStart: leftRight,
      );
    case 1:
      final all = tryParseCssLength(expressions[0]);
      return CssLengthBox(
        top: all,
        inlineEnd: all,
        bottom: all,
        inlineStart: all,
      );
  }

  return null;
}

CssLengthBox? _parseCssLengthBoxOne(
  CssLengthBox? existing,
  String suffix,
  css.Expression expression,
) {
  final parsed = tryParseCssLength(expression);
  if (parsed == null) return existing;

  existing ??= CssLengthBox();

  switch (suffix) {
    case kCssSuffixBottom:
    case kCssSuffixBlockEnd:
      return existing.copyWith(bottom: parsed);
    case kCssSuffixInlineEnd:
      return existing.copyWith(inlineEnd: parsed);
    case kCssSuffixInlineStart:
      return existing.copyWith(inlineStart: parsed);
    case kCssSuffixLeft:
      return existing.copyWith(left: parsed);
    case kCssSuffixRight:
      return existing.copyWith(right: parsed);
    case kCssSuffixTop:
    case kCssSuffixBlockStart:
      return existing.copyWith(top: parsed);
  }

  return existing;
}

CssLengthBox? tryParseCssLengthBox(BuildMetadata meta, String key) {
  CssLengthBox? output;

  for (final style in meta.styles) {
    final key = style.property;
    if (!key.startsWith(key)) continue;

    final suffix = key.substring(key.length);
    switch (suffix) {
      case '':
        output = _parseCssLengthBoxAll(style.values);
        break;

      case kCssSuffixBlockEnd:
      case kCssSuffixBlockStart:
      case kCssSuffixBottom:
      case kCssSuffixInlineEnd:
      case kCssSuffixInlineStart:
      case kCssSuffixLeft:
      case kCssSuffixRight:
      case kCssSuffixTop:
        final expression = style.value;
        if (expression != null) {
          output = _parseCssLengthBoxOne(output, suffix, expression);
        }
        break;
    }
  }

  return output;
}
