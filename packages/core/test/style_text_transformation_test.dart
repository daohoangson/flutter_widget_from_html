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
}
