import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '_.dart';

final _onTapAnchorResults = <String, bool>{};

void main() async {
  await loadAppFonts();

  group('build tests', () {
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

  group('tap tests', () {
    setUp(() {
      _onTapAnchorResults.clear();
    });

    testWidgets('skips unknown id', (WidgetTester tester) async {
      await tester.pumpWidgetBuilder(
        _ColumnTestApp(html: '<a href="#foo">Tap me</a>'),
      );

      expect(await tapText(tester, 'Tap me'), equals(1));
      await tester.pumpAndSettle();
      expect(_onTapAnchorResults, equals({'foo': false}));
    });

    group('scrolls', () {
      testWidgets('Column', (WidgetTester tester) async {
        await tester.pumpWidgetBuilder(
          _ColumnTestApp(),
          surfaceSize: Size(200, 200),
        );

        expect(await tapText(tester, 'Scroll down'), equals(1));
        await tester.pumpAndSettle();
        expect(_onTapAnchorResults, equals({'target': true}));
      });

      testWidgets('ListView', (WidgetTester tester) async {
        await tester.pumpWidgetBuilder(
          _ListViewTestApp(),
          surfaceSize: Size(200, 200),
        );

        expect(await tapText(tester, 'Scroll down'), equals(1));
        await tester.pumpAndSettle();
        expect(_onTapAnchorResults, equals({'target': true}));
      });

      testWidgets('SliverList', (WidgetTester tester) async {
        final keyBottom = GlobalKey();
        await tester.pumpWidgetBuilder(
          _SliverListTestApp(keyBottom: keyBottom),
          surfaceSize: Size(200, 200),
        );

        await tester.scrollUntilVisible(find.byKey(keyBottom), 100);

        expect(await tapText(tester, 'Scroll up'), equals(1));
        await tester.pumpAndSettle();
        expect(_onTapAnchorResults, equals({'target': true}));
      });
    });

    group('ListView', () {
      testWidgets('scrolls to DIV', (WidgetTester tester) async {
        await tester.pumpWidgetBuilder(
          _ListViewTestApp(
            html: '<a href="#div">Tap me</a>'
                '${htmlAsc * 3}'
                '<div id="div">Foo</div>',
          ),
          surfaceSize: Size(200, 200),
        );

        expect(await tapText(tester, 'Tap me'), equals(1));
        await tester.pumpAndSettle();
        expect(_onTapAnchorResults, equals({'div': true}));
      });

      testWidgets('scrolls to SPAN', (WidgetTester tester) async {
        await tester.pumpWidgetBuilder(
          _ListViewTestApp(
            html: '<a href="#span">Tap me</a>'
                '${htmlAsc * 10}'
                '<span id="span">Foo</span>',
          ),
          surfaceSize: Size(200, 200),
        );

        expect(await tapText(tester, 'Tap me'), equals(1));
        await tester.pumpAndSettle();
        expect(_onTapAnchorResults, equals({'span': true}));
      });

      testWidgets('scrolls to SPAN after DIV', (WidgetTester tester) async {
        await tester.pumpWidgetBuilder(
          _ListViewTestApp(
            html: '<a href="#span">Tap me</a>'
                '${htmlAsc * 3}'
                '<div id="div">YOLO</div>'
                '${htmlAsc * 3}'
                '<span id="span">Foo</span>',
          ),
          surfaceSize: Size(200, 200),
        );

        expect(await tapText(tester, 'Tap me'), equals(1));
        await tester.pumpAndSettle();
        expect(_onTapAnchorResults, equals({'span': true}));
      });

      testWidgets('scrolls to SPAN before DIV', (WidgetTester tester) async {
        await tester.pumpWidgetBuilder(
          _ListViewTestApp(
            html: '<a href="#span">Tap me</a>'
                '${htmlAsc * 3}'
                '<span id="span">Foo</span>'
                '${htmlAsc * 3}'
                '<div id="div">YOLO</div>'
                '${htmlAsc * 3}',
          ),
          surfaceSize: Size(200, 200),
        );

        expect(await tapText(tester, 'Tap me'), equals(1));
        await tester.pumpAndSettle();
        expect(_onTapAnchorResults, equals({'span': true}));
      });

      testWidgets('scrolls to SPAN between DIVs', (WidgetTester tester) async {
        await tester.pumpWidgetBuilder(
          _ListViewTestApp(
            html: '<a href="#span">Tap me</a>'
                '${htmlAsc * 3}'
                '<div id="div">YOLO</div>'
                '${htmlAsc * 3}'
                '<span id="span">Foo</span>'
                '${htmlAsc * 3}'
                '<div id="div">YOLO</div>'
                '${htmlAsc * 3}',
          ),
          surfaceSize: Size(200, 200),
        );

        expect(await tapText(tester, 'Tap me'), equals(1));
        await tester.pumpAndSettle();
        expect(_onTapAnchorResults, equals({'span': true}));
      });

      testWidgets('scrolls up then down', (WidgetTester tester) async {
        await tester.pumpWidgetBuilder(
          _ListViewTestApp(
            html: '<a href="#span1">Tap me 1</a>'
                '${htmlAsc * 10}'
                '<div id="div">YOLO</div>'
                '${htmlAsc * 10}'
                '<span id="span1">Foo</span>'
                '<p><a href="#span2">Tap me 2</a></p>'
                '${htmlAsc * 10}'
                '<span id="span2">Foo</span>',
          ),
          surfaceSize: Size(200, 200),
        );

        expect(await tapText(tester, 'Tap me 1'), equals(1));
        await tester.pumpAndSettle();
        expect(_onTapAnchorResults, equals({'span1': true}));

        expect(await tapText(tester, 'Tap me 2'), equals(1));
        await tester.pumpAndSettle();
        expect(_onTapAnchorResults, equals({'span1': true, 'span2': true}));
      });
    });
  });

  final goldenSkip = Platform.isLinux ? null : 'Linux only';
  GoldenToolkit.runWithConfiguration(
    () {
      group('tap test', () {
        testGoldens('scrolls down', (WidgetTester tester) async {
          await tester.pumpWidgetBuilder(
            _ColumnTestApp(),
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
            _ColumnTestApp(keyBottom: keyBottom),
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

final htmlAsc = '''<p>1</p>
<p>12</p>
<p>123</p>
<p>1234</p>
<p>12345</p>
<p>123456</p>
<p>1234567</p>
<p>12345678</p>
<p>123456789</p>
<p>1234567890</p>''';

final htmlDesc = '''<p>1234567890</p>
<p>123456789</p>
<p>12345678</p>
<p>1234567</p>
<p>123456</p>
<p>12345</p>
<p>1234</p>
<p>123</p>
<p>12</p>
<p>1</p>''';

final htmlDefault = '''
<a href="#target">Scroll down</a>
${htmlAsc * 3}
<p><a name="target"></a>--&gt; TARGET &lt--</p>
${htmlDesc * 3}
<a href="#target">Scroll up</a>
''';

class _ColumnTestApp extends StatelessWidget {
  final String? html;
  final Key? keyBottom;

  _ColumnTestApp({this.html, Key? key, this.keyBottom}) : super(key: key);

  @override
  Widget build(BuildContext _) => Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              HtmlWidget(
                html ?? htmlDefault,
                factoryBuilder: () => _WidgetFactory(),
              ),
              SizedBox.shrink(key: keyBottom),
            ],
          ),
        ),
      );
}

class _ListViewTestApp extends StatelessWidget {
  final String? html;

  _ListViewTestApp({this.html, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _) => Scaffold(
        body: HtmlWidget(
          html ?? htmlDefault,
          factoryBuilder: () => _WidgetFactory(),
          renderMode: RenderMode.ListView,
        ),
      );
}

class _SliverListTestApp extends StatelessWidget {
  final String? html;
  final Key? keyBottom;

  _SliverListTestApp({this.html, Key? key, this.keyBottom}) : super(key: key);

  @override
  Widget build(BuildContext _) => Scaffold(
        body: CustomScrollView(
          slivers: [
            HtmlWidget(
              html ?? htmlDefault,
              factoryBuilder: () => _WidgetFactory(),
              renderMode: RenderMode.SliverList,
            ),
            SliverToBoxAdapter(child: Container(height: 1, key: keyBottom)),
          ],
        ),
      );
}

class _WidgetFactory extends WidgetFactory {
  @override
  Future<bool> onTapAnchor(String id, EnsureVisible scrollTo) async {
    final result = await super.onTapAnchor(id, scrollTo);
    _onTapAnchorResults[id] = result;
    return result;
  }
}
