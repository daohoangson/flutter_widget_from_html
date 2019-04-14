import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '_.dart';

void main() {
  testWidgets('applies non-null style', (WidgetTester tester) async {
    final style = TextStyle(fontSize: 25);
    final html = '';
    final explained = await explain(
      tester,
      html,
      hw: HtmlWidget(
        html,
        style: style,
      ),
    );
    expect(
        explained,
        equals('[DefaultTextStyle:style=TextStyle(inherit: true, size: 25.0),'
            'child=[Text:]]'));
  });

  testWidgets('ignores null style', (WidgetTester tester) async {
    final html = '';
    final explained = await explain(
      tester,
      html,
      hw: HtmlWidget(
        html,
        style: null,
      ),
    );
    expect(explained, equals('[Text:]'));
  });
}
