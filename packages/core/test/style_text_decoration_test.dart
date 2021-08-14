import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  group('ABBR tag', () {
    testWidgets('renders ABBR', (WidgetTester tester) async {
      const html = '<abbr>ABBR</abbr>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+u/dotted:ABBR)]'));
    });

    testWidgets('renders ACRONYM', (WidgetTester tester) async {
      const html = '<acronym>ACRONYM</acronym>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+u/dotted:ACRONYM)]'));
    });
  });

  group('DEL tag', () {
    testWidgets('renders DEL tag', (WidgetTester tester) async {
      const html = 'This is some <del>deleted</del> text.';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:This is some (+l:deleted)(: text.))]'));
    });

    testWidgets('renders S tag', (WidgetTester tester) async {
      const html = 'This is some <s>striked</s> text.';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:This is some (+l:striked)(: text.))]'));
    });

    testWidgets('renders STRIKE tag', (WidgetTester tester) async {
      const html = 'This is some <strike>striked</strike> text.';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:This is some (+l:striked)(: text.))]'));
    });
  });

  group('INS tag', () {
    testWidgets('renders INS tag', (WidgetTester tester) async {
      const html = 'This is some <ins>inserted</ins> text.';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:This is some (+u:inserted)(: text.))]'));
    });

    testWidgets('renders U tag', (WidgetTester tester) async {
      const html = 'This is an <u>underline</u> text.';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[RichText:(:This is an (+u:underline)(: text.))]'),
      );
    });
  });

  group('text-decoration', () {
    testWidgets('renders line', (WidgetTester tester) async {
      const html = '<span style="text-decoration: underline">under</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+u:under)]'));
    });

    testWidgets('renders line & style', (WidgetTester tester) async {
      const html = '<span style="text-decoration: underline dotted">foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+u/dotted:foo)]'));
    });
  });

  group('text-decoration-line', () {
    testWidgets('renders line-through', (WidgetTester tester) async {
      const html =
          '<span style="text-decoration-line: line-through">line</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+l:line)]'));
    });

    testWidgets('renders overline', (WidgetTester tester) async {
      const html = '<span style="text-decoration-line: overline">over</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+o:over)]'));
    });

    testWidgets('renders underline', (WidgetTester tester) async {
      const html = '<span style="text-decoration-line: underline">under</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+u:under)]'));
    });

    testWidgets('renders all (inherited)', (WidgetTester tester) async {
      const html = '''
<span style="text-decoration-line: line-through">
<span style="text-decoration-line: overline">
<span style="text-decoration-line: underline">
foo</span></span></span>
''';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+l+o+u:foo)]'));
    });

    testWidgets('renders all (multiple)', (WidgetTester tester) async {
      const html =
          '<span style="text-decoration-line: line-through overline underline">foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+l+o+u:foo)]'));
    });

    testWidgets('skips rendering', (WidgetTester tester) async {
      const html = '''
<span style="text-decoration-line: line-through">
<span style="text-decoration-line: overline">
<span style="text-decoration-line: underline">
foo <span style="text-decoration-line: none">bar</span></span></span></span>
''';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:(+l+o+u:foo )(:bar))]'));
    });
  });

  group('text-decoration-style', () {
    testWidgets('renders dotted', (WidgetTester tester) async {
      const html = '<span style="text-decoration-line: line-through; '
          'text-decoration-style: dotted">foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+l/dotted:foo)]'));
    });

    testWidgets('renders dashed', (WidgetTester tester) async {
      const html = '<span style="text-decoration-line: line-through; '
          'text-decoration-style: dashed">foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+l/dashed:foo)]'));
    });

    testWidgets('renders double', (WidgetTester tester) async {
      const html = '<span style="text-decoration-line: line-through; '
          'text-decoration-style: double">foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+l/double:foo)]'));
    });

    testWidgets('renders solid', (WidgetTester tester) async {
      const html = '<span style="text-decoration-line: line-through; '
          'text-decoration-style: dotted">foo '
          '<span style="text-decoration-style: solid">bar</span></span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:(+l/dotted:foo )(+l:bar))]'));
    });
  });
}
