part of '../core_ops.dart';

const kTagFont = 'font';
const kAttributeFontColor = 'color';
const kAttributeFontFace = 'face';
const kAttributeFontSize = 'size';

class TagFont {
  BuildOp get buildOp => BuildOp(
        debugLabel: kTagFont,
        defaultStyles: (tree) {
          final attrs = tree.element.attributes;
          final color = attrs[kAttributeFontColor];
          final fontFace = attrs[kAttributeFontFace];
          final fontSize = kCssFontSizes[attrs[kAttributeFontSize] ?? ''];
          return {
            if (color != null) kCssColor: color,
            if (fontFace != null) kCssFontFamily: fontFace,
            if (fontSize != null) kCssFontSize: fontSize,
          };
        },
        priority: Prioritiy.tagFont,
      );
}
