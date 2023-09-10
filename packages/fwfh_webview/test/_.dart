import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_webview/fwfh_webview.dart';

import '../../core/test/_.dart' as helper;

String? webViewExplainer(helper.Explainer parent, Widget widget) {
  if (widget is WebView) {
    final debuggingEnabled = widget.debuggingEnabled
        ? ',debuggingEnabled=${widget.debuggingEnabled}'
        : '';
    final mediaPlaybackAlwaysAllow = widget.mediaPlaybackAlwaysAllow
        ? ',mediaPlaybackAlwaysAllow=${widget.mediaPlaybackAlwaysAllow}'
        : '';
    final unsupportedWorkaroundForIssue37 =
        !widget.unsupportedWorkaroundForIssue37
            ? ',unsupportedWorkaroundForIssue37='
                '${widget.unsupportedWorkaroundForIssue37}'
            : '';
    final userAgent = widget.userAgent?.isNotEmpty == true
        ? ',userAgent=${widget.userAgent}'
        : '';

    return '[WebView:url=${widget.url}'
        ',aspectRatio=${widget.aspectRatio.toStringAsFixed(2)}'
        "${widget.autoResize ? ',autoResize=${widget.autoResize}' : ''}"
        '$debuggingEnabled'
        "${!widget.js ? ',js=${widget.js}' : ''}"
        '$mediaPlaybackAlwaysAllow'
        '$unsupportedWorkaroundForIssue37'
        '$userAgent'
        ']';
  }

  return null;
}

Future<String> explain(
  WidgetTester tester,
  String html, {
  Uri? baseUrl,
  bool useExplainer = true,
  bool webView = true,
}) async =>
    helper.explain(
      tester,
      null,
      explainer: webViewExplainer,
      hw: HtmlWidget(
        html,
        baseUrl: baseUrl,
        key: helper.hwKey,
        factoryBuilder: () => WebViewWidgetFactory(webView: webView),
      ),
      useExplainer: useExplainer,
    );

class WebViewWidgetFactory extends WidgetFactory with WebViewFactory {
  final bool? _webView;

  WebViewWidgetFactory({bool? webView}) : _webView = webView;

  @override
  bool get webView => _webView ?? super.webView;
}
