import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  testWidgets('renders body padding', (WidgetTester tester) async {
    final html = 'Foo';
    final explained = await explain(tester, html, bodyVerticalPadding: 10);
    expect(explained, equals('[Padding:(10,0,10,0),child=[RichText:(:Foo)]]'));
  });

  testWidgets("doesn't render body padding", (tester) async {
    final html = 'Foo';
    final explained = await explain(tester, html);
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

  group('table paddings', () {
    testWidgets('renders table cell padding', (WidgetTester tester) async {
      final html = '<table><tr><td>Foo</td></tr></table>';
      final explained = await explain(tester, html, tableCellPadding: 5);
      expect(
        explained,
        equals('[Table:\n[Padding:(5,5,5,5),child=[RichText:(:Foo)]]\n]'),
      );
    });

    testWidgets("doesn't render table paddings", (WidgetTester tester) async {
      final html = '<table><tr><td>Foo</td></tr></table>';
      final explained = await explain(tester, html);
      expect(explained, equals('[Table:\n[RichText:(:Foo)]\n]'));
    });
  });
}
