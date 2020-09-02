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

  BuildOp get buildOp => BuildOp(onTree: (meta, tree) {
        final data = _parse(meta);
        final built = _build(meta, data);
        if (built == null) {
          final imgText = data.alt ?? data.title;
          if (imgText?.isNotEmpty == true) {
            tree.addText(imgText);
          }
          return;
        }

        final placeholder =
            WidgetPlaceholder<ImageMetadata>(data, child: built);

        tree.replaceWith(meta.isBlockElement
            ? WidgetBit.block(tree, placeholder)
            : WidgetBit.inline(tree, placeholder));
      });

  Widget _build(BuildMetadata meta, ImageMetadata data) {
    final provider = wf.imageProvider(data.sources?.first);
    if (provider == null) return null;
    return wf.buildImage(meta, provider, data);
  }

  ImageMetadata _parse(BuildMetadata meta) {
    final attrs = meta.element.attributes;
    final url = wf.urlFull(attrs[kAttributeImgSrc]);
    return ImageMetadata(
      alt: attrs[kAttributeImgAlt],
      sources: (url != null)
          ? [
              ImageSource(
                url,
                height: tryParseDoubleFromMap(attrs, kAttributeImgHeight),
                width: tryParseDoubleFromMap(attrs, kAttributeImgWidth),
              ),
            ]
          : null,
      title: attrs[kAttributeImgTitle],
    );
  }
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
