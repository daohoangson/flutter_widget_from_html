part of '../core_parser.dart';

const kCssLengthBoxSuffixBlockEnd = '-block-end';
const kCssLengthBoxSuffixBlockStart = '-block-start';
const kCssLengthBoxSuffixBottom = '-bottom';
const kCssLengthBoxSuffixInlineEnd = '-inline-end';
const kCssLengthBoxSuffixInlineStart = '-inline-start';
const kCssLengthBoxSuffixLeft = '-left';
const kCssLengthBoxSuffixRight = '-right';
const kCssLengthBoxSuffixTop = '-top';

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
    case kCssLengthBoxSuffixBottom:
    case kCssLengthBoxSuffixBlockEnd:
      return existing.copyWith(bottom: parsed);
    case kCssLengthBoxSuffixInlineEnd:
      return existing.copyWith(inlineEnd: parsed);
    case kCssLengthBoxSuffixInlineStart:
      return existing.copyWith(inlineStart: parsed);
    case kCssLengthBoxSuffixLeft:
      return existing.copyWith(left: parsed);
    case kCssLengthBoxSuffixRight:
      return existing.copyWith(right: parsed);
    case kCssLengthBoxSuffixTop:
    case kCssLengthBoxSuffixBlockStart:
      return existing.copyWith(top: parsed);
  }

  return existing;
}

CssLengthBox? tryParseCssLengthBox(BuildMetadata meta, String key) {
  CssLengthBox? output;

  for (final declaration in meta.styles) {
    if (!declaration.property.startsWith(key)) continue;

    final suffix = declaration.property.substring(key.length);
    switch (suffix) {
      case '':
        output = _parseCssLengthBoxAll(declaration.values);
        break;

      case kCssLengthBoxSuffixBlockEnd:
      case kCssLengthBoxSuffixBlockStart:
      case kCssLengthBoxSuffixBottom:
      case kCssLengthBoxSuffixInlineEnd:
      case kCssLengthBoxSuffixInlineStart:
      case kCssLengthBoxSuffixLeft:
      case kCssLengthBoxSuffixRight:
      case kCssLengthBoxSuffixTop:
        output = _parseCssLengthBoxOne(output, suffix, declaration.value);
        break;
    }
  }

  return output;
}
