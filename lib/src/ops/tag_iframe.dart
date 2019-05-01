part of '../widget_factory.dart';

class TagIframe {
  final WidgetFactory wf;

  TagIframe(this.wf);

  BuildOp get buildOp => BuildOp(onWidgets: (meta, _) => build(meta));

  Widget build(NodeMetadata meta) {
    final a = meta.domElement.attributes;
    if (!a.containsKey('src')) return null;

    final src = wf.constructFullUrl(a['src']);
    if (src == null) return null;

    return wf.buildWebView(
      src,
      height: a.containsKey('height') ? double.tryParse(a['height']) : null,
      width: a.containsKey('width') ? double.tryParse(a['width']) : null,
    );
  }
}
