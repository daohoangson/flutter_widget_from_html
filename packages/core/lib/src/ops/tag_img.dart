part of '../core_widget_factory.dart';

class _TagImg {
  final WidgetFactory wf;

  _TagImg(this.wf);

  BuildOp get buildOp => BuildOp(
        isBlockElement: false,
        onPieces: (meta, pieces) {
          if (meta.isBlockElement) return pieces;

          final text = pieces.last?.text;
          final img = _parseMetadata(meta, wf);
          if (img.url?.isNotEmpty != true && img.text?.isNotEmpty == true) {
            text.addText(img.text);
            return pieces;
          }

          text.add(_ImageBit(text, this, img));
          return pieces;
        },
        onWidgets: (meta, widgets) {
          if (!meta.isBlockElement) return widgets;

          final img = _parseMetadata(meta, wf);
          if (img.url?.isNotEmpty != true) return widgets;

          return _listOrNull(img.build(wf));
        },
      );

  Iterable<Widget> _buildImage(
    BuildContext _,
    Iterable<Widget> __,
    _TagImgMetadata img,
  ) =>
      [img.build(wf)];

  static String _getAttr(Map<dynamic, String> map, String key, String key2) =>
      map.containsKey(key)
          ? map[key]
          : map.containsKey(key2) ? map[key2] : null;

  static double _getDimension(
    NodeMetadata meta,
    Map<dynamic, String> map,
    String key,
  ) {
    final value = _getAttr(map, key, 'data-$key');
    return value != null ? double.tryParse(value) : null;
  }

  static _TagImgMetadata _parseMetadata(NodeMetadata meta, WidgetFactory wf) {
    final attrs = meta.domElement.attributes;
    final src = _getAttr(attrs, 'src', 'data-src');

    return _TagImgMetadata(
      height: _getDimension(meta, attrs, 'height'),
      text: _getAttr(attrs, 'alt', 'title'),
      url: wf.constructFullUrl(src),
      width: _getDimension(meta, attrs, 'width'),
    );
  }
}

class _ImageBit extends TextWidget<_TagImgMetadata> {
  _ImageBit(TextBits parent, _TagImg self, _TagImgMetadata img)
      : super(
          parent,
          WidgetPlaceholder(builder: self._buildImage, input: img),
        );

  @override
  WidgetSpan compile(TextStyle style) => _ImageSpan(
        alignment: alignment,
        baseline: baseline,
        child: widget,
        style: style,
      );
}

class _ImageSpan extends WidgetSpan {
  const _ImageSpan({
    PlaceholderAlignment alignment,
    TextBaseline baseline,
    WidgetPlaceholder child,
    TextStyle style,
  }) : super(
          alignment: alignment,
          baseline: baseline,
          child: child,
          style: style,
        );

  @override
  void build(ui.ParagraphBuilder builder,
      {double textScaleFactor = 1.0,
      @required List<PlaceholderDimensions> dimensions}) {
    super.build(builder, textScaleFactor: 1.0, dimensions: dimensions);
  }
}

class _TagImgMetadata {
  final double height;
  final String text;
  final String url;
  final double width;

  _TagImgMetadata({this.height, this.text, this.url, this.width});

  Widget build(WidgetFactory wf) =>
      wf.buildImage(url, height: height, text: text, width: width);
}
