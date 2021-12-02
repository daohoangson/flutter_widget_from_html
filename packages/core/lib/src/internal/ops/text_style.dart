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

const kCssLineHeight = 'line-height';
const kCssLineHeightNormal = 'normal';

// ignore: avoid_classes_with_only_static_members
class TextStyleOps {
  static HtmlStyle color(HtmlStyle p, Color color) =>
      p.copyWith(style: p.style.copyWith(color: color));

  static HtmlStyle fontFamily(HtmlStyle p, List<String> list) => p.copyWith(
        style: p.style.copyWith(
          fontFamily: list.isNotEmpty ? list.first : null,
          fontFamilyFallback: list.skip(1).toList(growable: false),
        ),
      );

  static HtmlStyle fontSize(HtmlStyle p, css.Expression v) => p.copyWith(
        style: p.style.copyWith(fontSize: _fontSizeTryParse(p, v)),
      );

  static HtmlStyle fontSizeEm(HtmlStyle p, double v) => p.copyWith(
        style: p.style.copyWith(
          fontSize:
              _fontSizeTryParseCssLength(p, CssLength(v, CssLengthUnit.em)),
        ),
      );

  static HtmlStyle fontSizeTerm(HtmlStyle p, String v) => p.copyWith(
        style: p.style.copyWith(fontSize: _fontSizeTryParseTerm(p, v)),
      );

  static HtmlStyle fontStyle(HtmlStyle p, FontStyle fontStyle) =>
      p.copyWith(style: p.style.copyWith(fontStyle: fontStyle));

  static HtmlStyle fontWeight(HtmlStyle p, FontWeight v) =>
      p.copyWith(style: p.style.copyWith(fontWeight: v));

  static HtmlStyle Function(HtmlStyle, css.Expression) lineHeight(
    WidgetFactory wf,
  ) =>
      (p, v) {
        final height = _lineHeightTryParse(wf, p, v);
        if (height == null) {
          return p;
        }

        if (height == -1) {
          // ignore: avoid_redundant_argument_values
          return p.copyWith(style: p.style.copyWith(height: null));
        }

        return p.copyWith(style: p.style.copyWith(height: height));
      };

  static HtmlStyle textDirection(HtmlStyle p, String v) {
    switch (v) {
      case kCssDirectionLtr:
        return p.copyWith(textDirection: TextDirection.ltr);
      case kCssDirectionRtl:
        return p.copyWith(textDirection: TextDirection.rtl);
    }

    return p;
  }

  static List<String> fontFamilyTryParse(List<css.Expression> expressions) {
    final list = <String>[];

    for (final expression in expressions) {
      if (expression is css.LiteralTerm) {
        final fontFamily = expression.valueAsString;
        if (fontFamily.isNotEmpty) {
          list.add(fontFamily);
        }
      }
    }

    return list;
  }

  static FontStyle? fontStyleTryParse(String value) {
    switch (value) {
      case kCssFontStyleItalic:
        return FontStyle.italic;
      case kCssFontStyleNormal:
        return FontStyle.normal;
    }

    return null;
  }

  static FontWeight? fontWeightTryParse(css.Expression expression) {
    if (expression is css.LiteralTerm) {
      if (expression is css.NumberTerm) {
        switch (expression.number) {
          case 100:
            return FontWeight.w100;
          case 200:
            return FontWeight.w200;
          case 300:
            return FontWeight.w300;
          case 400:
            return FontWeight.w400;
          case 500:
            return FontWeight.w500;
          case 600:
            return FontWeight.w600;
          case 700:
            return FontWeight.w700;
          case 800:
            return FontWeight.w800;
          case 900:
            return FontWeight.w900;
        }
      }

      switch (expression.valueAsString) {
        case kCssFontWeightBold:
          return FontWeight.bold;
      }
    }

    return null;
  }

  static HtmlStyle whitespace(HtmlStyle p, CssWhitespace v) =>
      p.copyWith(whitespace: v);

  static CssWhitespace? whitespaceTryParse(String value) {
    switch (value) {
      case kCssWhitespacePre:
        return CssWhitespace.pre;
      case kCssWhitespaceNormal:
        return CssWhitespace.normal;
    }

    return null;
  }

  static double? _fontSizeTryParse(HtmlStyle p, css.Expression v) {
    final length = tryParseCssLength(v);
    if (length != null) {
      final lengthValue = _fontSizeTryParseCssLength(p, length);
      if (lengthValue != null) {
        return lengthValue;
      }
    }

    if (v is css.LiteralTerm) {
      return _fontSizeTryParseTerm(p, v.valueAsString);
    }

    return null;
  }

  static double? _fontSizeTryParseCssLength(HtmlStyle p, CssLength v) =>
      v.getValue(
        p,
        baseValue: p.parent?.style.fontSize,
        scaleFactor: p.getDependency<MediaQueryData>().textScaleFactor,
      );

  static double? _fontSizeTryParseTerm(HtmlStyle p, String v) {
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
        return _fontSizeMultiplyWith(p.parent?.style.fontSize, 1.2);
      case kCssFontSizeSmaller:
        return _fontSizeMultiplyWith(p.parent?.style.fontSize, 15 / 18);
    }

    return null;
  }

  static double? _fontSizeMultiplyRootWith(HtmlStyle style, double value) {
    var root = style;
    for (final up = root.parent; up != null;) {
      root = up;
    }

    return _fontSizeMultiplyWith(root.style.fontSize, value);
  }

  static double? _fontSizeMultiplyWith(double? fontSize, double value) =>
      fontSize != null ? fontSize * value : null;

  static double? _lineHeightTryParse(
    WidgetFactory wf,
    HtmlStyle p,
    css.Expression v,
  ) {
    if (v is css.LiteralTerm) {
      if (v is css.NumberTerm) {
        final number = v.number.toDouble();
        if (number > 0) {
          return number;
        }
      }

      switch (v.valueAsString) {
        case kCssLineHeightNormal:
          return -1;
      }
    }

    final fontSize = p.style.fontSize;
    if (fontSize == null) {
      return null;
    }

    final length = tryParseCssLength(v);
    if (length == null) {
      return null;
    }

    final lengthValue = length.getValue(
      p,
      baseValue: fontSize,
      scaleFactor: p.getDependency<MediaQueryData>().textScaleFactor,
    );
    if (lengthValue == null) {
      return null;
    }

    return lengthValue / fontSize;
  }
}
