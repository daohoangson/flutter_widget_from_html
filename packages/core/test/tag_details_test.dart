import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  const defaultSummaryText = '\u{fffc}Details';

  group('renders DETAILS tag', () {
    const expected = [
      'HtmlDetails(state: _HtmlDetailsState)',
      '├HtmlSummary',
      '└HtmlDetailsMarker()',
      '└HtmlDetailsContents()',
      '└RichText(text: "Foo")'
    ];

    testWidgets('initial close', (WidgetTester tester) async {
      const html = '<details>Foo</details>';
      final explained = await explain(tester, html, useExplainer: false);
      expect(explained, contains(expected[0]));
      expect(explained, contains(expected[1]));
      expect(explained, contains(expected[2]));
      expect(explained, contains(expected[3]));
      expect(explained, isNot(contains(expected[4])));
    });

    testWidgets('initial open', (WidgetTester tester) async {
      const html = '<details open>Foo</details>';
      final explained = await explain(tester, html, useExplainer: false);
      expect(explained, contains(expected[0]));
      expect(explained, contains(expected[1]));
      expect(explained, contains(expected[2]));
      expect(explained, contains(expected[3]));
      expect(explained, contains(expected[4]));
    });

    testWidgets('open on tap', (WidgetTester tester) async {
      const html = '<details>Foo</details>';
      await explain(tester, html);

      final contentsFinder = findText('Foo');
      expect(contentsFinder, findsNothing);

      expect(await tapText(tester, defaultSummaryText), equals(1));
      await tester.pumpAndSettle();

      expect(contentsFinder, findsOneWidget);
    });

    testWidgets('close on tap', (WidgetTester tester) async {
      const html = '<details open>Foo</details>';
      await explain(tester, html);

      final contentsFinder = findText('Foo');
      expect(contentsFinder, findsOneWidget);

      expect(await tapText(tester, defaultSummaryText), equals(1));
      await tester.pumpAndSettle();

      expect(contentsFinder, findsNothing);
    });
  });

  group('renders SUMMARY tag', () {
    const summaryText = '\u{fffc}Foo';
    const expected = [
      '└HtmlDetails(state: _HtmlDetailsState)',
      '├HtmlSummary',
      '└RichText(text: "$summaryText")',
      '└HtmlDetailsMarker()',
      '└HtmlDetailsContents()',
      '└RichText(text: "Bar")'
    ];

    testWidgets('initial close', (WidgetTester tester) async {
      const html = '<details><summary>Foo</summary>Bar</details>';
      final explained = await explain(tester, html, useExplainer: false);
      expect(explained, contains(expected[0]));
      expect(explained, contains(expected[1]));
      expect(explained, contains(expected[2]));
      expect(explained, contains(expected[3]));
      expect(explained, contains(expected[4]));
      expect(explained, isNot(contains(expected[5])));
    });

    testWidgets('initial open', (WidgetTester tester) async {
      const html = '<details open><summary>Foo</summary>Bar</details>';
      final explained = await explain(tester, html, useExplainer: false);
      expect(explained, contains(expected[0]));
      expect(explained, contains(expected[1]));
      expect(explained, contains(expected[2]));
      expect(explained, contains(expected[3]));
      expect(explained, contains(expected[4]));
      expect(explained, contains(expected[5]));
    });

    testWidgets('open on tap', (WidgetTester tester) async {
      const html = '<details><summary>Foo</summary>Bar</details>';
      await explain(tester, html);

      final contentsFinder = findText('Bar');
      expect(contentsFinder, findsNothing);

      expect(await tapText(tester, summaryText), equals(1));
      await tester.pumpAndSettle();

      expect(contentsFinder, findsOneWidget);
    });

    testWidgets('close on tap', (WidgetTester tester) async {
      const html = '<details open><summary>Foo</summary>Bar</details>';
      await explain(tester, html);

      final contentsFinder = findText('Bar');
      expect(contentsFinder, findsOneWidget);

      expect(await tapText(tester, summaryText), equals(1));
      await tester.pumpAndSettle();

      expect(contentsFinder, findsNothing);
    });

    testWidgets('twice', (WidgetTester tester) async {
      const html = '<details open><summary>One</summary>'
          '<summary>Two</summary>Foo</details>';
      final explained = await explain(tester, html, useExplainer: false);
      expect(explained, contains('RichText(text: "\u{fffc}One")'));
      expect(explained, contains('RichText(text: "\u{fffc}Two")'));
      expect(explained, contains('RichText(text: "Foo")'));
    });
  });

  group('HtmlDetails', () {
    testWidgets('verifies updateShouldNotify', (WidgetTester tester) async {
      final contentsFinder = findText('Foo');

      await explain(tester, '<details>Foo</details>');
      expect(contentsFinder, findsNothing);

      await explain(tester, '<details open>Foo</details>');
      expect(contentsFinder, findsOneWidget);
    });
  });
}
