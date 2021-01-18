part of '../core_ops.dart';

const kCssDirection = 'direction';
const kCssDirectionLtr = 'ltr';
const kCssDirectionRtl = 'rtl';
const kAttributeDir = 'dir';

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
const kCssFontSizes = {
  '1': kCssFontSizeXxSmall,
  '2': kCssFontSizeXSmall,
  '3': kCssFontSizeSmall,
  '4': kCssFontSizeMedium,
  '5': kCssFontSizeLarge,
  '6': kCssFontSizeXLarge,
  '7': kCssFontSizeXxLarge,
};

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

const kCssLineHeight = 'line-height';
const kCssLineHeightNormal = 'normal';

const kCssTextDecoration = 'text-decoration';
const kCssTextDecorationLineThrough = 'line-through';
const kCssTextDecorationNone = 'none';
const kCssTextDecorationOverline = 'overline';
const kCssTextDecorationUnderline = 'underline';

class TextStyleOps {
  static TextStyleHtml color(TextStyleHtml p, Color color) =>
      p.copyWith(style: p.style.copyWith(color: color));

  static TextStyleHtml fontFamily(TextStyleHtml p, List<String> list) =>
      p.copyWith(
        style: p.style.copyWith(
          fontFamily: list.isNotEmpty ? list.first : null,
          fontFamilyFallback: list.skip(1).toList(growable: false),
        ),
      );

  static TextStyleHtml Function(TextStyleHtml, String) fontSize(
          WidgetFactory wf) =>
      (p, v) => p.copyWith(
          style: p.style.copyWith(fontSize: _fontSizeTryParse(wf, p, v)));

  static TextStyleHtml fontStyle(TextStyleHtml p, FontStyle fontStyle) =>
      p.copyWith(style: p.style.copyWith(fontStyle: fontStyle));

  static TextStyleHtml fontWeight(TextStyleHtml p, FontWeight v) =>
      p.copyWith(style: p.style.copyWith(fontWeight: v));

  static TextStyleHtml Function(TextStyleHtml, String) lineHeight(
          WidgetFactory wf) =>
      (p, v) => p.copyWith(height: _lineHeightTryParse(wf, p, v));

  static TextStyleHtml maxLines(TextStyleHtml p, int v) =>
      p.copyWith(maxLines: v);

  static TextStyleHtml textDeco(TextStyleHtml p, TextDeco v) {
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
        decorationThickness: v.thickness?.getValue(p),
      ),
    );
  }

  static TextStyleHtml textDirection(TextStyleHtml p, String v) {
    final textDirection = (v == kCssDirectionRtl)
        ? TextDirection.rtl
        : v == kCssDirectionLtr
            ? TextDirection.ltr
            : null;
    if (textDirection == null) return p;

    return p.copyWith(textDirection: textDirection);
  }

  static TextStyleHtml textOverflow(TextStyleHtml p, TextOverflow v) =>
      p.copyWith(textOverflow: v);

  static List<String> fontFamilyTryParse(String value) {
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

  static FontStyle fontStyleTryParse(String value) {
    switch (value) {
      case kCssFontStyleItalic:
        return FontStyle.italic;
      case kCssFontStyleNormal:
        return FontStyle.normal;
    }

    return null;
  }

  static FontWeight fontWeightTryParse(String value) {
    switch (value) {
      case kCssFontWeightBold:
        return FontWeight.bold;
      case kCssFontWeight100:
        return FontWeight.w100;
      case kCssFontWeight200:
        return FontWeight.w200;
      case kCssFontWeight300:
        return FontWeight.w300;
      case kCssFontWeight400:
        return FontWeight.w400;
      case kCssFontWeight500:
        return FontWeight.w500;
      case kCssFontWeight600:
        return FontWeight.w600;
      case kCssFontWeight700:
        return FontWeight.w700;
      case kCssFontWeight800:
        return FontWeight.w800;
      case kCssFontWeight900:
        return FontWeight.w900;
    }

    return null;
  }

  static double _fontSizeTryParse(WidgetFactory wf, TextStyleHtml p, String v) {
    final length = tryParseCssLength(v);
    if (length != null) {
      final lengthValue = length.getValue(
        p,
        baseValue: p.parent?.style?.fontSize,
        scaleFactor: p.getDependency<MediaQueryData>().textScaleFactor,
      );
      if (lengthValue != null) return lengthValue;
    }

    switch (v) {
      case kCssFontSizeXxLarge:
        return _fontSizeMultiplyRootWith(p, 2.0);
      case kCssFontSizeXLarge:
        return _fontSizeMultiplyRootWith(p, 1.5);
      case kCssFontSizeLarge:
        return _fontSizeMultiplyRootWith(p, 1.125);
      case kCssFontSizeMedium:
        return _fontSizeMultiplyRootWith(p, 1);
      case kCssFontSizeSmall:
        return _fontSizeMultiplyRootWith(p, .8125);
      case kCssFontSizeXSmall:
        return _fontSizeMultiplyRootWith(p, .625);
      case kCssFontSizeXxSmall:
        return _fontSizeMultiplyRootWith(p, .5625);

      case kCssFontSizeLarger:
        return _fontSizeMultiplyWith(p.parent?.style?.fontSize, 1.2);
      case kCssFontSizeSmaller:
        return _fontSizeMultiplyWith(p.parent?.style?.fontSize, 15 / 18);
    }

    return null;
  }

  static double _fontSizeMultiplyRootWith(TextStyleHtml tsh, double value) {
    var root = tsh;
    while (root.parent != null) {
      root = root.parent;
    }

    return _fontSizeMultiplyWith(root.style.fontSize, value);
  }

  static double _fontSizeMultiplyWith(double fontSize, double value) =>
      fontSize != null ? fontSize * value : null;

  static double _lineHeightTryParse(
      WidgetFactory wf, TextStyleHtml p, String v) {
    if (v == kCssLineHeightNormal) return -1;

    final number = double.tryParse(v);
    if (number != null && number > 0) return number;

    final length = tryParseCssLength(v);
    if (length == null) return null;

    final lengthValue = length.getValue(
      p,
      baseValue: p.style.fontSize,
      scaleFactor: p.getDependency<MediaQueryData>().textScaleFactor,
    );
    if (lengthValue == null) return null;

    return lengthValue / p.style.fontSize;
  }
}

@immutable
class TextDeco {
  final Color color;
  final bool over;
  final bool strike;
  final TextDecorationStyle style;
  final CssLength thickness;
  final bool under;

  TextDeco({
    this.color,
    this.over,
    this.strike,
    this.style,
    this.thickness,
    this.under,
  });

  factory TextDeco.tryParse(List<String> values) {
    for (final value in values) {
      switch (value) {
        case kCssTextDecorationLineThrough:
          return TextDeco(strike: true);
        case kCssTextDecorationNone:
          return TextDeco(
            over: false,
            strike: false,
            under: false,
          );
        case kCssTextDecorationOverline:
          return TextDeco(over: true);
        case kCssTextDecorationUnderline:
          return TextDeco(under: true);
      }
    }

    return null;
  }
}
