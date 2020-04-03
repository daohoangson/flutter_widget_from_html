part of '../core_widget_factory.dart';

const _kCssDisplay = 'display';
const _kCssDisplayBlock = 'block';
const _kCssDisplayInline = 'inline';
const _kCssDisplayInlineBlock = 'inline-block';
const _kCssDisplayNone = 'none';

const _kCssFontFamily = 'font-family';

const _kCssFontSize = 'font-size';
const _kCssFontSizeXxLarge = 'xx-large';
const _kCssFontSizeXLarge = 'x-large';
const _kCssFontSizeLarge = 'large';
const _kCssFontSizeMedium = 'medium';
const _kCssFontSizeSmall = 'small';
const _kCssFontSizeXSmall = 'x-small';
const _kCssFontSizeXxSmall = 'xx-small';
const _kCssFontSizeLarger = 'larger';
const _kCssFontSizeSmaller = 'smaller';
const _kCssFontSizes = {
  "1": _kCssFontSizeXxSmall,
  "2": _kCssFontSizeXSmall,
  "3": _kCssFontSizeSmall,
  "4": _kCssFontSizeMedium,
  "5": _kCssFontSizeLarge,
  "6": _kCssFontSizeXLarge,
  "7": _kCssFontSizeXxLarge,
};

const _kCssFontStyle = 'font-style';
const _kCssFontStyleItalic = 'italic';
const _kCssFontStyleNormal = 'normal';

const _kCssFontWeight = 'font-weight';
const _kCssFontWeightBold = 'bold';
const _kCssFontWeight100 = '100';
const _kCssFontWeight200 = '200';
const _kCssFontWeight300 = '300';
const _kCssFontWeight400 = '400';
const _kCssFontWeight500 = '500';
const _kCssFontWeight600 = '600';
const _kCssFontWeight700 = '700';
const _kCssFontWeight800 = '800';
const _kCssFontWeight900 = '900';

const _kCssTextDecoration = 'text-decoration';
const _kCssTextDecorationLineThrough = 'line-through';
const _kCssTextDecorationNone = 'none';
const _kCssTextDecorationOverline = 'overline';
const _kCssTextDecorationUnderline = 'underline';

final _lengthRegExp = RegExp(r'^([\d\.]+)(em|px)$');
final _spacingRegExp = RegExp(r'\s+');

CssLength parseCssLength(String value) {
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

Iterable<String> splitCss(String value) => value.split(_spacingRegExp);
