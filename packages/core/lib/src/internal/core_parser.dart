import 'dart:math';

import 'package:csslib/parser.dart' as css;
import 'package:csslib/visitor.dart' as css;
import 'package:flutter/widgets.dart';

import '../core_data.dart';
import '../core_helpers.dart';

part 'parser/border.dart';
part 'parser/color.dart';
part 'parser/length.dart';

const kCssMaxLines = 'max-lines';
const kCssMaxLinesNone = 'none';
const kCssMaxLinesWebkitLineClamp = '-webkit-line-clamp';

const kCssTextDecorationStyle = 'text-decoration-style';
const kCssTextDecorationStyleDotted = 'dotted';
const kCssTextDecorationStyleDashed = 'dashed';
const kCssTextDecorationStyleDouble = 'double';
const kCssTextDecorationStyleSolid = 'solid';

const kCssTextOverflow = 'text-overflow';
const kCssTextOverflowClip = 'clip';
const kCssTextOverflowEllipsis = 'ellipsis';

const kSuffixBlockEnd = '-block-end';
const kSuffixBlockStart = '-block-start';
const kSuffixBottom = '-bottom';
const kSuffixInlineEnd = '-inline-end';
const kSuffixInlineStart = '-inline-start';
const kSuffixLeft = '-left';
const kSuffixRight = '-right';
const kSuffixTop = '-top';

int? tryParseMaxLines(css.Expression? expression) {
  if (expression is css.LiteralTerm) {
    if (expression is css.NumberTerm) {
      return expression.number.ceil();
    }

    switch (expression.valueAsString) {
      case kCssMaxLinesNone:
        return -1;
    }
  }

  return null;
}

TextDecorationStyle? tryParseTextDecorationStyle(css.Expression expression) {
  final value = expression is css.LiteralTerm ? expression.valueAsString : null;
  switch (value) {
    case kCssTextDecorationStyleDotted:
      return TextDecorationStyle.dotted;
    case kCssTextDecorationStyleDashed:
      return TextDecorationStyle.dashed;
    case kCssTextDecorationStyleDouble:
      return TextDecorationStyle.double;
    case kCssTextDecorationStyleSolid:
      return TextDecorationStyle.solid;
  }

  return null;
}

TextOverflow? tryParseTextOverflow(css.Expression? expression) {
  if (expression is css.LiteralTerm) {
    switch (expression.valueAsString) {
      case kCssTextOverflowClip:
        return TextOverflow.clip;
      case kCssTextOverflowEllipsis:
        return TextOverflow.ellipsis;
    }
  }

  return null;
}
