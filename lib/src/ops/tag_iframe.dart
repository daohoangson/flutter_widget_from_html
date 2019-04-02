import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import '../widget_factory.dart';

class TagIframe {
  final WidgetFactory wf;

  TagIframe(this.wf);

  Widget build(dom.Element e) {
    final a = e.attributes;
    if (!a.containsKey('src')) return null;

    final config = wf.config;
    final src = buildFullUrl(a['src'], config.baseUrl);
    if (src == null) return null;
    if (!config.webView) return wf.buildWebViewLinkOnly(src);

    return wf.buildWebView(
      src,
      height: a.containsKey("height") ? double.tryParse(a["height"]) : null,
      width: a.containsKey("width") ? double.tryParse(a["width"]) : null,
    );
  }
}
