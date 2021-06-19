import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '_.dart';

void main() {
  testWidgets('renders SUB tag', (WidgetTester tester) async {
    const html = '<sub>Foo</sub>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[RichText:'
            '[Align:alignment=bottomCenter,child='
            '[Padding:(3,0,0,0),child=[RichText:(@8.3:Foo)]]'
            ']@top]'));
  });

  testWidgets('renders SUP tag', (WidgetTester tester) async {
    const html = '<sup>Foo</sup>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[RichText:'
            '[Align:alignment=topCenter,child='
            '[Padding:(0,0,3,0),child=[RichText:(@8.3:Foo)]]'
            ']@bottom]'));
  });

  testWidgets('renders baseline text', (WidgetTester tester) async {
    const html = '<span style="vertical-align: baseline">Foo</span>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:(:Foo)]'));
  });

  testWidgets('renders top text', (WidgetTester tester) async {
    const html = '<span style="vertical-align: top">Foo</span>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:[RichText:(:Foo)]@top]'));
  });

  testWidgets('renders bottom text', (WidgetTester tester) async {
    const html = '<span style="vertical-align: bottom">Foo</span>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:[RichText:(:Foo)]@bottom]'));
  });

  testWidgets('renders middle text', (WidgetTester tester) async {
    const html = '<span style="vertical-align: middle">Foo</span>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:[RichText:(:Foo)]@middle]'));
  });

  testWidgets('renders sub text', (WidgetTester tester) async {
    const html = '<span style="vertical-align: sub">Foo</span>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[RichText:'
            '[Align:alignment=bottomCenter,child='
            '[Padding:(4,0,0,0),child=[RichText:(:Foo)]]'
            ']@top]'));
  });

  testWidgets('renders super text', (WidgetTester tester) async {
    const html = '<span style="vertical-align: super">Foo</span>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[RichText:'
            '[Align:alignment=topCenter,child='
            '[Padding:(0,0,4,0),child=[RichText:(:Foo)]]'
            ']@bottom]'));
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
      const html = '<img src="$imgSrc" style="vertical-align: top" />';
      final explained = await imgExplain(tester, html);
      expect(explained, equals('[RichText:$imgRendered@top]'));
    });

    testWidgets('renders bottom image', (WidgetTester tester) async {
      const html = '<img src="$imgSrc" style="vertical-align: bottom" />';
      final explained = await imgExplain(tester, html);
      expect(explained, equals('[RichText:$imgRendered@bottom]'));
    });

    testWidgets('renders middle image', (WidgetTester tester) async {
      const html = '<img src="$imgSrc" style="vertical-align: middle" />';
      final explained = await imgExplain(tester, html);
      expect(explained, equals('[RichText:$imgRendered@middle]'));
    });

    testWidgets('renders after image', (WidgetTester tester) async {
      const html = '<img src="$imgSrc" /><sup>Foo</sup>';
      final explained = await imgExplain(tester, html);
      expect(
          explained,
          equals('[RichText:(:$imgRendered'
              '[Align:alignment=topCenter,child='
              '[Padding:(0,0,3,0),child=[RichText:(@8.3:Foo)]]'
              ']@bottom)]'));
    });
  });

  testWidgets('renders styling', (WidgetTester tester) async {
    const html = '<span style="vertical-align: top">F<em>o</em>o</span>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:[RichText:(:F(+i:o)(:o))]@top]'));
  });

  testWidgets('renders styling from outside', (WidgetTester tester) async {
    const html = '<em><span style="vertical-align: top">Foo</span></em>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:[RichText:(+i:Foo)]@top]'));
  });

  group('isBlockElement', () {
    group('renders top', () {
      const html = '<div style="vertical-align: top">Foo</span>';

      testWidgets('ltr', (WidgetTester tester) async {
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[CssBlock:child=[Align:alignment=topLeft,child='
                '[RichText:(:Foo)]]]'));
      });

      testWidgets('rtl', (WidgetTester tester) async {
        final explained = await explain(tester, html, rtl: true);
        expect(
            explained,
            equals('[CssBlock:child=[Align:alignment=topRight,child='
                '[RichText:dir=rtl,(:Foo)]]]'));
      });
    });

    group('renders middle', () {
      const html = '<div style="vertical-align: middle">Foo</span>';

      testWidgets('ltr', (WidgetTester tester) async {
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[CssBlock:child=[Align:alignment=centerLeft,child='
                '[RichText:(:Foo)]]]'));
      });

      testWidgets('rtl', (WidgetTester tester) async {
        final explained = await explain(tester, html, rtl: true);
        expect(
            explained,
            equals('[CssBlock:child=[Align:alignment=centerRight,child='
                '[RichText:dir=rtl,(:Foo)]]]'));
      });
    });

    group('renders bottom', () {
      const html = '<div style="vertical-align: bottom">Foo</span>';

      testWidgets('ltr', (WidgetTester tester) async {
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[CssBlock:child=[Align:alignment=bottomLeft,child='
                '[RichText:(:Foo)]]]'));
      });

      testWidgets('rtl', (WidgetTester tester) async {
        final explained = await explain(tester, html, rtl: true);
        expect(
            explained,
            equals('[CssBlock:child=[Align:alignment=bottomRight,child='
                '[RichText:dir=rtl,(:Foo)]]]'));
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
      expect(explained, equals('[RichText:(:Foo)]'));
    });
  });
}
