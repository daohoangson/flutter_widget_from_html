import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_chewie/fwfh_chewie.dart';

import '../../core/test/_.dart' as helper;

const kDataUri = helper.kDataUri;

String? videoPlayerExplainer(helper.Explainer parent, Widget widget) {
  if (widget is VideoPlayer) {
    final poster = widget.poster != null
        ? ',poster=${parent.explain(widget.poster!)}'
        : '';
    return '[VideoPlayer:url=${widget.url}'
        ',aspectRatio=${widget.aspectRatio.toStringAsFixed(2)}'
        "${!widget.autoResize ? ',autoResize=${widget.autoResize}' : ''}"
        "${widget.autoplay ? ',autoplay=${widget.autoplay}' : ''}"
        "${widget.controls ? ',controls=${widget.controls}' : ''}"
        "${widget.loop ? ',loop=${widget.loop}' : ''}"
        '$poster'
        ']';
  }

  return null;
}

Future<String> explain(
  WidgetTester tester,
  String html, {
  bool useExplainer = true,
  Duration delay = const Duration(milliseconds: 10),
}) async {
  final explained = await helper.explain(
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

  if (delay == Duration.zero) {
    return explained;
  }

  await tester.runAsync(() => Future.delayed(delay));
  await tester.pump();

  return helper.explainWithoutPumping(
    explainer: videoPlayerExplainer,
    useExplainer: useExplainer,
  );
}

class _WidgetFactory extends WidgetFactory with ChewieFactory {}
