import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '_.dart';

const kHref = 'http://domain.com/href';
const kImgSrc = 'http://domain.com/image.png';

void main() {
  testWidgets('renders accent color', (WidgetTester tester) async {
    final html = '<a href="$kHref">Foo</a>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:(#FF123456+u+onTap:Foo)]'));
  });

  testWidgets('renders inline stylings', (WidgetTester tester) async {
    final html = '<a href="$kHref" style="color: #f00">Foo</a>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:(#FFFF0000+u+onTap:Foo)]'));
  });

  testWidgets('renders inner stylings', (WidgetTester tester) async {
    final html = '<a href="$kHref"><b><i>Foo</i></b></a>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:(#FF123456+u+i+b+onTap:Foo)]'));
  });

  testWidgets('renders DIV tag inside', (WidgetTester tester) async {
    final html = '<a href="$kHref"><div>Foo</div></a>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals('[InkWell:child=[CssBlock:child=[RichText:(#FF123456+u:Foo)]]]'),
    );
  });

  testWidgets('renders DIV tags inside', (WidgetTester tester) async {
    final html = '<a href="$kHref"><div>Foo</div><div>Bar</div></a>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[Column:children='
        '[InkWell:child=[CssBlock:child=[RichText:(#FF123456+u:Foo)]]],'
        '[InkWell:child=[CssBlock:child=[RichText:(#FF123456+u:Bar)]]]'
        ']',
      ),
    );
  });

  group('tap test', () {
    testWidgets('triggers callback', (WidgetTester tester) async {
      final urls = <String>[];
      await tester.pumpWidget(_TapTestApp(onTapUrl: urls.add));
      await tester.pumpAndSettle();
      expect(await tapText(tester, 'Tap me'), equals(1));
      expect(urls, equals(const [kHref]));
    });

    testWidgets('proceeds to launch url', (WidgetTester tester) async {
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
