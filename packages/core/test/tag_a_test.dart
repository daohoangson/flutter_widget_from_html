import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:flutter_widget_from_html_core/src/internal/core_ops.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '_.dart';

const kHref = 'http://domain.com/href';
const kImgSrc = 'http://domain.com/image.png';

void main() {
  testWidgets('renders A tag', (WidgetTester tester) async {
    const html = '<a href="$kHref">Foo</a>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:(#FF123456+u+onTap:Foo)]'));
  });

  testWidgets('renders A tags', (WidgetTester tester) async {
    const html = 'Hello <a href="$kHref">foo</a> & <a href="$kHref">bar</a>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[RichText:(:Hello '
        '(#FF123456+u+onTap:foo)'
        '(: & )'
        '(#FF123456+u+onTap:bar)'
        ')]',
      ),
    );
  });

  group('renders without erroneous white spaces', () {
    testWidgets('first', (WidgetTester tester) async {
      const html = '<a href="$kHref"> Foo</a>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(#FF123456+u+onTap:Foo)]'));
    });

    testWidgets('last', (WidgetTester tester) async {
      const html = '<a href="$kHref">Foo </a>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(#FF123456+u+onTap:Foo)]'));
    });
  });

  testWidgets('renders inline stylings', (WidgetTester tester) async {
    const html = '<a href="$kHref" style="color: #f00">Foo</a>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:(#FFFF0000+u+onTap:Foo)]'));
  });

  testWidgets('renders complicated stylings', (WidgetTester tester) async {
    const html = 'Hello <a href="$kHref">f<b>o<i>o</i></b> <br /> bar</a>.';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[RichText:(:Hello '
        '(#FF123456+u+onTap:f)'
        '(#FF123456+u+b+onTap:o)'
        '(#FF123456+u+i+b+onTap:o)'
        '(#FF123456+u+onTap: \nbar)'
        '(:.)'
        ')]',
      ),
    );
  });

  group('display: inline', () {
    testWidgets('renders DIV tag', (WidgetTester tester) async {
      const html = '<a href="$kHref"><div>Foo</div></a>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[MouseRegion:child=[GestureDetector:child='
          '[CssBlock:child=[RichText:(#FF123456+u:Foo)]]'
          ']]',
        ),
      );
    });

    testWidgets('renders DIV tags', (WidgetTester tester) async {
      const html = '<a href="$kHref"><div>Foo</div><div>Bar</div></a>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Column:children='
          '[MouseRegion:child=[GestureDetector:child='
          '[CssBlock:child=[RichText:(#FF123456+u:Foo)]]]],'
          '[MouseRegion:child=[GestureDetector:child='
          '[CssBlock:child=[RichText:(#FF123456+u:Bar)]]]]'
          ']',
        ),
      );
    });

    testWidgets('renders SPAN tag', (WidgetTester tester) async {
      const html = '<a href="$kHref"><span>Foo</span></a>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(#FF123456+u+onTap:Foo)]'));
    });

    testWidgets('renders SPAN tags', (WidgetTester tester) async {
      const html = '<a href="$kHref"><span>Foo</span> <span>bar</span></a>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(#FF123456+u+onTap:Foo bar)]'));
    });

    testWidgets('renders DIV and SPAN tags', (tester) async {
      const html = '<a href="$kHref"><div>Foo</div> <span>bar</span></a>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Column:children='
          '[MouseRegion:child=[GestureDetector:child=[CssBlock:child=[RichText:(#FF123456+u:Foo)]]]],'
          '[RichText:(#FF123456+u+onTap:bar)]'
          ']',
        ),
      );
    });

    testWidgets('renders empty', (tester) async {
      const html = '<a href="$kHref""></a>';
      final explained = await explain(tester, html);
      expect(explained, equals('[widget0]'));
    });
  });

  group('display: block', () {
    testWidgets('renders DIV tag', (tester) async {
      const html = '<a href="$kHref" style="display: block"><div>Foo</div></a>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[MouseRegion:child=[GestureDetector:child='
          '[CssBlock:child=[RichText:(#FF123456+u:Foo)]]'
          ']]]',
        ),
      );
    });

    testWidgets('renders DIV tags', (tester) async {
      const html = '<a href="$kHref" style="display: block">'
          '<div>Foo</div><div>Bar</div></a>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[MouseRegion:child=[GestureDetector:child='
          '[Column:children='
          '[CssBlock:child=[RichText:(#FF123456+u:Foo)]],'
          '[CssBlock:child=[RichText:(#FF123456+u:Bar)]]'
          ']]]]',
        ),
      );
    });

    testWidgets('renders SPAN tag', (tester) async {
      const html =
          '<a href="$kHref" style="display: block"><span>Foo</span></a>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[MouseRegion:child=[GestureDetector:child='
          '[RichText:(#FF123456+u:Foo)]'
          ']]]',
        ),
      );
    });

    testWidgets('renders SPAN tags', (tester) async {
      const html = '<a href="$kHref" style="display: block">'
          '<span>Foo</span> <span>bar</span></a>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[MouseRegion:child=[GestureDetector:child='
          '[RichText:(#FF123456+u:Foo bar)]'
          ']]]',
        ),
      );
    });

    testWidgets('renders DIV and SPAN tags', (tester) async {
      const html = '<a href="$kHref" style="display: block">'
          '<div>Foo</div> <span>bar</span></a>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[MouseRegion:child=[GestureDetector:child='
          '[Column:children='
          '[CssBlock:child=[RichText:(#FF123456+u:Foo)]],'
          '[RichText:(#FF123456+u:bar)]'
          ']]]]',
        ),
      );
    });

    testWidgets('renders empty', (tester) async {
      const html = '<a href="$kHref" style="display: block"></a>';
      final explained = await explain(tester, html);
      expect(explained, equals('[widget0]'));
    });
  });

  testWidgets('renders empty background-color inside (#215)', (tester) async {
    const h = '<a href="$kHref"><div style="background-color: red"></div></a>';
    final explained = await explain(tester, h);
    expect(explained, contains('[widget0]'));
  });

  testWidgets('renders margin inside', (WidgetTester tester) async {
    const html = '<a href="$kHref"><div style="margin: 5px">Foo</div></a>';
    final explained = await explainMargin(tester, html);
    expect(
      explained,
      equals(
        '[SizedBox:0.0x5.0],'
        '[MouseRegion:child=[GestureDetector:child='
        '[HorizontalMargin:left=5,right=5,child='
        '[CssBlock:child=[RichText:(#FF123456+u:Foo)]]'
        ']]],'
        '[SizedBox:0.0x5.0]',
      ),
    );
  });

  testWidgets('renders custom widget inside', (tester) async {
    const html = '<a href="$kHref">Foo <span class="x">x</span> bar.</a>';
    final explained = await explain(
      tester,
      null,
      hw: HtmlWidget(
        html,
        key: hwKey,
        customWidgetBuilder: (e) =>
            e.classes.contains('x') ? Text(e.className) : null,
      ),
    );
    expect(
      explained,
      equals(
        '[Column:children='
        '[RichText:(#FF123456+u+onTap:Foo)],'
        '[MouseRegion:child=[GestureDetector:child=[Text:x]]],'
        '[RichText:(#FF123456+u+onTap:bar.)]'
        ']',
      ),
    );
  });

  group('IMG', () {
    Future<String> explainImg(WidgetTester tester, String html) =>
        mockNetworkImages(() => explain(tester, html));
    const sizingConstraints = 'height≥0.0,height=auto,width≥0.0,width=auto';

    testWidgets('renders IMG tag inside', (WidgetTester tester) async {
      const html = '<a href="$kHref"><img src="$kImgSrc" /></a>';
      final explained = await explainImg(tester, html);
      expect(
        explained,
        equals(
          '[MouseRegion:child=[GestureDetector:child='
          '[CssSizing:$sizingConstraints,child='
          '[Image:image=NetworkImage("$kImgSrc", scale: 1.0)]'
          ']]]',
        ),
      );
    });

    testWidgets('renders text + IMG tag both inside', (tester) async {
      const html = '<a href="$kHref">Foo <img src="$kImgSrc" /></a>';
      final explained = await explainImg(tester, html);
      expect(
        explained,
        equals(
          '[RichText:(:'
          '(#FF123456+u+onTap:Foo )'
          '[MouseRegion:child=[GestureDetector:child='
          '[CssSizing:$sizingConstraints,child='
          '[Image:image=NetworkImage("$kImgSrc", scale: 1.0)]'
          ']]])]',
        ),
      );
    });

    testWidgets('renders text outside + IMG tag inside', (tester) async {
      const html = 'Foo <a href="$kHref"><img src="$kImgSrc" /></a>';
      final explained = await explainImg(tester, html);
      expect(
        explained,
        equals(
          '[RichText:(:Foo '
          '[MouseRegion:child=[GestureDetector:child='
          '[CssSizing:$sizingConstraints,child='
          '[Image:image=NetworkImage("$kImgSrc", scale: 1.0)]'
          ']]])]',
        ),
      );
    });

    testWidgets('renders IMG tag + text both inside', (tester) async {
      const html = '<a href="$kHref"><img src="$kImgSrc" /> foo</a>';
      final explained = await explainImg(tester, html);
      expect(
        explained,
        equals(
          '[RichText:(:'
          '[MouseRegion:child=[GestureDetector:child='
          '[CssSizing:$sizingConstraints,child='
          '[Image:image=NetworkImage("$kImgSrc", scale: 1.0)]'
          ']]]'
          '(#FF123456+u+onTap: foo)'
          ')]',
        ),
      );
    });

    testWidgets('renders IMG tag inside + text outside', (tester) async {
      const html = '<a href="$kHref"><img src="$kImgSrc" /></a> foo';
      final explained = await explainImg(tester, html);
      expect(
        explained,
        equals(
          '[RichText:(:'
          '[MouseRegion:child=[GestureDetector:child='
          '[CssSizing:$sizingConstraints,child='
          '[Image:image=NetworkImage("$kImgSrc", scale: 1.0)]'
          ']]]'
          '(: foo))]',
        ),
      );
    });
  });

  group('skips decoration', () {
    // https://github.com/daohoangson/flutter_widget_from_html/issues/676
    testWidgets('renders a filled href', (tester) async {
      const html = '<a href="$kHref">test</a>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(#FF123456+u+onTap:test)]'));
    });

    testWidgets('renders an empty href', (tester) async {
      const html = '<a href="">test</a>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(#FF123456+u+onTap:test)]'));
    });

    testWidgets('renders href without value', (tester) async {
      const html = '<a href=>test</a>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(#FF123456+u+onTap:test)]'));
    });

    testWidgets('renders without href', (WidgetTester tester) async {
      const html = '<a>test</a>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:test)]'));
    });
  });

  group('error handling', () {
    group('defaultColor', () {
      test('returns resolving itself if context is null', () {
        const resolving = InheritedProperties([]);
        final actual = TagA.defaultColor(resolving, null);
        expect(actual, equals(resolving));
      });
    });
  });
}
