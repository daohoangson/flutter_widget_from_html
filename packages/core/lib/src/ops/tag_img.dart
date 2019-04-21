import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    show BuildOp;

import '../core_wf.dart';
import '../metadata.dart';

class TagImg {
  final WidgetFactory wf;

  BuildOp _buildOp;

  TagImg(this.wf);

  BuildOp get buildOp {
    _buildOp ??= BuildOp(onProcess: (meta, _, addWidgets, __) {
      final e = meta.buildOpElement;
      final image = _ImageMetadata.fromAttributes(e.attributes);
      if (image == null) return;

      final widget = wf.buildImageWidget(
        image.src,
        height: image.height,
        width: image.width,
      );
      if (widget == null) return;

      addWidgets(<Widget>[widget]);
    });

    return _buildOp;
  }
}

class _ImageMetadata {
  final int height;
  final String src;
  final int width;

  _ImageMetadata({this.height, this.src, this.width});

  static _ImageMetadata fromAttributes(Map<dynamic, String> map) {
    final src = _getValue(map, 'src', 'data-src');
    if (src?.isNotEmpty != true) return null;

    return _ImageMetadata(
      height: _parseInt(_getValue(map, 'height', 'data-height')),
      src: src,
      width: _parseInt(_getValue(map, 'width', 'data-width')),
    );
  }
}

String _getValue(Map<dynamic, String> map, String key, String key2) =>
    map.containsKey(key) ? map[key] : map.containsKey(key2) ? map[key2] : null;

int _parseInt(String value) =>
    value?.isNotEmpty == true ? int.parse(value) : null;
