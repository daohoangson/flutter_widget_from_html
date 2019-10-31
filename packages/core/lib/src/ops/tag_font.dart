part of '../core_widget_factory.dart';

const kTagFont = 'font';

class _TagFont {
  final WidgetFactory wf;

  _TagFont(this.wf);

  BuildOp get buildOp => BuildOp(
        defaultStyles: (_, e) {
          final a = e.attributes;
          final styles = <String>[];
          if (a.containsKey('color')) {
            styles.addAll([kCssColor, a['color']]);
          }
          if (a.containsKey('face')) {
            styles.addAll([kCssFontFamily, a['face']]);
          }
          if (a.containsKey('size')) {
            final size = a['size'];
            if (kCssFontSizes.containsKey(size)) {
              styles.addAll([kCssFontSize, kCssFontSizes[size]]);
            }
          }

          return styles;
        },
      );
}
