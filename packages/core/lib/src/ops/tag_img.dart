part of '../core_wf.dart';

class TagImg {
  final WidgetFactory wf;

  TagImg(this.wf);

  BuildOp get buildOp => BuildOp(onWidgets: (meta, widgets) {
        final attrs = meta.buildOpElement.attributes;
        final src = _getAttr(attrs, 'src', 'data-src');
        final height = _parseInt(_getAttr(attrs, 'height', 'data-height'));
        final width = _parseInt(_getAttr(attrs, 'width', 'data-width'));
        final text = _getAttr(attrs, 'alt', 'title');

        return wf.buildImage(
          wf.constructFullUrl(src) ?? src,
          height: height,
          text: text,
          width: width,
        );
      });
}

String _getAttr(Map<dynamic, String> map, String key, String key2) =>
    map.containsKey(key) ? map[key] : map.containsKey(key2) ? map[key2] : null;

int _parseInt(String value) =>
    value?.isNotEmpty == true ? int.parse(value) : null;
