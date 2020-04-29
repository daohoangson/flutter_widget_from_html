part of '../core_widget_factory.dart';

const _kCssLengthBoxSuffixBlockEnd = '-block-end';
const _kCssLengthBoxSuffixBlockStart = '-block-start';
const _kCssLengthBoxSuffixBottom = '-bottom';
const _kCssLengthBoxSuffixInlineEnd = '-inline-end';
const _kCssLengthBoxSuffixInlineStart = '-inline-start';
const _kCssLengthBoxSuffixLeft = '-left';
const _kCssLengthBoxSuffixRight = '-right';
const _kCssLengthBoxSuffixTop = '-top';

final _cssLengthValues4 =
    RegExp(r'^([^\s]+)\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)$');
final _cssLengthValues2 = RegExp(r'^([^\s]+)\s+([^\s]+)$');
final _cssLengthValue = RegExp(r'^([\d\.]+)(em|px)$');

CssLength _parseCssLength(String value) {
  if (value == null) return null;
  if (value == '0') return CssLength(0);

  final match = _cssLengthValue.firstMatch(value);
  if (match == null) return null;

  final number = double.tryParse(match[1]);
  if (number == null) return null;

  switch (match[2]) {
    case 'em':
      return CssLength(number, unit: CssLengthUnit.em);
    case 'px':
      return CssLength(number, unit: CssLengthUnit.px);
  }

  return null;
}

CssLengthBox _parseCssLengthBox(NodeMetadata meta, String key) {
  CssLengthBox output;

  for (final style in meta.styleEntries) {
    if (!style.key.startsWith(key)) continue;

    final suffix = style.key.substring(key.length);
    switch (suffix) {
      case '':
        output = _parseCssLengthBoxAll(style.value);
        break;

      case _kCssLengthBoxSuffixBlockEnd:
      case _kCssLengthBoxSuffixBlockStart:
      case _kCssLengthBoxSuffixBottom:
      case _kCssLengthBoxSuffixInlineEnd:
      case _kCssLengthBoxSuffixInlineStart:
      case _kCssLengthBoxSuffixLeft:
      case _kCssLengthBoxSuffixRight:
      case _kCssLengthBoxSuffixTop:
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
    case _kCssLengthBoxSuffixBottom:
    case _kCssLengthBoxSuffixBlockEnd:
      return existing.copyWith(bottom: parsed);
    case _kCssLengthBoxSuffixInlineEnd:
      return existing.copyWith(inlineEnd: parsed);
    case _kCssLengthBoxSuffixInlineStart:
      return existing.copyWith(inlineStart: parsed);
    case _kCssLengthBoxSuffixLeft:
      return existing.copyWith(left: parsed);
    case _kCssLengthBoxSuffixRight:
      return existing.copyWith(right: parsed);
    case _kCssLengthBoxSuffixTop:
    case _kCssLengthBoxSuffixBlockStart:
      return existing.copyWith(top: parsed);
  }

  return existing;
}
