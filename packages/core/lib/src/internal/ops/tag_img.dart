part of '../ops.dart';

const kAttributeImgAlt = 'alt';
const kAttributeImgHeight = 'height';
const kAttributeImgSrc = 'src';
const kAttributeImgTitle = 'title';
const kAttributeImgWidth = 'width';

const kTagImg = 'img';

class TagImg {
  final WidgetFactory wf;

  TagImg(this.wf);

  BuildOp get buildOp => BuildOp(
        isBlockElement: false,
        onPieces: (node, pieces) {
          if (node.isBlockElement) return pieces;

          final text = pieces.last?.text;
          final image = _parse(node);
          final built = _build(node, image);
          if (built == null) {
            final imgText = image.alt ?? image.title;
            if (imgText?.isNotEmpty == true) {
              text.addText(imgText);
            }
            return pieces;
          }

          text.add(_ImageBit(
            text,
            WidgetPlaceholder<ImageMetadata>(child: built, generator: image),
          ));
          return pieces;
        },
        onWidgets: (node, _) {
          if (!node.isBlockElement) return [];

          final image = _parse(node);
          final built = _build(node, image);
          if (built == null) return [];

          return [
            WidgetPlaceholder<ImageMetadata>(child: built, generator: image)
          ];
        },
      );

  Widget _build(NodeMetadata node, ImageMetadata image) {
    final provider = wf.imageProvider(image.sources?.first);
    if (provider == null) return null;
    return wf.buildImage(node, provider, image);
  }

  ImageMetadata _parse(NodeMetadata meta) {
    final attrs = meta.domElement.attributes;
    final src =
        attrs.containsKey(kAttributeImgSrc) ? attrs[kAttributeImgSrc] : null;
    final url = wf.constructFullUrl(src);
    return ImageMetadata(
      alt: attrs.containsKey(kAttributeImgAlt) ? attrs[kAttributeImgAlt] : null,
      sources: (url != null)
          ? [
              ImageSource(
                url,
                height: attrs.containsKey(kAttributeImgHeight)
                    ? double.tryParse(attrs[kAttributeImgHeight])
                    : null,
                width: attrs.containsKey(kAttributeImgWidth)
                    ? double.tryParse(attrs[kAttributeImgWidth])
                    : null,
              ),
            ]
          : null,
      title: attrs.containsKey(kAttributeImgTitle)
          ? attrs[kAttributeImgTitle]
          : null,
    );
  }
}

class _ImageBit extends TextWidget<ImageMetadata> {
  _ImageBit(TextBits parent, WidgetPlaceholder<ImageMetadata> widget)
      : super(parent, widget);

  @override
  InlineSpan compile(TextStyleBuilder _) => WidgetSpan(
        alignment: alignment,
        baseline: baseline,
        child: widget,
      );
}
