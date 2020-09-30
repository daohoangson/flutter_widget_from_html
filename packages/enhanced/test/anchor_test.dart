import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '_.dart';

void main() async {
  await loadAppFonts();

  group('build test', () {
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

  group('tap test', () {
    testWidgets('scrolls down', (WidgetTester tester) async {
      await tester.pumpWidget(_AnchorTestApp());

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('$kGoldenFilePrefix/anchor/down/top.png'),
      );

      expect(await tapText(tester, 'Scroll down'), equals(1));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('$kGoldenFilePrefix/anchor/down/target.png'),
      );
    }, skip: null);

    testWidgets('scrolls up', (WidgetTester tester) async {
      final keyBottom = GlobalKey();
      await tester.pumpWidget(_AnchorTestApp(keyBottom: keyBottom));

      await tester.ensureVisible(find.byKey(keyBottom));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('$kGoldenFilePrefix/anchor/up/bottom.png'),
      );

      expect(await tapText(tester, 'Scroll up'), equals(1));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('$kGoldenFilePrefix/anchor/up/target.png'),
      );
    }, skip: null);
  }, skip: Platform.isLinux ? null : 'Linux only');
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
