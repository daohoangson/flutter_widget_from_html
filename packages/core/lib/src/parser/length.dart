part of '../core_widget_factory.dart';

const _kCssLengthBoxSuffixBottom = '-bottom';
const _kCssLengthBoxSuffixEnd = '-end';
const _kCssLengthBoxSuffixLeft = '-left';
const _kCssLengthBoxSuffixRight = '-right';
const _kCssLengthBoxSuffixStart = '-start';
const _kCssLengthBoxSuffixTop = '-top';

final _lengthValuesFourRegExp =
    RegExp(r'^([^\s]+)\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)$');
final _lengthValuesTwoRegExp = RegExp(r'^([^\s]+)\s+([^\s]+)$');
final _lengthRegExp = RegExp(r'^([\d\.]+)(em|px)$');

CssLength _parseCssLength(String value) {
  if (value == null) return null;
  if (value == '0') return CssLength(0);

  final match = _lengthRegExp.firstMatch(value);
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

  for (final style in meta.styles) {
    if (!style.key.startsWith(key)) continue;

    final suffix = style.key.substring(key.length);
    switch (suffix) {
      case '':
        output = _parseCssLengthBoxAll(style.value);
        break;

      case _kCssLengthBoxSuffixBottom:
      case _kCssLengthBoxSuffixEnd:
      case _kCssLengthBoxSuffixLeft:
      case _kCssLengthBoxSuffixRight:
      case _kCssLengthBoxSuffixStart:
      case _kCssLengthBoxSuffixTop:
        output = _parseCssLengthBoxOne(output, suffix, style.value);
        break;
    }
  }

  return output;
}

CssLengthBox _parseCssLengthBoxAll(String value) {
  final valuesFour = _lengthValuesFourRegExp.firstMatch(value);
  if (valuesFour != null) {
    return CssLengthBox(
      top: _parseCssLength(valuesFour[1]),
      end: _parseCssLength(valuesFour[2]),
      bottom: _parseCssLength(valuesFour[3]),
      start: _parseCssLength(valuesFour[4]),
    );
  }

  final valuesTwo = _lengthValuesTwoRegExp.firstMatch(value);
  if (valuesTwo != null) {
    final topBottom = _parseCssLength(valuesTwo[1]);
    final leftRight = _parseCssLength(valuesTwo[2]);
    return CssLengthBox(
      top: topBottom,
      end: leftRight,
      bottom: topBottom,
      start: leftRight,
    );
  }

  final all = _parseCssLength(value);
  return CssLengthBox(top: all, end: all, bottom: all, start: all);
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
      return existing.copyWith(bottom: parsed);
    case _kCssLengthBoxSuffixEnd:
      return existing.copyWith(end: parsed);
    case _kCssLengthBoxSuffixLeft:
      return existing.copyWith(left: parsed);
    case _kCssLengthBoxSuffixRight:
      return existing.copyWith(right: parsed);
    case _kCssLengthBoxSuffixStart:
      return existing.copyWith(start: parsed);
    case _kCssLengthBoxSuffixTop:
      return existing.copyWith(top: parsed);
  }

  return existing;
}
