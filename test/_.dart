import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../packages/core/test/_.dart' as helper;

const kDataUri = helper.kDataUri;

final hwKey = helper.hwKey;

final buildCurrentState = helper.buildCurrentState;

String _explainer(Widget widget) {
  if (widget is CachedNetworkImage) {
    return '[CachedNetworkImage:${widget.imageUrl}]';
  }

  if (widget is VideoPlayer) return '[$widget]';
  if (widget is WebView) return '[$widget]';

  return null;
}

Future<String> explain(
  WidgetTester tester,
  String html, {
  bool buildFutureBuilderWithData = true,
  HtmlWidget hw,
  bool webView = false,
}) async =>
    helper.explain(
      tester,
      null,
      buildFutureBuilderWithData: buildFutureBuilderWithData,
      explainer: _explainer,
      hw: hw ??
          HtmlWidget(
            html,
            bodyPadding: const EdgeInsets.all(0),
            key: helper.hwKey,
            webView: webView,
          ),
    );
