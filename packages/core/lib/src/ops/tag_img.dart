import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    show BuildOp;

import '../core_wf.dart';
import '../metadata.dart';

class TagImg {
  final WidgetFactory wf;

  TagImg(this.wf);

  BuildOp get buildOp => BuildOp(onWidgets: (meta, widgets) {
        final attributes = meta.buildOpElement.attributes;
        final src = _getAttr(attributes, 'src', 'data-src');
        if (src?.isNotEmpty != true) return null;

        final h = _parseInt(_getAttr(attributes, 'height', 'data-height'));
        final w = _parseInt(_getAttr(attributes, 'width', 'data-width'));

        return wf.buildImageWidget(src, height: h, width: w);
      });
}

String _getAttr(Map<dynamic, String> map, String key, String key2) =>
    map.containsKey(key) ? map[key] : map.containsKey(key2) ? map[key2] : null;

int _parseInt(String value) =>
    value?.isNotEmpty == true ? int.parse(value) : null;
