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
