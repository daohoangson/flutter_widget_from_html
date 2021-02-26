import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_webview/fwfh_webview.dart';

import '../../core/test/_.dart' as helper;

String? webViewExplainer(helper.Explainer parent, Widget widget) {
  if (widget is WebView) {
    return '[WebView:url=${widget.url}'
        ',aspectRatio=${widget.aspectRatio.toStringAsFixed(2)}'
        "${widget.autoResize ? ',autoResize=${widget.autoResize}' : ''}"
        "${widget.debuggingEnabled ? ',debuggingEnabled=${widget.debuggingEnabled}' : ''}"
        "${!widget.js ? ',js=${widget.js}' : ''}"
        "${widget.mediaPlaybackAlwaysAllow ? ',mediaPlaybackAlwaysAllow=${widget.mediaPlaybackAlwaysAllow}' : ''}"
        "${!widget.unsupportedWorkaroundForIssue37 ? ',unsupportedWorkaroundForIssue37=${widget.unsupportedWorkaroundForIssue37}' : ''}"
        "${!widget.unsupportedWorkaroundForIssue375 ? ',unsupportedWorkaroundForIssue375=${widget.unsupportedWorkaroundForIssue375}' : ''}"
        "${widget.userAgent?.isNotEmpty == true ? ',userAgent=${widget.userAgent}' : ''}"
        ']';
  }

  return null;
}

Future<String> explain(
  WidgetTester tester,
  String html, {
  bool webView = true,
}) async =>
    helper.explain(
      tester,
      null,
      explainer: webViewExplainer,
      hw: HtmlWidget(
        html,
        key: helper.hwKey,
        factoryBuilder: () => _WidgetFactory(webView),
      ),
    );

class _WidgetFactory extends WidgetFactory with WebViewFactory {
  final bool _webView;

  _WidgetFactory(this._webView);

  @override
  bool get webView => _webView;
}
