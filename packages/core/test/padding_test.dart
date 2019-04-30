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
    testWidgets('renders table padding', (WidgetTester tester) async {
      final html = 'x<table><tr><td>Foo</td></tr></table>x';
      final explained = await explain(tester, html, tablePadding: 10);
      expect(
          explained,
          equals('[Column:children=[RichText:(:x)],'
              '[Padding:(10,10,10,10),child=[Table:\n[RichText:(:Foo)]\n]]'
              ',[RichText:(:x)]]'));
    });

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

  group('text padding', () {
    final test = (WidgetTester t, String html) async {
      final explained = await explain(t, html, textHorizontalPadding: 10);
      expect(explained, startsWith('[Padding:(0,10,0,10),child='));
    };

    testWidgets("doesn't render text padding", (WidgetTester t) async {
      final html = 'Foo';
      final explained = await explain(t, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('renders text padding', (WidgetTester tester) async {
      final html = 'Foo';
      await test(tester, html);
    });

    testWidgets('renders with body padding', (WidgetTester tester) async {
      final html = 'Foo';
      final explained = await explain(
        tester,
        html,
        bodyVerticalPadding: 10,
        textHorizontalPadding: 10,
      );
      expect(
          explained, equals('[Padding:(10,10,10,10),child=[RichText:(:Foo)]]'));
    });

    testWidgets('renders A tag', (WidgetTester tester) async {
      final html = '<a href="href.html">Foo</a>';
      await test(tester, html);
    });

    testWidgets('renders DIV tag inside A tag', (WidgetTester t) async {
      final html = '<a href="href.html"><div>Foo</div></a>';
      await test(t, html);
    });

    testWidgets('renders background-color', (WidgetTester tester) async {
      final html = '<span style="background-color: #f00">Foo</a>';
      await test(tester, html);
    });

    testWidgets('renders DIV tag inside background-color', (t) async {
      final html = '<span style="background-color: #f00">Foo</a>';
      await test(t, html);
    });

    testWidgets('renders text-align', (WidgetTester tester) async {
      final html = '<span style="text-align: center">Foo</a>';
      await test(tester, html);
    });

    testWidgets('renders DIV tag inside text-align', (WidgetTester t) async {
      final html = '<span style="text-align: center"><div>Foo</div></a>';
      await test(t, html);
    });
  });
}
