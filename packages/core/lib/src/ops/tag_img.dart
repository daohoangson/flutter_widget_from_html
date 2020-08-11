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

          text.add(_ImageBit(text, this, img));
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

  Iterable<Widget> _wpb(BuildContext _, Iterable<Widget> __, ImgMetadata img) =>
      _listOrNull(_buildImg(img));
}

class _ImageBit extends TextWidget<ImgMetadata> {
  _ImageBit(TextBits parent, _TagImg self, ImgMetadata img)
      : super(
          parent,
          WidgetPlaceholder(builder: self._wpb, input: img),
        );

  @override
  WidgetSpan compile(TextStyle style) => WidgetSpan(
        alignment: alignment,
        baseline: baseline,
        child: widget,
        style: style,
      );
}
