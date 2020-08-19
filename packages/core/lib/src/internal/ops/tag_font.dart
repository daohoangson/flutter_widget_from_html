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
          final styles = <String, String>{};

          if (attrs.containsKey(kAttributeFontColor)) {
            styles[kCssColor] = attrs[kAttributeFontColor];
          }

          if (attrs.containsKey(kAttributeFontFace)) {
            styles[kCssFontFamily] = attrs[kAttributeFontFace];
          }

          if (attrs.containsKey(kAttributeFontSize)) {
            final size = attrs[kAttributeFontSize];
            if (kCssFontSizes.containsKey(size)) {
              styles[kCssFontSize] = kCssFontSizes[size];
            }
          }

          return styles;
        },
      );
}
