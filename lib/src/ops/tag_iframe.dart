import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    show BuildOp;
import 'package:html/dom.dart' as dom;

import '../widget_factory.dart';

class TagIframe {
  final WidgetFactory wf;

  TagIframe(this.wf);

  BuildOp get buildOp =>
      BuildOp(onWidgets: (meta, __) => build(meta.buildOpElement));

  Widget build(dom.Element e) {
    final a = e.attributes;
    if (!a.containsKey('src')) return null;

    final config = wf.config;
    final src = wf.constructFullUrl(a['src']);
    if (src == null) return null;
    if (!config.webView) return wf.buildWebViewLinkOnly(src);

    return wf.buildWebView(
      src,
      height: a.containsKey("height") ? double.tryParse(a["height"]) : null,
      width: a.containsKey("width") ? double.tryParse(a["width"]) : null,
    );
  }
}
