import 'package:flutter_test/flutter_test.dart';

import '_.dart' as helper;

void main() {
  final explain = helper.explainMargin;

  testWidgets('renders text without padding', (WidgetTester tester) async {
    final html = '<div>Foo</div>';
    final explained = await explain(tester, html);
    expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
  });

  group('4 values', () {
    testWidgets('parses all', (WidgetTester tester) async {
      final html = '<div style="padding: 1px 2px 3px 4px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child=[Padding:(1,2,3,4),child='
              '[RichText:(:Foo)]]]'));
    });

    testWidgets('parses all (rtl)', (WidgetTester tester) async {
      final html = '<div style="padding: 1px 2px 3px 4px">Foo</div>';
      final explained = await explain(tester, html, rtl: true);
      expect(
          explained,
          equals('[CssBlock:child=[Padding:(1,4,3,2),child='
              '[RichText:dir=rtl,(:Foo)]]]'));
    });

    testWidgets('parses top only', (WidgetTester tester) async {
      final html = '<div style="padding: 1px 0 0 0">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child=[Padding:(1,0,0,0),child='
              '[RichText:(:Foo)]]]'));
    });

    group('parses end only', () {
      final html = '<div style="padding: 0 2px 0 0">Foo</div>';

      testWidgets('ltr', (WidgetTester tester) async {
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[CssBlock:child=[Padding:(0,2,0,0),child='
                '[RichText:(:Foo)]]]'));
      });

      testWidgets('rtl', (WidgetTester tester) async {
        final explained = await explain(tester, html, rtl: true);
        expect(
            explained,
            equals('[CssBlock:child=[Padding:(0,0,0,2),child='
                '[RichText:dir=rtl,(:Foo)]]]'));
      });
    });

    testWidgets('parses bottom only', (WidgetTester tester) async {
      final html = '<div style="padding: 0 0 3px 0">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child=[Padding:(0,0,3,0),child='
              '[RichText:(:Foo)]]]'));
    });

    group('parses start only', () {
      final html = '<div style="padding: 0 0 0 4px">Foo</div>';

      testWidgets('ltr', (WidgetTester tester) async {
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[CssBlock:child=[Padding:(0,0,0,4),child='
                '[RichText:(:Foo)]]]'));
      });

      testWidgets('rtl', (WidgetTester tester) async {
        final explained = await explain(tester, html, rtl: true);
        expect(
            explained,
            equals('[CssBlock:child=[Padding:(0,4,0,0),child='
                '[RichText:dir=rtl,(:Foo)]]]'));
      });
    });
  });

  group('2 values', () {
    testWidgets('parses both', (WidgetTester tester) async {
      final html = '<div style="padding: 5px 10px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child=[Padding:(5,10,5,10),child='
              '[RichText:(:Foo)]]]'));
    });

    testWidgets('parses vertical only', (WidgetTester tester) async {
      final html = '<div style="padding: 5px 0">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child=[Padding:(5,0,5,0),child='
              '[RichText:(:Foo)]]]'));
    });

    testWidgets('parses horizontal only', (WidgetTester tester) async {
      final html = '<div style="padding: 0 10px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child=[Padding:(0,10,0,10),child='
              '[RichText:(:Foo)]]]'));
    });
  });

  group('1 value', () {
    testWidgets('renders em', (WidgetTester tester) async {
      final html = '<div style="padding: 2em">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child=[Padding:(20,20,20,20),child='
              '[RichText:(:Foo)]]]'));
    });

    testWidgets('renders pt', (WidgetTester tester) async {
      final html = '<div style="padding: 10pt">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child=[Padding:(13,13,13,13),child='
              '[RichText:(:Foo)]]]'));
    });

    testWidgets('renders px', (WidgetTester tester) async {
      final html = '<div style="padding: 10px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child=[Padding:(10,10,10,10),child='
              '[RichText:(:Foo)]]]'));
    });
  });

  testWidgets('renders padding within another', (WidgetTester tester) async {
    final html = '<div style="padding: 1px">'
        '<div style="padding: 2px">Foo</div></div>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[CssBlock:child=[Padding:(1,1,1,1),child='
            '[CssBlock:child=[Padding:(2,2,2,2),child='
            '[RichText:(:Foo)]'
            ']]]]'));
  });

  testWidgets('renders paddings back to back', (WidgetTester tester) async {
    final html = '<div style="padding: 3px">1</div>'
        '<div style="padding: 3px">2</div>'
        '<div style="padding: 3px">3</div>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[CssBlock:child=[Padding:(3,3,3,3),child=[RichText:(:1)]]],'
            '[CssBlock:child=[Padding:(3,3,3,3),child=[RichText:(:2)]]],'
            '[CssBlock:child=[Padding:(3,3,3,3),child=[RichText:(:3)]]]'));
  });

  testWidgets('renders block paddings back to back', (tester) async {
    final html = '<div style="padding: 3px"><div>1a</div><div>1b</div></div>'
        '<div style="padding: 3px"><div>2a</div><div>2b</div></div>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[CssBlock:child=[Padding:(3,3,3,3),child=[Column:children='
            '[CssBlock:child=[RichText:(:1a)]],'
            '[CssBlock:child=[RichText:(:1b)]]'
            ']]],'
            '[CssBlock:child=[Padding:(3,3,3,3),child=[Column:children='
            '[CssBlock:child=[RichText:(:2a)]],'
            '[CssBlock:child=[RichText:(:2b)]]'
            ']]]'));
  });

  group('padding-xxx', () {
    testWidgets('parses padding-top', (WidgetTester tester) async {
      final html = '<div style="padding-top: 3px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child=[Padding:(3,0,0,0),child='
              '[RichText:(:Foo)]]]'));
    });

    testWidgets('parses padding-block-start', (WidgetTester tester) async {
      final html = '<div style="padding-block-start: 3px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child=[Padding:(3,0,0,0),child='
              '[RichText:(:Foo)]]]'));
    });

    testWidgets('parses padding-right', (WidgetTester tester) async {
      final html = '<div style="padding-right: 3px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child=[Padding:(0,3,0,0),child='
              '[RichText:(:Foo)]]]'));
    });

    group('parses padding-inline-end', () {
      final html = '<div style="padding-inline-end: 3px">Foo</div>';

      testWidgets('ltr', (WidgetTester tester) async {
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[CssBlock:child=[Padding:(0,3,0,0),child='
                '[RichText:(:Foo)]]]'));
      });

      testWidgets('rtl', (WidgetTester tester) async {
        final explained = await explain(tester, html, rtl: true);
        expect(
            explained,
            equals('[CssBlock:child=[Padding:(0,0,0,3),child='
                '[RichText:dir=rtl,(:Foo)]]]'));
      });
    });

    testWidgets('parses padding-bottom', (WidgetTester tester) async {
      final html = '<div style="padding-bottom: 3px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child=[Padding:(0,0,3,0),child='
              '[RichText:(:Foo)]]]'));
    });

    testWidgets('parses padding-block-end', (WidgetTester tester) async {
      final html = '<div style="padding-block-end: 3px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child=[Padding:(0,0,3,0),child='
              '[RichText:(:Foo)]]]'));
    });

    testWidgets('parses padding-left', (WidgetTester tester) async {
      final html = '<div style="padding-left: 3px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child=[Padding:(0,0,0,3),child='
              '[RichText:(:Foo)]]]'));
    });

    group('parses padding-inline-start', () {
      final html = '<div style="padding-inline-start: 3px">Foo</div>';

      testWidgets('ltr', (WidgetTester tester) async {
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[CssBlock:child=[Padding:(0,0,0,3),child='
                '[RichText:(:Foo)]]]'));
      });

      testWidgets('rtl', (WidgetTester tester) async {
        final explained = await explain(tester, html, rtl: true);
        expect(
            explained,
            equals('[CssBlock:child=[Padding:(0,3,0,0),child='
                '[RichText:dir=rtl,(:Foo)]]]'));
      });
    });

    testWidgets('overwrites padding with padding-top', (tester) async {
      final html = '<div style="padding: 3px; padding-top: 5px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child=[Padding:(5,3,3,3),child='
              '[RichText:(:Foo)]]]'));
    });

    testWidgets('reset padding with padding-bottom', (tester) async {
      final html = '<div style="padding: 3px; padding-bottom: 0">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child=[Padding:(3,3,0,3),child='
              '[RichText:(:Foo)]]]'));
    });
  });

  group('inline', () {
    final explain = helper.explain;

    testWidgets('renders left & right', (WidgetTester tester) async {
      final html = 'a<span style="padding: 5px">b</span>c';
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
      final html = 'a<span style="padding-left: 5px">b</span>c';
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
      final html = 'a<span style="padding-right: 5px">b</span>c';
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
      final html = 'a<span style="padding-inline-start: 5px">b</span>c';
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
      final html = 'a<span style="padding-inline-end: 5px">b</span>c';
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
      final html = 'a<span style="padding-inline-start: 5px">b</span>c';
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
      final html = 'a<span style="padding-inline-end: 5px">b</span>c';
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

  group('invalid values', () {
    testWidgets('4 values', (WidgetTester tester) async {
      final html = '<div style="padding: a b c d">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('2 values', (WidgetTester tester) async {
      final html = '<div style="padding: xxx yyy">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('1 value', (WidgetTester tester) async {
      final html = '<div style="padding: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('top', (WidgetTester tester) async {
      final html = '<div style="padding-top: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('right', (WidgetTester tester) async {
      final html = '<div style="padding-right: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('end', (WidgetTester tester) async {
      final html = '<div style="padding-inline-end: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('bottom', (WidgetTester tester) async {
      final html = '<div style="padding-bottom: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('left', (WidgetTester tester) async {
      final html = '<div style="padding-left: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('start', (WidgetTester tester) async {
      final html = '<div style="padding-inline-start: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });
  });
}
