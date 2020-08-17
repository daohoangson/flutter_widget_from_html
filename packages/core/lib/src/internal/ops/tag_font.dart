part of '../core_ops.dart';

const kAttributeFontColor = 'color';
const kAttributeFontFace = 'face';
const kAttributeFontSize = 'size';

const kTagFont = 'font';

class TagFont {
  final WidgetFactory wf;

  TagFont(this.wf);

  BuildOp get buildOp => BuildOp(
        defaultStyles: (_, e) {
          final a = e.attributes;
          final styles = <String, String>{};

          if (a.containsKey(kAttributeFontColor)) {
            styles[kCssColor] = a[kAttributeFontColor];
          }

          if (a.containsKey(kAttributeFontFace)) {
            styles[kCssFontFamily] = a[kAttributeFontFace];
          }

          if (a.containsKey(kAttributeFontSize)) {
            final size = a[kAttributeFontSize];
            if (kCssFontSizes.containsKey(size)) {
              styles[kCssFontSize] = kCssFontSizes[size];
            }
          }

          return styles;
        },
      );
}
