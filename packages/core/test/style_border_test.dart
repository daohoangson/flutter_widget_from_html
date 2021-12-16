import 'package:flutter_test/flutter_test.dart';

import '_.dart';

const _border1 = '1.0@none#FF001234';

void main() {
  testWidgets('renders text without border', (WidgetTester tester) async {
    const html = '<span>Foo</span>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:(:Foo)]'));
  });

  testWidgets('parses 3 values', (WidgetTester tester) async {
    const html = '<span style="border: 1px solid red">Foo</span>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[Container:'
        'border=1.0@solid#FFFF0000,'
        'child=[RichText:(:Foo)]]',
      ),
    );
  });

  testWidgets('parses 2 values', (WidgetTester tester) async {
    const html = '<span style="border: 1px solid">Foo</span>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[Container:'
        'border=1.0@solid#FF001234,'
        'child=[RichText:(:Foo)]]',
      ),
    );
  });

  testWidgets('renders dashed as solid', (WidgetTester tester) async {
    const html = '<span style="border: 1px dashed">Foo</span>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[Container:'
        'border=1.0@solid#FF001234,'
        'child=[RichText:(:Foo)]]',
      ),
    );
  });

  testWidgets('renders dotted as solid', (WidgetTester tester) async {
    const html = '<span style="border: 1px dotted">Foo</span>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[Container:'
        'border=1.0@solid#FF001234,'
        'child=[RichText:(:Foo)]]',
      ),
    );
  });

  testWidgets('renders double as solid', (WidgetTester tester) async {
    const html = '<span style="border: 1px double">Foo</span>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[Container:'
        'border=1.0@solid#FF001234,'
        'child=[RichText:(:Foo)]]',
      ),
    );
  });

  testWidgets('parses 1 value', (WidgetTester tester) async {
    const html = '<span style="border: 1px">Foo</span>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals('[Container:border=$_border1,child=[RichText:(:Foo)]]'),
    );
  });

  testWidgets('renders with other text', (WidgetTester tester) async {
    const html = 'Foo <span style="border: 1px">bar</span>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[RichText:(:Foo '
        '[Container:border=$_border1,child=[RichText:(:bar)]]'
        ')]',
      ),
    );
  });

  testWidgets('stays inside margin', (WidgetTester tester) async {
    const html = '<div style="border: 1px; margin: 1px">Foo</div>';
    final explained = await explainMargin(tester, html);
    expect(
      explained,
      equals(
        '[SizedBox:0.0x1.0],'
        '[Padding:(0,1,0,1),child='
        '[CssBlock:child=[Container:border=$_border1,child=[RichText:(:Foo)]]]'
        '],'
        '[SizedBox:0.0x1.0]',
      ),
    );
  });

  testWidgets('wraps child margin', (WidgetTester tester) async {
    const html =
        '<div style="border: 1px"><div style="margin: 1px">Foo</div></div>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[CssBlock:child=[Container:border=$_border1,child='
        '[Column:children='
        '[SizedBox:0.0x1.0],'
        '[Padding:(0,1,0,1),child=[CssBlock:child=[RichText:(:Foo)]]],'
        '[SizedBox:0.0x1.0]'
        ']]]',
      ),
    );
  });

  group('border-xxx', () {
    testWidgets('parses border-top', (WidgetTester tester) async {
      const html = '<span style="border-top: 1px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'border=(1.0@none#FF001234,none,none,none),'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('parses border-block-start', (WidgetTester tester) async {
      const html = '<span style="border-block-start: 1px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'border=(1.0@none#FF001234,none,none,none),'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('parses border-right', (WidgetTester tester) async {
      const html = '<span style="border-right: 1px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'border=(none,1.0@none#FF001234,none,none),'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('parses border-bottom', (WidgetTester tester) async {
      const html = '<span style="border-bottom: 1px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'border=(none,none,1.0@none#FF001234,none),'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('parses border-block-end', (WidgetTester tester) async {
      const html = '<span style="border-block-end: 1px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'border=(none,none,1.0@none#FF001234,none),'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('parses border-left', (WidgetTester tester) async {
      const html = '<span style="border-left: 1px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'border=(none,none,none,1.0@none#FF001234),'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    group('parses border-inline-start', () {
      const html = '<span style="border-inline-start: 1px">Foo</span>';

      testWidgets('ltr', (WidgetTester tester) async {
        final explained = await explain(tester, html);
        expect(
          explained,
          equals(
            '[Container:'
            'border=(none,none,none,1.0@none#FF001234),'
            'child=[RichText:(:Foo)]]',
          ),
        );
      });

      testWidgets('rtl', (WidgetTester tester) async {
        final explained = await explain(tester, html, rtl: true);
        expect(
          explained,
          equals(
            '[Container:'
            'border=(none,1.0@none#FF001234,none,none),'
            'child=[RichText:dir=rtl,(:Foo)]]',
          ),
        );
      });
    });

    group('parses border-inline-end', () {
      const html = '<span style="border-inline-end: 1px">Foo</span>';

      testWidgets('ltr', (WidgetTester tester) async {
        final explained = await explain(tester, html);
        expect(
          explained,
          equals(
            '[Container:'
            'border=(none,1.0@none#FF001234,none,none),'
            'child=[RichText:(:Foo)]]',
          ),
        );
      });

      testWidgets('rtl', (WidgetTester tester) async {
        final explained = await explain(tester, html, rtl: true);
        expect(
          explained,
          equals(
            '[Container:'
            'border=(none,none,none,1.0@none#FF001234),'
            'child=[RichText:dir=rtl,(:Foo)]]',
          ),
        );
      });
    });
  });

  group('radius', () {
    testWidgets('parses border-radius one value in em', (tester) async {
      const html = '<span style="border-radius: 1em">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'radius=[10.0, 10.0, 10.0, 10.0, 10.0, 10.0, 10.0, 10.0],'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('parses border-radius one value in pt', (tester) async {
      const html = '<span style="border-radius: 3pt">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'radius=[4.0, 4.0, 4.0, 4.0, 4.0, 4.0, 4.0, 4.0],'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('parses border-radius one value in px', (tester) async {
      const html = '<span style="border-radius: 1px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'radius=[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0],'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('parses border-radius two values', (WidgetTester tester) async {
      const html = '<span style="border-radius: 1px 2px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'radius=[1.0, 1.0, 2.0, 2.0, 1.0, 1.0, 2.0, 2.0],'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('parses border-radius three values', (tester) async {
      const html = '<span style="border-radius: 1px 2px 3px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'radius=[1.0, 1.0, 2.0, 2.0, 3.0, 3.0, 2.0, 2.0],'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('parses border-radius four values', (tester) async {
      const html = '<span style="border-radius: 1px 2px 3px 4px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'radius=[1.0, 1.0, 2.0, 2.0, 3.0, 3.0, 4.0, 4.0],'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('parses border-radius one slash one', (tester) async {
      const html = '<span style="border-radius: 1px / 2px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'radius=[1.0, 2.0, 1.0, 2.0, 1.0, 2.0, 1.0, 2.0],'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('parses border-radius one slash two', (tester) async {
      const html = '<span style="border-radius: 1px / 2px 3px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'radius=[1.0, 2.0, 1.0, 3.0, 1.0, 2.0, 1.0, 3.0],'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('parses border-radius one slash three', (tester) async {
      const html = '<span style="border-radius: 1px / 2px 3px 4px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'radius=[1.0, 2.0, 1.0, 3.0, 1.0, 4.0, 1.0, 3.0],'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('parses border-radius one slash four', (tester) async {
      const html =
          '<span style="border-radius: 1px / 2px 3px 4px 5px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'radius=[1.0, 2.0, 1.0, 3.0, 1.0, 4.0, 1.0, 5.0],'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('parses border-radius two slash one', (tester) async {
      const html = '<span style="border-radius: 1px 3px / 2px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'radius=[1.0, 2.0, 3.0, 2.0, 1.0, 2.0, 3.0, 2.0],'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('parses border-radius two slash two', (tester) async {
      const html = '<span style="border-radius: 1px 3px / 2px 4px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'radius=[1.0, 2.0, 3.0, 4.0, 1.0, 2.0, 3.0, 4.0],'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('parses border-radius two slash three', (tester) async {
      const html =
          '<span style="border-radius: 1px 3px / 2px 4px 5px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'radius=[1.0, 2.0, 3.0, 4.0, 1.0, 5.0, 3.0, 4.0],'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('parses border-radius two slash four', (tester) async {
      const html =
          '<span style="border-radius: 1px 3px / 2px 4px 5px 6px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'radius=[1.0, 2.0, 3.0, 4.0, 1.0, 5.0, 3.0, 6.0],'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('parses border-radius three slash one', (tester) async {
      const html = '<span style="border-radius: 1px 3px 4px / 2px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'radius=[1.0, 2.0, 3.0, 2.0, 4.0, 2.0, 3.0, 2.0],'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('parses border-radius three slash two', (tester) async {
      const html =
          '<span style="border-radius: 1px 3px 4px / 2px 5px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'radius=[1.0, 2.0, 3.0, 5.0, 4.0, 2.0, 3.0, 5.0],'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('parses border-radius three slash three', (tester) async {
      const html =
          '<span style="border-radius: 1px 3px 4px / 2px 5px 6px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'radius=[1.0, 2.0, 3.0, 5.0, 4.0, 6.0, 3.0, 5.0],'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('parses border-radius three slash four', (tester) async {
      const html =
          '<span style="border-radius: 1px 3px 4px / 2px 5px 6px 7px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'radius=[1.0, 2.0, 3.0, 5.0, 4.0, 6.0, 3.0, 7.0],'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('parses border-radius four slash one', (tester) async {
      const html =
          '<span style="border-radius: 1px 3px 4px 5px / 2px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'radius=[1.0, 2.0, 3.0, 2.0, 4.0, 2.0, 5.0, 2.0],'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('parses border-radius four slash two', (tester) async {
      const html =
          '<span style="border-radius: 1px 3px 4px 5px / 2px 6px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'radius=[1.0, 2.0, 3.0, 6.0, 4.0, 2.0, 5.0, 6.0],'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('parses border-radius four slash three', (tester) async {
      const html =
          '<span style="border-radius: 1px 3px 4px 5px / 2px 6px 7px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'radius=[1.0, 2.0, 3.0, 6.0, 4.0, 7.0, 5.0, 6.0],'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('parses border-radius four slash four', (tester) async {
      const html =
          '<span style="border-radius: 1px 3px 4px 5px / 2px 6px 7px 8px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'radius=[1.0, 2.0, 3.0, 6.0, 4.0, 7.0, 5.0, 8.0],'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('parses border-top-left-radius one value', (tester) async {
      const html = '<span style="border-top-left-radius: 1px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'radius=[1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('parses border-top-left-radius two value', (tester) async {
      const html = '<span style="border-top-left-radius: 1px 2px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'radius=[1.0, 2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('parses border-top-right-radius one value', (tester) async {
      const html = '<span style="border-top-right-radius: 1px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'radius=[0.0, 0.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0],'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('parses border-top-right-radius two value', (tester) async {
      const html = '<span style="border-top-right-radius: 1px 2px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'radius=[0.0, 0.0, 1.0, 2.0, 0.0, 0.0, 0.0, 0.0],'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('parses border-bottom-right-radius one value', (tester) async {
      const html = '<span style="border-bottom-right-radius: 1px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'radius=[0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.0, 0.0],'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('parses border-bottom-right-radius two value', (tester) async {
      const html =
          '<span style="border-bottom-right-radius: 1px 2px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'radius=[0.0, 0.0, 0.0, 0.0, 1.0, 2.0, 0.0, 0.0],'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('parses border-bottom-left-radius one value', (tester) async {
      const html = '<span style="border-bottom-left-radius: 1px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'radius=[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0],'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('parses border-bottom-left-radius two value', (tester) async {
      const html =
          '<span style="border-bottom-left-radius: 1px 2px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'radius=[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 2.0],'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });
  });

  group('box-sizing', () {
    testWidgets('renders without box-sizing', (tester) async {
      const html = '<span style="border: 1px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[Container:border=$_border1,child=[RichText:(:Foo)]]'),
      );
    });

    testWidgets('parses content-box', (tester) async {
      const html =
          '<span style="border: 1px; box-sizing: content-box">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[Container:border=$_border1,child=[RichText:(:Foo)]]'),
      );
    });

    testWidgets('parses border-box', (tester) async {
      const html =
          '<span style="border: 1px; box-sizing: border-box">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[DecoratedBox:border=$_border1,child=[RichText:(:Foo)]]'),
      );
    });
  });

  group('overwriting', () {
    testWidgets('overwrites border with border-top', (tester) async {
      const html = '<span style="border: 1px; border-top: 2px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'border=(2.0@none#FF001234,1.0@none#FF001234,'
          '1.0@none#FF001234,1.0@none#FF001234),'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('overwrites border with border-block-start', (tester) async {
      const html =
          '<span style="border: 1px; border-block-start: 2px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'border=(2.0@none#FF001234,1.0@none#FF001234,'
          '1.0@none#FF001234,1.0@none#FF001234),'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('overwrites border with border-right', (tester) async {
      const html = '<span style="border: 1px; border-right: 2px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'border=(1.0@none#FF001234,2.0@none#FF001234,'
          '1.0@none#FF001234,1.0@none#FF001234),'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('overwrites border with border-bottom', (tester) async {
      const html = '<span style="border: 1px; border-bottom: 2px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'border=(1.0@none#FF001234,1.0@none#FF001234,'
          '2.0@none#FF001234,1.0@none#FF001234),'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('overwrites border with border-block-end', (tester) async {
      const html =
          '<span style="border: 1px; border-block-end: 2px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'border=(1.0@none#FF001234,1.0@none#FF001234,'
          '2.0@none#FF001234,1.0@none#FF001234),'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('overwrites border with border-left', (tester) async {
      const html = '<span style="border: 1px; border-left: 2px">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'border=(1.0@none#FF001234,1.0@none#FF001234,'
          '1.0@none#FF001234,2.0@none#FF001234),'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    group('overwrites border with border-inline-start', () {
      const html =
          '<span style="border: 1px; border-inline-start: 2px">Foo</span>';

      testWidgets('ltr', (tester) async {
        final explained = await explain(tester, html);
        expect(
          explained,
          equals(
            '[Container:'
            'border=(1.0@none#FF001234,1.0@none#FF001234,'
            '1.0@none#FF001234,2.0@none#FF001234),'
            'child=[RichText:(:Foo)]]',
          ),
        );
      });

      testWidgets('rtl', (tester) async {
        final explained = await explain(tester, html, rtl: true);
        expect(
          explained,
          equals(
            '[Container:'
            'border=(1.0@none#FF001234,2.0@none#FF001234,'
            '1.0@none#FF001234,1.0@none#FF001234),'
            'child=[RichText:dir=rtl,(:Foo)]]',
          ),
        );
      });
    });

    group('overwrites border with border-inline-end', () {
      const html =
          '<span style="border: 1px; border-inline-end: 2px">Foo</span>';

      testWidgets('ltr', (tester) async {
        final explained = await explain(tester, html);
        expect(
          explained,
          equals(
            '[Container:'
            'border=(1.0@none#FF001234,2.0@none#FF001234,'
            '1.0@none#FF001234,1.0@none#FF001234),'
            'child=[RichText:(:Foo)]]',
          ),
        );
      });

      testWidgets('rtl', (tester) async {
        final explained = await explain(tester, html, rtl: true);
        expect(
          explained,
          equals(
            '[Container:'
            'border=(1.0@none#FF001234,1.0@none#FF001234,'
            '1.0@none#FF001234,2.0@none#FF001234),'
            'child=[RichText:dir=rtl,(:Foo)]]',
          ),
        );
      });
    });

    testWidgets('overwrites style', (tester) async {
      const html =
          '<span style="border: 1px; border-top: 1px solid">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'border=(1.0@solid#FF001234,1.0@none#FF001234,'
          '1.0@none#FF001234,1.0@none#FF001234),'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('overwrites color', (tester) async {
      const html =
          '<span style="border: 1px; border-top: 1px none red">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'border=(1.0@none#FFFF0000,1.0@none#FF001234,'
          '1.0@none#FF001234,1.0@none#FF001234),'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('resets to none', (tester) async {
      const html = '<span style="border: 1px; border-top: none">Foo</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:'
          'border=(none,1.0@none#FF001234,1.0@none#FF001234,1.0@none#FF001234),'
          'child=[RichText:(:Foo)]]',
        ),
      );
    });
  });

  group('isBlockElement', () {
    testWidgets('parses border', (WidgetTester tester) async {
      const html = '<div style="border: 1px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child='
          '[Container:border=$_border1,child=[RichText:(:Foo)]]'
          ']',
        ),
      );
    });

    testWidgets('parses border-top', (WidgetTester tester) async {
      const html = '<div style="border-top: 1px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[Container:'
          'border=(1.0@none#FF001234,none,none,none),'
          'child=[RichText:(:Foo)]]]',
        ),
      );
    });

    testWidgets('parses border-block-start', (WidgetTester tester) async {
      const html = '<div style="border-block-start: 1px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[Container:'
          'border=(1.0@none#FF001234,none,none,none),'
          'child=[RichText:(:Foo)]]]',
        ),
      );
    });

    testWidgets('parses border-right', (WidgetTester tester) async {
      const html = '<div style="border-right: 1px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[Container:'
          'border=(none,1.0@none#FF001234,none,none),'
          'child=[RichText:(:Foo)]]]',
        ),
      );
    });

    testWidgets('parses border-bottom', (WidgetTester tester) async {
      const html = '<div style="border-bottom: 1px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[Container:'
          'border=(none,none,1.0@none#FF001234,none),'
          'child=[RichText:(:Foo)]]]',
        ),
      );
    });

    testWidgets('parses border-block-end', (WidgetTester tester) async {
      const html = '<div style="border-block-end: 1px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[Container:'
          'border=(none,none,1.0@none#FF001234,none),'
          'child=[RichText:(:Foo)]]]',
        ),
      );
    });

    testWidgets('parses border-left', (WidgetTester tester) async {
      const html = '<div style="border-left: 1px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[Container:'
          'border=(none,none,none,1.0@none#FF001234),'
          'child=[RichText:(:Foo)]]]',
        ),
      );
    });

    group('parses border-inline-start', () {
      const html = '<div style="border-inline-start: 1px">Foo</div>';

      testWidgets('ltr', (WidgetTester tester) async {
        final explained = await explain(tester, html);
        expect(
          explained,
          equals(
            '[CssBlock:child=[Container:'
            'border=(none,none,none,1.0@none#FF001234),'
            'child=[RichText:(:Foo)]]]',
          ),
        );
      });

      testWidgets('rtl', (WidgetTester tester) async {
        final explained = await explain(tester, html, rtl: true);
        expect(
          explained,
          equals(
            '[CssBlock:child=[Container:'
            'border=(none,1.0@none#FF001234,none,none),'
            'child=[RichText:dir=rtl,(:Foo)]]]',
          ),
        );
      });
    });

    group('parses border-inline-end', () {
      const html = '<div style="border-inline-end: 1px">Foo</div>';

      testWidgets('ltr', (WidgetTester tester) async {
        final explained = await explain(tester, html);
        expect(
          explained,
          equals(
            '[CssBlock:child=[Container:'
            'border=(none,1.0@none#FF001234,none,none),'
            'child=[RichText:(:Foo)]]]',
          ),
        );
      });

      testWidgets('rtl', (WidgetTester tester) async {
        final explained = await explain(tester, html, rtl: true);
        expect(
          explained,
          equals(
            '[CssBlock:child=[Container:'
            'border=(none,none,none,1.0@none#FF001234),'
            'child=[RichText:dir=rtl,(:Foo)]]]',
          ),
        );
      });
    });
  });

  group('combos', () {
    testWidgets('renders with background & h2', (WidgetTester tester) async {
      const html = '<div style="background: red; border: 1px solid">'
          '<h2>Foo</h2></div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child='
          '[Container:bg=#FFFF0000,border=1.0@solid#FF001234,child='
          '[Column:children='
          '[SizedBox:0.0x12.4],'
          '[CssBlock:child=[RichText:(@15.0+b:Foo)]],'
          '[SizedBox:0.0x12.4]'
          ']]]',
        ),
      );
    });

    testWidgets('renders border-box with background', (tester) async {
      const html =
          '<div style="background: red; border: 1px solid red; box-sizing: border-box">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child='
          '[DecoratedBox:bg=#FFFF0000,border=1.0@solid#FFFF0000,child='
          '[RichText:(:Foo)]]]',
        ),
      );
    });

    testWidgets('renders content-box with background', (tester) async {
      const html =
          '<div style="background: red; border: 1px solid red; box-sizing: content-box">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child='
          '[Container:bg=#FFFF0000,border=1.0@solid#FFFF0000,child='
          '[RichText:(:Foo)]]]',
        ),
      );
    });
  });

  group('error handling', () {
    testWidgets('3 values', (WidgetTester tester) async {
      const html = '<span style="border: a b c">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('2 values', (WidgetTester tester) async {
      const html = '<span style="border: a b">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('1 value', (WidgetTester tester) async {
      const html = '<span style="border: a">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('negative value', (WidgetTester tester) async {
      const html = '<span style="border: -1px">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });
  });
}
