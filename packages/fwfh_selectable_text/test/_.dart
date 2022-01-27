import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../core/test/_.dart' as helper;

Future<String> explain(
  WidgetTester tester,
  String html,
  WidgetFactory wf,
) async =>
    helper.explain(
      tester,
      null,
      hw: HtmlWidget(
        html,
        key: helper.hwKey,
        factoryBuilder: () => wf,
      ),
    );
