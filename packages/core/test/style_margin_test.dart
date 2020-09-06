import 'package:flutter_test/flutter_test.dart';

import '_.dart' as helper;

void main() {
  final explain = helper.explainMargin;

  testWidgets('renders text without margin', (WidgetTester tester) async {
    final html = '<div>Foo</div>';
    final explained = await explain(tester, html);
    expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
  });

  group('4 values', () {
    testWidgets('parses all', (WidgetTester tester) async {
      final html = '<div style="margin: 1px 2px 3px 4px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[SizedBox:0.0x1.0],'
              '[Padding:(0,2,0,4),child=[CssBlock:child=[RichText:(:Foo)]]],'
              '[SizedBox:0.0x3.0]'));
    });

    testWidgets('parses all (rtl)', (WidgetTester tester) async {
      final html = '<div style="margin: 1px 2px 3px 4px">Foo</div>';
      final explained = await explain(tester, html, rtl: true);
      expect(
          explained,
          equals('[SizedBox:0.0x1.0],'
              '[Padding:(0,4,0,2),child=[CssBlock:child=[RichText:dir=rtl,(:Foo)]]],'
              '[SizedBox:0.0x3.0]'));
    });

    testWidgets('parses top only', (WidgetTester tester) async {
      final html = '<div style="margin: 1px 0 0 0">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained,
          equals('[SizedBox:0.0x1.0],[CssBlock:child=[RichText:(:Foo)]]'));
    });

    group('parses end only', () {
      final html = '<div style="margin: 0 2px 0 0">Foo</div>';

      testWidgets('ltr', (WidgetTester tester) async {
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[Padding:(0,2,0,0),child=[CssBlock:child='
                '[RichText:(:Foo)]]]'));
      });

      testWidgets('rtl', (WidgetTester tester) async {
        final explained = await explain(tester, html, rtl: true);
        expect(
            explained,
            equals('[Padding:(0,0,0,2),child=[CssBlock:child='
                '[RichText:dir=rtl,(:Foo)]]]'));
      });
    });

    testWidgets('parses bottom only', (WidgetTester tester) async {
      final html = '<div style="margin: 0 0 3px 0">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained,
          equals('[CssBlock:child=[RichText:(:Foo)]],[SizedBox:0.0x3.0]'));
    });

    group('parses start only', () {
      final html = '<div style="margin: 0 0 0 4px">Foo</div>';

      testWidgets('ltr', (WidgetTester tester) async {
        final e = await explain(tester, html);
        expect(
            e,
            equals('[Padding:(0,0,0,4),child=[CssBlock:child='
                '[RichText:(:Foo)]]]'));
      });

      testWidgets('rtl', (WidgetTester tester) async {
        final e = await explain(tester, html, rtl: true);
        expect(
            e,
            equals('[Padding:(0,4,0,0),child=[CssBlock:child='
                '[RichText:dir=rtl,(:Foo)]]]'));
      });
    });
  });

  group('2 values', () {
    testWidgets('parses both', (WidgetTester tester) async {
      final html = '<div style="margin: 5px 10px">Foo</div>';
      final e = await explain(tester, html);
      expect(
          e,
          equals('[SizedBox:0.0x5.0],'
              '[Padding:(0,10,0,10),child=[CssBlock:child=[RichText:(:Foo)]]],'
              '[SizedBox:0.0x5.0]'));
    });

    testWidgets('parses vertical only', (WidgetTester tester) async {
      final html = '<div style="margin: 5px 0">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[SizedBox:0.0x5.0],'
              '[CssBlock:child=[RichText:(:Foo)]],'
              '[SizedBox:0.0x5.0]'));
    });

    testWidgets('parses horizontal only', (WidgetTester tester) async {
      final html = '<div style="margin: 0 10px">Foo</div>';
      final e = await explain(tester, html);
      expect(
          e,
          equals('[Padding:(0,10,0,10),child=[CssBlock:child='
              '[RichText:(:Foo)]]]'));
    });
  });

  group('1 value', () {
    testWidgets('renders em', (WidgetTester tester) async {
      final html = '<div style="margin: 2em">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[SizedBox:0.0x20.0],'
              '[Padding:(0,20,0,20),child=[CssBlock:child=[RichText:(:Foo)]]],'
              '[SizedBox:0.0x20.0]'));
    });

    testWidgets('renders pt', (WidgetTester tester) async {
      final html = '<div style="margin: 10pt">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[SizedBox:0.0x13.3],'
              '[Padding:(0,13,0,13),child=[CssBlock:child=[RichText:(:Foo)]]],'
              '[SizedBox:0.0x13.3]'));
    });

    testWidgets('renders px', (WidgetTester tester) async {
      final html = '<div style="margin: 10px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[SizedBox:0.0x10.0],'
              '[Padding:(0,10,0,10),child=[CssBlock:child=[RichText:(:Foo)]]],'
              '[SizedBox:0.0x10.0]'));
    });
  });

  testWidgets('renders margin within another', (WidgetTester tester) async {
    final html = '<div style="margin: 1px">'
        '<div style="margin: 2px">Foo</div></div>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[SizedBox:0.0x2.0],'
            '[Padding:(0,1,0,1),child=[CssBlock:child=[Padding:(0,2,0,2),child=[CssBlock:child=[RichText:(:Foo)]]]]],'
            '[SizedBox:0.0x2.0]'));
  });

  testWidgets('renders margins back to back', (WidgetTester tester) async {
    final html = '<div style="margin: 3px">1</div>'
        '<div style="margin: 3px">2</div>'
        '<div style="margin: 3px">3</div>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[SizedBox:0.0x3.0],'
            '[Padding:(0,3,0,3),child=[CssBlock:child=[RichText:(:1)]]],'
            '[SizedBox:0.0x3.0],'
            '[Padding:(0,3,0,3),child=[CssBlock:child=[RichText:(:2)]]],'
            '[SizedBox:0.0x3.0],'
            '[Padding:(0,3,0,3),child=[CssBlock:child=[RichText:(:3)]]],'
            '[SizedBox:0.0x3.0]'));
  });

  testWidgets('renders block margins back to back', (tester) async {
    final html = '<div style="margin: 3px"><div>1a</div><div>1b</div></div>'
        '<div style="margin: 3px"><div>2a</div><div>2b</div></div>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[SizedBox:0.0x3.0],'
            '[Padding:(0,3,0,3),child=[CssBlock:child=[Column:children='
            '[CssBlock:child=[RichText:(:1a)]],'
            '[CssBlock:child=[RichText:(:1b)]]'
            ']]],'
            '[SizedBox:0.0x3.0],'
            '[Padding:(0,3,0,3),child=[CssBlock:child=[Column:children='
            '[CssBlock:child=[RichText:(:2a)]],'
            '[CssBlock:child=[RichText:(:2b)]]'
            ']]],'
            '[SizedBox:0.0x3.0]'));
  });

  group('margin-xxx', () {
    testWidgets('parses margin-top', (WidgetTester tester) async {
      final html = '<div style="margin-top: 3px">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained,
          equals('[SizedBox:0.0x3.0],[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('parses margin-block-start', (WidgetTester tester) async {
      final html = '<div style="margin-block-start: 3px">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained,
          equals('[SizedBox:0.0x3.0],[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('parses margin-right', (WidgetTester tester) async {
      final html = '<div style="margin-right: 3px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Padding:(0,3,0,0),child=[CssBlock:child='
              '[RichText:(:Foo)]]]'));
    });

    group('parses margin-inline-end', () {
      final html = '<div style="margin-inline-end: 3px">Foo</div>';

      testWidgets('ltr', (WidgetTester tester) async {
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[Padding:(0,3,0,0),child=[CssBlock:child='
                '[RichText:(:Foo)]]]'));
      });

      testWidgets('rtl', (WidgetTester tester) async {
        final e = await explain(tester, html, rtl: true);
        expect(
            e,
            equals('[Padding:(0,0,0,3),child=[CssBlock:child='
                '[RichText:dir=rtl,(:Foo)]]]'));
      });
    });

    testWidgets('parses margin-bottom', (WidgetTester tester) async {
      final html = '<div style="margin-bottom: 3px">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained,
          equals('[CssBlock:child=[RichText:(:Foo)]],[SizedBox:0.0x3.0]'));
    });

    testWidgets('parses margin-block-end', (WidgetTester tester) async {
      final html = '<div style="margin-block-end: 3px">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained,
          equals('[CssBlock:child=[RichText:(:Foo)]],[SizedBox:0.0x3.0]'));
    });

    testWidgets('parses margin-left', (WidgetTester tester) async {
      final html = '<div style="margin-left: 3px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Padding:(0,0,0,3),child=[CssBlock:child='
              '[RichText:(:Foo)]]]'));
    });

    group('parses margin-inline-start', () {
      final html = '<div style="margin-inline-start: 3px">Foo</div>';

      testWidgets('ltr', (WidgetTester tester) async {
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[Padding:(0,0,0,3),child=[CssBlock:child='
                '[RichText:(:Foo)]]]'));
      });

      testWidgets('rtl', (WidgetTester tester) async {
        final explained = await explain(tester, html, rtl: true);
        expect(
            explained,
            equals('[Padding:(0,3,0,0),child=[CssBlock:child='
                '[RichText:dir=rtl,(:Foo)]]]'));
      });
    });

    testWidgets('overwrites margin with margin-top', (tester) async {
      final html = '<div style="margin: 3px; margin-top: 5px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[SizedBox:0.0x5.0],'
              '[Padding:(0,3,0,3),child=[CssBlock:child=[RichText:(:Foo)]]],'
              '[SizedBox:0.0x3.0]'));
    });

    testWidgets('reset margin with margin-bottom', (tester) async {
      final html = '<div style="margin: 3px; margin-bottom: 0">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[SizedBox:0.0x3.0],'
              '[Padding:(0,3,0,3),child=[CssBlock:child=[RichText:(:Foo)]]]'));
    });
  });

  group('inline', () {
    final explain = helper.explain;

    testWidgets('renders left & right', (WidgetTester tester) async {
      final html = 'a<span style="margin: 5px">b</span>c';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[RichText:(:'
              'a'
              '[SizedBox:5.0x0.0]'
              '(:b)'
              '[SizedBox:5.0x0.0]'
              '(:c)'
              ')]'));
    });

    testWidgets('renders left', (WidgetTester tester) async {
      final html = 'a<span style="margin-left: 5px">b</span>c';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[RichText:(:'
              'a'
              '[SizedBox:5.0x0.0]'
              '(:b)'
              '[widget0]'
              '(:c)'
              ')]'));
    });

    testWidgets('renders right', (WidgetTester tester) async {
      final html = 'a<span style="margin-right: 5px">b</span>c';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[RichText:(:'
              'a'
              '[widget0]'
              '(:b)'
              '[SizedBox:5.0x0.0]'
              '(:c)'
              ')]'));
    });

    testWidgets('renders inline-start (ltr)', (WidgetTester tester) async {
      final html = 'a<span style="margin-inline-start: 5px">b</span>c';
      final explained = await explain(tester, html, rtl: false);
      expect(
          explained,
          equals('[RichText:(:'
              'a'
              '[SizedBox:5.0x0.0]'
              '(:b)'
              '[widget0]'
              '(:c)'
              ')]'));
    });

    testWidgets('renders inline-end (ltr)', (WidgetTester tester) async {
      final html = 'a<span style="margin-inline-end: 5px">b</span>c';
      final explained = await explain(tester, html, rtl: false);
      expect(
          explained,
          equals('[RichText:(:'
              'a'
              '[widget0]'
              '(:b)'
              '[SizedBox:5.0x0.0]'
              '(:c)'
              ')]'));
    });

    testWidgets('renders inline-start (rtl)', (WidgetTester tester) async {
      final html = 'a<span style="margin-inline-start: 5px">b</span>c';
      final explained = await explain(tester, html, rtl: true);
      expect(
          explained,
          equals('[RichText:dir=rtl,(:'
              'a'
              '[widget0]'
              '(:b)'
              '[SizedBox:5.0x0.0]'
              '(:c)'
              ')]'));
    });

    testWidgets('renders inline-end (rtl)', (WidgetTester tester) async {
      final html = 'a<span style="margin-inline-end: 5px">b</span>c';
      final explained = await explain(tester, html, rtl: true);
      expect(
          explained,
          equals('[RichText:dir=rtl,(:'
              'a'
              '[SizedBox:5.0x0.0]'
              '(:b)'
              '[widget0]'
              '(:c)'
              ')]'));
    });
  });

  group('trimming', () {
    testWidgets('trims top intances', (WidgetTester tester) async {
      final html = '<div style="margin-top: 1em">Foo</div>';
      final explained = await helper.explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('trims bottom instances', (WidgetTester tester) async {
      final html = '<div style="margin-bottom: 1em">Foo</div>';
      final explained = await helper.explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('trims both ways', (WidgetTester tester) async {
      final html = '<div style="margin: 1em 0">Foo</div>'
          '<div style="margin: 1em 0">Bar</div>';
      final explained = await helper.explain(tester, html);
      expect(
          explained,
          equals('[Column:children='
              '[CssBlock:child=[RichText:(:Foo)]],'
              '[SizedBox:0.0x10.0],'
              '[CssBlock:child=[RichText:(:Bar)]]'
              ']'));
    });
  });

  group('invalid values', () {
    testWidgets('4 values', (WidgetTester tester) async {
      final html = '<div style="margin: a b c d">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('2 values', (WidgetTester tester) async {
      final html = '<div style="margin: xxx yyy">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('1 value', (WidgetTester tester) async {
      final html = '<div style="margin: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('top', (WidgetTester tester) async {
      final html = '<div style="margin-top: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('right', (WidgetTester tester) async {
      final html = '<div style="margin-right: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('end', (WidgetTester tester) async {
      final html = '<div style="margin-inline-end: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('bottom', (WidgetTester tester) async {
      final html = '<div style="margin-bottom: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('left', (WidgetTester tester) async {
      final html = '<div style="margin-left: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('start', (WidgetTester tester) async {
      final html = '<div style="margin-inline-start: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });
  });
}
