import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  const summaryDetails = 'Details';
  const summaryWithPlaceholder = '\u{fffc}Details';

  group('renders DETAILS tag', () {
    testWidgets('initial close', (WidgetTester tester) async {
      const html = '<details>Foo</details>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[HtmlDetails:open=false,child=[Column:children='
          '[HtmlSummary:child=[RichText:(:[HtmlDetailsMarker]@middle(:$summaryDetails))]],'
          '[HtmlDetailsContents:child=[RichText:(:Foo)]]'
          ']]',
        ),
      );
    });

    testWidgets('initial open', (WidgetTester tester) async {
      const html = '<details open>Foo</details>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[HtmlDetails:open=true,child=[Column:children='
          '[HtmlSummary:child=[RichText:(:[HtmlDetailsMarker]@middle(:$summaryDetails))]],'
          '[HtmlDetailsContents:child=[RichText:(:Foo)]]'
          ']]',
        ),
      );
    });

    testWidgets('open on tap', (WidgetTester tester) async {
      const html = '<details>Foo</details>';
      await explain(tester, html);

      final contentsFinder = findText('Foo');
      expect(contentsFinder, findsNothing);

      expect(await tapText(tester, summaryWithPlaceholder), equals(1));
      await tester.pumpAndSettle();

      expect(contentsFinder, findsOneWidget);
    });

    testWidgets('close on tap', (WidgetTester tester) async {
      const html = '<details open>Foo</details>';
      await explain(tester, html);

      final contentsFinder = findText('Foo');
      expect(contentsFinder, findsOneWidget);

      expect(await tapText(tester, summaryWithPlaceholder), equals(1));
      await tester.pumpAndSettle();

      expect(contentsFinder, findsNothing);
    });
  });

  group('renders SUMMARY tag', () {
    const summaryFoo = '\u{fffc}Foo';

    testWidgets('initial close', (WidgetTester tester) async {
      const html = '<details><summary>Foo</summary>Bar</details>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[HtmlDetails:open=false,child=[Column:children='
          '[HtmlSummary:child=[RichText:(:[HtmlDetailsMarker]@middle(:Foo))]],'
          '[HtmlDetailsContents:child=[RichText:(:Bar)]]'
          ']]',
        ),
      );
    });

    testWidgets('initial open', (WidgetTester tester) async {
      const html = '<details open><summary>Foo</summary>Bar</details>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[HtmlDetails:open=true,child=[Column:children='
          '[HtmlSummary:child=[RichText:(:[HtmlDetailsMarker]@middle(:Foo))]],'
          '[HtmlDetailsContents:child=[RichText:(:Bar)]]'
          ']]',
        ),
      );
    });

    testWidgets('open on tap', (WidgetTester tester) async {
      const html = '<details><summary>Foo</summary>Bar</details>';
      await explain(tester, html);

      final contentsFinder = findText('Bar');
      expect(contentsFinder, findsNothing);

      expect(await tapText(tester, summaryFoo), equals(1));
      await tester.pumpAndSettle();

      expect(contentsFinder, findsOneWidget);
    });

    testWidgets('close on tap', (WidgetTester tester) async {
      const html = '<details open><summary>Foo</summary>Bar</details>';
      await explain(tester, html);

      final contentsFinder = findText('Bar');
      expect(contentsFinder, findsOneWidget);

      expect(await tapText(tester, summaryFoo), equals(1));
      await tester.pumpAndSettle();

      expect(contentsFinder, findsNothing);
    });

    testWidgets('double DETAILS', (WidgetTester tester) async {
      const html = '<details open><summary>Foo1</summary>Foo2</details>'
          '<details open><summary>Bar1</summary>Bar2</details>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Column:children='
          '[HtmlDetails:open=true,child=[Column:children='
          '[HtmlSummary:child=[RichText:(:[HtmlDetailsMarker]@middle(:Foo1))]],'
          '[HtmlDetailsContents:child=[RichText:(:Foo2)]]'
          ']],'
          '[HtmlDetails:open=true,child=[Column:children='
          '[HtmlSummary:child=[RichText:(:[HtmlDetailsMarker]@middle(:Bar1))]],'
          '[HtmlDetailsContents:child=[RichText:(:Bar2)]]'
          ']]]',
        ),
      );
    });

    testWidgets('double SUMMARY', (WidgetTester tester) async {
      const html = '<details><summary>One</summary>'
          '<summary>Two</summary>Foo</details>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[HtmlDetails:open=false,child=[Column:children='
          '[HtmlSummary:child=[RichText:(:[HtmlDetailsMarker]@middle(:One))]],'
          '[HtmlDetailsContents:child=[Column:children='
          '[RichText:(:[HtmlDetailsMarker]@middle(:Two))],'
          '[RichText:(:Foo)]'
          ']]]]',
        ),
      );
    });
  });

  group('error handling', () {
    testWidgets('empty DETAILS tag', (WidgetTester tester) async {
      const html = '<details></details>';
      final explained = await explain(tester, html);
      expect(explained, equals('[widget0]'));
    });

    testWidgets('empty contents', (WidgetTester tester) async {
      const html = '<details><summary>Foo</summary></details>';
      final explained = await explain(tester, html);
      expect(explained, isNot(contains('[HtmlDetails:')));
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
