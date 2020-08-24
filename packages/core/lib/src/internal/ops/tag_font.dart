part of '../core_ops.dart';

const kAttributeFontColor = 'color';
const kAttributeFontFace = 'face';
const kAttributeFontSize = 'size';

const kTagFont = 'font';

class TagFont {
  final WidgetFactory wf;

  TagFont(this.wf);

  BuildOp get buildOp => BuildOp(
        defaultStyles: (meta) {
          final attrs = meta.element.attributes;
          return {
            kCssColor: attrs[kAttributeFontColor],
            kCssFontFamily: attrs[kAttributeFontFace],
            kCssFontSize: kCssFontSizes[attrs[kAttributeFontSize]],
          };
        },
      );
}
