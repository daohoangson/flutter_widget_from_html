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
        alwaysRenderBlock: false,
        debugLabel: kTagImg,
        defaultStyles: _defaultStyles,
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
        onRenderBlock: _onRenderBlock,
        onRenderInline: _onRenderInline,
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

  static StylesMap _defaultStyles(dom.Element element) {
    // other tags that share the same logic:
    // - IFRAME
    //
    // consider update them together if this changes
    final attrs = element.attributes;
    final height = attrs[kAttributeImgHeight];
    final width = attrs[kAttributeImgWidth];
    return {
      kCssHeight: kCssLengthAuto,
      kCssMinWidth: '0px',
      kCssMinHeight: '0px',
      kCssWidth: kCssLengthAuto,
      if (height != null) kCssHeight: '${height}px',
      if (width != null) kCssWidth: '${width}px',
    };
  }

  static Widget _onRenderBlock(BuildTree tree, WidgetPlaceholder placeholder) =>
      _builts[tree] ?? placeholder;

  static void _onRenderInline(BuildTree tree) {
    final built = _builts[tree];
    if (built == null) {
      return;
    }

    tree.append(WidgetBit.inline(tree, built));
  }
}
