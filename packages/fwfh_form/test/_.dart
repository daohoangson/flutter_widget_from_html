import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_form/fwfh_form.dart';

import '../../core/test/_.dart' as helper;

String? formExplainer(helper.Explainer parent, Widget widget) {
  if (widget is Form) return '[Form]';
  if (widget is TextFormField) return '[TextFormField]';
  if (widget is ElevatedButton) return '[ElevatedButton]';
  return null;
}

Future<String> explain(WidgetTester tester, String html) => helper.explain(
      tester,
      null,
      explainer: formExplainer,
      hw: HtmlWidget(
        html,
        key: helper.hwKey,
        factoryBuilder: () => _WidgetFactory(),
      ),
    );

class _WidgetFactory extends WidgetFactory with FormFactory {}
