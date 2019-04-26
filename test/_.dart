import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../packages/core/test/_.dart' as _coreTesting;

String _explainer(Widget widget) {
  if (widget is CachedNetworkImage)
    return "[CachedNetworkImage:${widget.imageUrl}]";

  if (widget is WebView) return widget.toString();

  return null;
}

Future<String> explain(
  WidgetTester tester,
  String html, {
  bool webView = false,
}) async =>
    _coreTesting.explain(
      tester,
      html,
      hw: () => HtmlWidget(
            html,
            webView: webView,
          ),
      explainer: _explainer,
    );
