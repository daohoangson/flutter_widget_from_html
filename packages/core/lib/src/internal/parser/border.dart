part of '../core_parser.dart';

const kCssBorder = 'border';
const kCssBorderInherit = 'inherit';
const kCssBorderStyleDotted = 'dotted';
const kCssBorderStyleDashed = 'dashed';
const kCssBorderStyleDouble = 'double';
const kCssBorderStyleSolid = 'solid';

final _elementBorder = Expando<CssBorder>();

CssBorder tryParseBorder(BuildMetadata meta) {
  final existing = _elementBorder[meta.element];
  if (existing != null) return existing;
  var border = CssBorder();

  for (final style in meta.styles) {
    final key = style.property;
    if (!key.startsWith(kCssBorder)) continue;

    if (style.term == kCssBorderInherit) {
      border = CssBorder(inherit: true);
      continue;
    }

    final borderSide = tryParseCssBorderSide(style.values);
    final suffix = key.substring(kCssBorder.length);
    if (suffix.isEmpty) {
      border = CssBorder(all: borderSide);
    } else {
      switch (suffix) {
        case kCssSuffixBottom:
        case kCssSuffixBlockEnd:
          border = border.copyWith(bottom: borderSide);
          break;
        case kCssSuffixInlineEnd:
          border = border.copyWith(inlineEnd: borderSide);
          break;
        case kCssSuffixInlineStart:
          border = border.copyWith(inlineStart: borderSide);
          break;
        case kCssSuffixLeft:
          border = border.copyWith(left: borderSide);
          break;
        case kCssSuffixRight:
          border = border.copyWith(right: borderSide);
          break;
        case kCssSuffixTop:
        case kCssSuffixBlockStart:
          border = border.copyWith(top: borderSide);
          break;
      }
    }
  }

  return _elementBorder[meta.element] = border;
}

CssBorderSide? tryParseCssBorderSide(List<css.Expression> expressions) {
  final width =
      expressions.isNotEmpty ? tryParseCssLength(expressions[0]) : null;
  if (width == null || width.number <= 0) return null;

  return CssBorderSide(
    color: expressions.length >= 3 ? tryParseColor(expressions[2]) : null,
    style:
        expressions.length >= 2 ? tryParseCssBorderStyle(expressions[1]) : null,
    width: width,
  );
}

TextDecorationStyle? tryParseCssBorderStyle(css.Expression expression) {
  if (expression is css.LiteralTerm) {
    switch (expression.valueAsString) {
      case kCssBorderStyleDotted:
        return TextDecorationStyle.dotted;
      case kCssBorderStyleDashed:
        return TextDecorationStyle.dashed;
      case kCssBorderStyleDouble:
        return TextDecorationStyle.double;
    }
  }

  return null;
}
