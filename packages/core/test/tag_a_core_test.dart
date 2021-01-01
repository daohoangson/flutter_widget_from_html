import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '_.dart';

const kHref = 'http://domain.com/href';
const kImgSrc = 'http://domain.com/image.png';

void main() {
  group('basic usage', () {
    final html = '<a href="$kHref">Foo</a>';

    testWidgets('renders', (WidgetTester tester) async {
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(#FF0000FF+u+onTap:Foo)]'));
    });

    testWidgets('useExplainer=false', (WidgetTester tester) async {
      final explained = await explain(tester, html, useExplainer: false);
      expect(
          explained,
          equals('TshWidget\n'
              '└WidgetPlaceholder<BuildTree>(BuildTree#0 tsb#1:\n'
              ' │  BuildTree#2 tsb#3(parent=#1):\n'
              ' │    "Foo"\n'
              ' │    _TagABit#4 tsb#3(parent=#1)\n'
              ' │)\n'
              ' └RichText(text: "Foo")\n\n'));
    });
  });

  group('renders without erroneous white spaces', () {
    testWidgets('first', (WidgetTester tester) async {
      final html = '<a href="$kHref"> Foo</a>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(#FF0000FF+u+onTap:Foo)]'));
    });

    testWidgets('last', (WidgetTester tester) async {
      final html = '<a href="$kHref">Foo </a>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(#FF0000FF+u+onTap:Foo)]'));
    });
  });

  testWidgets('renders inline stylings', (WidgetTester tester) async {
    final html = '<a href="$kHref" style="color: #f00">Foo</a>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:(#FFFF0000+u+onTap:Foo)]'));
  });

  testWidgets('renders complicated stylings', (WidgetTester tester) async {
    final html = 'Hello <a href="$kHref">f<b>o<i>o</i></b> <br /> bar</a>.';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[RichText:(:Hello '
            '(#FF0000FF+u+onTap:f)'
            '(#FF0000FF+u+b+onTap:o)'
            '(#FF0000FF+u+i+b+onTap:o)'
            '(#FF0000FF+u+onTap: \nbar)'
            '(:.)'
            ')]'));
  });

  testWidgets('renders DIV tag inside', (WidgetTester tester) async {
    final html = '<a href="$kHref"><div>Foo</div></a>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals('[GestureDetector:child='
          '[CssBlock:child=[RichText:(#FF0000FF+u:Foo)]]'
          ']'),
    );
  });

  testWidgets('renders DIV tags inside', (WidgetTester tester) async {
    final html = '<a href="$kHref"><div>Foo</div><div>Bar</div></a>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[Column:children='
        '[GestureDetector:child=[CssBlock:child=[RichText:(#FF0000FF+u:Foo)]]],'
        '[GestureDetector:child=[CssBlock:child=[RichText:(#FF0000FF+u:Bar)]]]'
        ']',
      ),
    );
  });

  testWidgets('renders empty inside', (tester) async {
    final html = '<a href="$kHref""></a>';
    final explained = await explain(tester, html);
    expect(explained, equals('[widget0]'));
  });

  testWidgets('renders DIV tag inside (display: block)', (tester) async {
    final html = '<a href="$kHref" style="display: block"><div>Foo</div></a>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals('[CssBlock:child=[GestureDetector:child='
          '[CssBlock:child=[RichText:(#FF0000FF+u:Foo)]]'
          ']]'),
    );
  });

  testWidgets('renders DIV tags inside (display: block)', (tester) async {
    final html = '<a href="$kHref" style="display: block">'
        '<div>Foo</div><div>Bar</div></a>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[CssBlock:child=[GestureDetector:child=[Column:children='
        '[CssBlock:child=[RichText:(#FF0000FF+u:Foo)]],'
        '[CssBlock:child=[RichText:(#FF0000FF+u:Bar)]]'
        ']]]',
      ),
    );
  });

  testWidgets('renders empty inside (display: block)', (tester) async {
    final html = '<a href="$kHref" style="display: block"></a>';
    final explained = await explain(tester, html);
    expect(explained, equals('[widget0]'));
  });

  testWidgets('renders empty background-color inside (#215)', (tester) async {
    final h = '<a href="$kHref"><div style="background-color: red"></div></a>';
    final explained = await explain(tester, h);
    expect(explained, equals('[widget0]'));
  });

  testWidgets('renders margin inside', (WidgetTester tester) async {
    final html = '<a href="$kHref"><div style="margin: 5px">Foo</div></a>';
    final explained = await explainMargin(tester, html);
    expect(
        explained,
        equals('[SizedBox:0.0x5.0],'
            '[GestureDetector:child=[Padding:(0,5,0,5),child=[CssBlock:child=[RichText:(#FF0000FF+u:Foo)]]]],'
            '[SizedBox:0.0x5.0]'));
  });

  group('IMG', () {
    final explainImg = (WidgetTester tester, String html) =>
        mockNetworkImagesFor(() => explain(tester, html));
    final sizingConstraints = 'height≥0.0,height=auto,width≥0.0,width=auto';

    testWidgets('renders IMG tag inside', (WidgetTester tester) async {
      final html = '<a href="$kHref"><img src="$kImgSrc" /></a>';
      final explained = await explainImg(tester, html);
      expect(
          explained,
          equals('[GestureDetector:child='
              '[CssSizing:$sizingConstraints,child=[Image:image=NetworkImage("$kImgSrc", scale: 1.0)]]'
              ']'));
    });

    testWidgets('renders text + IMG tag both inside', (tester) async {
      final html = '<a href="$kHref">Foo <img src="$kImgSrc" /></a>';
      final explained = await explainImg(tester, html);
      expect(
          explained,
          equals('[RichText:(:'
              '(#FF0000FF+u+onTap:Foo )'
              '[GestureDetector:child='
              '[CssSizing:$sizingConstraints,child=[Image:image=NetworkImage("$kImgSrc", scale: 1.0)]]'
              '])]'));
    });

    testWidgets('renders text outside + IMG tag inside', (tester) async {
      final html = 'Foo <a href="$kHref"><img src="$kImgSrc" /></a>';
      final explained = await explainImg(tester, html);
      expect(
          explained,
          equals('[RichText:(:Foo '
              '[GestureDetector:child='
              '[CssSizing:$sizingConstraints,child=[Image:image=NetworkImage("$kImgSrc", scale: 1.0)]]'
              '])]'));
    });

    testWidgets('renders IMG tag + text both inside', (tester) async {
      final html = '<a href="$kHref"><img src="$kImgSrc" /> foo</a>';
      final explained = await explainImg(tester, html);
      expect(
          explained,
          equals('[RichText:(:'
              '[GestureDetector:child='
              '[CssSizing:$sizingConstraints,child=[Image:image=NetworkImage("$kImgSrc", scale: 1.0)]]'
              ']'
              '(#FF0000FF+u+onTap: foo)'
              ')]'));
    });

    testWidgets('renders IMG tag inside + text outside', (tester) async {
      final html = '<a href="$kHref"><img src="$kImgSrc" /></a> foo';
      final explained = await explainImg(tester, html);
      expect(
          explained,
          equals('[RichText:(:'
              '[GestureDetector:child='
              '[CssSizing:$sizingConstraints,child=[Image:image=NetworkImage("$kImgSrc", scale: 1.0)]]'
              ']'
              '(: foo))]'));
    });
  });

  group('tap test', () {
    testWidgets('triggers callback', (WidgetTester tester) async {
      final urls = <String>[];
      await tester.pumpWidget(_TapTestApp(onTapUrl: urls.add));
      await tester.pumpAndSettle();
      expect(await tapText(tester, 'Tap me'), equals(1));
      expect(urls, equals(const [kHref]));
    });

    testWidgets('prints log', (WidgetTester tester) async {
      await tester.pumpWidget(_TapTestApp());
      await tester.pumpAndSettle();
      expect(await tapText(tester, 'Tap me'), equals(1));
    });
  });
}

class _TapTestApp extends StatelessWidget {
  final void Function(String) onTapUrl;

  const _TapTestApp({Key key, this.onTapUrl}) : super(key: key);

  @override
  Widget build(BuildContext _) => MaterialApp(
        home: Scaffold(
          body: HtmlWidget(
            '<a href="$kHref">Tap me</a>',
            onTapUrl: onTapUrl,
          ),
        ),
      );
}
