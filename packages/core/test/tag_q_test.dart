import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '_.dart';

void main() {
  group('basic usage', () {
    const html = 'Someone said <q>Foo</q>.';

    testWidgets('renders quotes', (WidgetTester tester) async {
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Someone said “Foo”.)]'));
    });

    testWidgets('useExplainer=false', (WidgetTester tester) async {
      final explained = await explain(tester, html, useExplainer: false);
      expect(
        explained,
        equals(
          'TshWidget\n'
          '└WidgetPlaceholder<BuildTree>(BuildTree#0 tsb#1:\n'
          ' │  "Someone said"\n'
          ' │  Whitespace[32]#2\n'
          ' │  BuildTree#3 tsb#4(parent=#1):\n'
          ' │    QBit.opening#5 tsb#4(parent=#1)\n'
          ' │    "Foo"\n'
          ' │    QBit.closing#6 tsb#4(parent=#1)\n'
          ' │  "."\n'
          ' │)\n'
          ' └RichText(text: "Someone said “Foo”.")\n\n',
        ),
      );
    });
  });

  testWidgets('renders quotes without contents', (WidgetTester tester) async {
    const html = 'x<q></q>y';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:(:x“”y)]'));
  });

  testWidgets('renders quotes alone', (WidgetTester tester) async {
    const html = '<q></q>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:(:“”)]'));
  });

  testWidgets(
    'renders quotes around IMG',
    (tester) => mockNetworkImages(() async {
      const src = 'http://domain.com/image.png';
      const html = '<q><img src="$src" /></q>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[RichText:(:“'
          '[CssSizing:height≥0.0,height=auto,width≥0.0,width=auto,child='
          '[Image:image=NetworkImage("$src", scale: 1.0)]]'
          '(:”))]',
        ),
      );
    }),
  );

  testWidgets('renders styling', (WidgetTester tester) async {
    const html = 'Someone said <q><em>Foo</em></q>.';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:(:Someone said (+i:“Foo”)(:.))]'));
  });

  testWidgets('renders complicated styling', (WidgetTester tester) async {
    const html = 'Someone said <q><u><em>F</em>o<b>o</b></u></q>.';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals('[RichText:(:Someone said (+u+i:“F)(+u:o)(+u+b:o”)(:.))]'),
    );
  });

  testWidgets('renders within vertical-align middle', (tester) async {
    const html = '<span style="vertical-align: middle"><q>Foo</q></span> bar';
    final e = await explain(tester, html);
    expect(e, equals('[RichText:(:[RichText:(:“Foo”)]@middle(: bar))]'));
  });
}
