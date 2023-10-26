part of '../core_ops.dart';

const kTagFont = 'font';
const kAttributeFontColor = 'color';
const kAttributeFontFace = 'face';
const kAttributeFontSize = 'size';

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

extension TagFont on WidgetFactory {
  BuildOp get tagFont => const BuildOp.v2(
        debugLabel: kTagFont,
        defaultStyles: _defaultStyles,
        priority: Priority.tagFont,
      );

  static StylesMap _defaultStyles(dom.Element element) {
    final attrs = element.attributes;
    final color = attrs[kAttributeFontColor];
    final fontFace = attrs[kAttributeFontFace];
    final fontSize = kCssFontSizes[attrs[kAttributeFontSize] ?? ''];
    return {
      if (color != null) kCssColor: color,
      if (fontFace != null) kCssFontFamily: fontFace,
      if (fontSize != null) kCssFontSize: fontSize,
    };
  }
}
