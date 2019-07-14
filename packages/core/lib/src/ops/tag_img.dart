part of '../core_widget_factory.dart';

class ImageLayout extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;

  ImageLayout({this.child, this.height, this.width})
      : assert(child != null),
        assert(height > 0),
        assert(width > 0);

  @override
  Widget build(BuildContext context) => CustomSingleChildLayout(
        child: child,
        delegate: _ImageLayoutDelegate(
          height: height,
          width: width,
        ),
      );
}

class _ImageLayoutDelegate extends SingleChildLayoutDelegate {
  final double height;
  final double ratio;
  final double width;

  _ImageLayoutDelegate({this.height, this.width})
      : assert(height > 0),
        assert(width > 0),
        ratio = width / height;

  @override
  Size getSize(BoxConstraints bc) {
    final w = width < bc.maxWidth ? width : bc.maxWidth;
    final h = height < bc.maxHeight ? height : bc.maxHeight;
    if (w == width && h == height) return Size(w, h);

    final r = w / h;
    if (r < ratio) return Size(w, w / ratio);

    return Size(h * ratio, h);
  }

  @override
  bool shouldRelayout(_ImageLayoutDelegate other) =>
      height != other.height || width != other.width;
}

class _TagImg {
  final WidgetFactory wf;

  _TagImg(this.wf);

  BuildOp get buildOp => BuildOp(
        isBlockElement: false,
        onPieces: (meta, pieces) {
          if (meta.isBlockElement) return pieces;

          final img = _parseMetadata(meta, wf);

          if (img.url?.isNotEmpty != true && img.text?.isNotEmpty == true) {
            return pieces..last?.block?.addText(img.text);
          }

          final widget = _buildImage(img, wf);
          if (widget == null) return pieces;

          if (widget is Text) {
            return pieces..last?.block?.addText(widget.data);
          }

          return pieces
            ..last?.block?.addWidget(WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: widget,
                ));
        },
        onWidgets: (meta, widgets) {
          if (!meta.isBlockElement) return widgets;

          final img = _parseMetadata(meta, wf);
          if (img.url?.isNotEmpty != true) return widgets;

          var widget = _buildImage(img, wf);
          if (widget == null) return widgets;

          // [Wrap] is required to avoid small image width being stretched
          return [
            Wrap(children: [widget])
          ];
        },
      );

  static Widget _buildImage(_TagImgMetadata img, WidgetFactory wf) =>
      wf.buildImage(
        img.url,
        height: img.height,
        text: img.text,
        width: img.width,
      );

  static String _getAttr(Map<dynamic, String> map, String key, String key2) =>
      map.containsKey(key)
          ? map[key]
          : map.containsKey(key2) ? map[key2] : null;

  static double _getDouble(Map<dynamic, String> map, String key, String key2) {
    final value = _getAttr(map, key, key2);
    return value != null ? double.tryParse(value) : null;
  }

  static _TagImgMetadata _parseMetadata(NodeMetadata meta, WidgetFactory wf) {
    final attrs = meta.domElement.attributes;
    final src = _getAttr(attrs, 'src', 'data-src');

    return _TagImgMetadata(
      height: _getDouble(attrs, 'height', 'data-height'),
      text: _getAttr(attrs, 'alt', 'title'),
      url: wf.constructFullUrl(src),
      width: _getDouble(attrs, 'width', 'data-width'),
    );
  }
}

class _TagImgMetadata {
  final double height;
  final String text;
  final String url;
  final double width;

  _TagImgMetadata({this.height, this.text, this.url, this.width});
}
