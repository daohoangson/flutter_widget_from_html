part of '../core_widget_factory.dart';

class _TagImg {
  final WidgetFactory wf;

  _TagImg(this.wf);

  BuildOp get buildOp => BuildOp(
        isBlockElement: false,
        onPieces: (meta, pieces) {
          if (meta.isBlockElement) return pieces;

          final text = pieces.last?.text;
          final img = _parseMetadata(meta);
          if (img.url?.isNotEmpty != true) {
            final imgText = img.alt ?? img.title;
            if (imgText?.isNotEmpty == true) {
              text.addText(imgText);
            }
            return pieces;
          }

          text.add(_ImageBit(
            text,
            WidgetPlaceholder(builder: _wpb, input: img),
          ));
          return pieces;
        },
        onWidgets: (meta, widgets) {
          if (!meta.isBlockElement) return widgets;

          final img = _parseMetadata(meta);
          return _listOrNull(_buildImg(img));
        },
      );

  Widget _buildImg(ImgMetadata img) {
    final image = wf.buildImageProvider(img.url);
    if (image == null) {
      final text = img.alt ?? img.title;
      if (text == null) return null;
      return Text(text);
    }

    return wf.buildImage(image, img);
  }

  ImgMetadata _parseMetadata(NodeMetadata meta) {
    final attrs = meta.domElement.attributes;
    final src = attrs.containsKey('src') ? attrs['src'] : null;
    return ImgMetadata(
      alt: attrs.containsKey('alt') ? attrs['alt'] : null,
      title: attrs.containsKey('title') ? attrs['title'] : null,
      url: wf.constructFullUrl(src),
    );
  }

  Widget _wpb(BuildContext _, Widget __, ImgMetadata img) => _buildImg(img);
}

class _ImageBit extends TextWidget<ImgMetadata> {
  _ImageBit(TextBits parent, WidgetPlaceholder<ImgMetadata> widget)
      : super(parent, widget);

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
