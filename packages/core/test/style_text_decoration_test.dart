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

    testWidgets('renders line & color', (WidgetTester tester) async {
      const html = '<span style="text-decoration: red underline">foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+u/#FFFF0000:foo)]'));
    });

    testWidgets('renders line & style', (WidgetTester tester) async {
      const html = '<span style="text-decoration: underline dotted">foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+u/dotted:foo)]'));
    });

    testWidgets('renders line & thickness', (WidgetTester tester) async {
      const html = '<span style="text-decoration: underline 50%">foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+u/0.5:foo)]'));
    });

    testWidgets('renders everything', (WidgetTester tester) async {
      const html =
          '<span style="text-decoration: red underline dotted 50%">foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+u/#FFFF0000/dotted/0.5:foo)]'));
    });
  });

  group('text-decoration-color', () {
    testWidgets('renders color', (WidgetTester tester) async {
      const html = '<span style="text-decoration-line: line-through; '
          'text-decoration-color: red">foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+l/#FFFF0000:foo)]'));
    });

    testWidgets('changes inherited color', (WidgetTester tester) async {
      const html = '<span style="text-decoration: red line-through">foo '
          '<span style="text-decoration-color: #0f0">bar</span></span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:(+l/#FFFF0000:foo )(+l/#FF00FF00:bar))]'));
    });

    testWidgets('renders currentcolor', (WidgetTester tester) async {
      const html = '<span style="text-decoration: red line-through">foo '
          '<span style="text-decoration-color: currentcolor">bar</span></span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:(+l/#FFFF0000:foo )(+l:bar))]'));
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

    testWidgets('renders all (child with none)', (WidgetTester tester) async {
      const html =
          '<span style="text-decoration: line-through overline underline">foo '
          '<span style="text-decoration-line: none">bar</span></span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:(+l+o+u:foo )(+l+o+u:bar))]'));
    });

    testWidgets('renders none after line-through', (WidgetTester tester) async {
      const html = '<span style="text-decoration-line: line-through; '
          'text-decoration-line: none">foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:foo)]'));
    });

    testWidgets('renders none after overline', (WidgetTester tester) async {
      const html = '<span style="text-decoration-line: overline; '
          'text-decoration-line: none">foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:foo)]'));
    });

    testWidgets('renders none after underline', (WidgetTester tester) async {
      const html = '<span style="text-decoration-line: underline; '
          'text-decoration-line: none">foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:foo)]'));
    });

    testWidgets('renders none after all', (WidgetTester tester) async {
      const html =
          '<span style="text-decoration-line: line-through overline underline; '
          'text-decoration-line: none">foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:foo)]'));
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
      const html = '<span style="text-decoration: line-through dotted">foo '
          '<span style="text-decoration-style: solid">bar</span></span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:(+l/dotted:foo )(+l:bar))]'));
    });
  });

  group('text-decoration-thickness', () {
    testWidgets('renders percentage', (WidgetTester tester) async {
      const html = '<span style="text-decoration-line: line-through; '
          'text-decoration-thickness: 50%">foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+l/0.5:foo)]'));
    });

    testWidgets('changes inherited thickness', (WidgetTester tester) async {
      const html = '<span style="text-decoration: line-through 50%">foo '
          '<span style="text-decoration-thickness: 75%">bar</span></span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:(+l/0.5:foo )(+l/0.75:bar))]'));
    });

    testWidgets('skips px', (WidgetTester tester) async {
      const html = '<span style="text-decoration-line: line-through; '
          'text-decoration-thickness: 5px">foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+l:foo)]'));
    });
  });

  group('text-decoration-width', () {
    testWidgets('renders percentage', (WidgetTester tester) async {
      const html = '<span style="text-decoration-line: line-through; '
          'text-decoration-width: 50%">foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+l/0.5:foo)]'));
    });

    testWidgets('changes inherited width', (WidgetTester tester) async {
      const html = '<span style="text-decoration: line-through 50%">foo '
          '<span style="text-decoration-width: 75%">bar</span></span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:(+l/0.5:foo )(+l/0.75:bar))]'));
    });

    testWidgets('skips px', (WidgetTester tester) async {
      const html = '<span style="text-decoration-line: line-through; '
          'text-decoration-width: 5px">foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+l:foo)]'));
    });
  });
}
