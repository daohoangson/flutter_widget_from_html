part of '../ops.dart';

const kAttributeIframeHeight = 'height';
const kAttributeIframeSrc = 'src';
const kAttributeIframeWidth = 'width';

const kTagIframe = 'iframe';

class TagIframe {
  final WidgetFactory wf;

  TagIframe(this.wf);

  BuildOp get buildOp => BuildOp(onWidgets: (meta, _) {
        final webView = build(meta);
        return webView != null ? [webView] : null;
      });

  Widget build(NodeMetadata meta) {
    final attrs = meta.domElement.attributes;
    if (!attrs.containsKey(kAttributeIframeSrc)) return null;

    final src = wf.urlFull(attrs[kAttributeIframeSrc]);
    if (src == null) return null;

    return wf.buildWebView(
      meta,
      src,
      height: tryParseDoubleFromMap(attrs, kAttributeIframeHeight),
      width: tryParseDoubleFromMap(attrs, kAttributeIframeWidth),
    );
  }
}
