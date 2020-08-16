part of '../core_widget_factory.dart';

const kCssLengthBoxSuffixBlockEnd = '-block-end';
const kCssLengthBoxSuffixBlockStart = '-block-start';
const kCssLengthBoxSuffixBottom = '-bottom';
const kCssLengthBoxSuffixInlineEnd = '-inline-end';
const kCssLengthBoxSuffixInlineStart = '-inline-start';
const kCssLengthBoxSuffixLeft = '-left';
const kCssLengthBoxSuffixRight = '-right';
const kCssLengthBoxSuffixTop = '-top';

final _cssLengthValues4 =
    RegExp(r'^([^\s]+)\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)$');
final _cssLengthValues2 = RegExp(r'^([^\s]+)\s+([^\s]+)$');
final _cssLengthValue = RegExp(r'^([\d\.]+)(em|%|pt|px)$');

CssLength _parseCssLength(String value) {
  if (value == null) return null;
  if (value == '0') return CssLength(0);

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

CssLengthBox _parseCssLengthBox(NodeMetadata meta, String key) {
  CssLengthBox output;

  for (final style in meta.styles) {
    if (!style.key.startsWith(key)) continue;

    final suffix = style.key.substring(key.length);
    switch (suffix) {
      case '':
        output = _parseCssLengthBoxAll(style.value);
        break;

      case kCssLengthBoxSuffixBlockEnd:
      case kCssLengthBoxSuffixBlockStart:
      case kCssLengthBoxSuffixBottom:
      case kCssLengthBoxSuffixInlineEnd:
      case kCssLengthBoxSuffixInlineStart:
      case kCssLengthBoxSuffixLeft:
      case kCssLengthBoxSuffixRight:
      case kCssLengthBoxSuffixTop:
        output = _parseCssLengthBoxOne(output, suffix, style.value);
        break;
    }
  }

  return output;
}

CssLengthBox _parseCssLengthBoxAll(String value) {
  final valuesFour = _cssLengthValues4.firstMatch(value);
  if (valuesFour != null) {
    return CssLengthBox(
      top: _parseCssLength(valuesFour[1]),
      inlineEnd: _parseCssLength(valuesFour[2]),
      bottom: _parseCssLength(valuesFour[3]),
      inlineStart: _parseCssLength(valuesFour[4]),
    );
  }

  final valuesTwo = _cssLengthValues2.firstMatch(value);
  if (valuesTwo != null) {
    final topBottom = _parseCssLength(valuesTwo[1]);
    final leftRight = _parseCssLength(valuesTwo[2]);
    return CssLengthBox(
      top: topBottom,
      inlineEnd: leftRight,
      bottom: topBottom,
      inlineStart: leftRight,
    );
  }

  final all = _parseCssLength(value);
  return CssLengthBox(top: all, inlineEnd: all, bottom: all, inlineStart: all);
}

CssLengthBox _parseCssLengthBoxOne(
  CssLengthBox existing,
  String suffix,
  String value,
) {
  final parsed = _parseCssLength(value);
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
