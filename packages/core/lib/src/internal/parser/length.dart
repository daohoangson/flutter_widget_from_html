part of '../core_parser.dart';

final _cssLengthValues4 =
    RegExp(r'^([^\s]+)\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)$');
final _cssLengthValues2 = RegExp(r'^([^\s]+)\s+([^\s]+)$');
final _cssLengthValue = RegExp(r'^([\d\.]+)(em|%|pt|px)$');

CssLength tryParseCssLength(String value) {
  if (value == null) return null;

  value = value.toLowerCase();
  switch (value) {
    case '0':
      return CssLength(0);
    case 'auto':
      return CssLength(1, CssLengthUnit.auto);
  }

  final match = _cssLengthValue.firstMatch(value);
  if (match == null) return null;

  final number = double.tryParse(match[1]);
  if (number == null) return null;

  switch (match[2]) {
    case 'em':
      return CssLength(number, CssLengthUnit.em);
    case '%':
      return CssLength(number, CssLengthUnit.percentage);
    case 'pt':
      return CssLength(number, CssLengthUnit.pt);
    case 'px':
      return CssLength(number, CssLengthUnit.px);
  }

  return null;
}

CssLengthBox tryParseCssLengthBox(BuildMetadata meta, String key) {
  CssLengthBox output;

  for (final style in meta.styles) {
    if (!style.key.startsWith(key)) continue;

    final suffix = style.key.substring(key.length);
    if (suffix.isEmpty) {
      output = _parseCssLengthBoxAll(style.value);
    } else {
      final parsed = tryParseCssLength(style.value);
      output ??= CssLengthBox();

      switch (suffix) {
        case kSuffixBottom:
        case kSuffixBlockEnd:
          output = output.copyWith(bottom: parsed);
          break;
        case kSuffixInlineEnd:
          output = output.copyWith(inlineEnd: parsed);
          break;
        case kSuffixInlineStart:
          output = output.copyWith(inlineStart: parsed);
          break;
        case kSuffixLeft:
          output = output.copyWith(left: parsed);
          break;
        case kSuffixRight:
          output = output.copyWith(right: parsed);
          break;
        case kSuffixTop:
        case kSuffixBlockStart:
          output = output.copyWith(top: parsed);
          break;
      }
    }
  }

  return output;
}

CssLengthBox _parseCssLengthBoxAll(String value) {
  final valuesFour = _cssLengthValues4.firstMatch(value);
  if (valuesFour != null) {
    return CssLengthBox(
      top: tryParseCssLength(valuesFour[1]),
      inlineEnd: tryParseCssLength(valuesFour[2]),
      bottom: tryParseCssLength(valuesFour[3]),
      inlineStart: tryParseCssLength(valuesFour[4]),
    );
  }

  final valuesTwo = _cssLengthValues2.firstMatch(value);
  if (valuesTwo != null) {
    final topBottom = tryParseCssLength(valuesTwo[1]);
    final leftRight = tryParseCssLength(valuesTwo[2]);
    return CssLengthBox(
      top: topBottom,
      inlineEnd: leftRight,
      bottom: topBottom,
      inlineStart: leftRight,
    );
  }

  final all = tryParseCssLength(value);
  return CssLengthBox(top: all, inlineEnd: all, bottom: all, inlineStart: all);
}
