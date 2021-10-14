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
        return CssLength(number);
    }
  } else if (expression is css.LiteralTerm) {
    if (expression is css.NumberTerm) {
      if (expression.number == 0) {
        return const CssLength(0);
      }
    } else if (expression is css.PercentageTerm) {
      return CssLength(
        (expression.value as num).toDouble(),
        CssLengthUnit.percentage,
      );
    }

    switch (expression.valueAsString) {
      case 'auto':
        return const CssLength(1, CssLengthUnit.auto);
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
  if (parsed == null) {
    return existing;
  }

  final box = existing ?? const CssLengthBox();
  switch (suffix) {
    case kSuffixBottom:
    case kSuffixBlockEnd:
      return box.copyWith(bottom: parsed);
    case kSuffixInlineEnd:
      return box.copyWith(inlineEnd: parsed);
    case kSuffixInlineStart:
      return box.copyWith(inlineStart: parsed);
    case kSuffixLeft:
      return box.copyWith(left: parsed);
    case kSuffixRight:
      return box.copyWith(right: parsed);
    case kSuffixTop:
    case kSuffixBlockStart:
      return box.copyWith(top: parsed);
  }

  return box;
}

CssLengthBox? tryParseCssLengthBox(BuildMetadata meta, String prefix) {
  CssLengthBox? output;

  for (final style in meta.styles) {
    final key = style.property;
    if (!key.startsWith(prefix)) {
      continue;
    }

    final suffix = key.substring(prefix.length);
    if (suffix.isEmpty) {
      output = _parseCssLengthBoxAll(style.values);
    } else {
      final expression = style.value;
      if (expression != null) {
        output = _parseCssLengthBoxOne(output, suffix, expression);
      }
    }
  }

  return output;
}
