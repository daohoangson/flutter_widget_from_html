import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  const foo = 'child=[CssBlock:child=[RichText:(:Foo)]]';

  group('box-shadow', () {
    testWidgets('renders offsets', (WidgetTester tester) async {
      const html = '<div style="box-shadow: 1px 2px red">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[Container:boxShadow=[#FFFF0000 1.0,2.0 0.0 0.0],$foo]'),
      );
    });

    testWidgets('renders blur radius', (WidgetTester tester) async {
      const html = '<div style="box-shadow: 1px 2px 3px red">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[Container:boxShadow=[#FFFF0000 1.0,2.0 3.0 0.0],$foo]'),
      );
    });

    testWidgets('renders spread radius', (WidgetTester tester) async {
      const html = '<div style="box-shadow: 1px 2px 3px 4px red">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[Container:boxShadow=[#FFFF0000 1.0,2.0 3.0 4.0],$foo]'),
      );
    });

    testWidgets('renders negative values', (WidgetTester tester) async {
      const html = '<div style="box-shadow: -1px -2px 3px -4px red">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[Container:boxShadow=[#FFFF0000 -1.0,-2.0 3.0 -4.0],$foo]'),
      );
    });

    testWidgets('renders color first', (WidgetTester tester) async {
      const html = '<div style="box-shadow: red 1px 2px 3px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[Container:boxShadow=[#FFFF0000 1.0,2.0 3.0 0.0],$foo]'),
      );
    });

    testWidgets('renders rgba color', (WidgetTester tester) async {
      const html =
          '<div style="box-shadow: 0px 1px 5px rgba(0,0,0,0.1)">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[Container:boxShadow=[#1A000000 0.0,1.0 5.0 0.0],$foo]'),
      );
    });

    testWidgets('renders currentcolor by default', (WidgetTester tester) async {
      const html = '<div style="box-shadow: 1px 2px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[Container:boxShadow=[#FF001234 1.0,2.0 0.0 0.0],$foo]'),
      );
    });

    testWidgets('renders em values', (WidgetTester tester) async {
      const html = '<div style="box-shadow: 1em 2em red">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[Container:boxShadow=[#FFFF0000 10.0,20.0 0.0 0.0],$foo]'),
      );
    });

    testWidgets('renders multiple shadows', (WidgetTester tester) async {
      const html =
          '<div style="box-shadow: 1px 1px red, 2px 2px blue">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:boxShadow=['
          '#FF0000FF 2.0,2.0 0.0 0.0;'
          '#FFFF0000 1.0,1.0 0.0 0.0'
          '],$foo]',
        ),
      );
    });

    testWidgets('skips inset shadow', (WidgetTester tester) async {
      const html =
          '<div style="box-shadow: inset 1px 1px red, 2px 2px blue">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[Container:boxShadow=[#FF0000FF 2.0,2.0 0.0 0.0],$foo]'),
      );
    });

    testWidgets('skips inset only', (WidgetTester tester) async {
      const html = '<div style="box-shadow: 1px 1px red inset">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('renders none', (WidgetTester tester) async {
      const html = '<div style="box-shadow: none">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('overwrites with none', (WidgetTester tester) async {
      const html =
          '<div style="box-shadow: 1px 1px red; box-shadow: none">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('renders with background and border', (tester) async {
      const html = '<div style="background: white; border: 1px solid; '
          'border-radius: 4px; box-shadow: 0 1px 5px red">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:border=1.0@solid#FF001234,'
          'boxShadow=[#FFFF0000 0.0,1.0 5.0 0.0],'
          'color=#FFFFFFFF,'
          'radius=[4.0, 4.0, 4.0, 4.0, 4.0, 4.0, 4.0, 4.0],'
          '$foo]',
        ),
      );
    });

    testWidgets('renders inside margins', (WidgetTester tester) async {
      const html = '<div style="box-shadow: 1px 2px red; '
          'margin: 1px; padding: 2px">Foo</div>';
      final explained = await explainMargin(tester, html);
      expect(
        explained,
        equals(
          '[SizedBox:0.0x1.0],'
          '[HorizontalMargin:left=1,right=1,child='
          '[Container:boxShadow=[#FFFF0000 1.0,2.0 0.0 0.0],child='
          '[Padding:(2,2,2,2),child='
          '[CssBlock:child='
          '[RichText:(:Foo)]]]'
          ']],[SizedBox:0.0x1.0]',
        ),
      );
    });

    testWidgets('ignores inline', (WidgetTester tester) async {
      const html = 'Foo <span style="box-shadow: 1px 2px red">bar</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo bar)]'));
    });

    group('invalid values', () {
      const invalids = {
        'one length': '1px',
        'five lengths': '1px 2px 3px 4px 5px',
        'negative blur radius': '1px 2px -3px',
        'two colors': 'red 1px 2px blue',
        'two insets': 'inset inset 1px 2px',
        'unknown keyword': '1px 2px foo',
        'empty shadow': '1px 2px red,',
      };

      for (final invalid in invalids.entries) {
        testWidgets(invalid.key, (WidgetTester tester) async {
          final html = '<div style="box-shadow: ${invalid.value}">Foo</div>';
          final explained = await explain(tester, html);
          expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
        });
      }

      testWidgets('keeps previous valid value', (WidgetTester tester) async {
        const html =
            '<div style="box-shadow: 1px 2px red; box-shadow: 1px">Foo</div>';
        final explained = await explain(tester, html);
        expect(
          explained,
          equals('[Container:boxShadow=[#FFFF0000 1.0,2.0 0.0 0.0],$foo]'),
        );
      });
    });
  });
}
