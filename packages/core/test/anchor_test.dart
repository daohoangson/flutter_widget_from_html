import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '_.dart';

final _onTapAnchorResults = <String, bool>{};
final _targetFinder = findText('\u{fffc}--> TARGET <--');

void main() {
  group('build tests', () {
    testWidgets('renders A[name]', (WidgetTester tester) async {
      const html = '<a name="foo"></a>Foo';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:[SizedBox#foo:0.0x10.0](:Foo))]'));
    });

    testWidgets('renders SPAN[id]', (WidgetTester tester) async {
      const html = '<span id="foo">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:[SizedBox#foo:0.0x10.0](:Foo))]'));
    });

    testWidgets('renders DIV[id]', (WidgetTester tester) async {
      const html = '<div id="foo">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[SizedBox#foo:child='
          '[CssBlock:child='
          '[RichText:(:Foo)]'
          ']]',
        ),
      );
    });

    testWidgets('renders SUP[id]', (WidgetTester tester) async {
      const html = '<sup id="foo">Foo</sup>';
      final explained = await explain(tester, html);
      expect(explained, contains('[SizedBox#foo'));
    });

    testWidgets('renders in ListView', (WidgetTester tester) async {
      const html = '<a name="foo"></a>Foo';
      final explained = await explain(
        tester,
        null,
        hw: HtmlWidget(
          html,
          key: hwKey,
          renderMode: RenderMode.listView,
        ),
        useExplainer: false,
      );
      expect(explained, contains('[GlobalKey anchor-0--header]'));
      expect(explained, contains('[GlobalKey anchor-0--footer]'));
      expect(explained, contains('[GlobalKey foo]'));
    });

    testWidgets('renders in SliverList', (WidgetTester tester) async {
      const html = '<a name="foo"></a>Foo';
      final explained = await explain(
        tester,
        null,
        hw: CustomScrollView(
          slivers: [
            HtmlWidget(
              html,
              key: hwKey,
              renderMode: RenderMode.sliverList,
            )
          ],
        ),
        useExplainer: false,
      );
      expect(explained, contains('[GlobalKey anchor-0--header]'));
      expect(explained, contains('[GlobalKey anchor-0--footer]'));
      expect(explained, contains('[GlobalKey foo]'));
    });
  });

  group('tap test', () {
    testWidgets('skips unknown id', (WidgetTester tester) async {
      await pumpWidget(
        tester,
        const _ColumnTestApp(html: '<a href="#foo">Tap me</a>'),
      );

      expect(await tapText(tester, 'Tap me'), equals(1));
      await tester.pumpAndSettle();
      expect(_onTapAnchorResults, equals({'foo': false}));
    });

    group('scrolls', () {
      testWidgets('Column down', (WidgetTester tester) async {
        await pumpWidget(tester, const _ColumnTestApp());
        final viewport = tester.getRect(find.byType(MaterialApp));
        final before = tester.getRect(_targetFinder);
        expect(before.top, greaterThan(viewport.bottom));

        expect(await tapText(tester, 'Scroll down'), equals(1));
        await tester.pumpAndSettle();
        expect(_onTapAnchorResults, equals({'target': true}));

        final after = tester.getRect(_targetFinder);
        expect(after.bottom, lessThan(viewport.bottom));
      });

      testWidgets('Column up', (WidgetTester tester) async {
        final keyBottom = GlobalKey();
        await pumpWidget(tester, _ColumnTestApp(keyBottom: keyBottom));

        await tester.ensureVisible(find.byKey(keyBottom));
        await tester.pumpAndSettle();
        final before = tester.getRect(_targetFinder);
        expect(before.bottom, lessThan(0));

        expect(await tapText(tester, 'Scroll up'), equals(1));
        await tester.pumpAndSettle();
        expect(_onTapAnchorResults, equals({'target': true}));

        final after = tester.getRect(_targetFinder);
        expect(after.bottom, greaterThan(0));
      });

      testWidgets('ListView down', (WidgetTester tester) async {
        await pumpWidget(tester, const _ListViewTestApp());
        expect(_targetFinder, findsNothing);

        expect(await tapText(tester, 'Scroll down'), equals(1));
        await tester.pumpAndSettle();
        expect(_onTapAnchorResults, equals({'target': true}));

        expect(_targetFinder, findsOneWidget);
      });

      testWidgets('SliverList up', (WidgetTester tester) async {
        final keyBottom = GlobalKey();
        await pumpWidget(tester, _SliverListTestApp(keyBottom: keyBottom));

        await tester.scrollUntilVisible(find.byKey(keyBottom), 100);
        expect(_targetFinder, findsNothing);

        expect(await tapText(tester, 'Scroll up'), equals(1));
        await tester.pumpAndSettle();
        expect(_onTapAnchorResults, equals({'target': true}));

        expect(_targetFinder, findsOneWidget);
      });

      group('scrollToAnchor', () {
        testWidgets('Column', (tester) async {
          await pumpWidget(tester, const _ColumnTestApp());

          final scrollFuture = globalKey.currentState?.scrollToAnchor('target');
          await tester.pumpAndSettle();

          expect(await scrollFuture, isTrue);
          expect(_onTapAnchorResults, equals({'target': true}));
        });

        testWidgets('ListView down', (WidgetTester tester) async {
          await pumpWidget(tester, const _ListViewTestApp());

          final scrollFuture = globalKey.currentState?.scrollToAnchor('target');
          await tester.pumpAndSettle();

          expect(await scrollFuture, isTrue);
          expect(_onTapAnchorResults, equals({'target': true}));
        });

        testWidgets('SliverList up', (WidgetTester tester) async {
          final keyBottom = GlobalKey();
          await pumpWidget(tester, _SliverListTestApp(keyBottom: keyBottom));

          await tester.scrollUntilVisible(find.byKey(keyBottom), 100);

          final scrollFuture = globalKey.currentState?.scrollToAnchor('target');
          await tester.pumpAndSettle();

          expect(await scrollFuture, isTrue);
          expect(_onTapAnchorResults, equals({'target': true}));
        });
      });
    });

    group('ListView', () {
      testWidgets('scrolls to DIV', (WidgetTester tester) async {
        await pumpWidget(
          tester,
          _ListViewTestApp(
            html: '<a href="#div">Tap me</a>'
                '${htmlAsc * 3}'
                '<div id="div">Foo</div>',
          ),
        );

        expect(await tapText(tester, 'Tap me'), equals(1));
        await tester.pumpAndSettle();
        expect(_onTapAnchorResults, equals({'div': true}));
      });

      testWidgets('scrolls to SPAN', (WidgetTester tester) async {
        await pumpWidget(
          tester,
          _ListViewTestApp(
            html: '<a href="#span">Tap me</a>'
                '${htmlAsc * 10}'
                '<span id="span">Foo</span>',
          ),
        );

        expect(await tapText(tester, 'Tap me'), equals(1));
        await tester.pumpAndSettle();
        expect(_onTapAnchorResults, equals({'span': true}));
      });

      testWidgets('scrolls to SPAN after DIV', (WidgetTester tester) async {
        await pumpWidget(
          tester,
          _ListViewTestApp(
            html: '<a href="#span">Tap me</a>'
                '${htmlAsc * 3}'
                '<div id="div">YOLO</div>'
                '${htmlAsc * 3}'
                '<span id="span">Foo</span>',
          ),
        );

        expect(await tapText(tester, 'Tap me'), equals(1));
        await tester.pumpAndSettle();
        expect(_onTapAnchorResults, equals({'span': true}));
      });

      testWidgets('scrolls to SPAN before DIV', (WidgetTester tester) async {
        await pumpWidget(
          tester,
          _ListViewTestApp(
            html: '<a href="#span">Tap me</a>'
                '${htmlAsc * 3}'
                '<span id="span">Foo</span>'
                '${htmlAsc * 3}'
                '<div id="div">YOLO</div>'
                '${htmlAsc * 3}',
          ),
        );

        expect(await tapText(tester, 'Tap me'), equals(1));
        await tester.pumpAndSettle();
        expect(_onTapAnchorResults, equals({'span': true}));
      });

      testWidgets('scrolls to SPAN between DIVs', (WidgetTester tester) async {
        await pumpWidget(
          tester,
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
        );

        expect(await tapText(tester, 'Tap me'), equals(1));
        await tester.pumpAndSettle();
        expect(_onTapAnchorResults, equals({'span': true}));
      });

      testWidgets('scrolls up then down', (WidgetTester tester) async {
        await pumpWidget(
          tester,
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
        );

        expect(await tapText(tester, 'Tap me 1'), equals(1));
        await tester.pumpAndSettle();
        expect(_onTapAnchorResults, equals({'span1': true}));

        expect(await tapText(tester, 'Tap me 2'), equals(1));
        await tester.pumpAndSettle();
        expect(_onTapAnchorResults, equals({'span1': true, 'span2': true}));
      });

      testWidgets('scrolls to hidden SPAN', (WidgetTester tester) async {
        await pumpWidget(
          tester,
          _ListViewTestApp(
            html: '<a href="#span">Tap me</a>'
                '${htmlAsc * 10}'
                '<p style="display: none">Foo <span id="span">bar</span>.</p>',
          ),
        );

        expect(await tapText(tester, 'Tap me'), equals(1));
        await tester.pumpAndSettle();
        expect(_onTapAnchorResults, equals({'span': false}));
      });
    });
  });

  group('error handling', () {
    testWidgets('AnchorRegistry empty body items', (WidgetTester tester) async {
      await pumpWidget(
        tester,
        Scaffold(
          body: HtmlWidget(
            htmlDefault,
            factoryBuilder: () => _WidgetFactory(),
            renderMode: _NoBuildBodyAnchorForItemListViewRenderMode(),
          ),
        ),
      );

      expect(await tapText(tester, 'Scroll down'), equals(1));
      await tester.pumpAndSettle();
      expect(_onTapAnchorResults, equals({'target': false}));
    });
  });
}

