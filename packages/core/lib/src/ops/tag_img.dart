part of '../core_widget_factory.dart';

final _dimensionRegExp = RegExp(r'^(.+)px$');

class ImageLayout extends StatefulWidget {
  final double height;
  final ImageProvider image;
  final String text;
  final double width;

  ImageLayout(this.image, {this.height, Key key, this.text, this.width})
      : assert(image != null),
        super(key: key);

  @override
  _ImageLayoutState createState() => _ImageLayoutState();
}

class _ImageLayoutState extends State<ImageLayout> {
  var error;
  double height;
  double width;

  ImageStream _stream;
  ImageStreamListener _streamListener;

  bool get hasDimensions => height != null && height > 0 && width != null;

  @override
  void initState() {
    super.initState();

    height = widget.height;
    width = widget.width;
  }

  @override
  void dispose() {
    super.dispose();

    _stream?.removeListener(_streamListener);
  }

  @override
  Widget build(BuildContext _) {
    if (!hasDimensions && _stream == null) {
      _streamListener = ImageStreamListener(
        (info, isSync) {
          height = info.image.height.toDouble();
          width = info.image.width.toDouble();

          // trigger state change only on async update
          if (!isSync) setState(() {});
        },
        onError: (e, _) => print('[flutter_widget_from_html] '
            "Error resolving image: $e"),
      );
      _stream = widget.image.resolve(ImageConfiguration.empty);
      _stream.addListener(_streamListener);
    }

    if (hasDimensions) {
      // we may have dimensions in 3 cases
      // 1. From the beginning, via widget constructor
      // 2. From synchronized image info, immediately in the first build
      // 3. From async update / triggered state change (see above)
      return CustomSingleChildLayout(
        child: Image(image: widget.image, fit: BoxFit.cover),
        delegate: _ImageLayoutDelegate(height: height, width: width),
      );
    }

    return widget.text != null ? Text(widget.text) : widget0;
  }
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
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      BoxConstraints.tight(getSize(constraints));

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

class _TextImage extends TextWidget {
  _TextImage(TextBits parent, _TagImg self, _TagImgMetadata img)
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
    IWidgetPlaceholder child,
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

          text.add(_TextImage(text, this, img));
          return pieces;
        },
        onWidgets: (meta, widgets) {
          if (!meta.isBlockElement) return widgets;

          final img = _parseMetadata(meta, wf);
          if (img.url?.isNotEmpty != true) return widgets;

          return _listOrNull(_buildImage1(img));
        },
      );

  Iterable<Widget> _buildImage(
    BuildContext _,
    Iterable<Widget> __,
    _TagImgMetadata img,
  ) =>
      [_buildImage1(img)];

  Widget _buildImage1(_TagImgMetadata img) => wf.buildImage(
        img.url,
        height: img.height,
        text: img.text,
        width: img.width,
      );

  static String _getAttr(Map<dynamic, String> map, String key, String key2) =>
      map.containsKey(key)
          ? map[key]
          : map.containsKey(key2) ? map[key2] : null;

  static double _getDimension(
    NodeMetadata meta,
    Map<dynamic, String> map,
    String key,
    String key2,
  ) {
    String value;
    meta.styles((k, v) => k == key ? value = v : null);
    if (value != null) {
      final match = _dimensionRegExp.matchAsPrefix(value);
      if (match != null) {
        final parsed = double.tryParse(match.group(1));
        if (parsed != null) return parsed;
      }
    }

    value = _getAttr(map, key, key2);
    return value != null ? double.tryParse(value) : null;
  }

  static _TagImgMetadata _parseMetadata(NodeMetadata meta, WidgetFactory wf) {
    final attrs = meta.domElement.attributes;
    final src = _getAttr(attrs, 'src', 'data-src');

    return _TagImgMetadata(
      height: _getDimension(meta, attrs, 'height', 'data-height'),
      text: _getAttr(attrs, 'alt', 'title'),
      url: wf.constructFullUrl(src),
      width: _getDimension(meta, attrs, 'width', 'data-width'),
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
