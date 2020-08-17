part of '../ops.dart';

class TagIframe {
  final WidgetFactory wf;

  TagIframe(this.wf);

  BuildOp get buildOp => BuildOp(onWidgets: (meta, _) {
        final webView = build(meta);
        return webView != null ? [webView] : null;
      });

  Widget build(NodeMetadata meta) {
    final a = meta.domElement.attributes;
    if (!a.containsKey('src')) return null;

    final src = wf.urlFull(a['src']);
    if (src == null) return null;

    return wf.buildWebView(
      meta,
      src,
      height: a.containsKey('height') ? double.tryParse(a['height']) : null,
      width: a.containsKey('width') ? double.tryParse(a['width']) : null,
    );
  }
}
