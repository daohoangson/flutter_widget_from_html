import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  testWidgets('renders body padding', (WidgetTester tester) async {
    final html = 'Foo';
    final explained = await explain(tester, html, bodyVerticalPadding: 10);
    expect(explained, equals('[Padding:(10,0,10,0),child=[RichText:(:Foo)]]'));
  });

  testWidgets("doesn't render body padding", (WidgetTester t) async {
    final html = 'Foo';
    final explained = await explain(t, html);
    expect(explained, equals('[RichText:(:Foo)]'));
  });

  group('BR tag', () {
    testWidgets('trims top intances', (WidgetTester tester) async {
      final html = '<br/><br/>Foo';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('trims bottom instances', (WidgetTester tester) async {
      final html = 'Foo<br/><br/>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('skip others', (WidgetTester tester) async {
      final html = '<br/>Foo<br/>Bar<br/>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Column:children=[RichText:(:Foo)],'
              '[Padding:(5,0,5,0),child=[widget0]],'
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
