import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  testWidgets('renders text without border', (WidgetTester tester) async {
    final html = '<span>Foo</span>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:(:Foo)]'));
  });

  testWidgets('parses 3 values', (WidgetTester tester) async {
    final html = '<span style="border: 1px solid red">Foo</span>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[Container:'
            'border=1.0@solid#FFFF0000,'
            'child=[RichText:(:Foo)]]'));
  });

  testWidgets('parses 2 values', (WidgetTester tester) async {
    final html = '<span style="border: 1px solid">Foo</span>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[Container:'
            'border=1.0@solid#FF001234,'
            'child=[RichText:(:Foo)]]'));
  });

  testWidgets('renders dashed as solid', (WidgetTester tester) async {
    final html = '<span style="border: 1px dashed">Foo</span>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[Container:'
            'border=1.0@solid#FF001234,'
            'child=[RichText:(:Foo)]]'));
  });

  testWidgets('renders dotted as solid', (WidgetTester tester) async {
    final html = '<span style="border: 1px dotted">Foo</span>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[Container:'
            'border=1.0@solid#FF001234,'
            'child=[RichText:(:Foo)]]'));
  });

  testWidgets('renders double as solid', (WidgetTester tester) async {
    final html = '<span style="border: 1px double">Foo</span>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[Container:'
            'border=1.0@solid#FF001234,'
            'child=[RichText:(:Foo)]]'));
  });

  testWidgets('parses 1 value', (WidgetTester tester) async {
    final html = '<span style="border: 1px">Foo</span>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[Container:'
            'border=1.0@none#FF001234,'
            'child=[RichText:(:Foo)]]'));
  });

  testWidgets('renders with other text', (WidgetTester tester) async {
    final html = 'Foo <span style="border: 1px">bar</span>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[RichText:(:Foo [Container:'
            'border=1.0@none#FF001234,'
            'child=[RichText:(:bar)]])]'));
  });

  testWidgets('stays inside margin', (WidgetTester tester) async {
    final html = '<div style="border: 1px; margin: 1px">Foo</div>';
    final explained = await explainMargin(tester, html);
    expect(
        explained,
        equals('[SizedBox:0.0x1.0],'
            '[Padding:(0,1,0,1),child='
            '[Container:border=1.0@none#FF001234,child=[CssBlock:child=[RichText:(:Foo)]]]'
            '],'
            '[SizedBox:0.0x1.0]'));
  });

  testWidgets('wraps child margin', (WidgetTester tester) async {
    final html =
        '<div style="border: 1px"><div style="margin: 1px">Foo</div></div>';
    final explained = await explainMargin(tester, html);
    expect(
        explained,
        equals('[Container:border=1.0@none#FF001234,child='
            '[Column:children=[SizedBox:0.0x1.0],[CssBlock:child=[Padding:(0,1,0,1),child=[CssBlock:child=[RichText:(:Foo)]]]],[SizedBox:0.0x1.0]]'
            ']'));
  });

  group('border-xxx', () {
    testWidgets('parses border-top', (WidgetTester tester) async {
      final html = '<span style="border-top: 1px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Container:'
              'border=(1.0@none#FF001234,none,none,none),'
              'child=[RichText:(:Foo)]]'));
    });

    testWidgets('parses border-block-start', (WidgetTester tester) async {
      final html = '<span style="border-block-start: 1px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Container:'
              'border=(1.0@none#FF001234,none,none,none),'
              'child=[RichText:(:Foo)]]'));
    });

    testWidgets('parses border-right', (WidgetTester tester) async {
      final html = '<span style="border-right: 1px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Container:'
              'border=(none,1.0@none#FF001234,none,none),'
              'child=[RichText:(:Foo)]]'));
    });

    testWidgets('parses border-bottom', (WidgetTester tester) async {
      final html = '<span style="border-bottom: 1px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Container:'
              'border=(none,none,1.0@none#FF001234,none),'
              'child=[RichText:(:Foo)]]'));
    });

    testWidgets('parses border-block-end', (WidgetTester tester) async {
      final html = '<span style="border-block-end: 1px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Container:'
              'border=(none,none,1.0@none#FF001234,none),'
              'child=[RichText:(:Foo)]]'));
    });

    testWidgets('parses border-left', (WidgetTester tester) async {
      final html = '<span style="border-left: 1px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Container:'
              'border=(none,none,none,1.0@none#FF001234),'
              'child=[RichText:(:Foo)]]'));
    });

    group('parses border-inline-start', () {
      final html = '<span style="border-inline-start: 1px">Foo</span>';

      testWidgets('ltr', (WidgetTester tester) async {
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[Container:'
                'border=(none,none,none,1.0@none#FF001234),'
                'child=[RichText:(:Foo)]]'));
      });

      testWidgets('rtl', (WidgetTester tester) async {
        final explained = await explain(tester, html, rtl: true);
        expect(
            explained,
            equals('[Container:'
                'border=(none,1.0@none#FF001234,none,none),'
                'child=[RichText:dir=rtl,(:Foo)]]'));
      });
    });

    group('parses border-inline-end', () {
      final html = '<span style="border-inline-end: 1px">Foo</span>';

      testWidgets('ltr', (WidgetTester tester) async {
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[Container:'
                'border=(none,1.0@none#FF001234,none,none),'
                'child=[RichText:(:Foo)]]'));
      });

      testWidgets('rtl', (WidgetTester tester) async {
        final explained = await explain(tester, html, rtl: true);
        expect(
            explained,
            equals('[Container:'
                'border=(none,none,none,1.0@none#FF001234),'
                'child=[RichText:dir=rtl,(:Foo)]]'));
      });
    });
  });

  group('box-sizing', () {
    testWidgets('renders without box-sizing', (tester) async {
      final html = '<span style="border: 1px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Container:'
              'border=1.0@none#FF001234,'
              'child=[RichText:(:Foo)]]'));
    });

    testWidgets('parses content-box', (tester) async {
      final html =
          '<span style="border: 1px; box-sizing: content-box">Foo</span>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Container:'
              'border=1.0@none#FF001234,'
              'child=[RichText:(:Foo)]]'));
    });

    testWidgets('parses border-box', (tester) async {
      final html =
          '<span style="border: 1px; box-sizing: border-box">Foo</span>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[DecoratedBox:'
              'border=1.0@none#FF001234,'
              'child=[RichText:(:Foo)]]'));
    });
  });

  group('overwriting', () {
    testWidgets('overwrites border with border-top', (tester) async {
      final html = '<span style="border: 1px; border-top: 2px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Container:'
              'border=(2.0@none#FF001234,1.0@none#FF001234,1.0@none#FF001234,1.0@none#FF001234),'
              'child=[RichText:(:Foo)]]'));
    });

    testWidgets('overwrites border with border-block-start', (tester) async {
      final html =
          '<span style="border: 1px; border-block-start: 2px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Container:'
              'border=(2.0@none#FF001234,1.0@none#FF001234,1.0@none#FF001234,1.0@none#FF001234),'
              'child=[RichText:(:Foo)]]'));
    });

    testWidgets('overwrites border with border-right', (tester) async {
      final html = '<span style="border: 1px; border-right: 2px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Container:'
              'border=(1.0@none#FF001234,2.0@none#FF001234,1.0@none#FF001234,1.0@none#FF001234),'
              'child=[RichText:(:Foo)]]'));
    });

    testWidgets('overwrites border with border-bottom', (tester) async {
      final html = '<span style="border: 1px; border-bottom: 2px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Container:'
              'border=(1.0@none#FF001234,1.0@none#FF001234,2.0@none#FF001234,1.0@none#FF001234),'
              'child=[RichText:(:Foo)]]'));
    });

    testWidgets('overwrites border with border-block-end', (tester) async {
      final html =
          '<span style="border: 1px; border-block-end: 2px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Container:'
              'border=(1.0@none#FF001234,1.0@none#FF001234,2.0@none#FF001234,1.0@none#FF001234),'
              'child=[RichText:(:Foo)]]'));
    });

    testWidgets('overwrites border with border-left', (tester) async {
      final html = '<span style="border: 1px; border-left: 2px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Container:'
              'border=(1.0@none#FF001234,1.0@none#FF001234,1.0@none#FF001234,2.0@none#FF001234),'
              'child=[RichText:(:Foo)]]'));
    });

    group('overwrites border with border-inline-start', () {
      final html =
          '<span style="border: 1px; border-inline-start: 2px">Foo</span>';

      testWidgets('ltr', (tester) async {
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[Container:'
                'border=(1.0@none#FF001234,1.0@none#FF001234,1.0@none#FF001234,2.0@none#FF001234),'
                'child=[RichText:(:Foo)]]'));
      });

      testWidgets('rtl', (tester) async {
        final explained = await explain(tester, html, rtl: true);
        expect(
            explained,
            equals('[Container:'
                'border=(1.0@none#FF001234,2.0@none#FF001234,1.0@none#FF001234,1.0@none#FF001234),'
                'child=[RichText:dir=rtl,(:Foo)]]'));
      });
    });

    group('overwrites border with border-inline-end', () {
      final html =
          '<span style="border: 1px; border-inline-end: 2px">Foo</span>';

      testWidgets('ltr', (tester) async {
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[Container:'
                'border=(1.0@none#FF001234,2.0@none#FF001234,1.0@none#FF001234,1.0@none#FF001234),'
                'child=[RichText:(:Foo)]]'));
      });

      testWidgets('rtl', (tester) async {
        final explained = await explain(tester, html, rtl: true);
        expect(
            explained,
            equals('[Container:'
                'border=(1.0@none#FF001234,1.0@none#FF001234,1.0@none#FF001234,2.0@none#FF001234),'
                'child=[RichText:dir=rtl,(:Foo)]]'));
      });
    });

    testWidgets('overwrites style', (tester) async {
      final html =
          '<span style="border: 1px; border-top: 1px solid">Foo</span>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Container:'
              'border=(1.0@solid#FF001234,1.0@none#FF001234,1.0@none#FF001234,1.0@none#FF001234),'
              'child=[RichText:(:Foo)]]'));
    });

    testWidgets('overwrites color', (tester) async {
      final html =
          '<span style="border: 1px; border-top: 1px none red">Foo</span>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Container:'
              'border=(1.0@none#FFFF0000,1.0@none#FF001234,1.0@none#FF001234,1.0@none#FF001234),'
              'child=[RichText:(:Foo)]]'));
    });

    testWidgets('resets to none', (tester) async {
      final html = '<span style="border: 1px; border-top: none">Foo</span>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Container:'
              'border=(none,1.0@none#FF001234,1.0@none#FF001234,1.0@none#FF001234),'
              'child=[RichText:(:Foo)]]'));
    });
  });

  group('isBlockElement', () {
    testWidgets('parses border', (WidgetTester tester) async {
      final html = '<div style="border: 1px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Container:'
              'border=1.0@none#FF001234,'
              'child=[CssBlock:child=[RichText:(:Foo)]]]'));
    });

    testWidgets('parses border-top', (WidgetTester tester) async {
      final html = '<div style="border-top: 1px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Container:'
              'border=(1.0@none#FF001234,none,none,none),'
              'child=[CssBlock:child=[RichText:(:Foo)]]]'));
    });

    testWidgets('parses border-block-start', (WidgetTester tester) async {
      final html = '<div style="border-block-start: 1px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Container:'
              'border=(1.0@none#FF001234,none,none,none),'
              'child=[CssBlock:child=[RichText:(:Foo)]]]'));
    });

    testWidgets('parses border-right', (WidgetTester tester) async {
      final html = '<div style="border-right: 1px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Container:'
              'border=(none,1.0@none#FF001234,none,none),'
              'child=[CssBlock:child=[RichText:(:Foo)]]]'));
    });

    testWidgets('parses border-bottom', (WidgetTester tester) async {
      final html = '<div style="border-bottom: 1px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Container:'
              'border=(none,none,1.0@none#FF001234,none),'
              'child=[CssBlock:child=[RichText:(:Foo)]]]'));
    });

    testWidgets('parses border-block-end', (WidgetTester tester) async {
      final html = '<div style="border-block-end: 1px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Container:'
              'border=(none,none,1.0@none#FF001234,none),'
              'child=[CssBlock:child=[RichText:(:Foo)]]]'));
    });

    testWidgets('parses border-left', (WidgetTester tester) async {
      final html = '<div style="border-left: 1px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Container:'
              'border=(none,none,none,1.0@none#FF001234),'
              'child=[CssBlock:child=[RichText:(:Foo)]]]'));
    });

    group('parses border-inline-start', () {
      final html = '<div style="border-inline-start: 1px">Foo</div>';

      testWidgets('ltr', (WidgetTester tester) async {
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[Container:'
                'border=(none,none,none,1.0@none#FF001234),'
                'child=[CssBlock:child=[RichText:(:Foo)]]]'));
      });

      testWidgets('rtl', (WidgetTester tester) async {
        final explained = await explain(tester, html, rtl: true);
        expect(
            explained,
            equals('[Container:'
                'border=(none,1.0@none#FF001234,none,none),'
                'child=[CssBlock:child=[RichText:dir=rtl,(:Foo)]]]'));
      });
    });

    group('parses border-inline-end', () {
      final html = '<div style="border-inline-end: 1px">Foo</div>';

      testWidgets('ltr', (WidgetTester tester) async {
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[Container:'
                'border=(none,1.0@none#FF001234,none,none),'
                'child=[CssBlock:child=[RichText:(:Foo)]]]'));
      });

      testWidgets('rtl', (WidgetTester tester) async {
        final explained = await explain(tester, html, rtl: true);
        expect(
            explained,
            equals('[Container:'
                'border=(none,none,none,1.0@none#FF001234),'
                'child=[CssBlock:child=[RichText:dir=rtl,(:Foo)]]]'));
      });
    });
  });

  group('invalid values', () {
    testWidgets('3 values', (WidgetTester tester) async {
      final html = '<span style="border: a b c">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('2 values', (WidgetTester tester) async {
      final html = '<span style="border: a b">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('1 value', (WidgetTester tester) async {
      final html = '<span style="border: a">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });
  });
}
