// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_widget_from_html_core/src/internal/html_style_widget.dart';
import 'package:html/dom.dart' as dom;

import '../../fwfh_url_launcher/test/mock_url_launcher_platform.dart';
import '_.dart' as helper;

Future<String> explain(WidgetTester t, HtmlWidget hw) =>
    helper.explain(t, null, hw: hw);

void main() {
  group('buildAsync', () {
    Future<String?> explain(
      WidgetTester tester,
      String html, {
      bool? buildAsync,
    }) =>
        helper.explain(
          tester,
          null,
          hw: HtmlWidget(html, buildAsync: buildAsync, key: helper.hwKey),
          useExplainer: false,
        );

    testWidgets('uses FutureBuilder', (WidgetTester tester) async {
      const html = 'Foo';
      final explained = await explain(tester, html, buildAsync: true);
      expect(explained, startsWith('FutureBuilder'));
    });

    testWidgets('renders FutureBuilder', (WidgetTester tester) async {
      const html = 'Foo';
      const rendered = 'RichText(text: "Foo")';
      final loading = await explain(tester, html, buildAsync: true);
      expect(loading, isNot(contains(rendered)));

      await tester.runAsync(() => Future.delayed(const Duration(seconds: 1)));
      await tester.pump();

      final success = await helper.explainWithoutPumping(useExplainer: false);

      expect(success, startsWith('FutureBuilder'));
      expect(success, contains(rendered));
    });

    testWidgets('skips FutureBuilder', (WidgetTester tester) async {
      const html = 'Foo';
      final explained = await explain(tester, html, buildAsync: false);
      expect(explained, startsWith('HtmlStyleWidget'));
    });

    testWidgets('uses FutureBuilder automatically', (tester) async {
      final html = 'Foo' * kShouldBuildAsync;
      final explained = await explain(tester, html);
      expect(explained, startsWith('FutureBuilder'));
    });
  });

  group('enableCaching', () {
    Future<String?> explain(
      WidgetTester tester,
      String html, {
      Uri? baseUrl,
      bool? buildAsync,
      required bool enableCaching,
      List<dynamic>? rebuildTriggers,
      TextStyle? textStyle,
    }) =>
        helper.explain(
          tester,
          null,
          hw: HtmlWidget(
            html,
            baseUrl: baseUrl,
            buildAsync: buildAsync,
            enableCaching: enableCaching,
            key: helper.hwKey,
            rebuildTriggers: rebuildTriggers,
            textStyle: textStyle ?? const TextStyle(),
          ),
        );

    void enableCachingExpect(Widget? built1, Widget? built2, Matcher matcher) {
      final widget1 = (built1! as HtmlStyleWidget).child;
      final widget2 = (built2! as HtmlStyleWidget).child;
      expect(widget1 == widget2, matcher);
    }

    testWidgets('caches built widget tree', (WidgetTester tester) async {
      const html = 'Foo';
      final explained = await explain(tester, html, enableCaching: true);
      expect(explained, equals('[RichText:(:Foo)]'));
      final built1 = helper.buildCurrentState();

      await explain(tester, html, enableCaching: true);
      final built2 = helper.buildCurrentState();
      enableCachingExpect(built1, built2, isTrue);
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

      await explain(
        tester,
        html,
        baseUrl: Uri.http('domain.com'),
        enableCaching: true,
      );
      final built2 = helper.buildCurrentState();
      enableCachingExpect(built1, built2, isFalse);
    });

    testWidgets('rebuild new buildAsync', (tester) async {
      const html = 'Foo';

      final explained1 = await explain(tester, html, enableCaching: true);
      expect(explained1, equals('[RichText:(:Foo)]'));
      final built1 = helper.buildCurrentState();

      await explain(tester, html, buildAsync: false, enableCaching: true);
      final built2 = helper.buildCurrentState();
      enableCachingExpect(built1, built2, isFalse);
    });

    testWidgets('rebuild new enableCaching', (tester) async {
      const html = 'Foo';

      final explained1 = await explain(tester, html, enableCaching: true);
      expect(explained1, equals('[RichText:(:Foo)]'));
      final built1 = helper.buildCurrentState();

      await explain(tester, html, enableCaching: false);
      final built2 = helper.buildCurrentState();
      enableCachingExpect(built1, built2, isFalse);
    });

    testWidgets('rebuild new rebuildTriggers', (tester) async {
      const html = 'Foo';

      final explained1 = await explain(
        tester,
        html,
        enableCaching: true,
        rebuildTriggers: [1],
      );
      expect(explained1, equals('[RichText:(:Foo)]'));
      final built1 = helper.buildCurrentState();

      await explain(
        tester,
        html,
        enableCaching: true,
        rebuildTriggers: [2],
      );
      final built2 = helper.buildCurrentState();
      enableCachingExpect(built1, built2, isFalse);
    });

    testWidgets('rebuild new textStyle', (tester) async {
      const html = 'Foo';

      final explained1 = await explain(tester, html, enableCaching: true);
      expect(explained1, equals('[RichText:(:Foo)]'));

      final explained2 = await explain(
        tester,
        html,
        enableCaching: true,
        textStyle: const TextStyle(fontSize: 20),
      );
      expect(explained2, equals('[RichText:(@20.0:Foo)]'));
    });

    testWidgets('skips caching', (WidgetTester tester) async {
      const html = 'Foo';
      final explained = await explain(tester, html, enableCaching: false);
      expect(explained, equals('[RichText:(:Foo)]'));
      final built1 = helper.buildCurrentState();

      await explain(tester, html, enableCaching: false);
      final built2 = helper.buildCurrentState();
      enableCachingExpect(built1, built2, isFalse);
    });
  });

  group('baseUrl', () {
    final baseUrl = Uri.parse('http://base.com/path/');
    const html = '<img src="image.png" alt="image dot png" />';

    testWidgets('renders without value', (WidgetTester tester) async {
      final e = await explain(tester, HtmlWidget(html, key: helper.hwKey));
      expect(e, equals('[RichText:(:image dot png)]'));
    });

    testWidgets('renders with value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        HtmlWidget(html, baseUrl: baseUrl, key: helper.hwKey),
      );
      expect(explained, contains('CachedNetworkImage'));
    });
  });

  group('customStylesBuilder', () {
    group('color: red', () {
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

    group('resets FIGURE margin', () {
      const html = '<figure class="name">Foo</figure>';

      testWidgets('renders without value', (WidgetTester tester) async {
        final e = await explain(tester, HtmlWidget(html, key: helper.hwKey));
        expect(
          e,
          equals(
            '[Padding:(0,40,0,40),child='
            '[CssBlock:child=[RichText:(:Foo)]]'
            ']',
          ),
        );
      });

      testWidgets('renders with value', (WidgetTester tester) async {
        final explained = await explain(
          tester,
          HtmlWidget(
            html,
            customStylesBuilder: (e) =>
                e.classes.contains('name') ? {'margin': '0'} : null,
            key: helper.hwKey,
          ),
        );
        expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
      });
    });
  });

  group('customWidgetBuilder', () {
    Widget? customWidgetBuilder(dom.Element element) => const Text('Bar');
    const html = '<span>Foo</span>';

    testWidgets('renders without value', (WidgetTester tester) async {
      final e = await explain(tester, HtmlWidget(html, key: helper.hwKey));
      expect(e, equals('[RichText:(:Foo)]'));
    });

    testWidgets('renders with value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        HtmlWidget(
          html,
          customWidgetBuilder: customWidgetBuilder,
          key: helper.hwKey,
        ),
      );
      expect(explained, equals('[Text:Bar]'));
    });
  });

  group('customWidgetBuilder (VIDEO)', () {
    Widget? customWidgetBuilder(dom.Element e) =>
        e.localName == 'video' ? const Text('Bar') : null;
    const src = 'http://domain.com/video.mp4';
    const html = 'Foo <video width="21" height="9"><source src="$src"></video>';

    testWidgets('renders without value', (WidgetTester tester) async {
      final explained =
          await explain(tester, HtmlWidget(html, key: helper.hwKey));
      expect(
        explained,
        equals(
          '[Column:children='
          '[RichText:(:Foo)],'
          '[VideoPlayer:url=http://domain.com/video.mp4,aspectRatio=2.33,autoResize=false]'
          ']',
        ),
      );
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

  group('onErrorBuilder', () {
    Future<String?> explain(
      WidgetTester tester, {
      required bool buildAsync,
      OnErrorBuilder? onErrorBuilder,
    }) async {
      await runZonedGuarded(
        () async {
          await helper.explain(
            tester,
            null,
            hw: HtmlWidget(
              'Foo <span class="throw">bar</span>.',
              buildAsync: buildAsync,
              factoryBuilder: () => _OnErrorBuilderFactory(),
              key: helper.hwKey,
              onErrorBuilder: onErrorBuilder,
            ),
            useExplainer: false,
          );

          await tester
              .runAsync(() => Future.delayed(const Duration(seconds: 1)));
          await tester.pump();
        },
        (_, __) {},
      );

      return helper.explainWithoutPumping(useExplainer: false);
    }

    testWidgets('[sync] renders default', (tester) async {
      final explained = await explain(tester, buildAsync: false);
      expect(explained, contains('Text("❌")'));
    });

    testWidgets('[sync] renders custom', (tester) async {
      final explained = await explain(
        tester,
        buildAsync: false,
        onErrorBuilder: (_, __, ___) => const Text('sync error'),
      );
      expect(explained, contains('RichText(text: "sync error")'));
    });

    testWidgets('[async] renders default', (tester) async {
      final explained = await explain(tester, buildAsync: true);
      expect(explained, contains('Text("❌")'));
    });

    testWidgets('[async] renders custom', (tester) async {
      final explained = await explain(
        tester,
        buildAsync: true,
        onErrorBuilder: (_, __, ___) => const Text('async error'),
      );
      expect(explained, contains('RichText(text: "async error")'));
    });
  });

  group('onLoadingBuilder', () {
    Future<String?> explain(
      WidgetTester tester, {
      OnLoadingBuilder? onLoadingBuilder,
    }) =>
        helper.explain(
          tester,
          null,
          hw: HtmlWidget(
            'Foo',
            buildAsync: true,
            key: helper.hwKey,
            onLoadingBuilder: onLoadingBuilder,
          ),
          useExplainer: false,
        );

    testWidgets('renders CircularProgressIndicator', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      final explained = await explain(tester);
      expect(explained, contains('CircularProgressIndicator'));
      expect(explained, isNot(contains('CupertinoActivityIndicator')));
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('renders CupertinoActivityIndicator', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      final explained = await explain(tester);
      expect(explained, contains('CupertinoActivityIndicator'));
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('renders custom', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        onLoadingBuilder: (_, __, ___) => const Text('Custom'),
      );
      expect(explained, contains('RichText(text: "Custom")'));
    });
  });

  group('onTapUrl', () {
    setUp(mockUrlLauncherPlatform);

    testWidgets('triggers callback (returns false)', (tester) async {
      const href = 'returns-false';
      final urls = <String>[];

      await explain(
        tester,
        HtmlWidget(
          '<a href="$href">Tap me</a>',
          onTapUrl: (url) {
            urls.add(url);
            return false;
          },
        ),
      );
      await tester.pumpAndSettle();
      expect(await helper.tapText(tester, 'Tap me'), equals(1));

      expect(urls, equals(const [href]));
      expect(mockLaunchedUrls, equals(const [href]));
    });

    testWidgets('triggers callback (returns true)', (tester) async {
      const href = 'returns-true';
      final urls = <String>[];

      await explain(
        tester,
        HtmlWidget(
          '<a href="$href">Tap me</a>',
          onTapUrl: (url) {
            urls.add(url);
            return true;
          },
        ),
      );
      await tester.pumpAndSettle();
      expect(await helper.tapText(tester, 'Tap me'), equals(1));

      expect(urls, equals(const [href]));
      expect(mockLaunchedUrls, equals(const []));
    });

    testWidgets('triggers callback (async false)', (tester) async {
      const href = 'async-false';
      final urls = <String>[];

      await explain(
        tester,
        HtmlWidget(
          '<a href="$href">Tap me</a>',
          onTapUrl: (url) async {
            urls.add(url);
            return false;
          },
        ),
      );
      await tester.pumpAndSettle();
      expect(await helper.tapText(tester, 'Tap me'), equals(1));

      expect(urls, equals(const [href]));
      expect(mockLaunchedUrls, equals(const [href]));
    });

    testWidgets('triggers callback (async true)', (tester) async {
      const href = 'async-true';
      final urls = <String>[];

      await explain(
        tester,
        HtmlWidget(
          '<a href="$href">Tap me</a>',
          onTapUrl: (url) async {
            urls.add(url);
            return true;
          },
        ),
      );
      await tester.pumpAndSettle();
      expect(await helper.tapText(tester, 'Tap me'), equals(1));

      expect(urls, equals(const [href]));
      expect(mockLaunchedUrls, equals(const []));
    });

    testWidgets('default handler', (WidgetTester tester) async {
      const href = 'default';
      await explain(
        tester,
        const HtmlWidget('<a href="$href">Tap me</a>'),
      );
      await tester.pumpAndSettle();
      expect(await helper.tapText(tester, 'Tap me'), equals(1));

      expect(mockLaunchedUrls, equals(const [href]));
    });
  });

  group('renderMode', () {
    Future<String> explain(
      WidgetTester tester,
      RenderMode renderMode, {
      bool buildAsync = false,
      String? html,
      GlobalKey? key,
    }) {
      key ??= helper.hwKey;
      final hw = HtmlWidget(
        html ?? '<p>Foo</p><p>Bar</p>',
        buildAsync: buildAsync,
        key: key,
        renderMode: renderMode,
      );

      return helper.explain(
        tester,
        null,
        hw: renderMode == RenderMode.sliverList
            ? CustomScrollView(slivers: [hw])
            : hw,
        key: key,
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

    testWidgets('renders ListView with ScrollController', (tester) async {
      final controller = ScrollController();
      final renderMode = ListViewMode(controller: controller);
      final html =
          '${'Lorem ipsum dolor sit amet, consectetur adipiscing elit. ' * 999}'
          '<a name="bottom">Bottom></a>';
      final key = GlobalKey<HtmlWidgetState>();
      await explain(tester, renderMode, html: html, key: key);
      expect(controller.offset, equals(0));

      final htmlWidget = key.currentState!;
      htmlWidget.scrollToAnchor('bottom');
      await tester.pumpAndSettle();
      expect(controller.offset, isNot(equals(0)));
    });

    testWidgets('renders SliverList', (WidgetTester tester) async {
      final explained = await explain(tester, RenderMode.sliverList);
      expect(explained, contains('└SliverList('));
      expect(explained, isNot(contains('└Column(')));
    });
  });

  group('tags', () {
    const html = 'Hello <foo>World</foo>!';

    testWidgets('renders without value', (WidgetTester tester) async {
      final e = await explain(tester, HtmlWidget(html, key: helper.hwKey));
      expect(e, equals('[RichText:(:Hello World!)]'));
    });

    testWidgets('renders with value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        HtmlWidget(html, key: helper.hwKey, tags: {
          'foo': BuildOp.v1(defaultStyles: (_) => {'color': 'red'})
        }),
      );
      expect(explained, equals('[RichText:(:Hello (#FFFF0000:World)(:!))]'));
    });
  });

  group('textStyle', () {
    const html = 'Foo';

    testWidgets('renders without value', (WidgetTester tester) async {
      final e = await explain(tester, HtmlWidget(html, key: helper.hwKey));
      expect(e, equals('[RichText:(:Foo)]'));
    });

    testWidgets('renders with value', (WidgetTester tester) async {
      final e = await explain(
        tester,
        HtmlWidget(
          html,
          key: helper.hwKey,
          textStyle: const TextStyle(fontStyle: FontStyle.italic),
        ),
      );
      expect(e, equals('[RichText:(+i:Foo)]'));
    });
  });
}

class _OnErrorBuilderFactory extends WidgetFactory {
  @override
  void parse(BuildTree tree) {
    if (tree.element.className == 'throw') {
      throw UnsupportedError(tree.element.outerHtml);
    }

    super.parse(tree);
  }
}
