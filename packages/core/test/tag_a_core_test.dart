import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '_.dart';

const kHref = 'http://domain.com/href';
const kImgSrc = 'http://domain.com/image.png';

void main() {
  testWidgets('renders underline', (WidgetTester tester) async {
    final html = '<a href="$kHref">Foo</a>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:(#FF0000FF+u+onTap:Foo)]'));
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
    final html = 'Hello <a href="$kHref">f<b>o<i>o</i></b> bar</a>.';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[RichText:(:Hello '
            '(#FF0000FF+u+onTap:f)'
            '(#FF0000FF+u+b+onTap:o)'
            '(#FF0000FF+u+i+b+onTap:o)'
            '(#FF0000FF+u+onTap: bar)'
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

    testWidgets('renders IMG tag inside', (WidgetTester tester) async {
      final html = '<a href="$kHref"><img src="$kImgSrc" /></a>';
      final explained = await explainImg(tester, html);
      expect(
          explained,
          equals('[GestureDetector:child='
              '[Image:image=NetworkImage("$kImgSrc", scale: 1.0)]'
              ']'));
    });

    testWidgets('renders text + IMG tag both inside', (tester) async {
      final html = '<a href="$kHref">Foo <img src="$kImgSrc" /></a>';
      final explained = await explainImg(tester, html);
      expect(
          explained,
          equals('[RichText:(:'
              '(#FF0000FF+u+onTap:Foo )'
              '[GestureDetector:child=[Image:image=NetworkImage("$kImgSrc", scale: 1.0)]]'
              ')]'));
    });

    testWidgets('renders text outside + IMG tag inside', (tester) async {
      final html = 'Foo <a href="$kHref"><img src="$kImgSrc" /></a>';
      final explained = await explainImg(tester, html);
      expect(
          explained,
          equals('[RichText:(:Foo '
              '[GestureDetector:child=[Image:image=NetworkImage("$kImgSrc", scale: 1.0)]]'
              ')]'));
    });

    testWidgets('renders IMG tag + text both inside', (tester) async {
      final html = '<a href="$kHref"><img src="$kImgSrc" /> foo</a>';
      final explained = await explainImg(tester, html);
      expect(
          explained,
          equals('[RichText:(:'
              '[GestureDetector:child=[Image:image=NetworkImage("$kImgSrc", scale: 1.0)]]'
              '(#FF0000FF+u+onTap: foo)'
              ')]'));
    });

    testWidgets('renders IMG tag inside + text outside', (tester) async {
      final html = '<a href="$kHref"><img src="$kImgSrc" /></a> foo';
      final explained = await explainImg(tester, html);
      expect(
          explained,
          equals('[RichText:(:'
              '[GestureDetector:child=[Image:image=NetworkImage("$kImgSrc", scale: 1.0)]]'
              '(: foo))]'));
    });
  });
}
