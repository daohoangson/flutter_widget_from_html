import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../packages/enhanced/test/_.dart' as helper;

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
      final explained = await helper.explain(tester, html, useExplainer: false);
      expect(explained, equals(expectation));
    });

    testWidgets('renders span[id]', (WidgetTester tester) async {
      final html = '<span id="foo"></span>';
      final explained = await helper.explain(tester, html, useExplainer: false);
      expect(explained, equals(expectation));
    });
  });

  group('widget test', () {
    final tapText = (WidgetTester tester, String data) async {
      final candidates = find.byType(RichText).evaluate();
      var tapped = 0;
      for (final candidate in candidates) {
        final richText = candidate.widget as RichText;
        final text = richText.text;
        if (text is TextSpan) {
          if (text.text == data) {
            await tester.tap(find.byWidget(richText));
            tapped++;
          }
        }
      }

      return tapped;
    };

    testWidgets('scrolls down', (WidgetTester tester) async {
      await tester.pumpWidget(_AnchorTestApp());

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('anchor/down/top.png'),
      );

      expect(await tapText(tester, 'Scroll down'), equals(1));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('anchor/down/target.png'),
      );
    });

    testWidgets('scrolls up', (WidgetTester tester) async {
      final keyBottom = GlobalKey();
      await tester.pumpWidget(_AnchorTestApp(keyBottom: keyBottom));

      await tester.ensureVisible(find.byKey(keyBottom));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('anchor/up/bottom.png'),
      );

      expect(await tapText(tester, 'Scroll up'), equals(1));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('anchor/up/target.png'),
      );
    });
  });
}

class _AnchorTestApp extends StatelessWidget {
  final Key keyBottom;

  _AnchorTestApp({Key key, this.keyBottom}) : super(key: key);

  @override
  Widget build(BuildContext _) => UnconstrainedBox(
        child: ConstrainedBox(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    HtmlWidget('''
<a href="#target">Scroll down</a>
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
<p><a name="target"></a>--&gt; TARGET &lt--</p>
<p>1234567890</p>
<p>123456789</p>
<p>12345678</p>
<p>1234567</p>
<p>123456</p>
<p>12345</p>
<p>1234</p>
<p>123</p>
<p>12</p>
<p>1</p>
<a href="#target">Scroll up</a>
                    '''),
                    SizedBox.shrink(key: keyBottom),
                  ],
                ),
              ),
            ),
          ),
          constraints: BoxConstraints.tightFor(height: 200, width: 200),
        ),
      );
}
