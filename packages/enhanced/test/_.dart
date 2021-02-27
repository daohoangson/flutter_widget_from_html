import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../core/test/_.dart' as helper;
import '../../fwfh_svg/test/_.dart' as fwfh_svg;

const kDataUri = helper.kDataUri;

const kGoldenFilePrefix = helper.kGoldenFilePrefix;

final hwKey = helper.hwKey;

final buildCurrentState = helper.buildCurrentState;

String _explainer(helper.Explainer parent, Widget widget) {
  if (widget is VideoPlayer) {
    return '[VideoPlayer:url=${widget.url}'
        ',aspectRatio=${widget.aspectRatio.toStringAsFixed(2)}'
        "${!widget.autoResize ? ',autoResize=${widget.autoResize}' : ''}"
        "${widget.autoplay ? ',autoplay=${widget.autoplay}' : ''}"
        "${widget.controls ? ',controls=${widget.controls}' : ''}"
        "${widget.loop ? ',loop=${widget.loop}' : ''}"
        "${widget.poster != null ? ',poster=${parent.explain(widget.poster)}' : ''}"
        ']';
  }

  if (widget is WebView) {
    return '[WebView:url=${widget.url}'
        ',aspectRatio=${widget.aspectRatio.toStringAsFixed(2)}'
        "${widget.autoResize ? ',autoResize=${widget.autoResize}' : ''}"
        "${widget.debuggingEnabled ? ',debuggingEnabled=${widget.debuggingEnabled}' : ''}"
        "${!widget.js ? ',js=${widget.js}' : ''}"
        "${widget.mediaPlaybackAlwaysAllow ? ',mediaPlaybackAlwaysAllow=${widget.mediaPlaybackAlwaysAllow}' : ''}"
        "${widget.unsupportedWorkaroundForIssue37 ? ',unsupportedWorkaroundForIssue37=${widget.unsupportedWorkaroundForIssue37}' : ''}"
        "${widget.unsupportedWorkaroundForIssue375 ? ',unsupportedWorkaroundForIssue375=${widget.unsupportedWorkaroundForIssue375}' : ''}"
        "${widget.userAgent?.isNotEmpty == true ? ',userAgent=${widget.userAgent}' : ''}"
        ']';
  }

  return fwfh_svg.svgExplainer(parent, widget);
}

Future<String> explain(
  WidgetTester tester,
  String html, {
  bool buildFutureBuilderWithData = true,
  HtmlWidget hw,
  bool useExplainer = true,
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
            key: helper.hwKey,
            webView: webView,
          ),
      useExplainer: useExplainer,
    );

Future<int> tapText(WidgetTester tester, String data) =>
    helper.tapText(tester, data);
