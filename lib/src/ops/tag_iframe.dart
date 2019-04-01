import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    show BuiltPiece, BuiltPieceSimple;
import 'package:html/dom.dart' as dom;
import 'package:webview_flutter/webview_flutter.dart';

import '../widget_factory.dart';
import 'tag_a.dart';

class TagIframe {
  final WidgetFactory wf;

  TagIframe(this.wf);

  Widget build(dom.Element e) {
    final a = e.attributes;
    if (!a.containsKey('src')) {
      return null;
    }

    final config = wf.config;
    final src = buildFullUrl(a['src'], config.baseUrl);

    if (!config.webView) {
      final tagA = TagA(src, wf, icon: false);
      final pieces = tagA.onPieces(<BuiltPiece>[
        BuiltPieceSimple(widgets: <Widget>[wf.buildTextWidget(src)]),
      ]);
      return pieces.first?.widgets?.first;
    }

    var width = 16.0;
    var height = 9.0;
    if (a.containsKey("width") && a.containsKey("height")) {
      final aWidth = double.tryParse(a["width"]);
      final aHeight = double.tryParse(a["height"]);
      if (aWidth != null && aHeight != null) {
        width = aWidth;
        height = aHeight;
      }
    }

    return wrapPadding(
      AspectRatio(
        aspectRatio: width / height,
        child: WebView(
            initialUrl: src,
            javascriptMode: config.webViewJs
                ? JavascriptMode.unrestricted
                : JavascriptMode.disabled),
      ),
      config.webViewPadding,
    );
  }
}
