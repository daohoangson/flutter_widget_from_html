part of '../core_helpers.dart';

class TagImg {
  final WidgetFactory wf;

  TagImg(this.wf);

  BuildOp get buildOp => BuildOp(
        onPieces: (meta, pieces) {
          final attrs = meta.domElement.attributes;
          final src = _getAttr(attrs, 'src', 'data-src');
          final height = _getDouble(attrs, 'height', 'data-height');
          final width = _getDouble(attrs, 'width', 'data-width');
          final text = _getAttr(attrs, 'alt', 'title');
          final fullUrl = wf.constructFullUrl(src) ?? src;

          if (fullUrl?.isNotEmpty != true && text?.isNotEmpty == true) {
            pieces.last.block.addText(text);
            return pieces;
          }

          var widget = wf.buildImage(
            wf.constructFullUrl(src) ?? src,
            height: height,
            text: text,
            width: width,
          );
          if (!meta.isBlockElement || widget is LimitedBox) {
            widget = wf.buildWrapable(widget);
          }

          return pieces.toList()
            ..add(BuiltPieceSimple(widgets: <Widget>[widget]));
        },
      );
}

String _getAttr(Map<dynamic, String> map, String key, String key2) =>
    map.containsKey(key) ? map[key] : map.containsKey(key2) ? map[key2] : null;

double _getDouble(Map<dynamic, String> map, String key, String key2) {
  final value = _getAttr(map, key, key2);
  return value != null ? double.tryParse(value) : null;
}
