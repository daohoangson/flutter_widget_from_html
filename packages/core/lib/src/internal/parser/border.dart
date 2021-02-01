part of '../core_parser.dart';

const kCssBorder = 'border';
const kCssBorderInherit = 'inherit';
const kCssBorderStyleDotted = 'dotted';
const kCssBorderStyleDashed = 'dashed';
const kCssBorderStyleDouble = 'double';
const kCssBorderStyleSolid = 'solid';

final _borderValuesThreeRegExp = RegExp(r'^(.+)\s+(.+)\s+(.+)$');
final _borderValuesTwoRegExp = RegExp(r'^(.+)\s+(.+)$');
final _elementBorder = Expando<CssBorder>();

CssBorder tryParseBorder(BuildMetadata meta) {
  var border = _elementBorder[meta.element];
  if (border != null) return border;
  border = CssBorder();

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

CssBorderSide _tryParseBorderSide(String value) {
  String color_, style_, width_;

  final valuesThree = _borderValuesThreeRegExp.firstMatch(value);
  if (valuesThree != null) {
    color_ = valuesThree[3];
    style_ = valuesThree[2];
    width_ = valuesThree[1];
  } else {
    final valuesTwo = _borderValuesTwoRegExp.firstMatch(value);
    if (valuesTwo != null) {
      style_ = valuesTwo[2];
      width_ = valuesTwo[1];
    } else {
      width_ = value;
    }
  }

  final width = tryParseCssLength(width_);
  if (width == null || width.number <= 0) return CssBorderSide.none;

  return CssBorderSide(
    color: tryParseColor(color_),
    style: _tryParseTextDecorationStyle(style_),
    width: width,
  );
}

TextDecorationStyle _tryParseTextDecorationStyle(String value) {
  switch (value) {
    case kCssBorderStyleDotted:
      return TextDecorationStyle.dotted;
    case kCssBorderStyleDashed:
      return TextDecorationStyle.dashed;
    case kCssBorderStyleDouble:
      return TextDecorationStyle.double;
    case kCssBorderStyleSolid:
      return TextDecorationStyle.solid;
  }

  return null;
}
