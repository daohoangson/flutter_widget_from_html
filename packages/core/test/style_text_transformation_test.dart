import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  group('text-transform p tag', () {
    testWidgets('text-transform: capitalize', (WidgetTester tester) async {
      const html = '<p style="text-transform: capitalize;">rain man</p>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Rain Man)]]'));
    });

    testWidgets('text-transform: uppercase', (WidgetTester tester) async {
      const html = '<p style="text-transform: uppercase;">oppEnheimer</p>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:OPPENHEIMER)]]'));
    });

    testWidgets('text-transform: lowercase', (WidgetTester tester) async {
      const html =
          '<p style="text-transform: lowercase;">ThE Boy AnD THE heron</p>';
      final explained = await explain(tester, html);
      expect(explained,
          equals('[CssBlock:child=[RichText:(:the boy and the heron)]]'));
    });

    testWidgets('text-transform: none', (WidgetTester tester) async {
      const html = '<p style="text-transform: none;">The BeAr</p>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:The BeAr)]]'));
    });

    testWidgets('text-transform: invalid syntax', (WidgetTester tester) async {
      const html = '<p style="text-transform: nonex;">AlicE In wonDERLA nd</p>';
      final explained = await explain(tester, html);
      expect(explained,
          equals('[CssBlock:child=[RichText:(:AlicE In wonDERLA nd)]]'));
    });
  });

  group('text-transform other tags', () {
    testWidgets('text-transform: uppercase, <a> tag',
        (WidgetTester tester) async {
      const html =
          '<a href="https://www.google.com" style="text-transform: uppercase;">raIn MAn</a>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(#FF123456+u+onTap:RAIN MAN)]'));
    });

    testWidgets('text-transform: uppercase, <b> tag',
        (WidgetTester tester) async {
      const html = '<b style="text-transform: uppercase;">raIn MAn</b>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+b:RAIN MAN)]'));
    });

    testWidgets('text-transform: uppercase, <abbr> tag',
        (WidgetTester tester) async {
      const html = '<abbr style="text-transform: uppercase;">raIn MAn</abbr>';
      final explained = await explain(tester, html);
      print(explained);
      expect(explained, equals('[RichText:(+b:RAIN MAN)]'));
    });

    testWidgets('text-transform: uppercase, <h1> tag',
        (WidgetTester tester) async {
      const html = '<h1 style="text-transform: uppercase;">raIn MAn</h1>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[CssBlock:child=[RichText:(@20.0+b:RAIN MAN)]]'),
      );
    });

    testWidgets('text-transform: uppercase, <blockquote> tag',
        (WidgetTester tester) async {
      const html =
          '<blockquote style="text-transform: uppercase;">raIn MAn</blockquote>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals(
            '[HorizontalMargin:left=40,right=40,child=[CssBlock:child=[RichText:(:RAIN MAN)]]]',
          ));
    });
  });
}
