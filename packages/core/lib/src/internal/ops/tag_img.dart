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
        onTree: (meta, tree) {
          final data = _parse(meta);
          final built = wf.buildImage(meta, data);
          if (built == null) {
            final imgText = data.alt ?? data.title ?? '';
            if (imgText.isNotEmpty) {
              tree.addText(imgText);
            }
            return;
          }

          final placeholder =
              _placeholders[meta] = WidgetPlaceholder(data, child: built);

          if (data.sources.isNotEmpty) {
            final src = data.sources.first;
            final width = src.width;
            final height = src.height;
            placeholder.wrapWith(
              (_, child) => CssSizing(
                minHeight: const CssSizingValue.value(0),
                minWidth: const CssSizingValue.value(0),
                preferredHeight: height != null
                    ? CssSizingValue.value(height)
                    : const CssSizingValue.auto(),
                preferredWidth: width != null
                    ? CssSizingValue.value(width)
                    : const CssSizingValue.auto(),
                child: child,
              ),
            );
          }
        },
        onTreeFlattening: (meta, tree) {
          final placeholder = _placeholders[meta];
          if (placeholder == null) {
            return;
          }

          tree.add(
            WidgetBit.inline(
              tree,
              placeholder,
              alignment: PlaceholderAlignment.baseline,
            ),
          );
        },
        onWidgets: (meta, widgets) {
          final placeholder = _placeholders[meta];
          if (placeholder == null) {
            return widgets;
          }

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
