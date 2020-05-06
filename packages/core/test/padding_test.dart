import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '_.dart';

void main() {
  testWidgets('renders body padding', (WidgetTester tester) async {
    final html = 'Foo';
    final e = await explain(tester, null,
        hw: HtmlWidget(
          html,
          bodyPadding: const EdgeInsets.all(10),
          key: hwKey,
        ));
    expect(e, equals('[Padding:(10,10,10,10),child=[RichText:(:Foo)]]'));
  });

  testWidgets("doesn't render body padding", (tester) async {
    final html = 'Foo';
    final explained = await explain(tester, null,
        hw: HtmlWidget(
          html,
          bodyPadding: const EdgeInsets.all(0),
          key: hwKey,
        ));
    expect(explained, equals('[RichText:(:Foo)]'));
  });

  group('trimming', () {
    testWidgets('trims top intances', (WidgetTester tester) async {
      final html = '<div style="margin-top: 1em">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('trims bottom instances', (WidgetTester tester) async {
      final html = '<div style="margin-bottom: 1em">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('trims both ways', (WidgetTester tester) async {
      final html = '<div style="margin: 1em 0">Foo</div>'
          '<div style="margin: 1em 0">Bar</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Column:children=[RichText:(:Foo)],'
              '[SizedBox:0.0x10.0],'
              '[RichText:(:Bar)]]'));
    });
  });
}
