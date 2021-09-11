import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../core/test/_.dart' as helper;
import '../../fwfh_cached_network_image/test/_.dart'
    as fwfh_cached_network_image;
import '../../fwfh_chewie/test/_.dart' as fwfh_chewie;
import '../../fwfh_just_audio/test/_.dart' as fwfh_just_audio;
import '../../fwfh_svg/test/_.dart' as fwfh_svg;
import '../../fwfh_webview/test/_.dart' as fwfh_webview;

const kDataUri = helper.kDataUri;

const kGoldenFilePrefix = helper.kGoldenFilePrefix;

final hwKey = helper.hwKey;

const buildCurrentState = helper.buildCurrentState;

const explainWithoutPumping = helper.explainWithoutPumping;

String? _explainer(helper.Explainer parent, Widget widget) {
  return fwfh_cached_network_image.cachedNetworkImageExplainer(
        parent,
        widget,
      ) ??
      fwfh_chewie.videoPlayerExplainer(parent, widget) ??
      fwfh_just_audio.audioPlayerExplainer(parent, widget) ??
      fwfh_svg.svgExplainer(parent, widget) ??
      fwfh_webview.webViewExplainer(parent, widget);
}

Future<String> explain(
  WidgetTester tester,
  String? html, {
  Widget? hw,
  bool useExplainer = true,
}) async =>
    helper.explain(
      tester,
      null,
      explainer: _explainer,
      hw: hw ?? HtmlWidget(html!, key: helper.hwKey),
      useExplainer: useExplainer,
    );

Future<int> tapText(WidgetTester tester, String data) =>
    helper.tapText(tester, data);