const htmlAsc = '''
<p>1</p>
<p>12</p>
<p>123</p>
<p>1234</p>
<p>12345</p>
<p>123456</p>
<p>1234567</p>
<p>12345678</p>
<p>123456789</p>
<p>1234567890</p>''';

const htmlDesc = '''
<p>1234567890</p>
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

final globalKey = GlobalKey<HtmlWidgetState>();

Future<void> pumpWidget(WidgetTester tester, Widget child) async {
  tester.binding.window.physicalSizeTestValue = const Size(200, 200);
  addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

  tester.binding.window.devicePixelRatioTestValue = 1.0;
  addTearDown(tester.binding.window.clearDevicePixelRatioTestValue);

  tester.binding.window.textScaleFactorTestValue = 1.0;
  addTearDown(tester.binding.window.clearTextScaleFactorTestValue);

  await tester.pumpWidget(MaterialApp(home: child));
  await tester.pump();
}

class _ColumnTestApp extends StatelessWidget {
  final String? html;
  final Key? keyBottom;

  const _ColumnTestApp({this.html, Key? key, this.keyBottom}) : super(key: key);

  @override
  Widget build(BuildContext _) => Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              HtmlWidget(
                html ?? htmlDefault,
                factoryBuilder: () => _WidgetFactory(),
                key: globalKey,
              ),
              SizedBox.shrink(key: keyBottom),
            ],
          ),
        ),
      );
}

class _ListViewTestApp extends StatelessWidget {
  final String? html;

  const _ListViewTestApp({this.html, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _) => Scaffold(
        body: HtmlWidget(
          html ?? htmlDefault,
          factoryBuilder: () => _WidgetFactory(),
          key: globalKey,
          renderMode: RenderMode.listView,
        ),
      );
}

class _SliverListTestApp extends StatelessWidget {
  final String? html;
  final Key? keyBottom;

  const _SliverListTestApp({this.html, Key? key, this.keyBottom})
      : super(key: key);

  @override
  Widget build(BuildContext _) => Scaffold(
        body: CustomScrollView(
          cacheExtent: 0,
          slivers: [
            HtmlWidget(
              html ?? htmlDefault,
              factoryBuilder: () => _WidgetFactory(),
              key: globalKey,
              renderMode: RenderMode.sliverList,
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

  @override
  void reset(State<StatefulWidget> state) {
    super.reset(state);
    _onTapAnchorResults.clear();
  }
}

class _NoBuildBodyAnchorForItemListViewRenderMode extends RenderMode {
  @override
  Widget buildBodyWidget(
    WidgetFactory wf,
    BuildContext context,
    List<Widget> children,
  ) =>
      ListView.builder(
        addAutomaticKeepAlives: false,
        addSemanticIndexes: false,
        itemBuilder: (c, i) => children[i],
        itemCount: children.length,
      );
}
