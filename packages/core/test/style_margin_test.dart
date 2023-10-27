import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '_.dart' as helper;

void main() {
  const explain = helper.explainMargin;

  testWidgets('renders text without margin', (WidgetTester tester) async {
    const html = '<div>Foo</div>';
    final explained = await explain(tester, html);
    expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
  });

  group('4 values', () {
    testWidgets('parses all', (WidgetTester tester) async {
      const html = '<div style="margin: 1px 2px 3px 4px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[SizedBox:0.0x1.0],'
          '[HorizontalMargin:left=4,right=2,child=[CssBlock:child=[RichText:(:Foo)]]],'
          '[SizedBox:0.0x3.0]',
        ),
      );
    });

    testWidgets('parses all (rtl)', (WidgetTester tester) async {
      const html = '<div style="margin: 1px 2px 3px 4px">Foo</div>';
      final explained = await explain(tester, html, rtl: true);
      expect(
        explained,
        equals(
          '[SizedBox:0.0x1.0],'
          '[HorizontalMargin:left=2,right=4,child='
          '[CssBlock:child=[RichText:dir=rtl,(:Foo)]]'
          '],'
          '[SizedBox:0.0x3.0]',
        ),
      );
    });

    testWidgets('parses top only', (WidgetTester tester) async {
      const html = '<div style="margin: 1px 0 0 0">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[SizedBox:0.0x1.0],[CssBlock:child=[RichText:(:Foo)]]',
        ),
      );
    });

    group('parses end only', () {
      const html = '<div style="margin: 0 2px 0 0">Foo</div>';

      testWidgets('ltr', (WidgetTester tester) async {
        final explained = await explain(tester, html);
        expect(
          explained,
          equals(
            '[HorizontalMargin:left=0,right=2,child=[CssBlock:child='
            '[RichText:(:Foo)]]]',
          ),
        );
      });

      testWidgets('rtl', (WidgetTester tester) async {
        final explained = await explain(tester, html, rtl: true);
        expect(
          explained,
          equals(
            '[HorizontalMargin:left=2,right=0,child=[CssBlock:child='
            '[RichText:dir=rtl,(:Foo)]]]',
          ),
        );
      });
    });

    testWidgets('parses bottom only', (WidgetTester tester) async {
      const html = '<div style="margin: 0 0 3px 0">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[RichText:(:Foo)]],[SizedBox:0.0x3.0]',
        ),
      );
    });

    group('parses start only', () {
      const html = '<div style="margin: 0 0 0 4px">Foo</div>';

      testWidgets('ltr', (WidgetTester tester) async {
        final explained = await explain(tester, html);
        expect(
          explained,
          equals(
            '[HorizontalMargin:left=4,right=0,child=[CssBlock:child='
            '[RichText:(:Foo)]]]',
          ),
        );
      });

      testWidgets('rtl', (WidgetTester tester) async {
        final explained = await explain(tester, html, rtl: true);
        expect(
          explained,
          equals(
            '[HorizontalMargin:left=0,right=4,child=[CssBlock:child='
            '[RichText:dir=rtl,(:Foo)]]]',
          ),
        );
      });
    });
  });

  group('2 values', () {
    testWidgets('parses both', (WidgetTester tester) async {
      const html = '<div style="margin: 5px 10px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[SizedBox:0.0x5.0],'
          '[HorizontalMargin:left=10,right=10,child=[CssBlock:child=[RichText:(:Foo)]]],'
          '[SizedBox:0.0x5.0]',
        ),
      );
    });

    testWidgets('parses vertical only', (WidgetTester tester) async {
      const html = '<div style="margin: 5px 0">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[SizedBox:0.0x5.0],'
          '[CssBlock:child=[RichText:(:Foo)]],'
          '[SizedBox:0.0x5.0]',
        ),
      );
    });

    testWidgets('parses horizontal only', (WidgetTester tester) async {
      const html = '<div style="margin: 0 10px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[HorizontalMargin:left=10,right=10,child=[CssBlock:child='
          '[RichText:(:Foo)]]]',
        ),
      );
    });
  });

  group('1 value', () {
    testWidgets('renders em', (WidgetTester tester) async {
      const html = '<div style="margin: 2em">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[SizedBox:0.0x20.0],'
          '[HorizontalMargin:left=20,right=20,child=[CssBlock:child=[RichText:(:Foo)]]],'
          '[SizedBox:0.0x20.0]',
        ),
      );
    });

    testWidgets('renders pt', (WidgetTester tester) async {
      const html = '<div style="margin: 10pt">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[SizedBox:0.0x13.3],'
          '[HorizontalMargin:left=13,right=13,child=[CssBlock:child=[RichText:(:Foo)]]],'
          '[SizedBox:0.0x13.3]',
        ),
      );
    });

    testWidgets('renders px', (WidgetTester tester) async {
      const html = '<div style="margin: 10px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[SizedBox:0.0x10.0],'
          '[HorizontalMargin:left=10,right=10,child=[CssBlock:child=[RichText:(:Foo)]]],'
          '[SizedBox:0.0x10.0]',
        ),
      );
    });
  });

  group('auto', () {
    testWidgets('parses 4 values', (WidgetTester tester) async {
      const html = '<div style="margin: 1px auto 2px auto">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[SizedBox:0.0x1.0],'
          '[HorizontalMargin:left=∞,right=∞,child=[CssBlock:child=[RichText:(:Foo)]]],'
          '[SizedBox:0.0x2.0]',
        ),
      );
    });

    testWidgets('parses 2 values', (WidgetTester tester) async {
      const html = '<div style="margin: 0 auto">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[HorizontalMargin:left=∞,right=∞,child=[CssBlock:child=[RichText:(:Foo)]]]',
        ),
      );
    });

    testWidgets('parses 1 value', (WidgetTester tester) async {
      const html = '<div style="margin: auto">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[widget0],'
          '[HorizontalMargin:left=∞,right=∞,child=[CssBlock:child=[RichText:(:Foo)]]],'
          '[widget0]',
        ),
      );
    });
  });

  testWidgets('renders margin within another', (WidgetTester tester) async {
    const html = '<div style="margin: 1px">'
        '<div style="margin: 2px">Foo</div></div>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[SizedBox:0.0x2.0],'
        '[HorizontalMargin:left=1,right=1,child='
        '[CssBlock:child=[HorizontalMargin:left=2,right=2,child='
        '[CssBlock:child=[RichText:(:Foo)]]'
        ']]],'
        '[SizedBox:0.0x2.0]',
      ),
    );
  });

  testWidgets('renders margins back to back', (WidgetTester tester) async {
    const html = '<div style="margin: 3px">1</div>'
        '<div style="margin: 3px">2</div>'
        '<div style="margin: 3px">3</div>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[SizedBox:0.0x3.0],'
        '[HorizontalMargin:left=3,right=3,child=[CssBlock:child=[RichText:(:1)]]],'
        '[SizedBox:0.0x3.0],'
        '[HorizontalMargin:left=3,right=3,child=[CssBlock:child=[RichText:(:2)]]],'
        '[SizedBox:0.0x3.0],'
        '[HorizontalMargin:left=3,right=3,child=[CssBlock:child=[RichText:(:3)]]],'
        '[SizedBox:0.0x3.0]',
      ),
    );
  });

  testWidgets('renders block margins back to back', (tester) async {
    const html = '<div style="margin: 3px"><div>1a</div><div>1b</div></div>'
        '<div style="margin: 3px"><div>2a</div><div>2b</div></div>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[SizedBox:0.0x3.0],'
        '[HorizontalMargin:left=3,right=3,child=[CssBlock:child=[Column:children='
        '[CssBlock:child=[RichText:(:1a)]],'
        '[CssBlock:child=[RichText:(:1b)]]'
        ']]],'
        '[SizedBox:0.0x3.0],'
        '[HorizontalMargin:left=3,right=3,child=[CssBlock:child=[Column:children='
        '[CssBlock:child=[RichText:(:2a)]],'
        '[CssBlock:child=[RichText:(:2b)]]'
        ']]],'
        '[SizedBox:0.0x3.0]',
      ),
    );
  });

  group('margin-xxx', () {
    testWidgets('parses margin-top', (WidgetTester tester) async {
      const html = '<div style="margin-top: 3px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[SizedBox:0.0x3.0],[CssBlock:child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('parses margin-block-start', (WidgetTester tester) async {
      const html = '<div style="margin-block-start: 3px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[SizedBox:0.0x3.0],[CssBlock:child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('parses margin-right', (WidgetTester tester) async {
      const html = '<div style="margin-right: 3px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[HorizontalMargin:left=0,right=3,child=[CssBlock:child='
          '[RichText:(:Foo)]]]',
        ),
      );
    });

    group('parses margin-inline-end', () {
      const html = '<div style="margin-inline-end: 3px">Foo</div>';

      testWidgets('ltr', (WidgetTester tester) async {
        final explained = await explain(tester, html);
        expect(
          explained,
          equals(
            '[HorizontalMargin:left=0,right=3,child=[CssBlock:child='
            '[RichText:(:Foo)]]]',
          ),
        );
      });

      testWidgets('rtl', (WidgetTester tester) async {
        final explained = await explain(tester, html, rtl: true);
        expect(
          explained,
          equals(
            '[HorizontalMargin:left=3,right=0,child=[CssBlock:child='
            '[RichText:dir=rtl,(:Foo)]]]',
          ),
        );
      });
    });

    testWidgets('parses margin-bottom', (WidgetTester tester) async {
      const html = '<div style="margin-bottom: 3px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[RichText:(:Foo)]],[SizedBox:0.0x3.0]',
        ),
      );
    });

    testWidgets('parses margin-block-end', (WidgetTester tester) async {
      const html = '<div style="margin-block-end: 3px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[RichText:(:Foo)]],[SizedBox:0.0x3.0]',
        ),
      );
    });

    testWidgets('parses margin-left', (WidgetTester tester) async {
      const html = '<div style="margin-left: 3px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[HorizontalMargin:left=3,right=0,child=[CssBlock:child='
          '[RichText:(:Foo)]]]',
        ),
      );
    });

    group('parses margin-inline-start', () {
      const html = '<div style="margin-inline-start: 3px">Foo</div>';

      testWidgets('ltr', (WidgetTester tester) async {
        final explained = await explain(tester, html);
        expect(
          explained,
          equals(
            '[HorizontalMargin:left=3,right=0,child=[CssBlock:child='
            '[RichText:(:Foo)]]]',
          ),
        );
      });

      testWidgets('rtl', (WidgetTester tester) async {
        final explained = await explain(tester, html, rtl: true);
        expect(
          explained,
          equals(
            '[HorizontalMargin:left=0,right=3,child=[CssBlock:child='
            '[RichText:dir=rtl,(:Foo)]]]',
          ),
        );
      });
    });

    testWidgets('overwrites margin with margin-top', (tester) async {
      const html = '<div style="margin: 3px; margin-top: 5px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[SizedBox:0.0x5.0],'
          '[HorizontalMargin:left=3,right=3,child=[CssBlock:child=[RichText:(:Foo)]]],'
          '[SizedBox:0.0x3.0]',
        ),
      );
    });

    testWidgets('reset margin with margin-bottom', (tester) async {
      const html = '<div style="margin: 3px; margin-bottom: 0">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[SizedBox:0.0x3.0],'
          '[HorizontalMargin:left=3,right=3,child=[CssBlock:child=[RichText:(:Foo)]]]',
        ),
      );
    });
  });

  group('inline', () {
    const explain = helper.explain;

    testWidgets('renders left & right', (WidgetTester tester) async {
      const html = 'a<span style="margin: 5px">b</span>c';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[RichText:(:'
          'a'
          '[SizedBox:5.0x0.0]@bottom'
          '(:b)'
          '[SizedBox:5.0x0.0]@bottom'
          '(:c)'
          ')]',
        ),
      );
    });

    testWidgets('renders left', (WidgetTester tester) async {
      const html = 'a<span style="margin-left: 5px">b</span>c';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[RichText:(:'
          'a'
          '[SizedBox:5.0x0.0]@bottom'
          '(:bc)'
          ')]',
        ),
      );
    });

    testWidgets('renders right', (WidgetTester tester) async {
      const html = 'a<span style="margin-right: 5px">b</span>c';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[RichText:(:'
          'ab'
          '[SizedBox:5.0x0.0]@bottom'
          '(:c)'
          ')]',
        ),
      );
    });

    testWidgets('renders inline-start (ltr)', (WidgetTester tester) async {
      const html = 'a<span style="margin-inline-start: 5px">b</span>c';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[RichText:(:'
          'a'
          '[SizedBox:5.0x0.0]@bottom'
          '(:b)'
          '[widget0]@bottom'
          '(:c)'
          ')]',
        ),
      );
    });

    testWidgets('renders inline-end (ltr)', (WidgetTester tester) async {
      const html = 'a<span style="margin-inline-end: 5px">b</span>c';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[RichText:(:'
          'a'
          '[widget0]@bottom'
          '(:b)'
          '[SizedBox:5.0x0.0]@bottom'
          '(:c)'
          ')]',
        ),
      );
    });

    testWidgets('renders inline-start (rtl)', (WidgetTester tester) async {
      const html = 'a<span style="margin-inline-start: 5px">b</span>c';
      final explained = await explain(tester, html, rtl: true);
      expect(
        explained,
        equals(
          '[RichText:dir=rtl,(:'
          'a'
          '[widget0]@bottom'
          '(:b)'
          '[SizedBox:5.0x0.0]@bottom'
          '(:c)'
          ')]',
        ),
      );
    });

    testWidgets('renders inline-end (rtl)', (WidgetTester tester) async {
      const html = 'a<span style="margin-inline-end: 5px">b</span>c';
      final explained = await explain(tester, html, rtl: true);
      expect(
        explained,
        equals(
          '[RichText:dir=rtl,(:'
          'a'
          '[SizedBox:5.0x0.0]@bottom'
          '(:b)'
          '[widget0]@bottom'
          '(:c)'
          ')]',
        ),
      );
    });
  });

  group('trimming', () {
    testWidgets('trims top intances', (WidgetTester tester) async {
      const html = '<div style="margin-top: 1em">'
          '<div style="margin-top: 1em">Foo</div></div>';
      final explained = await helper.explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('trims bottom instances', (WidgetTester tester) async {
      const html = '<div style="margin-bottom: 1em">'
          '<div style="margin-bottom: 1em">Foo</div></div>';
      final explained = await helper.explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('trims both ways', (WidgetTester tester) async {
      const html = '<div style="margin: 1em 0">Foo</div>'
          '<div style="margin: 1em 0">Bar</div>';
      final explained = await helper.explain(tester, html);
      expect(
        explained,
        equals(
          '[Column:children='
          '[CssBlock:child=[RichText:(:Foo)]],'
          '[SizedBox:0.0x10.0],'
          '[CssBlock:child=[RichText:(:Bar)]]'
          ']',
        ),
      );
    });

    testWidgets('trims around empty block', (WidgetTester tester) async {
      const html = 'Foo.<p></p>Bar.';
      final explained = await helper.explain(tester, html);
      expect(
        explained,
        equals(
          '[Column:children='
          '[RichText:(:Foo.)],'
          '[SizedBox:0.0x10.0],'
          '[RichText:(:Bar.)]'
          ']',
        ),
      );
    });
  });

  group('negative values', () {
    testWidgets('4 values', (WidgetTester tester) async {
      const html = '<div style="margin: -1px -2px -3px -4px">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('2 values', (WidgetTester tester) async {
      const html = '<div style="margin: -1px -2px">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('1 value', (WidgetTester tester) async {
      const html = '<div style="margin: -1px">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('top', (WidgetTester tester) async {
      const html = '<div style="margin-top: -1px">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('right', (WidgetTester tester) async {
      const html = '<div style="margin-right: -1px">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('end', (WidgetTester tester) async {
      const html = '<div style="margin-inline-end: -1px">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('bottom', (WidgetTester tester) async {
      const html = '<div style="margin-bottom: -1px">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('left', (WidgetTester tester) async {
      const html = '<div style="margin-left: -1px">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('start', (WidgetTester tester) async {
      const html = '<div style="margin-inline-start: -1px">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });
  });

  group('invalid values', () {
    testWidgets('4 values', (WidgetTester tester) async {
      const html = '<div style="margin: a b c d">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('2 values', (WidgetTester tester) async {
      const html = '<div style="margin: xxx yyy">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('1 value', (WidgetTester tester) async {
      const html = '<div style="margin: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('top', (WidgetTester tester) async {
      const html = '<div style="margin-top: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('right', (WidgetTester tester) async {
      const html = '<div style="margin-right: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('end', (WidgetTester tester) async {
      const html = '<div style="margin-inline-end: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('bottom', (WidgetTester tester) async {
      const html = '<div style="margin-bottom: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('left', (WidgetTester tester) async {
      const html = '<div style="margin-left: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('start', (WidgetTester tester) async {
      const html = '<div style="margin-inline-start: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });
  });

  group('HorizontalMargin', () {
    group('_HorizontalMarginRenderObject setters', () {
      testWidgets('updates left', (t) async {
        await explain(t, '<div style="margin-left: 1px">Foo</div>');
        final element = find.byType(HorizontalMargin).evaluate().single;
        final before = element.widget as HorizontalMargin;
        expect(before.left, equals(1.0));

        await explain(t, '<div style="margin-left: auto">Foo</div>');
        final after = element.widget as HorizontalMargin;
        expect(after.left, equals(double.infinity));
      });

      testWidgets('updates right', (t) async {
        await explain(t, '<div style="margin-right: 1px">Foo</div>');
        final element = find.byType(HorizontalMargin).evaluate().single;
        final before = element.widget as HorizontalMargin;
        expect(before.right, equals(1.0));

        await explain(t, '<div style="margin-right: auto">Foo</div>');
        final after = element.widget as HorizontalMargin;
        expect(after.right, equals(double.infinity));
      });
    });

    testWidgets('computeDryLayout', (tester) async {
      await tester.pumpSizedBox(
        left: double.infinity,
        right: double.infinity,
      );

      final bc = BoxConstraints.loose(const Size(50, 50));
      final drySize = tester.horizontalMargin.getDryLayout(bc);
      expect(drySize, equals(const Size(50, 10)));
    });

    group('computeMaxIntrinsicWidth', () {
      testWidgets('computes with child', (tester) async {
        await tester.pumpSizedBox(left: 1, right: 2);
        final maxWidth = tester.horizontalMargin.getMaxIntrinsicWidth(50);
        expect(maxWidth, equals(13));
      });

      testWidgets('computes without child', (tester) async {
        await tester.pumpSizedBox(isNull: true, left: 1, right: 2);
        final maxWidth = tester.horizontalMargin.getMaxIntrinsicWidth(50);
        expect(maxWidth, equals(3));
      });
    });

    group('computeMinIntrinsicWidth', () {
      testWidgets('computes with child', (tester) async {
        await tester.pumpSizedBox(left: 1, right: 2);
        final maxWidth = tester.horizontalMargin.getMinIntrinsicWidth(50);
        expect(maxWidth, equals(13));
      });

      testWidgets('computes without child', (tester) async {
        await tester.pumpSizedBox(isNull: true, left: 1, right: 2);
        final maxWidth = tester.horizontalMargin.getMinIntrinsicWidth(50);
        expect(maxWidth, equals(3));
      });
    });

    group('performLayout', () {
      testWidgets('aligns left', (tester) async {
        final key = await tester.pumpSizedBox(right: double.infinity);

        final full = tester.getRect(find.byType(HorizontalMargin));
        expect(full, equals(const Rect.fromLTWH(0, 0, 100, 10)));

        final child = tester.getRect(find.byKey(key));
        expect(child, equals(const Rect.fromLTWH(0, 0, 10, 10)));
      });

      testWidgets('aligns center', (tester) async {
        final key = await tester.pumpSizedBox(
          left: double.infinity,
          right: double.infinity,
        );

        final full = tester.getRect(find.byType(HorizontalMargin));
        expect(full, equals(const Rect.fromLTWH(0, 0, 100, 10)));

        final child = tester.getRect(find.byKey(key));
        expect(child, equals(const Rect.fromLTWH(45, 0, 10, 10)));
      });

      testWidgets('aligns right', (tester) async {
        final key = await tester.pumpSizedBox(left: double.infinity);

        final full = tester.getRect(find.byType(HorizontalMargin));
        expect(full, equals(const Rect.fromLTWH(0, 0, 100, 10)));

        final child = tester.getRect(find.byKey(key));
        expect(child, equals(const Rect.fromLTWH(90, 0, 10, 10)));
      });

      testWidgets('aligns values', (tester) async {
        final key = await tester.pumpSizedBox(left: 20, right: 30);

        final full = tester.getRect(find.byType(HorizontalMargin));
        expect(full, equals(const Rect.fromLTWH(0, 0, 60, 10)));

        final child = tester.getRect(find.byKey(key));
        expect(child, equals(const Rect.fromLTWH(20, 0, 10, 10)));
      });

      testWidgets('aligns big values', (tester) async {
        final key = await tester.pumpSizedBox(left: 200, right: 300);

        final full = tester.getRect(find.byType(HorizontalMargin));
        expect(full, equals(const Rect.fromLTWH(0, 0, 100, 10)));

        final child = tester.getSize(find.byKey(key));
        expect(child, equals(const Size(0, 10)));
      });
    });
  });
}

extension on WidgetTester {
  RenderBox get horizontalMargin =>
      renderObject(find.byType(HorizontalMargin)) as RenderBox;

  Future<GlobalKey> pumpSizedBox({
    bool isNull = false,
    double left = .0,
    double right = .0,
  }) async {
    setWindowSize(const Size(100, 100));

    final key = GlobalKey();
    await pumpWidget(
      Align(
        alignment: Alignment.topLeft,
        child: HorizontalMargin(
          left: left,
          right: right,
          child: isNull
              ? null
              : SizedBox(
                  height: 10,
                  key: key,
                  width: 10,
                ),
        ),
      ),
    );

    return key;
  }
}
