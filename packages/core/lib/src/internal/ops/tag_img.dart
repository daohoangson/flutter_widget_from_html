part of '../core_ops.dart';

const kAttributeImgAlt = 'alt';
const kAttributeImgHeight = 'height';
const kAttributeImgSrc = 'src';
const kAttributeImgTitle = 'title';
const kAttributeImgWidth = 'width';

const kTagImg = 'img';

class TagImg {
  final WidgetFactory wf;

  static final _placeholders = Expando<WidgetPlaceholder<ImageMetadata>>();

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
          final built = wf.buildImage(meta, data);
          if (built == null) {
            final imgText = data.alt ?? data.title ?? '';
            if (imgText.isNotEmpty) tree.addText(imgText);
            return;
          }

          _placeholders[meta] = WidgetPlaceholder(data, child: built);
        },
        onTreeFlattening: (meta, tree) {
          final placeholder = _placeholders[meta];
          if (placeholder == null) return;

          tree.replaceWith(WidgetBit.inline(tree, placeholder));
        },
        onWidgets: (meta, widgets) {
          final placeholder = _placeholders[meta];
          if (placeholder == null) return widgets;
          return [placeholder];
        },
        onWidgetsIsOptional: true,
      );

  ImageMetadata _parse(BuildMetadata meta) {
    final attrs = meta.element.attributes;
    final url = wf.urlFull(attrs[kAttributeImgSrc] ?? '');
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
          : const [],
      title: attrs[kAttributeImgTitle],
    );
  }
}
