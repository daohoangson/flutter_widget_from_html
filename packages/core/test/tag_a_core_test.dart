import 'package:flutter_test/flutter_test.dart';

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
            '(#FF0000FF+u: )(#FF0000FF+u+onTap:bar)'
            '(:.)'
            ')]'));
  });

  testWidgets('renders DIV tag inside', (WidgetTester tester) async {
    final html = '<a href="$kHref"><div>Foo</div></a>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals('[GestureDetector:child=[RichText:(#FF0000FF+u:Foo)]]'),
    );
  });

  testWidgets('renders DIV tags inside', (WidgetTester tester) async {
    final html = '<a href="$kHref"><div>Foo</div><div>Bar</div></a>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[Column:children='
        '[GestureDetector:child=[RichText:(#FF0000FF+u:Foo)]],'
        '[GestureDetector:child=[RichText:(#FF0000FF+u:Bar)]]]',
      ),
    );
  });

  testWidgets('renders margin inside', (WidgetTester tester) async {
    final html = '<a href="$kHref"><div style="margin: 5px">Foo</div></a>';
    final explained = await explainMargin(tester, html);
    expect(
        explained,
        equals('[SizedBox:0.0x5.0],'
            '[GestureDetector:child=[Padding:(0,5,0,5),child=[RichText:(#FF0000FF+u:Foo)]]],'
            '[SizedBox:0.0x5.0]'));
  });

  group('IMG', () {
    testWidgets('renders IMG tag inside', (WidgetTester tester) async {
      final html = '<a href="$kHref"><img src="$kImgSrc" /></a>';
      final e = await explain(tester, html);
      expect(e, equals('[GestureDetector:child=[NetworkImage:url=$kImgSrc]]'));
    });

    testWidgets('renders text + IMG tag both inside', (tester) async {
      final html = '<a href="$kHref">Foo <img src="$kImgSrc" /></a>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[RichText:(:(#FF0000FF+u+onTap:Foo)(#FF0000FF+u: )'
              '[GestureDetector:child=[NetworkImage:url=$kImgSrc]])]'));
    });

    testWidgets('renders text outside + IMG tag inside', (tester) async {
      final html = 'Foo <a href="$kHref"><img src="$kImgSrc" /></a>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[RichText:(:Foo '
              '[GestureDetector:child=[NetworkImage:url=$kImgSrc]])]'));
    });

    testWidgets('renders IMG tag + text both inside', (tester) async {
      final html = '<a href="$kHref"><img src="$kImgSrc" /> foo</a>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[RichText:(:'
              '[GestureDetector:child=[NetworkImage:url=$kImgSrc]]'
              '(#FF0000FF+u: )(#FF0000FF+u+onTap:foo))]'));
    });

    testWidgets('renders IMG tag inside + text outside', (tester) async {
      final html = '<a href="$kHref"><img src="$kImgSrc" /></a> foo';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[RichText:(:'
              '[GestureDetector:child=[NetworkImage:url=$kImgSrc]]'
              '(: foo))]'));
    });
  });
}
