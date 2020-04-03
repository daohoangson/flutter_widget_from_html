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
            styles.addAll([_kCssColor, a['color']]);
          }
          if (a.containsKey('face')) {
            styles.addAll([_kCssFontFamily, a['face']]);
          }
          if (a.containsKey('size')) {
            final size = a['size'];
            if (_kCssFontSizes.containsKey(size)) {
              styles.addAll([_kCssFontSize, _kCssFontSizes[size]]);
            }
          }

          return styles;
        },
      );
}
