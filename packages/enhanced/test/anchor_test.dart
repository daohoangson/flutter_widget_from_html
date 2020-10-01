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

  GoldenToolkit.runWithConfiguration(
    () {
      group('tap test', () {
        testGoldens('scrolls down', (WidgetTester tester) async {
          await tester.pumpWidgetBuilder(
            _AnchorTestApp(),
            wrapper: materialAppWrapper(theme: ThemeData.light()),
            surfaceSize: Size(200, 200),
          );
          await screenMatchesGolden(tester, 'down/top');

          expect(await tapText(tester, 'Scroll down'), equals(1));
          await tester.pumpAndSettle();
          await screenMatchesGolden(tester, 'down/target');
        }, skip: null);

        testGoldens('scrolls up', (WidgetTester tester) async {
          final keyBottom = GlobalKey();
          await tester.pumpWidgetBuilder(
            _AnchorTestApp(keyBottom: keyBottom),
            wrapper: materialAppWrapper(theme: ThemeData.light()),
            surfaceSize: Size(200, 200),
          );

          await tester.ensureVisible(find.byKey(keyBottom));
          await tester.pumpAndSettle();
          await screenMatchesGolden(tester, 'up/bottom');

          expect(await tapText(tester, 'Scroll up'), equals(1));
          await tester.pumpAndSettle();
          await screenMatchesGolden(tester, 'up/target');
        }, skip: null);
      }, skip: Platform.isLinux ? null : 'Linux only');
    },
    config: GoldenToolkitConfiguration(
      fileNameFactory: (name) => '$kGoldenFilePrefix/anchor/$name.png',
    ),
  );
}

class _AnchorTestApp extends StatelessWidget {
  final Key keyBottom;

  _AnchorTestApp({Key key, this.keyBottom}) : super(key: key);

  @override
  Widget build(BuildContext _) => Scaffold(
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
      );
}
