part of '../core_ops.dart';

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
    final url = wf.urlFull(src);
    return ImageMetadata(
      alt: attrs.containsKey(kAttributeImgAlt) ? attrs[kAttributeImgAlt] : null,
      sources: (url != null)
          ? [
              ImageSource(
                url,
                height: tryParseDoubleFromMap(attrs, kAttributeImgHeight),
                width: tryParseDoubleFromMap(attrs, kAttributeImgWidth),
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
  InlineSpan compile(TextStyleHtml _) => WidgetSpan(
        alignment: alignment,
        baseline: baseline,
        child: child,
      );
}

final _dataUriRegExp = RegExp(r'^data:image/[^;]+;(base64|utf8),');

Uint8List bytesFromDataUri(String dataUri) {
  final match = _dataUriRegExp.matchAsPrefix(dataUri);
  if (match == null) return null;

  final prefix = match[0];
  final encoding = match[1];
  final data = dataUri.substring(prefix.length);

  final bytes = encoding == 'base64'
      ? base64.decode(data)
      : encoding == 'utf8' ? Uint8List.fromList(data.codeUnits) : null;
  if (bytes.isEmpty) return null;

  return bytes;
}
