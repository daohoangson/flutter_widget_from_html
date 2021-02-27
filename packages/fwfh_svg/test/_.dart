import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_svg/fwfh_svg.dart';

import '../../core/test/_.dart' as helper;

String? svgExplainer(helper.Explainer parent, Widget widget) {
  if (widget is SvgPicture) {
    return '[SvgPicture:pictureProvider=${widget.pictureProvider}]';
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
      explainer: svgExplainer,
      hw: HtmlWidget(
        html,
        key: helper.hwKey,
        factoryBuilder: () => _WidgetFactory(),
      ),
    );

class _WidgetFactory extends WidgetFactory with SvgFactory {}
