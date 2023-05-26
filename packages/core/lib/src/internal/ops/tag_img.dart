part of '../core_ops.dart';

const kAttributeImgAlt = 'alt';
const kAttributeImgHeight = 'height';
const kAttributeImgSrc = 'src';
const kAttributeImgTitle = 'title';
const kAttributeImgWidth = 'width';

const kTagImg = 'img';

class TagImg {
  final WidgetFactory wf;

  static final _builts = Expando<Widget>();

  TagImg(this.wf);

  BuildOp get buildOp => BuildOp(
        debugLabel: kTagImg,
        defaultStyles: (tree) {
          final attrs = tree.element.attributes;
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
        mustBeBlock: false,
        onParsed: (tree) {
          final data = _parse(tree);
          final built = wf.buildImage(tree, data);
          if (built == null) {
            final imgText = data.alt ?? data.title ?? '';
            if (imgText.isNotEmpty) {
              tree.addText(imgText);
            }
            return tree;
          }

          _builts[tree] = built;
          return tree;
        },
        onRenderBlock: (tree, placeholder) => _builts[tree] ?? placeholder,
        onRenderInline: (tree) {
          final built = _builts[tree];
          if (built == null) {
            return;
          }

          const baseline = PlaceholderAlignment.baseline;
          tree.append(WidgetBit.inline(tree, built, alignment: baseline));
        },
        priority: Priority.tagImg,
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
