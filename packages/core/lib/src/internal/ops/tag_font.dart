part of '../core_ops.dart';

const kTagFont = 'font';
const kAttributeFontColor = 'color';
const kAttributeFontFace = 'face';
const kAttributeFontSize = 'size';

class TagFont {
  final WidgetFactory wf;

  TagFont(this.wf);

  BuildOp get buildOp => BuildOp(
        debugLabel: kTagFont,
        defaultStyles: (element) {
          final attrs = element.attributes;
          final color = attrs[kAttributeFontColor];
          final fontFace = attrs[kAttributeFontFace];
          final fontSize = kCssFontSizes[attrs[kAttributeFontSize] ?? ''];
          return {
            if (color != null) kCssColor: color,
            if (fontFace != null) kCssFontFamily: fontFace,
            if (fontSize != null) kCssFontSize: fontSize,
          };
        },
      );
}
