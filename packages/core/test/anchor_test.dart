import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '_.dart';

void main() async {
  await loadAppFonts();

  group('build test', () {
    testWidgets('renders A[name]', (WidgetTester tester) async {
      final html = '<a name="foo"></a>Foo';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:[SizedBox#foo:0.0x10.0](:Foo))]'));
    });

    testWidgets('renders SPAN[id]', (WidgetTester tester) async {
      final html = '<span id="foo">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:[SizedBox#foo:0.0x10.0](:Foo))]'));
    });

    testWidgets('renders DIV[id]', (WidgetTester tester) async {
      final html = '<div id="foo">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child='
              '[SizedBox#foo:child='
              '[RichText:(:Foo)]'
              ']]'));
    });

    testWidgets('renders SUP[id]', (WidgetTester tester) async {
      final html = '<sup id="foo">Foo</sup>';
      final explained = await explain(tester, html);
      expect(explained, contains('[SizedBox#foo'));
    });

    testWidgets('renders in ListView', (WidgetTester tester) async {
      final html = '<a name="foo"></a>Foo';
      final explained = await explain(
        tester,
        null,
        hw: HtmlWidget(
          html,
          key: hwKey,
          renderMode: RenderMode.ListView,
        ),
        useExplainer: false,
      );
      expect(explained, contains('BodyItemWidget-[GlobalKey 0]'));
      expect(explained, contains('SizedBox-[GlobalKey foo]'));
    });

    testWidgets('renders in SliverList', (WidgetTester tester) async {
      final html = '<a name="foo"></a>Foo';
      final explained = await explain(
        tester,
        null,
        hw: CustomScrollView(slivers: [
          HtmlWidget(
            html,
            key: hwKey,
            renderMode: RenderMode.SliverList,
          )
        ]),
        useExplainer: false,
      );
      expect(explained, contains('BodyItemWidget-[GlobalKey 0]'));
      expect(explained, contains('SizedBox-[GlobalKey foo]'));
    });
  });

  final goldenSkip = Platform.isLinux ? null : 'Linux only';
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
        }, skip: goldenSkip != null);

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
        }, skip: goldenSkip != null);

        group('_BodyItemWidget', () {
          testGoldens('ListView scrolls down', (WidgetTester tester) async {
            await tester.pumpWidgetBuilder(
              _ListViewTestApp(),
              wrapper: materialAppWrapper(theme: ThemeData.light()),
              surfaceSize: Size(200, 200),
            );
            await screenMatchesGolden(tester, 'listview/down/top');

            expect(await tapText(tester, 'Scroll down'), equals(1));
            await tester.pumpAndSettle();
            await screenMatchesGolden(tester, 'listview/down/target');
          }, skip: goldenSkip != null);

          testGoldens('SliverList scrolls up', (WidgetTester tester) async {
            final keyBottom = GlobalKey();
            await tester.pumpWidgetBuilder(
              _SliverListTestApp(keyBottom: keyBottom),
              wrapper: materialAppWrapper(theme: ThemeData.light()),
              surfaceSize: Size(200, 200),
            );

            await tester.scrollUntilVisible(find.byKey(keyBottom), 100);
            await tester.pumpAndSettle();
            await screenMatchesGolden(tester, 'sliverlist/up/bottom');

            expect(await tapText(tester, 'Scroll up'), equals(1));
            await tester.pumpAndSettle();
            await screenMatchesGolden(tester, 'sliverlist/up/target');
          }, skip: goldenSkip != null);
        });
      }, skip: goldenSkip);
    },
    config: GoldenToolkitConfiguration(
      fileNameFactory: (name) => '$kGoldenFilePrefix/anchor/$name.png',
    ),
  );
}

final _html1 = '''<p>1</p>
<p>12</p>
<p>123</p>
<p>1234</p>
<p>12345</p>
<p>123456</p>
<p>1234567</p>
<p>12345678</p>
<p>123456789</p>
<p>1234567890</p>''';

final _html2 = '''<p>1234567890</p>
<p>123456789</p>
<p>12345678</p>
<p>1234567</p>
<p>123456</p>
<p>12345</p>
<p>1234</p>
<p>123</p>
<p>12</p>
<p>1</p>''';

final html = '''
<a href="#target">Scroll down</a>
${_html1 * 3}
<p><a name="target"></a>--&gt; TARGET &lt--</p>
${_html2 * 3}
<a href="#target">Scroll up</a>
''';

class _AnchorTestApp extends StatelessWidget {
  final Key? keyBottom;

  _AnchorTestApp({Key? key, this.keyBottom}) : super(key: key);

  @override
  Widget build(BuildContext _) => Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              HtmlWidget(html),
              SizedBox.shrink(key: keyBottom),
            ],
          ),
        ),
      );
}

class _ListViewTestApp extends StatelessWidget {
  _ListViewTestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _) => Scaffold(
        body: HtmlWidget(html, renderMode: RenderMode.ListView),
      );
}

class _SliverListTestApp extends StatelessWidget {
  final Key keyBottom;

  _SliverListTestApp({Key? key, required this.keyBottom}) : super(key: key);

  @override
  Widget build(BuildContext _) => Scaffold(
        body: CustomScrollView(
          slivers: [
            HtmlWidget(html, renderMode: RenderMode.SliverList),
            SliverToBoxAdapter(child: Container(height: 1, key: keyBottom)),
          ],
        ),
      );
}
