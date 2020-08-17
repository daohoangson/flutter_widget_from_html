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
    final a = meta.domElement.attributes;
    if (!a.containsKey(kAttributeIframeSrc)) return null;

    final src = wf.urlFull(a[kAttributeIframeSrc]);
    if (src == null) return null;

    return wf.buildWebView(
      meta,
      src,
      height: a.containsKey(kAttributeIframeHeight)
          ? double.tryParse(a[kAttributeIframeHeight])
          : null,
      width: a.containsKey(kAttributeIframeWidth)
          ? double.tryParse(a[kAttributeIframeWidth])
          : null,
    );
  }
}
