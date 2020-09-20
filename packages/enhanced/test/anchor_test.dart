import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '_.dart';

void main() {
  group('unit test', () {
    final expectation = 'TshWidget\n'
        '└WidgetPlaceholder<BuildTree>(BuildTree#0 tsb#1:\n'
        ' │  BuildTree#2 tsb#3(parent=#1):\n'
        ' │    WidgetBit.inline#4 WidgetPlaceholder(#foo)\n'
        ' │)\n'
        ' └WidgetPlaceholder<String>(#foo)\n'
        '  └SizedBox-(height: 10.0)\n\n';

    testWidgets('renders A[name]', (WidgetTester tester) async {
      final html = '<a name="foo"></a>';
      final explained = await explain(tester, html, useExplainer: false);
      expect(explained, equals(expectation));
    });

    testWidgets('renders span[id]', (WidgetTester tester) async {
      final html = '<span id="foo"></span>';
      final explained = await explain(tester, html, useExplainer: false);
      expect(explained, equals(expectation));
    });
  });

  testWidgets('scrolls on #target tap', (WidgetTester tester) async {
    final filler = '''
<p>1</p>
<p>12</p>
<p>123</p>
<p>1234</p>
<p>12345</p>
<p>123456</p>
<p>1234567</p>
<p>12345678</p>
<p>123456789</p>
<p>1234567890</p>
''';
    final html = '''
<p style="color: red">----------</p>
$filler
<p style="color: green">----------</p>
<a name="target"></a>
<p style="color: blue">----------</p>
$filler
<a href="#target">Tap me</a>
''';
    final keyTop = GlobalKey();
    final keyBottom = GlobalKey();
    await tester.pumpWidget(
      UnconstrainedBox(
        child: ConstrainedBox(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox.shrink(key: keyTop),
                    HtmlWidget(html),
                    SizedBox.shrink(key: keyBottom),
                  ],
                ),
              ),
            ),
          ),
          constraints: BoxConstraints.tightFor(
            height: 200,
            width: 200,
          ),
        ),
      ),
    );

    await expectLater(
        find.byType(MaterialApp), matchesGoldenFile('anchor/top.png'));

    await tester.ensureVisible(find.byKey(keyBottom));
    await tester.pumpAndSettle();
    await expectLater(
        find.byType(MaterialApp), matchesGoldenFile('anchor/bottom.png'));

    final candidates = find.byType(RichText).evaluate();
    var tapped = 0;
    for (final candidate in candidates) {
      final richText = candidate.widget as RichText;
      final text = richText.text;
      if (text is TextSpan) {
        if (text.text == 'Tap me') {
          await tester.tap(find.byWidget(richText));
          tapped++;
        }
      }
    }
    expect(tapped, equals(1));
    await tester.pumpAndSettle();
    await expectLater(
        find.byType(MaterialApp), matchesGoldenFile('anchor/target.png'));
  });
}
