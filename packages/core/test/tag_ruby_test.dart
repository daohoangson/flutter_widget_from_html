import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  testWidgets('renders with RT', (WidgetTester tester) async {
    final html = '<ruby>明日 <rp>(</rp><rt>Ashita</rt><rp>)</rp></ruby>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[RichText:[_RubyWidget:children='
            '[RichText:(:明日)],'
            '[RichText:(@5.0:Ashita)]'
            ']@middle]'));
  });

  testWidgets('renders with multiple RTs', (WidgetTester tester) async {
    final html = '<ruby>漢<rt>かん</rt>字<rt>じ</rt></ruby>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[RichText:(:'
            '[_RubyWidget:children=[RichText:(:漢)],[RichText:(@5.0:かん)]]@middle'
            '[_RubyWidget:children=[RichText:(:字)],[RichText:(@5.0:じ)]]@middle'
            ')]'));
  });

  testWidgets('renders without erroneous white spaces', (tester) async {
    final html = '<ruby>\n漢\n<rt>かん</rt>\n\n字\n<rt>じ</rt></ruby>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[RichText:(:'
            '[_RubyWidget:children=[RichText:(:漢)],[RichText:(@5.0:かん)]]@middle'
            '(: )'
            '[_RubyWidget:children=[RichText:(:字)],[RichText:(@5.0:じ)]]@middle'
            ')]'));
  });

  group('possible conflict', () {
    testWidgets('triple renders', (WidgetTester tester) async {
      final html = '<ruby><ruby>ruby1 <rt>ruby2</rt></ruby> '
          '<rt><ruby>rt1 <rt>rt2</rt></ruby></rt></ruby>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[RichText:'
              '[_RubyWidget:children='
              '[RichText:[_RubyWidget:children=[RichText:(:ruby1)],[RichText:(@5.0:ruby2)]]@middle],'
              '[RichText:[_RubyWidget:children=[RichText:(@5.0:rt1)],[RichText:(@2.5:rt2)]]@middle]'
              ']@middle'
              ']'));
    });

    testWidgets('renders with A tag', (WidgetTester tester) async {
      final html = '<ruby><a href="http://domain.com/foo">foo</a> '
          '<rt><a href="http://domain.com/bar">bar</a></rt></ruby>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[RichText:[_RubyWidget:children='
              '[RichText:(#FF0000FF+u+onTap:foo)],'
              '[RichText:(#FF0000FF+u@5.0+onTap:bar)]'
              ']@middle]'));
    });

    testWidgets('renders with Q tag', (WidgetTester tester) async {
      final html = '<ruby><q>foo</q> <rt><q>bar</q></rt></ruby>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[RichText:[_RubyWidget:children='
              '[RichText:(:“foo”)],'
              '[RichText:(@5.0:“bar”)]'
              ']@middle]'));
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

    testWidgets('renders with only empty RT', (WidgetTester tester) async {
      final html = 'Foo <ruby><rt></rt></ruby>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });
  });
}
