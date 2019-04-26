part of '../core_wf.dart';

class TagImg {
  final WidgetFactory wf;

  TagImg(this.wf);

  BuildOp get buildOp => BuildOp(onWidgets: (meta, widgets) {
        final attributes = meta.buildOpElement.attributes;
        final src = _getAttr(attributes, 'src', 'data-src');
        final h = _parseInt(_getAttr(attributes, 'height', 'data-height'));
        final w = _parseInt(_getAttr(attributes, 'width', 'data-width'));
        final t = _getAttr(attributes, 'alt', 'title');

        return wf.buildImage(src, height: h, text: t, width: w);
      });
}

String _getAttr(Map<dynamic, String> map, String key, String key2) =>
    map.containsKey(key) ? map[key] : map.containsKey(key2) ? map[key2] : null;

int _parseInt(String value) =>
    value?.isNotEmpty == true ? int.parse(value) : null;
