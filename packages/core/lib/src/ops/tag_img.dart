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
          final built = _buildImg(img);
          if (built == null) {
            final imgText = img.alt ?? img.title;
            if (imgText?.isNotEmpty == true) {
              text.addText(imgText);
            }
            return pieces;
          }

          text.add(_ImageBit(
            text,
            WidgetPlaceholder<ImgMetadata>(child: built, generator: img),
          ));
          return pieces;
        },
        onWidgets: (meta, _) {
          if (!meta.isBlockElement) return [];

          final img = _parseMetadata(meta);
          final built = _buildImg(img);
          if (built == null) return [];

          return [WidgetPlaceholder<ImgMetadata>(child: built, generator: img)];
        },
      );

  Widget _buildImg(ImgMetadata img) {
    final image = wf.buildImageProvider(img.url);
    if (image == null) return null;
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
}

class _ImageBit extends TextWidget<ImgMetadata> {
  _ImageBit(TextBits parent, WidgetPlaceholder<ImgMetadata> widget)
      : super(parent, widget);

  @override
  TextSpanBuilder prepareBuilder(TextStyleBuilder _) =>
      TextSpanBuilder.prebuilt(
        span: WidgetSpan(
          alignment: alignment,
          baseline: baseline,
          child: widget,
        ),
      );
}
