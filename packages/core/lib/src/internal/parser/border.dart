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
    if (!style.key.startsWith(kCssBorder)) continue;

    if (style.value == kCssBorderInherit) {
      border = CssBorder(inherit: true);
      continue;
    }

    final borderSide = _tryParseBorderSide(style.value);
    final suffix = style.key.substring(kCssBorder.length);
    if (suffix.isEmpty) {
      border = CssBorder(all: borderSide);
    } else {
      switch (suffix) {
        case kSuffixBottom:
        case kSuffixBlockEnd:
          border = border.copyWith(bottom: borderSide);
          break;
        case kSuffixInlineEnd:
          border = border.copyWith(inlineEnd: borderSide);
          break;
        case kSuffixInlineStart:
          border = border.copyWith(inlineStart: borderSide);
          break;
        case kSuffixLeft:
          border = border.copyWith(left: borderSide);
          break;
        case kSuffixRight:
          border = border.copyWith(right: borderSide);
          break;
        case kSuffixTop:
        case kSuffixBlockStart:
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
