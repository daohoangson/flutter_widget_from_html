part of '../core_widget_factory.dart';

class _TagFont {
  final WidgetFactory wf;

  _TagFont(this.wf);

  BuildOp get buildOp => BuildOp(
        defaultStyles: (_, e) {
          final a = e.attributes;
          final styles = <String, String>{};

          if (a.containsKey('color')) styles[_kCssColor] = a['color'];

          if (a.containsKey('face')) styles[_kCssFontFamily] = a['face'];

          if (a.containsKey('size')) {
            final size = a['size'];
            if (_kCssFontSizes.containsKey(size)) {
              styles[_kCssFontSize] = _kCssFontSizes[size];
            }
          }

          return styles;
        },
      );
}
