import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_chewie/fwfh_chewie.dart';

import '../../core/test/_.dart' as helper;

final kDataUri = helper.kDataUri;

String? videoPlayerExplainer(helper.Explainer parent, Widget widget) {
  if (widget is VideoPlayer) {
    return '[VideoPlayer:url=${widget.url}'
        ',aspectRatio=${widget.aspectRatio.toStringAsFixed(2)}'
        "${!widget.autoResize ? ',autoResize=${widget.autoResize}' : ''}"
        "${widget.autoplay ? ',autoplay=${widget.autoplay}' : ''}"
        "${widget.controls ? ',controls=${widget.controls}' : ''}"
        "${widget.loop ? ',loop=${widget.loop}' : ''}"
        "${widget.poster != null ? ',poster=${parent.explain(widget.poster!)}' : ''}"
        ']';
  }

  return null;
}

Future<String> explain(
  WidgetTester tester,
  String html, {
  bool useExplainer = true,
}) async =>
    helper.explain(
      tester,
      null,
      explainer: videoPlayerExplainer,
      hw: HtmlWidget(
        html,
        key: helper.hwKey,
        factoryBuilder: () => _WidgetFactory(),
      ),
      useExplainer: useExplainer,
    );

class _WidgetFactory extends WidgetFactory with ChewieFactory {}
