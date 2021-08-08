import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:flutter_widget_from_html_core/src/internal/tsh_widget.dart';
import 'package:html/dom.dart' as dom;
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '_.dart' as helper;

Future<String> explain(WidgetTester t, HtmlWidget hw) =>
    helper.explain(t, null, hw: hw);

void main() {
  group('buildAsync', () {
    Future<String?> explain(WidgetTester tester, String html,
            {bool? buildAsync}) =>
        tester.runAsync(() => helper.explain(tester, null,
            hw: HtmlWidget(html, buildAsync: buildAsync, key: helper.hwKey)));

    testWidgets('uses FutureBuilder', (WidgetTester tester) async {
      const html = 'Foo';
      final explained = await explain(tester, html, buildAsync: true);
      expect(explained, equals('[FutureBuilder:[RichText:(:$html)]]'));
    });

    testWidgets('skips FutureBuilder', (WidgetTester tester) async {
      const html = 'Foo';
      final explained = await explain(tester, html, buildAsync: false);
      expect(explained, equals('[RichText:(:$html)]'));
    });

    testWidgets('uses FutureBuilder automatically', (tester) async {
      final html = 'Foo' * kShouldBuildAsync;
      final explained = await explain(tester, html);
      expect(explained, equals('[FutureBuilder:[RichText:(:$html)]]'));
    });
  });

  group('buildAsyncBuilder', () {
    Future<String?> explain(
      WidgetTester tester,
      String html, {
      AsyncWidgetBuilder<Widget>? buildAsyncBuilder,
      required bool withData,
    }) =>
        tester.runAsync(() => helper.explain(tester, null,
            buildFutureBuilderWithData: withData,
            hw: HtmlWidget(
              html,
              buildAsync: true,
              buildAsyncBuilder: buildAsyncBuilder,
              key: helper.hwKey,
            )));

    group('default', () {
      testWidgets('renders data', (WidgetTester tester) async {
        const html = 'Foo';
        final explained = await explain(tester, html, withData: true);
        expect(explained, equals('[FutureBuilder:[RichText:(:$html)]]'));
      });

      testWidgets('renders CircularProgressIndicator', (tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        const html = 'Foo';
        final explained = await explain(tester, html, withData: false);
        expect(
            explained,
            equals('[FutureBuilder:'
                '[Center:child='
                '[Padding:(8,8,8,8),child='
                '[CircularProgressIndicator]'
                ']]]'));
        debugDefaultTargetPlatformOverride = null;
      });

      testWidgets('renders CupertinoActivityIndicator', (tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        const html = 'Foo';
        final explained = await explain(tester, html, withData: false);
        expect(
            explained,
            equals('[FutureBuilder:'
                '[Center:child='
                '[Padding:(8,8,8,8),child='
                '[CupertinoActivityIndicator]'
                ']]]'));
        debugDefaultTargetPlatformOverride = null;
      });
    });

    group('custom', () {
      Widget buildAsyncBuilder(
              BuildContext _, AsyncSnapshot<Widget> snapshot) =>
          snapshot.data ?? const Text('No data');

      testWidgets('renders data', (WidgetTester tester) async {
        const html = 'Foo';
        final explained = await explain(
          tester,
          html,
          buildAsyncBuilder: buildAsyncBuilder,
          withData: true,
        );
        expect(explained, equals('[FutureBuilder:[RichText:(:$html)]]'));
      });

      testWidgets('renders indicator', (WidgetTester tester) async {
        const html = 'Foo';
        final explained = await explain(
          tester,
          html,
          buildAsyncBuilder: buildAsyncBuilder,
          withData: false,
        );
        expect(explained, equals('[FutureBuilder:[Text:No data]]'));
      });
    });
  });

  group('enableCaching', () {
    Future<String> explain(
      WidgetTester tester,
      String html, {
      Uri? baseUrl,
      bool? buildAsync,
      required bool enableCaching,
      Color? hyperlinkColor,
      RebuildTriggers? rebuildTriggers,
      TextStyle? textStyle,
    }) =>
        helper.explain(tester, null,
            hw: HtmlWidget(
              html,
              baseUrl: baseUrl,
              buildAsync: buildAsync,
              enableCaching: enableCaching,
              hyperlinkColor: hyperlinkColor,
              key: helper.hwKey,
              rebuildTriggers: rebuildTriggers,
              textStyle: textStyle,
            ));

    void _expect(Widget? built1, Widget? built2, Matcher matcher) {
      final widget1 = (built1! as TshWidget).child;
      final widget2 = (built2! as TshWidget).child;
      expect(widget1 == widget2, matcher);
    }

    testWidgets('caches built widget tree', (WidgetTester tester) async {
      const html = 'Foo';
      final explained = await explain(tester, html, enableCaching: true);
      expect(explained, equals('[RichText:(:Foo)]'));
      final built1 = helper.buildCurrentState();

      await explain(tester, html, enableCaching: true);
      final built2 = helper.buildCurrentState();
      _expect(built1, built2, isTrue);
    });

    testWidgets('rebuild new html', (WidgetTester tester) async {
      const html1 = 'Foo';
      const html2 = 'Bar';

      final explained1 = await explain(tester, html1, enableCaching: true);
      expect(explained1, equals('[RichText:(:Foo)]'));

      final explained2 = await explain(tester, html2, enableCaching: true);
      expect(explained2, equals('[RichText:(:Bar)]'));
    });

    testWidgets('rebuild new baseUrl', (tester) async {
      const html = 'Foo';

      final explained1 = await explain(tester, html, enableCaching: true);
      expect(explained1, equals('[RichText:(:Foo)]'));
      final built1 = helper.buildCurrentState();

      await explain(tester, html,
          enableCaching: true, baseUrl: Uri.http('domain.com', ''));
      final built2 = helper.buildCurrentState();
      _expect(built1, built2, isFalse);
    });

    testWidgets('rebuild new buildAsync', (tester) async {
      const html = 'Foo';

      final explained1 = await explain(tester, html, enableCaching: true);
      expect(explained1, equals('[RichText:(:Foo)]'));
      final built1 = helper.buildCurrentState();

      await explain(tester, html, enableCaching: true, buildAsync: false);
      final built2 = helper.buildCurrentState();
      _expect(built1, built2, isFalse);
    });

    testWidgets('rebuild new enableCaching', (tester) async {
      const html = 'Foo';

      final explained1 = await explain(tester, html, enableCaching: true);
      expect(explained1, equals('[RichText:(:Foo)]'));
      final built1 = helper.buildCurrentState();

      await explain(tester, html, enableCaching: false);
      final built2 = helper.buildCurrentState();
      _expect(built1, built2, isFalse);
    });

    testWidgets('rebuild new hyperlinkColor', (tester) async {
      const html = 'Foo';

      final explained1 = await explain(tester, html, enableCaching: true);
      expect(explained1, equals('[RichText:(:Foo)]'));
      final built1 = helper.buildCurrentState();

      await explain(tester, html,
          enableCaching: true,
          hyperlinkColor: const Color.fromRGBO(255, 0, 0, 1));
      final built2 = helper.buildCurrentState();
      _expect(built1, built2, isFalse);
    });

    testWidgets('rebuild new rebuildTriggers', (tester) async {
      const html = 'Foo';

      final explained1 = await explain(tester, html,
          enableCaching: true, rebuildTriggers: RebuildTriggers([1]));
      expect(explained1, equals('[RichText:(:Foo)]'));
      final built1 = helper.buildCurrentState();

      await explain(tester, html,
          enableCaching: true, rebuildTriggers: RebuildTriggers([2]));
      final built2 = helper.buildCurrentState();
      _expect(built1, built2, isFalse);
    });

    testWidgets('rebuild new textStyle', (tester) async {
      const html = 'Foo';

      final explained1 = await explain(tester, html, enableCaching: true);
      expect(explained1, equals('[RichText:(:Foo)]'));

      final explained2 = await explain(tester, html,
          enableCaching: true, textStyle: const TextStyle(fontSize: 20));
      expect(explained2, equals('[RichText:(@20.0:Foo)]'));
    });

    testWidgets('skips caching', (WidgetTester tester) async {
      const html = 'Foo';
      final explained = await explain(tester, html, enableCaching: false);
      expect(explained, equals('[RichText:(:Foo)]'));
      final built1 = helper.buildCurrentState();

      await explain(tester, html, enableCaching: false);
      final built2 = helper.buildCurrentState();
      _expect(built1, built2, isFalse);
    });
  });

  group('baseUrl', () {
    final baseUrl = Uri.parse('http://base.com/path/');
    const html = '<img src="image.png" alt="image dot png" />';

    testWidgets('renders without value', (WidgetTester tester) async {
      final e = await explain(tester, HtmlWidget(html, key: helper.hwKey));
      expect(e, equals('[RichText:(:image dot png)]'));
    });

    testWidgets(
      'renders with value',
      (tester) => mockNetworkImages(() async {
        final explained = await explain(
          tester,
          HtmlWidget(html, baseUrl: baseUrl, key: helper.hwKey),
        );
        expect(
            explained,
            equals(
                '[CssSizing:height≥0.0,height=auto,width≥0.0,width=auto,child='
                '[Image:image=NetworkImage("http://base.com/path/image.png", scale: 1.0),'
                'semanticLabel=image dot png'
                ']]'));
      }),
    );
  });

  group('customStylesBuilder', () {
    const html = 'Hello <span class="name">World</span>!';

    testWidgets('renders without value', (WidgetTester tester) async {
      final e = await explain(tester, HtmlWidget(html, key: helper.hwKey));
      expect(e, equals('[RichText:(:Hello World!)]'));
    });

    testWidgets('renders with value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        HtmlWidget(
          html,
          customStylesBuilder: (e) =>
              e.classes.contains('name') ? {'color': 'red'} : null,
          key: helper.hwKey,
        ),
      );
      expect(explained, equals('[RichText:(:Hello (#FFFF0000:World)(:!))]'));
    });
  });

  group('customWidgetBuilder', () {
    Widget? customWidgetBuilder(dom.Element _) => const Text('Bar');
    const html = 'Foo <span>bar</span>';

    testWidgets('renders without value', (WidgetTester tester) async {
      final e = await explain(tester, HtmlWidget(html, key: helper.hwKey));
      expect(e, equals('[RichText:(:Foo bar)]'));
    });

    testWidgets('renders with value', (WidgetTester tester) async {
      final e = await explain(
        tester,
        HtmlWidget(
          html,
          customWidgetBuilder: customWidgetBuilder,
          key: helper.hwKey,
        ),
      );
      expect(e, equals('[Column:children=[RichText:(:Foo)],[Text:Bar]]'));
    });
  });

  group('customWidgetBuilder (TABLE)', () {
    Widget? customWidgetBuilder(dom.Element e) =>
        e.localName == 'table' ? const Text('Bar') : null;
    const html = 'Foo <table><tr><td>bar</td></tr></table>';

    testWidgets('renders without value', (WidgetTester tester) async {
      final explained =
          await explain(tester, HtmlWidget(html, key: helper.hwKey));
      expect(explained, isNot(contains('Bar')));
    });

    testWidgets('renders with value', (WidgetTester tester) async {
      final e = await explain(
        tester,
        HtmlWidget(
          html,
          customWidgetBuilder: customWidgetBuilder,
          key: helper.hwKey,
        ),
      );
      expect(e, equals('[Column:children=[RichText:(:Foo)],[Text:Bar]]'));
    });
  });

  group('hyperlinkColor', () {
    const hyperlinkColor = Color.fromRGBO(255, 0, 0, 1);
    const html = '<a>Foo</a>';

    testWidgets('renders default value', (WidgetTester tester) async {
      final e = await explain(tester, HtmlWidget(html, key: helper.hwKey));
      expect(e, equals('[RichText:(#FF123456+u:Foo)]'));
    });

    testWidgets('renders custom value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        HtmlWidget(html, hyperlinkColor: hyperlinkColor, key: helper.hwKey),
      );
      expect(explained, equals('[RichText:(#FFFF0000+u:Foo)]'));
    });
  });

  group('onTapUrl', () {
    testWidgets('triggers callback (returns void)', (tester) async {
      const href = 'returns-void';
      final urls = <String>[];
      final onTapCallbackResults = [];

      await tester.pumpWidget(_OnTapUrlApp(
        href: href,
        onTapCallbackResults: onTapCallbackResults,
        onTapUrl: urls.add,
      ));
      await tester.pumpAndSettle();
      expect(await helper.tapText(tester, 'Tap me'), equals(1));

      expect(urls, equals(const [href]));
      expect(onTapCallbackResults, equals(const [href, true]));
    });

    testWidgets('triggers callback (returns false)', (tester) async {
      const href = 'returns-false';
      final onTapCallbackResults = [];

      await tester.pumpWidget(_OnTapUrlApp(
        href: href,
        onTapCallbackResults: onTapCallbackResults,
        onTapUrl: (_) => false,
      ));
      await tester.pumpAndSettle();
      expect(await helper.tapText(tester, 'Tap me'), equals(1));

      expect(onTapCallbackResults, equals(const [href, false]));
    });

    testWidgets('triggers callback (returns true)', (tester) async {
      const href = 'returns-true';
      final onTapCallbackResults = [];

      await tester.pumpWidget(_OnTapUrlApp(
        href: href,
        onTapCallbackResults: onTapCallbackResults,
        onTapUrl: (_) => true,
      ));
      await tester.pumpAndSettle();
      expect(await helper.tapText(tester, 'Tap me'), equals(1));

      expect(onTapCallbackResults, equals(const [href, true]));
    });

    testWidgets('triggers callback (async false)', (tester) async {
      const href = 'returns-false';
      final onTapCallbackResults = [];

      await tester.pumpWidget(_OnTapUrlApp(
        href: href,
        onTapCallbackResults: onTapCallbackResults,
        onTapUrl: (_) async => false,
      ));
      await tester.pumpAndSettle();
      expect(await helper.tapText(tester, 'Tap me'), equals(1));

      expect(onTapCallbackResults, equals(const [href, false]));
    });

    testWidgets('triggers callback (async true)', (tester) async {
      const href = 'returns-true';
      final onTapCallbackResults = [];

      await tester.pumpWidget(_OnTapUrlApp(
        href: href,
        onTapCallbackResults: onTapCallbackResults,
        onTapUrl: (_) async => true,
      ));
      await tester.pumpAndSettle();
      expect(await helper.tapText(tester, 'Tap me'), equals(1));

      expect(onTapCallbackResults, equals(const [href, true]));
    });

    testWidgets('default handler', (WidgetTester tester) async {
      const href = 'default';
      final onTapCallbackResults = [];

      await tester.pumpWidget(_OnTapUrlApp(
        href: href,
        onTapCallbackResults: onTapCallbackResults,
      ));
      await tester.pumpAndSettle();
      expect(await helper.tapText(tester, 'Tap me'), equals(1));

      expect(onTapCallbackResults, equals(const [href, false]));
    });
  });

  group('renderMode', () {
    Future<String> explain(
      WidgetTester tester,
      RenderMode renderMode, {
      bool buildAsync = false,
      String? html,
    }) {
      final hw = HtmlWidget(
        html ?? '<p>Foo</p><p>Bar</p>',
        buildAsync: buildAsync,
        key: helper.hwKey,
        renderMode: renderMode,
      );

      return helper.explain(
        tester,
        null,
        hw: renderMode == RenderMode.sliverList
            ? CustomScrollView(slivers: [hw])
            : hw,
        useExplainer: false,
      );
    }

    testWidgets('renders Column', (WidgetTester tester) async {
      final explained = await explain(tester, RenderMode.column);
      expect(explained, contains('└Column('));
    });

    testWidgets('renders ListView', (WidgetTester tester) async {
      final explained = await explain(tester, RenderMode.listView);
      expect(explained, contains('└ListView('));
      expect(explained, isNot(contains('└Column(')));
    });

    testWidgets('renders SliverList', (WidgetTester tester) async {
      final explained = await explain(tester, RenderMode.sliverList);
      expect(explained, contains('└SliverList('));
      expect(explained, isNot(contains('└Column(')));
    });

    testWidgets('renders SliverList (buildAsync)', (WidgetTester tester) async {
      final e = await explain(tester, RenderMode.sliverList, buildAsync: true);
      expect(e, contains('└SliverToBoxAdapter('));
    });

    testWidgets('renders SliverList (CssBlock unwrap)', (tester) async {
      final explained = await explain(
        tester,
        RenderMode.sliverList,
        html: '<div><p>Foo</p><p>Bar</p></div>',
      );
      expect(explained.split('└CssBlock(').length, equals(3),
          reason: '$explained has too many `CssBlock`s');
    });
  });

  group('textStyle', () {
    const html = 'Foo';

    testWidgets('renders without value', (WidgetTester tester) async {
      final e = await explain(tester, HtmlWidget(html, key: helper.hwKey));
      expect(e, equals('[RichText:(:Foo)]'));
    });

    testWidgets('renders with value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        HtmlWidget(
          html,
          key: helper.hwKey,
          textStyle: const TextStyle(fontStyle: FontStyle.italic),
        ),
      );
      expect(explained, equals('[RichText:(+i:Foo)]'));
    });
  });
}

class _OnTapUrlApp extends StatelessWidget {
  final String href;
  final dynamic Function(String)? onTapUrl;
  final List? onTapCallbackResults;

  const _OnTapUrlApp({
    Key? key,
    required this.href,
    this.onTapCallbackResults,
    this.onTapUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext _) => MaterialApp(
        home: Scaffold(
          body: HtmlWidget(
            '<a href="$href">Tap me</a>',
            factoryBuilder: () => _OnTapUrlFactory(
              onTapCallbackResults: onTapCallbackResults,
            ),
            onTapUrl: onTapUrl,
          ),
        ),
      );
}

class _OnTapUrlFactory extends WidgetFactory {
  final List? onTapCallbackResults;

  _OnTapUrlFactory({this.onTapCallbackResults});

  @override
  Future<bool> onTapCallback(String url) async {
    final result = await super.onTapCallback(url);
    onTapCallbackResults?.addAll([url, result]);
    return result;
  }
}
