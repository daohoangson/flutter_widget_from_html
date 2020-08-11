part of '../core_widget_factory.dart';

const _kCssDisplay = 'display';
const _kCssDisplayBlock = 'block';
const _kCssDisplayInline = 'inline';
const _kCssDisplayInlineBlock = 'inline-block';
const _kCssDisplayNone = 'none';

const _kCssMaxLines = 'max-lines';
const _kCssMaxLinesNone = 'none';
const _kCssMaxLinesWebkitLineClamp = '-webkit-line-clamp';

const _kCssTextAlign = 'text-align';
const _kCssTextAlignCenter = 'center';
const _kCssTextAlignJustify = 'justify';
const _kCssTextAlignLeft = 'left';
const _kCssTextAlignRight = 'right';
const _kAttributeAlign = 'align';

const _kCssTextOverflow = 'text-overflow';
const _kCssTextOverflowClip = 'clip';
const _kCssTextOverflowEllipsis = 'ellipsis';

TextAlign _tryParseTextAlign(String value) {
  switch (value) {
    case _kCssTextAlignCenter:
      return TextAlign.center;
    case _kCssTextAlignJustify:
      return TextAlign.justify;
    case _kCssTextAlignLeft:
      return TextAlign.left;
    case _kCssTextAlignRight:
      return TextAlign.right;
  }

  return null;
}
