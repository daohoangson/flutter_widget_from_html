import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_just_audio/fwfh_just_audio.dart';

import '../../core/test/_.dart' as helper;

String? audioPlayerExplainer(helper.Explainer parent, Widget widget) {
  if (widget is AudioPlayer) {
    return '[AudioPlayer:url=${widget.url}'
        "${widget.autoplay ? ',autoplay=${widget.autoplay}' : ''}"
        "${widget.loop ? ',loop=${widget.loop}' : ''}"
        "${widget.muted ? ',muted=${widget.muted}' : ''}"
        "${widget.preload ? ',preload=${widget.preload}' : ''}"
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
      explainer: audioPlayerExplainer,
      hw: HtmlWidget(
        html,
        key: helper.hwKey,
        factoryBuilder: () => _WidgetFactory(),
      ),
      useExplainer: useExplainer,
    );

class _WidgetFactory extends WidgetFactory with JustAudioFactory {}
