part of '../core_widget_factory.dart';

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
  '1': _kCssFontSizeXxSmall,
  '2': _kCssFontSizeXSmall,
  '3': _kCssFontSizeSmall,
  '4': _kCssFontSizeMedium,
  '5': _kCssFontSizeLarge,
  '6': _kCssFontSizeXLarge,
  '7': _kCssFontSizeXxLarge,
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

const _kCssLineHeight = 'line-height';
const _kCssLineHeightNormal = 'normal';

const _kCssTextDecoration = 'text-decoration';
const _kCssTextDecorationLineThrough = 'line-through';
const _kCssTextDecorationNone = 'none';
const _kCssTextDecorationOverline = 'overline';
const _kCssTextDecorationUnderline = 'underline';

class _TextStyle {
  static TextStyleHtml color(BuildContext _, TextStyleHtml p, Color color) =>
      p.copyWith(style: p.style.copyWith(color: color));

  static TextStyleHtml fontFamily(
          BuildContext _, TextStyleHtml p, List<String> list) =>
      p.copyWith(
        style: p.style.copyWith(
          fontFamily: list.isNotEmpty ? list.first : null,
          fontFamilyFallback: list.skip(1).toList(growable: false),
        ),
      );

  static TextStyleHtml fontSize(BuildContext c, TextStyleHtml p, String v) =>
      p.copyWith(style: p.style.copyWith(fontSize: _fontSizeTryParse(c, p, v)));

  static TextStyleHtml fontStyle(
          BuildContext _, TextStyleHtml p, FontStyle fontStyle) =>
      p.copyWith(style: p.style.copyWith(fontStyle: fontStyle));

  static TextStyleHtml fontWeight(
          BuildContext _, TextStyleHtml p, FontWeight v) =>
      p.copyWith(style: p.style.copyWith(fontWeight: v));

  static TextStyleHtml lineHeight(BuildContext c, TextStyleHtml p, String v) =>
      p.copyWith(height: _lineHeightTryParse(c, p, v));

  static TextStyleHtml textDeco(BuildContext _, TextStyleHtml p, _TextDeco v) {
    final pd = p.style.decoration;
    final lineThough = pd?.contains(TextDecoration.lineThrough) == true;
    final overline = pd?.contains(TextDecoration.overline) == true;
    final underline = pd?.contains(TextDecoration.underline) == true;

    final list = <TextDecoration>[];
    if (v.over == true || (overline && v.over != false)) {
      list.add(TextDecoration.overline);
    }
    if (v.strike == true || (lineThough && v.strike != false)) {
      list.add(TextDecoration.lineThrough);
    }
    if (v.under == true || (underline && v.under != false)) {
      list.add(TextDecoration.underline);
    }

    return p.copyWith(
      style: p.style.copyWith(
        decoration: TextDecoration.combine(list),
        decorationColor: v.color,
        decorationStyle: v.style,
        decorationThickness: v.thickness?.getValueFromStyle(p),
      ),
    );
  }

  static List<String> _fontFamilyTryParse(String value) {
    final parts = value.split(',');
    final list = <String>[];

    for (final part in parts) {
      final fontFamily = part
          .trim()
          .replaceFirstMapped(RegExp(r"""^("|')(.+)\1$"""), (m) => m.group(2));
      if (fontFamily.isNotEmpty) list.add(fontFamily);
    }

    return list;
  }

  static double _fontSizeTryParse(BuildContext c, TextStyleHtml p, String v) {
    final length = _parseCssLength(v);
    if (length != null) {
      final lengthValue = length.getValueFromStyle(
        p,
        baseValue: p.parent?.style?.fontSize,
        scaleFactor: MediaQuery.of(c).textScaleFactor,
      );
      if (lengthValue != null) return lengthValue;
    }

    switch (v) {
      case _kCssFontSizeXxLarge:
        return _fontSizeMultiplyWith(p.root?.style?.fontSize, 2.0);
      case _kCssFontSizeXLarge:
        return _fontSizeMultiplyWith(p.root?.style?.fontSize, 1.5);
      case _kCssFontSizeLarge:
        return _fontSizeMultiplyWith(p.root?.style?.fontSize, 1.125);
      case _kCssFontSizeMedium:
        return p.root?.style?.fontSize;
      case _kCssFontSizeSmall:
        return _fontSizeMultiplyWith(p.root?.style?.fontSize, .8125);
      case _kCssFontSizeXSmall:
        return _fontSizeMultiplyWith(p.root?.style?.fontSize, .625);
      case _kCssFontSizeXxSmall:
        return _fontSizeMultiplyWith(p.root?.style?.fontSize, .5625);

      case _kCssFontSizeLarger:
        return _fontSizeMultiplyWith(p.parent?.style?.fontSize, 1.2);
      case _kCssFontSizeSmaller:
        return _fontSizeMultiplyWith(p.parent?.style?.fontSize, 15 / 18);
    }

    return null;
  }

  static double _fontSizeMultiplyWith(double fontSize, double value) =>
      fontSize != null ? fontSize * value : null;

  static FontStyle _fontStyleTryParse(String value) {
    switch (value) {
      case _kCssFontStyleItalic:
        return FontStyle.italic;
      case _kCssFontStyleNormal:
        return FontStyle.normal;
    }

    return null;
  }

  static FontWeight _fontWeightTryParse(String value) {
    switch (value) {
      case _kCssFontWeightBold:
        return FontWeight.bold;
      case _kCssFontWeight100:
        return FontWeight.w100;
      case _kCssFontWeight200:
        return FontWeight.w200;
      case _kCssFontWeight300:
        return FontWeight.w300;
      case _kCssFontWeight400:
        return FontWeight.w400;
      case _kCssFontWeight500:
        return FontWeight.w500;
      case _kCssFontWeight600:
        return FontWeight.w600;
      case _kCssFontWeight700:
        return FontWeight.w700;
      case _kCssFontWeight800:
        return FontWeight.w800;
      case _kCssFontWeight900:
        return FontWeight.w900;
    }

    return null;
  }

  static double _lineHeightTryParse(BuildContext c, TextStyleHtml p, String v) {
    if (v == _kCssLineHeightNormal) return -1;

    final number = double.tryParse(v);
    if (number != null && number > 0) return number;

    final length = _parseCssLength(v);
    if (length == null) return null;

    final lengthValue = length.getValueFromStyle(
      p,
      baseValue: p.style.fontSize,
      scaleFactor: MediaQuery.of(c).textScaleFactor,
    );
    if (lengthValue == null) return null;

    return lengthValue / p.style.fontSize;
  }
}

@immutable
class _TextDeco {
  final Color color;
  final bool over;
  final bool strike;
  final TextDecorationStyle style;
  final CssLength thickness;
  final bool under;

  _TextDeco({
    this.color,
    this.over,
    this.strike,
    this.style,
    this.thickness,
    this.under,
  });

  factory _TextDeco.tryParse(String value) {
    for (final v in splitCssValues(value)) {
      switch (v) {
        case _kCssTextDecorationLineThrough:
          return _TextDeco(strike: true);
        case _kCssTextDecorationNone:
          return _TextDeco(
            over: false,
            strike: false,
            under: false,
          );
        case _kCssTextDecorationOverline:
          return _TextDeco(over: true);
        case _kCssTextDecorationUnderline:
          return _TextDeco(under: true);
      }
    }

    return null;
  }
}
