import 'package:csslib/visitor.dart' as css;
import 'package:flutter/widgets.dart';

import '../core_data.dart';
import '../core_helpers.dart';
import 'core_ops.dart';
import 'core_parser.dart';

InheritedProperties color(InheritedProperties resolving, Color color) =>
    resolving.copyWith(
      style: TextStyle(
        color: color,
        debugLabel: 'fwfh: $kCssColor',
      ),
    );

InheritedProperties fontFamily(InheritedProperties resolving, List<String> v) =>
    resolving.copyWith(
      style: TextStyle(
        debugLabel: 'fwfh: $kCssFontFamily',
        fontFamily: v.isNotEmpty ? v.first : null,
        fontFamilyFallback: v.skip(1).toList(growable: false),
      ),
    );

InheritedProperties fontSize(InheritedProperties resolving, css.Expression v) =>
    resolving.copyWith(
      style: TextStyle(
        debugLabel: 'fwfh: $kCssFontSize',
        fontSize: _fontSizeTryParse(resolving, v),
      ),
    );

InheritedProperties fontSizeEm(InheritedProperties resolving, double v) =>
    resolving.copyWith(
      style: TextStyle(
        debugLabel: 'fwfh: $kCssFontSize ${v}em',
        fontSize: _fontSizeTryParseCssLength(
          resolving,
          CssLength(v, CssLengthUnit.em),
        ),
      ),
    );

InheritedProperties fontSizeTerm(InheritedProperties resolving, String v) =>
    resolving.copyWith(
      style: TextStyle(
        debugLabel: 'fwfh: $kCssFontSize $v',
        fontSize: _fontSizeTryParseTerm(resolving, v),
      ),
    );

double? _fontSizeTryParse(InheritedProperties resolved, css.Expression v) {
  final length = tryParseCssLength(v);
  if (length != null) {
    final lengthValue = _fontSizeTryParseCssLength(resolved, length);
    if (lengthValue != null) {
      return lengthValue;
    }
  }

  if (v is css.LiteralTerm) {
    return _fontSizeTryParseTerm(resolved, v.valueAsString);
  }

  return null;
}

double? _fontSizeTryParseCssLength(InheritedProperties resolved, CssLength v) =>
    v.getValue(
      resolved,
      baseValue: resolved.parent?.get<TextStyle>()?.fontSize,
      scaleFactor: resolved.get<TextScaleFactor>()?.value,
    );

double? _fontSizeTryParseTerm(InheritedProperties resolved, String value) {
  switch (value) {
    case kCssFontSizeXxLarge:
      return _fontSizeMultiplyRootWith(resolved, 2.0);
    case kCssFontSizeXLarge:
      return _fontSizeMultiplyRootWith(resolved, 1.5);
    case kCssFontSizeLarge:
      return _fontSizeMultiplyRootWith(resolved, 1.125);
    case kCssFontSizeMedium:
      return _fontSizeMultiplyRootWith(resolved, 1);
    case kCssFontSizeSmall:
      return _fontSizeMultiplyRootWith(resolved, .8125);
    case kCssFontSizeXSmall:
      return _fontSizeMultiplyRootWith(resolved, .625);
    case kCssFontSizeXxSmall:
      return _fontSizeMultiplyRootWith(resolved, .5625);

    case kCssFontSizeLarger:
      final parent = resolved.parent?.get<TextStyle>()?.fontSize;
      return _fontSizeMultiplyWith(parent, 1.2);
    case kCssFontSizeSmaller:
      final parent = resolved.parent?.get<TextStyle>()?.fontSize;
      return _fontSizeMultiplyWith(parent, 15 / 18);
  }

  return null;
}

double? _fontSizeMultiplyRootWith(InheritedProperties resolved, double value) {
  var root = resolved;
  for (InheritedProperties? x = root; x != null; x = x.parent) {
    root = x;
  }

  return _fontSizeMultiplyWith(root.get<TextStyle>()?.fontSize, value);
}

double? _fontSizeMultiplyWith(double? fontSize, double value) =>
    fontSize != null ? fontSize * value : null;

InheritedProperties fontStyle(InheritedProperties resolving, FontStyle v) =>
    resolving.copyWith(
      style: TextStyle(
        debugLabel: 'fwfh: $kCssFontStyle',
        fontStyle: v,
      ),
    );

InheritedProperties fontWeight(InheritedProperties resolving, FontWeight v) =>
    resolving.copyWith(
      style: TextStyle(
        debugLabel: 'fwfh: $kCssFontWeight',
        fontWeight: v,
      ),
    );

InheritedProperties lineHeight(
  InheritedProperties resolving,
  css.Expression expression,
) {
  final height = _lineHeightTryParse(expression);
  if (height == null) {
    return resolving;
  }

  return resolving.copyWith(value: height);
}

TextStyleLineHeight? _lineHeightTryParse(css.Expression expression) {
  if (expression is css.LiteralTerm) {
    if (expression is css.NumberTerm) {
      final number = expression.number.toDouble();
      if (number > 0) {
        final percentage = CssLength(number * 100, CssLengthUnit.percentage);
        return TextStyleLineHeight(percentage);
      }
    }

    switch (expression.valueAsString) {
      case kCssLineHeightNormal:
        return const TextStyleLineHeight();
    }
  }

  final length = tryParseCssLength(expression);
  if (length == null) {
    return null;
  }

  return TextStyleLineHeight(length);
}

InheritedProperties textDirection(InheritedProperties resolving, String v) {
  switch (v) {
    case kCssDirectionLtr:
      return resolving.copyWith(value: TextDirection.ltr);
    case kCssDirectionRtl:
      return resolving.copyWith(value: TextDirection.rtl);
  }

  return resolving;
}

List<String> fontFamilyTryParse(List<css.Expression> expressions) {
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

FontStyle? fontStyleTryParse(String value) {
  switch (value) {
    case kCssFontStyleItalic:
      return FontStyle.italic;
    case kCssFontStyleNormal:
      return FontStyle.normal;
  }

  return null;
}

FontWeight? fontWeightTryParse(css.Expression expression) {
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

InheritedProperties whitespace(
  InheritedProperties resolving,
  CssWhitespace whitespace,
) =>
    resolving.copyWith(value: whitespace);

CssWhitespace? whitespaceTryParse(String value) {
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
