import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../packages/core/test/_.dart' as helper;

final hwKey = helper.hwKey;

final buildCurrentState = helper.buildCurrentState;

String _explainer(Widget widget, String Function(Widget) parent) {
  if (widget is CachedNetworkImage) {
    return "[CachedNetworkImage:${widget.imageUrl}]";
  }

  if (widget is GridPlacement) {
    return "[${widget.rowStart},${widget.columnStart}"
        "${widget.rowSpan != 1 || widget.columnSpan != 1 ? ':${widget.rowSpan}x${widget.columnSpan}' : ''}"
        ":${parent(widget.child)}]";
  }

  if (widget is VideoPlayer) return widget.toString();
  if (widget is WebView) return widget.toString();

  return null;
}

Future<String> explain(
  WidgetTester tester,
  String html, {
  HtmlWidget hw,
  bool webView = false,
}) async =>
    helper.explain(
      tester,
      null,
      hw: hw ??
          HtmlWidget(
            html,
            bodyPadding: const EdgeInsets.all(0),
            key: helper.hwKey,
            webView: webView,
          ),
      explainer: _explainer,
    );
