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

extension BuildTreeEllipsis on BuildTree {
  _BuildTreeEllipsis get _ => value() ?? _BuildTreeEllipsis();

  set _(_BuildTreeEllipsis v) => value<_BuildTreeEllipsis>(v);

  int get maxLines => _.maxLines;

  set maxLines(int value) {
    final v = _;
    v.maxLines = value;
    _ = v;
  }

  TextOverflow get overflow => _.overflow;

  set overflow(TextOverflow value) {
    final v = _;
    v.overflow = value;
    _ = v;
  }
}

// ignore: avoid_classes_with_only_static_members
class TextStyleOps {
  static HtmlStyle color(HtmlStyle style, Color color) => style.copyWith(
        textStyle: style.textStyle.copyWith(
          color: color,
          debugLabel: 'fwfh: $kCssColor',
        ),
      );

  static HtmlStyle fontFamily(HtmlStyle style, List<String> list) =>
      style.copyWith(
        textStyle: style.textStyle.copyWith(
          debugLabel: 'fwfh: $kCssFontFamily',
          fontFamily: list.isNotEmpty ? list.first : null,
          fontFamilyFallback: list.skip(1).toList(growable: false),
        ),
      );

  static HtmlStyle fontSize(HtmlStyle style, css.Expression v) =>
      style.copyWith(
        textStyle: style.textStyle.copyWith(
          debugLabel: 'fwfh: $kCssFontSize',
          fontSize: _fontSizeTryParse(style, v),
        ),
      );

  static HtmlStyle fontSizeEm(HtmlStyle style, double v) => style.copyWith(
        textStyle: style.textStyle.copyWith(
          debugLabel: 'fwfh: $kCssFontSize ${v}em',
          fontSize: _fontSizeTryParseCssLength(
            style,
            CssLength(v, CssLengthUnit.em),
          ),
        ),
      );

  static HtmlStyle fontSizeTerm(HtmlStyle style, String v) => style.copyWith(
        textStyle: style.textStyle.copyWith(
          debugLabel: 'fwfh: $kCssFontSize $v',
          fontSize: _fontSizeTryParseTerm(style, v),
        ),
      );

  static HtmlStyle fontStyle(HtmlStyle style, FontStyle fontStyle) =>
      style.copyWith(
        textStyle: style.textStyle.copyWith(
          debugLabel: 'fwfh: $kCssFontStyle',
          fontStyle: fontStyle,
        ),
      );

  static HtmlStyle fontWeight(HtmlStyle style, FontWeight v) => style.copyWith(
        textStyle: style.textStyle.copyWith(
          debugLabel: 'fwfh: $kCssFontWeight',
          fontWeight: v,
        ),
      );

  static HtmlStyle Function(HtmlStyle, css.Expression) lineHeight(
    WidgetFactory wf,
  ) =>
      (style, v) {
        final lineHeight = _lineHeightTryParse(wf, style, v);
        if (lineHeight == null) {
          return style;
        }

        return style.copyWith<LineHeight>(value: lineHeight);
      };

  static HtmlStyle textDirection(HtmlStyle style, String v) {
    switch (v) {
      case kCssDirectionLtr:
        return style.copyWith(value: TextDirection.ltr);
      case kCssDirectionRtl:
        return style.copyWith(value: TextDirection.rtl);
    }

    return style;
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

  static HtmlStyle whitespace(HtmlStyle style, CssWhitespace value) =>
      style.copyWith(value: value);

  static CssWhitespace? whitespaceTryParse(String value) {
    switch (value) {
      case kCssWhitespaceNormal:
        return CssWhitespace.normal;
      case kCssWhitespaceNowrap:
        return CssWhitespace.nowrap;
      case kCssWhitespacePre:
        return CssWhitespace.pre;
    }

    return null;
  }

  static double? _fontSizeTryParse(HtmlStyle style, css.Expression v) {
    final length = tryParseCssLength(v);
    if (length != null) {
      final lengthValue = _fontSizeTryParseCssLength(style, length);
      if (lengthValue != null) {
        return lengthValue;
      }
    }

    if (v is css.LiteralTerm) {
      return _fontSizeTryParseTerm(style, v.valueAsString);
    }

    return null;
  }

  static double? _fontSizeTryParseCssLength(HtmlStyle style, CssLength v) =>
      v.getValue(
        style,
        baseValue: style.parent?.textStyle.fontSize,
        scaleFactor: style.textScaleFactor,
      );

  static double? _fontSizeTryParseTerm(HtmlStyle style, String v) {
    switch (v) {
      case kCssFontSizeXxLarge:
        return _fontSizeMultiplyRootWith(style, 2.0);
      case kCssFontSizeXLarge:
        return _fontSizeMultiplyRootWith(style, 1.5);
      case kCssFontSizeLarge:
        return _fontSizeMultiplyRootWith(style, 1.125);
      case kCssFontSizeMedium:
        return _fontSizeMultiplyRootWith(style, 1);
      case kCssFontSizeSmall:
        return _fontSizeMultiplyRootWith(style, .8125);
      case kCssFontSizeXSmall:
        return _fontSizeMultiplyRootWith(style, .625);
      case kCssFontSizeXxSmall:
        return _fontSizeMultiplyRootWith(style, .5625);

      case kCssFontSizeLarger:
        return _fontSizeMultiplyWith(style.parent?.textStyle.fontSize, 1.2);
      case kCssFontSizeSmaller:
        return _fontSizeMultiplyWith(style.parent?.textStyle.fontSize, 15 / 18);
    }

    return null;
  }

  static double? _fontSizeMultiplyRootWith(HtmlStyle style, double value) {
    var root = style;
    for (HtmlStyle? x = root; x != null; x = x.parent) {
      root = x;
    }

    return _fontSizeMultiplyWith(root.textStyle.fontSize, value);
  }

  static double? _fontSizeMultiplyWith(double? fontSize, double value) =>
      fontSize != null ? fontSize * value : null;

  static LineHeight? _lineHeightTryParse(
    WidgetFactory wf,
    HtmlStyle style,
    css.Expression v,
  ) {
    if (v is css.LiteralTerm) {
      if (v is css.NumberTerm) {
        final number = v.number.toDouble();
        if (number > 0) {
          return LineHeight(number);
        }
      }

      switch (v.valueAsString) {
        case kCssLineHeightNormal:
          return const LineHeight(null);
      }
    }

    final fontSize = style.textStyle.fontSize;
    if (fontSize == null) {
      return null;
    }

    final length = tryParseCssLength(v);
    if (length == null) {
      return null;
    }

    final lengthValue = length.getValue(
      style,
      baseValue: fontSize,
      scaleFactor: style.textScaleFactor,
    );
    if (lengthValue == null) {
      return null;
    }

    return LineHeight(lengthValue / fontSize);
  }
}

class _BuildTreeEllipsis {
  int maxLines = -1;
  TextOverflow overflow = TextOverflow.clip;
}
