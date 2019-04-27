part of '../widget_factory.dart';

class TagIframe {
  final WidgetFactory wf;

  TagIframe(this.wf);

  BuildOp get buildOp =>
      BuildOp(onWidgets: (meta, __) => build(meta.buildOpElement));

  Widget build(dom.Element e) {
    final a = e.attributes;
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
