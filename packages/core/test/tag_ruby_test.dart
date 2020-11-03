import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  group('basic usage', () {
    final html = '<ruby>明日 <rp>(</rp><rt>Ashita</rt><rp>)</rp></ruby>';

    testWidgets('renders', (WidgetTester tester) async {
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[HtmlRuby:children='
              '[RichText:(:明日)],'
              '[RichText:(@5.0:Ashita)]'
              ']'));
    });

    testWidgets('useExplainer=false', (WidgetTester tester) async {
      final explained = await explain(tester, html, useExplainer: false);
      expect(
          explained,
          equals('TshWidget\n'
              '└WidgetPlaceholder<BuildTree>(BuildTree#0 tsb#1:\n'
              ' │  BuildTree#2 tsb#3(parent=#1):\n'
              ' │    WidgetBit.inline#4 WidgetPlaceholder([BuildTree#5 tsb#6(parent=#3):\n'
              ' │      "明日"\n'
              ' │      Whitespace#7, BuildTree#8 tsb#9(parent=#3):\n'
              ' │      "Ashita"])\n'
              ' │    BuildTree#10 tsb#11(parent=#3):\n'
              ' │    BuildTree#12 tsb#9(parent=#3):\n'
              ' │    BuildTree#13 tsb#14(parent=#3):\n'
              ' │)\n'
              ' └WidgetPlaceholder<List<BuildTree>>([BuildTree#5 tsb#6(parent=#3):\n'
              '  │  "明日"\n'
              '  │  Whitespace#7, BuildTree#8 tsb#9(parent=#3):\n'
              '  │  "Ashita"]\n'
              '  │)\n'
              '  └HtmlRuby()\n'
              '   ├WidgetPlaceholder<BuildTree>(BuildTree#5 tsb#6(parent=#3):\n'
              '   ││  "明日"\n'
              '   ││  Whitespace#7\n'
              '   ││)\n'
              '   │└RichText(text: "明日")\n'
              '   └WidgetPlaceholder<BuildTree>(BuildTree#8 tsb#9(parent=#3):\n'
              '    │  "Ashita"\n'
              '    │)\n'
              '    └RichText(text: "Ashita")\n\n'));
    });
  });

  testWidgets('renders text after RT', (WidgetTester tester) async {
    final html = '<ruby>ruby <rt>rt</rt> foo</ruby>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[RichText:(:'
            '[HtmlRuby:children=[RichText:(:ruby)],[RichText:(@5.0:rt)]]'
            '(: foo)'
            ')]'));
  });

  testWidgets('renders with multiple RTs', (WidgetTester tester) async {
    final html = '<ruby>漢<rt>かん</rt>字<rt>じ</rt></ruby>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[RichText:(:'
            '[HtmlRuby:children=[RichText:(:漢)],[RichText:(@5.0:かん)]]'
            '[HtmlRuby:children=[RichText:(:字)],[RichText:(@5.0:じ)]]'
            ')]'));
  });

  testWidgets('renders without erroneous white spaces', (tester) async {
    final html = '<ruby>\n漢\n<rt>かん</rt>\n\n字\n<rt>じ</rt></ruby>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[RichText:(:'
            '[HtmlRuby:children=[RichText:(:漢)],[RichText:(@5.0:かん)]]'
            '(: )'
            '[HtmlRuby:children=[RichText:(:字)],[RichText:(@5.0:じ)]]'
            ')]'));
  });

  group('possible conflict', () {
    testWidgets('triple renders', (WidgetTester tester) async {
      final html = '<ruby><ruby>ruby1 <rt>ruby2</rt></ruby> '
          '<rt><ruby>rt1 <rt>rt2</rt></ruby></rt></ruby>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[HtmlRuby:children='
              '[HtmlRuby:children=[RichText:(:ruby1)],[RichText:(@5.0:ruby2)]],'
              '[HtmlRuby:children=[RichText:(@5.0:rt1)],[RichText:(@2.5:rt2)]]'
              ']'));
    });

    testWidgets('renders with A tag', (WidgetTester tester) async {
      final html = '<ruby><a href="http://domain.com/foo">foo</a> '
          '<rt><a href="http://domain.com/bar">bar</a></rt></ruby>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[HtmlRuby:children='
              '[RichText:(#FF0000FF+u+onTap:foo)],'
              '[RichText:(#FF0000FF+u@5.0+onTap:bar)]'
              ']'));
    });

    testWidgets('renders with Q tag', (WidgetTester tester) async {
      final html = '<ruby><q>foo</q> <rt><q>bar</q></rt></ruby>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[HtmlRuby:children='
              '[RichText:(:“foo”)],'
              '[RichText:(@5.0:“bar”)]'
              ']'));
    });
  });

  group('error handling', () {
    testWidgets('renders without RT', (WidgetTester tester) async {
      final html = '<ruby>明日</ruby>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:明日)]'));
    });

    testWidgets('renders with empty RT', (WidgetTester tester) async {
      final html = '<ruby>明日 <rt></rt></ruby>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:明日)]'));
    });

    testWidgets('renders without contents', (WidgetTester tester) async {
      final html = 'Foo <ruby></ruby>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('renders with only RT', (WidgetTester tester) async {
      final html = 'Foo <ruby><rt>Ashita</rt></ruby>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo (@5.0:Ashita))]'));
    });

    testWidgets('renders with only empty RT', (WidgetTester tester) async {
      final html = 'Foo <ruby><rt></rt></ruby>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });
  });
}
