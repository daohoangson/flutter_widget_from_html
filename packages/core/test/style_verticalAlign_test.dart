import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '_.dart';

void main() {
  testWidgets('renders SUB tag', (WidgetTester tester) async {
    final html = '<sub>Foo</sub>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[RichText:[Stack:children='
            '[Padding:(0,0,3,0),child=[Opacity:child=[RichText:(@8.3:Foo)]]],'
            '[Positioned:(null,null,0.0,null),child=[RichText:(@8.3:Foo)]]'
            ']@top]'));
  });

  testWidgets('renders SUP tag', (WidgetTester tester) async {
    final html = '<sup>Foo</sup>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[RichText:[Stack:children='
            '[Padding:(3,0,0,0),child=[Opacity:child=[RichText:(@8.3:Foo)]]],'
            '[Positioned:(0.0,null,null,null),child=[RichText:(@8.3:Foo)]]'
            ']@bottom]'));
  });

  testWidgets('renders baseline text', (WidgetTester tester) async {
    final html = '<span style="vertical-align: baseline">Foo</span>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:(:Foo)]'));
  });

  testWidgets('renders top text', (WidgetTester tester) async {
    final html = '<span style="vertical-align: top">Foo</span>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:[RichText:(:Foo)]@top]'));
  });

  testWidgets('renders bottom text', (WidgetTester tester) async {
    final html = '<span style="vertical-align: bottom">Foo</span>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:[RichText:(:Foo)]@bottom]'));
  });

  testWidgets('renders middle text', (WidgetTester tester) async {
    final html = '<span style="vertical-align: middle">Foo</span>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:[RichText:(:Foo)]@middle]'));
  });
  testWidgets('renders sub text', (WidgetTester tester) async {
    final html = '<span style="vertical-align: sub">Foo</span>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[RichText:[Stack:children='
            '[Padding:(0,0,4,0),child=[Opacity:child=[RichText:(:Foo)]]],'
            '[Positioned:(null,null,0.0,null),child=[RichText:(:Foo)]]'
            ']@top]'));
  });

  testWidgets('renders super text', (WidgetTester tester) async {
    final html = '<span style="vertical-align: super">Foo</span>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[RichText:[Stack:children='
            '[Padding:(4,0,0,0),child=[Opacity:child=[RichText:(:Foo)]]],'
            '[Positioned:(0.0,null,null,null),child=[RichText:(:Foo)]]'
            ']@bottom]'));
  });

  group('image', () {
    final imgSrc = 'http://domain.com/image.png';
    final imgRendered =
        '[CssSizing:height≥0.0,height=auto,width≥0.0,width=auto,child='
        '[Image:image=NetworkImage("$imgSrc", scale: 1.0)]'
        ']';
    final imgExplain = (WidgetTester t, String html) =>
        mockNetworkImagesFor(() => explain(t, html));

    testWidgets('renders top image', (WidgetTester tester) async {
      final html = '<img src="$imgSrc" style="vertical-align: top" />';
      final explained = await imgExplain(tester, html);
      expect(explained, equals('[RichText:$imgRendered@top]'));
    });

    testWidgets('renders bottom image', (WidgetTester tester) async {
      final html = '<img src="$imgSrc" style="vertical-align: bottom" />';
      final explained = await imgExplain(tester, html);
      expect(explained, equals('[RichText:$imgRendered@bottom]'));
    });

    testWidgets('renders middle image', (WidgetTester tester) async {
      final html = '<img src="$imgSrc" style="vertical-align: middle" />';
      final explained = await imgExplain(tester, html);
      expect(explained, equals('[RichText:$imgRendered@middle]'));
    });

    testWidgets('renders after image', (WidgetTester tester) async {
      final html = '<img src="$imgSrc" /><sup>Foo</sup>';
      final explained = await imgExplain(tester, html);
      expect(
          explained,
          equals('[RichText:(:$imgRendered'
              '[Stack:children='
              '[Padding:(3,0,0,0),child=[Opacity:child=[RichText:(@8.3:Foo)]]],'
              '[Positioned:(0.0,null,null,null),child=[RichText:(@8.3:Foo)]]'
              ']@bottom)]'));
    });
  });

  testWidgets('renders styling', (WidgetTester tester) async {
    final html = '<span style="vertical-align: top">F<em>o</em>o</span>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:[RichText:(:F(+i:o)(:o))]@top]'));
  });

  testWidgets('renders styling from outside', (WidgetTester tester) async {
    final html = '<em><span style="vertical-align: top">Foo</span></em>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:[RichText:(+i:Foo)]@top]'));
  });

  group('isBlockElement', () {
    group('renders top', () {
      final html = '<div style="vertical-align: top">Foo</span>';

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
      final html = '<div style="vertical-align: middle">Foo</span>';

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
      final html = '<div style="vertical-align: bottom">Foo</span>';

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
      final html = 'Foo <sub></sub>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('renders empty SPAN inside', (WidgetTester tester) async {
      final html = 'Foo <sup><span></span></sup>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('renders empty DIV inside', (WidgetTester tester) async {
      final html = 'Foo <sup><div></div></sup>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('#159: renders CODE of whitespaces inside', (tester) async {
      final html = 'Foo <sup><code>\n  \n\n\n</code></sup>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('#170: renders whitespace contents', (tester) async {
      final html = 'Foo <sub> </sub>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('#170: renders trailing whitespace contents', (tester) async {
      final html = 'Foo <sub>bar </sub>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[RichText:(:'
              'Foo '
              '[Stack:children='
              '[Padding:(0,0,3,0),child=[Opacity:child=[RichText:(@8.3:bar)]]],'
              '[Positioned:(null,null,0.0,null),child=[RichText:(@8.3:bar)]]'
              ']@top)]'));
    });
  });
}
