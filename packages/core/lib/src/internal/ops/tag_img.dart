part of '../core_ops.dart';

const kAttributeImgAlt = 'alt';
const kAttributeImgHeight = 'height';
const kAttributeImgSrc = 'src';
const kAttributeImgTitle = 'title';
const kAttributeImgWidth = 'width';

const kTagImg = 'img';

class TagImg {
  final WidgetFactory wf;

  static final _placeholders = Expando<WidgetPlaceholder>();

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
        onTree: (tree) {
          final data = _parse(tree);
          final built = wf.buildImage(tree, data);
          if (built == null) {
            final imgText = data.alt ?? data.title ?? '';
            if (imgText.isNotEmpty) {
              tree.addText(imgText);
            }
            return;
          }

          _placeholders[tree] = WidgetPlaceholder(
            localName: kTagImg,
            child: built,
          );
        },
        onTreeFlattening: (tree) {
          final placeholder = _placeholders[tree];
          if (placeholder == null) {
            return false;
          }

          tree.append(
            WidgetBit.inline(
              tree,
              placeholder,
              alignment: PlaceholderAlignment.baseline,
            ),
          );

          return true;
        },
        onWidgets: (tree, widgets) {
          final placeholder = _placeholders[tree];
          if (placeholder == null) {
            return widgets;
          }

          return [placeholder];
        },
        onWidgetsIsOptional: true,
      );

  ImageMetadata _parse(BuildTree tree) {
    final attrs = tree.element.attributes;
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
