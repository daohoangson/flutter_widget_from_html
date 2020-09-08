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
          final styles = <String, String>{};

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
              WidgetPlaceholder<ImageMetadata>(data, child: built)
                  .wrapWith((context, child) => _LoosenConstraintsWidget(
                        child: child,
                        crossAxisAlignment:
                            meta.tsb().build(context).crossAxisAlignment,
                      ));

          tree.replaceWith(meta.isBlockElement
              ? WidgetBit.block(tree, placeholder)
              : WidgetBit.inline(tree, placeholder));
        },
      );

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

class _LoosenConstraintsWidget extends SingleChildRenderObjectWidget {
  final CrossAxisAlignment crossAxisAlignment;

  _LoosenConstraintsWidget(
      {@required Widget child, this.crossAxisAlignment, Key key})
      : super(child: child, key: key);

  @override
  _LoosenConstraintsRender createRenderObject(BuildContext _) =>
      _LoosenConstraintsRender(crossAxisAlignment: crossAxisAlignment);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<CrossAxisAlignment>(
        'crossAxisAlignment', crossAxisAlignment));
  }

  @override
  void updateRenderObject(
      BuildContext _, _LoosenConstraintsRender renderObject) {
    renderObject.crossAxisAlignment = crossAxisAlignment;
  }
}

class _LoosenConstraintsParentData extends ContainerBoxParentData<RenderBox> {}

class _LoosenConstraintsRender extends RenderProxyBox {
  _LoosenConstraintsRender({
    RenderBox child,
    CrossAxisAlignment crossAxisAlignment,
  })  : _crossAxisAlignment = crossAxisAlignment,
        super(child);

  CrossAxisAlignment _crossAxisAlignment;
  set crossAxisAlignment(CrossAxisAlignment value) {
    if (value == _crossAxisAlignment) return;
    _crossAxisAlignment = value;
    markNeedsLayout();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final data = child.parentData as _LoosenConstraintsParentData;
    context.paintChild(child, data.offset + offset);
  }

  @override
  void performLayout() {
    final c = constraints;
    child.layout(c.loosen(), parentUsesSize: true);
    size = c.constrain(child.size);

    if (_crossAxisAlignment == CrossAxisAlignment.center) {
      final data = child.parentData as _LoosenConstraintsParentData;
      data.offset = Offset((size.width - child.size.width) / 2, 0);
    }
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _LoosenConstraintsParentData) {
      child.parentData = _LoosenConstraintsParentData();
    }
  }
}
