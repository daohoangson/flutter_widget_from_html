import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '_.dart';

void main() {
  testWidgets('renders SUB tag', (WidgetTester tester) async {
    const html = '<sub>Foo</sub>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[Align:alignment=bottomCenter,child='
        '[Padding:(3,0,0,0),child=[RichText:(@8.3:Foo)]]'
        ']',
      ),
    );
  });

  testWidgets('renders SUP tag', (WidgetTester tester) async {
    const html = '<sup>Foo</sup>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[Align:alignment=topCenter,child='
        '[Padding:(0,0,3,0),child=[RichText:(@8.3:Foo)]]'
        ']',
      ),
    );
  });

  testWidgets('renders baseline text', (WidgetTester tester) async {
    const html = '<span style="vertical-align: baseline">Foo</span> bar';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:(:Foo bar)]'));
  });

  testWidgets('renders top text', (WidgetTester tester) async {
    const html = '<span style="vertical-align: top">Foo</span> bar';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:(:[RichText:(:Foo)]@top(: bar))]'));
  });

  testWidgets('renders bottom text', (WidgetTester tester) async {
    const html = '<span style="vertical-align: bottom">Foo</span> bar';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:(:[RichText:(:Foo)]@bottom(: bar))]'));
  });

  testWidgets('renders middle text', (WidgetTester tester) async {
    const html = '<span style="vertical-align: middle">Foo</span> bar';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:(:[RichText:(:Foo)]@middle(: bar))]'));
  });

  testWidgets('renders sub text', (WidgetTester tester) async {
    const html = '<span style="vertical-align: sub">Foo</span> bar';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[RichText:(:'
        '[Align:alignment=bottomCenter,child='
        '[Padding:(4,0,0,0),child=[RichText:(:Foo)]]'
        ']@top'
        '(: bar)'
        ')]',
      ),
    );
  });

  testWidgets('renders super text', (WidgetTester tester) async {
    const html = '<span style="vertical-align: super">Foo</span> bar';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[RichText:(:'
        '[Align:alignment=topCenter,child='
        '[Padding:(0,0,4,0),child=[RichText:(:Foo)]]'
        ']@bottom'
        '(: bar)'
        ')]',
      ),
    );
  });

  group('image', () {
    const imgSrc = 'http://domain.com/image.png';
    const imgRendered =
        '[CssSizing:height≥0.0,height=auto,width≥0.0,width=auto,child='
        '[Image:image=NetworkImage("$imgSrc", scale: 1.0)]'
        ']';
    Future<String> imgExplain(WidgetTester t, String html) =>
        mockNetworkImages(() => explain(t, html));

    testWidgets('renders top image', (WidgetTester tester) async {
      const html = '<img src="$imgSrc" style="vertical-align: top" /> foo';
      final explained = await imgExplain(tester, html);
      expect(explained, equals('[RichText:(:$imgRendered@top(: foo))]'));
    });

    testWidgets('renders after image', (WidgetTester tester) async {
      const html = '<img src="$imgSrc" /><sup>Foo</sup>';
      final explained = await imgExplain(tester, html);
      expect(
        explained,
        equals(
          '[RichText:(:$imgRendered'
          '[Align:alignment=topCenter,child='
          '[Padding:(0,0,3,0),child=[RichText:(@8.3:Foo)]]'
          ']@bottom)]',
        ),
      );
    });
  });

  testWidgets('renders styling', (WidgetTester tester) async {
    const html = '<span style="vertical-align: top">F<em>o</em>o</span> bar';
    final e = await explain(tester, html);
    expect(e, equals('[RichText:(:[RichText:(:F(+i:o)(:o))]@top(: bar))]'));
  });

  testWidgets('renders styling from outside', (WidgetTester tester) async {
    const html = '<em><span style="vertical-align: top">Foo</span></em> bar';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:(:[RichText:(+i:Foo)]@top(: bar))]'));
  });

  group('isBlockElement', () {
    group('renders top', () {
      const html = '<div style="vertical-align: top">Foo</span>';

      testWidgets('ltr', (WidgetTester tester) async {
        final explained = await explain(tester, html);
        expect(
          explained,
          equals(
            '[Align:alignment=topLeft,child='
            '[CssBlock:child='
            '[RichText:(:Foo)]]]',
          ),
        );
      });

      testWidgets('rtl', (WidgetTester tester) async {
        final explained = await explain(tester, html, rtl: true);
        expect(
          explained,
          equals(
            '[Align:alignment=topRight,child='
            '[CssBlock:child='
            '[RichText:dir=rtl,(:Foo)]]]',
          ),
        );
      });
    });

    group('renders middle', () {
      const html = '<div style="vertical-align: middle">Foo</span>';

      testWidgets('ltr', (WidgetTester tester) async {
        final explained = await explain(tester, html);
        expect(
          explained,
          equals(
            '[Align:alignment=centerLeft,child='
            '[CssBlock:child='
            '[RichText:(:Foo)]]]',
          ),
        );
      });

      testWidgets('rtl', (WidgetTester tester) async {
        final explained = await explain(tester, html, rtl: true);
        expect(
          explained,
          equals(
            '[Align:alignment=centerRight,child='
            '[CssBlock:child='
            '[RichText:dir=rtl,(:Foo)]]]',
          ),
        );
      });
    });

    group('renders bottom', () {
      const html = '<div style="vertical-align: bottom">Foo</span>';

      testWidgets('ltr', (WidgetTester tester) async {
        final explained = await explain(tester, html);
        expect(
          explained,
          equals(
            '[Align:alignment=bottomLeft,child='
            '[CssBlock:child='
            '[RichText:(:Foo)]]]',
          ),
        );
      });

      testWidgets('rtl', (WidgetTester tester) async {
        final explained = await explain(tester, html, rtl: true);
        expect(
          explained,
          equals(
            '[Align:alignment=bottomRight,child='
            '[CssBlock:child='
            '[RichText:dir=rtl,(:Foo)]]]',
          ),
        );
      });
    });
  });

  group('error handling', () {
    testWidgets('renders empty tag', (WidgetTester tester) async {
      const html = 'Foo <sub></sub>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('renders empty SPAN inside', (WidgetTester tester) async {
      const html = 'Foo <sup><span></span></sup>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('renders empty DIV inside', (WidgetTester tester) async {
      const html = 'Foo <sup><div></div></sup>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('#170: renders whitespace contents', (tester) async {
      const html = 'Foo <sub> </sub>';
      final explained = await explain(tester, html);
      // TODO: drop widget0 if possible
      expect(explained, equals('[RichText:(:Foo [widget0]@top)]'));
    });
  });
}
