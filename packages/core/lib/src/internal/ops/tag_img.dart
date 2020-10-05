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
        defaultStyles: (element) {
          final attrs = element.attributes;
          final styles = {
            kCssHeight: 'auto',
            kCssMinWidth: '0px',
            kCssMinHeight: '0px',
            kCssWidth: 'auto',
          };

          if (attrs.containsKey(kAttributeImgHeight)) {
            styles[kCssHeight] = '${attrs[kAttributeImgHeight]}px';
          }
          if (attrs.containsKey(kAttributeImgWidth)) {
            styles[kCssWidth] = '${attrs[kAttributeImgWidth]}px';
          }

          return styles;
        },
        onTree: (meta, tree) {
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

          tree.replaceWith(meta.willBuildSubtree
              ? WidgetBit.block(tree, placeholder)
              : WidgetBit.inline(tree, placeholder));
        },
      );

  Widget _build(BuildMetadata meta, ImageMetadata data) {
    final source = data.sources?.first;
    if (source == null) return null;

    final provider = wf.imageProvider(source);
    if (provider == null) return null;

    var built = wf.buildImage(meta, provider, data);

    if (source.height?.isNegative == false &&
        source.width?.isNegative == false &&
        source.height != 0) {
      built = wf.buildAspectRatio(meta, built, source.width / source.height);
    }

    return built;
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
