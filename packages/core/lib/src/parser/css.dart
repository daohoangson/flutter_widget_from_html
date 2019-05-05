part of '../core_helpers.dart';

const kCssFontFamily = 'font-family';

const kCssFontSize = 'font-size';
const kCssFontSizeXxLarge = 'xx-large';
const kCssFontSizeXLarge = 'x-large';
const kCssFontSizeLarge = 'large';
const kCssFontSizeMedium = 'medium';
const kCssFontSizeSmall = 'small';
const kCssFontSizeXSmall = 'x-small';
const kCssFontSizeXxSmall = 'xx-small';
const kCssFontSizeLarger = 'larger';
const kCssFontSizeSmaller = 'smaller';

const kCssFontStyle = 'font-style';
const kCssFontStyleItalic = 'italic';
const kCssFontStyleNormal = 'normal';

const kCssFontWeight = 'font-weight';
const kCssFontWeightBold = 'bold';
const kCssFontWeight100 = '100';
const kCssFontWeight200 = '200';
const kCssFontWeight300 = '300';
const kCssFontWeight400 = '400';
const kCssFontWeight500 = '500';
const kCssFontWeight600 = '600';
const kCssFontWeight700 = '700';
const kCssFontWeight800 = '800';
const kCssFontWeight900 = '900';

const kCssTextDecoration = 'text-decoration';
const kCssTextDecorationLineThrough = 'line-through';
const kCssTextDecorationNone = 'none';
const kCssTextDecorationOverline = 'overline';
const kCssTextDecorationUnderline = 'underline';

final _lengthRegExp = RegExp(r'^([\d\.]+)(em|px)$');
final _spacingRegExp = RegExp(r'\s+');

CssLength lengthParseValue(String value) {
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

Iterable<String> cssSplit(String value) => value.split(_spacingRegExp);
