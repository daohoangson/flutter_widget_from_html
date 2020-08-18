import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_widget_from_html_core/src/internal/tsh_widget.dart';

import '_.dart' as helper;

Future<String> explain(WidgetTester t, HtmlWidget hw) =>
    helper.explain(t, null, hw: hw);

void main() {
  group('buildAsync', () {
    final explain = (WidgetTester tester, String html, bool buildAsync) =>
        tester.runAsync(() => helper.explain(tester, null,
            hw: HtmlWidget(
              html,
              buildAsync: buildAsync,
              key: helper.hwKey,
            )));

    testWidgets('uses FutureBuilder', (WidgetTester tester) async {
      final html = 'Foo';
      final explained = await explain(tester, html, true);
      expect(explained, equals('[FutureBuilder:[RichText:(:$html)]]'));
    });

    testWidgets('skips FutureBuilder', (WidgetTester tester) async {
      final html = 'Foo';
      final explained = await explain(tester, html, false);
      expect(explained, equals('[RichText:(:$html)]'));
    });

    testWidgets('uses FutureBuilder automatically', (tester) async {
      final html = 'Foo' * kShouldBuildAsync;
      final explained = await explain(tester, html, null);
      expect(explained, equals('[FutureBuilder:[RichText:(:$html)]]'));
    });
  });

  group('buildAsyncBuilder', () {
    final explain = (
      WidgetTester tester,
      String html, {
      AsyncWidgetBuilder<Widget> buildAsyncBuilder,
      bool withData,
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
        final html = 'Foo';
        final explained = await explain(tester, html, withData: true);
        expect(explained, equals('[FutureBuilder:[RichText:(:$html)]]'));
      });

      testWidgets('renders indicator', (WidgetTester tester) async {
        final html = 'Foo';
        final explained = await explain(tester, html, withData: false);
        expect(
            explained,
            equals('[FutureBuilder:'
                '[Center:child='
                '[Padding:(8,8,8,8),child='
                '[CircularProgressIndicator]'
                ']]]'));
      });
    });

    group('custom', () {
      final buildAsyncBuilder =
          (BuildContext _, AsyncSnapshot<Widget> snapshot) =>
              snapshot.hasData ? snapshot.data : Text('No data');

      testWidgets('renders data', (WidgetTester tester) async {
        final html = 'Foo';
        final explained = await explain(
          tester,
          html,
          buildAsyncBuilder: buildAsyncBuilder,
          withData: true,
        );
        expect(explained, equals('[FutureBuilder:[RichText:(:$html)]]'));
      });

      testWidgets('renders indicator', (WidgetTester tester) async {
        final html = 'Foo';
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
    final explain = (
      WidgetTester tester,
      String html,
      bool enableCaching, {
      Uri baseUrl,
      bool buildAsync,
      Color hyperlinkColor = const Color.fromRGBO(0, 0, 255, 1),
      TextStyle textStyle,
    }) =>
        helper.explain(tester, null,
            hw: HtmlWidget(
              html,
              baseUrl: baseUrl,
              buildAsync: buildAsync,
              enableCaching: enableCaching,
              hyperlinkColor: hyperlinkColor,
              key: helper.hwKey,
              textStyle: textStyle,
            ));

    final _expect = (Widget built1, Widget built2, Matcher matcher) {
      final widget1 = (built1 as TshWidget).child;
      final widget2 = (built2 as TshWidget).child;
      expect(widget1 == widget2, matcher);
    };

    testWidgets('caches built widget tree', (WidgetTester tester) async {
      final html = 'Foo';
      final explained = await explain(tester, html, true);
      expect(explained, equals('[RichText:(:Foo)]'));
      final built1 = helper.buildCurrentState();

      await explain(tester, html, true);
      final built2 = helper.buildCurrentState();
      _expect(built1, built2, isTrue);
    });

    testWidgets('rebuild new html', (WidgetTester tester) async {
      final html1 = 'Foo';
      final html2 = 'Bar';

      final explained1 = await explain(tester, html1, true);
      expect(explained1, equals('[RichText:(:Foo)]'));

      final explained2 = await explain(tester, html2, true);
      expect(explained2, equals('[RichText:(:Bar)]'));
    });

    testWidgets('rebuild new baseUrl', (tester) async {
      final html = 'Foo';

      final explained1 = await explain(tester, html, true);
      expect(explained1, equals('[RichText:(:Foo)]'));
      final built1 = helper.buildCurrentState();

      await explain(tester, html, true, baseUrl: Uri.http('domain.com', ''));
      final built2 = helper.buildCurrentState();
      _expect(built1, built2, isFalse);
    });

    testWidgets('rebuild new buildAsync', (tester) async {
      final html = 'Foo';

      final explained1 = await explain(tester, html, true);
      expect(explained1, equals('[RichText:(:Foo)]'));
      final built1 = helper.buildCurrentState();

      await explain(tester, html, true, buildAsync: false);
      final built2 = helper.buildCurrentState();
      _expect(built1, built2, isFalse);
    });

    testWidgets('rebuild new enableCaching', (tester) async {
      final html = 'Foo';

      final explained1 = await explain(tester, html, true);
      expect(explained1, equals('[RichText:(:Foo)]'));
      final built1 = helper.buildCurrentState();

      await explain(tester, html, false);
      final built2 = helper.buildCurrentState();
      _expect(built1, built2, isFalse);
    });

    testWidgets('rebuild new hyperlinkColor', (tester) async {
      final html = 'Foo';

      final explained1 = await explain(tester, html, true);
      expect(explained1, equals('[RichText:(:Foo)]'));
      final built1 = helper.buildCurrentState();

      await explain(tester, html, true,
          hyperlinkColor: Color.fromRGBO(255, 0, 0, 1));
      final built2 = helper.buildCurrentState();
      _expect(built1, built2, isFalse);
    });

    testWidgets('rebuild new textStyle', (tester) async {
      final html = 'Foo';

      final explained1 = await explain(tester, html, true);
      expect(explained1, equals('[RichText:(:Foo)]'));

      final explained2 =
          await explain(tester, html, true, textStyle: TextStyle(fontSize: 20));
      expect(explained2, equals('[RichText:(@20.0:Foo)]'));
    });

    testWidgets('skips caching', (WidgetTester tester) async {
      final html = 'Foo';
      final explained = await explain(tester, html, false);
      expect(explained, equals('[RichText:(:Foo)]'));
      final built1 = helper.buildCurrentState();

      await explain(tester, html, false);
      final built2 = helper.buildCurrentState();
      _expect(built1, built2, isFalse);
    });
  });

  group('baseUrl', () {
    final baseUrl = Uri.parse('http://base.com/path/');
    final html = '<img src="image.png" alt="image dot png" />';

    testWidgets('renders without value', (WidgetTester tester) async {
      final e = await explain(tester, HtmlWidget(html, key: helper.hwKey));
      expect(e, equals('[RichText:(:image dot png)]'));
    });

    testWidgets('renders with value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        HtmlWidget(html, baseUrl: baseUrl, key: helper.hwKey),
      );
      expect(
          explained,
          equals(
              '[Image:image=CachedNetworkImageProvider("http://base.com/path/image.png", scale: 1.0),'
              'semanticLabel=image dot png'
              ']'));
    });
  });

  group('customStylesBuilder', () {
    final html = 'Hello <span class="name">World</span>!';

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
    final CustomWidgetBuilder customWidgetBuilder = (_) => Text('Bar');
    final html = '<span>Foo</span>';

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
      expect(explained, equals('[CssBlock:child=[Text:Bar]]'));
    });
  });

  group('hyperlinkColor', () {
    final hyperlinkColor = Color.fromRGBO(255, 0, 0, 1);
    final html = '<a>Foo</a>';

    testWidgets('renders without value', (WidgetTester tester) async {
      final e = await explain(tester, HtmlWidget(html, key: helper.hwKey));
      expect(e, equals('[RichText:(#FF123456+u:Foo)]'));
    });

    testWidgets('renders with value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        HtmlWidget(html, hyperlinkColor: hyperlinkColor, key: helper.hwKey),
      );
      expect(explained, equals('[RichText:(#FFFF0000+u:Foo)]'));
    });
  });

  // TODO: onTapUrl

  group('textStyle', () {
    final html = 'Foo';

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
          textStyle: TextStyle(fontStyle: FontStyle.italic),
        ),
      );
      expect(e, equals('[RichText:(+i:Foo)]'));
    });
  });

  group('webView', () {
    final webViewSrc = 'http://domain.com';
    final html = '<iframe src="$webViewSrc"></iframe>';
    final webViewDefaultAspectRatio = '1.78';

    testWidgets('renders default value', (WidgetTester tester) async {
      final e = await explain(tester, HtmlWidget(html, key: helper.hwKey));
      expect(
          e,
          equals(
              '[CssBlock:child=[GestureDetector:child=[Text:$webViewSrc]]]'));
    });

    testWidgets('renders true value', (WidgetTester tester) async {
      final explained = await explain(
          tester,
          HtmlWidget(
            html,
            key: helper.hwKey,
            webView: true,
          ));
      expect(
          explained,
          equals('[CssBlock:child=[WebView:'
              'url=$webViewSrc,'
              'aspectRatio=$webViewDefaultAspectRatio,'
              'autoResize=true]]'));
    });

    testWidgets('renders false value', (WidgetTester tester) async {
      final explained = await explain(
          tester,
          HtmlWidget(
            html,
            key: helper.hwKey,
            webView: false,
          ));
      expect(
          explained,
          equals(
              '[CssBlock:child=[GestureDetector:child=[Text:$webViewSrc]]]'));
    });

    testWidgets('renders null value', (WidgetTester tester) async {
      final explained = await explain(
          tester,
          HtmlWidget(
            html,
            key: helper.hwKey,
            webView: null,
          ));
      expect(
          explained,
          equals(
              '[CssBlock:child=[GestureDetector:child=[Text:$webViewSrc]]]'));
    });

    group('unsupportedWebViewWorkaroundForIssue37', () {
      testWidgets('renders true value', (WidgetTester tester) async {
        final explained = await explain(
            tester,
            HtmlWidget(
              html,
              key: helper.hwKey,
              unsupportedWebViewWorkaroundForIssue37: true,
              webView: true,
            ));
        expect(
            explained,
            equals('[CssBlock:child=[WebView:'
                'url=$webViewSrc,'
                'aspectRatio=$webViewDefaultAspectRatio,'
                'autoResize=true,'
                'unsupportedWorkaroundForIssue37=true'
                ']]'));
      });

      testWidgets('renders false value', (WidgetTester tester) async {
        final explained = await explain(
            tester,
            HtmlWidget(
              html,
              key: helper.hwKey,
              unsupportedWebViewWorkaroundForIssue37: false,
              webView: true,
            ));
        expect(
            explained,
            equals('[CssBlock:child=[WebView:'
                'url=$webViewSrc,'
                'aspectRatio=$webViewDefaultAspectRatio,'
                'autoResize=true'
                ']]'));
      });

      testWidgets('renders null value', (WidgetTester tester) async {
        final explained = await explain(
            tester,
            HtmlWidget(
              html,
              key: helper.hwKey,
              unsupportedWebViewWorkaroundForIssue37: null,
              webView: true,
            ));
        expect(
            explained,
            equals('[CssBlock:child=[WebView:'
                'url=$webViewSrc,'
                'aspectRatio=$webViewDefaultAspectRatio,'
                'autoResize=true'
                ']]'));
      });
    });

    group('webViewJs', () {
      testWidgets('renders true value', (WidgetTester tester) async {
        final explained = await explain(
            tester,
            HtmlWidget(
              html,
              key: helper.hwKey,
              webView: true,
              webViewJs: true,
            ));
        expect(
            explained,
            equals('[CssBlock:child=[WebView:'
                'url=$webViewSrc,'
                'aspectRatio=$webViewDefaultAspectRatio,'
                'autoResize=true'
                ']]'));
      });

      testWidgets('renders false value', (WidgetTester tester) async {
        final explained = await explain(
            tester,
            HtmlWidget(
              html,
              key: helper.hwKey,
              webView: true,
              webViewJs: false,
            ));
        expect(
            explained,
            equals('[CssBlock:child=[WebView:'
                'url=$webViewSrc,'
                'aspectRatio=$webViewDefaultAspectRatio,'
                'js=false'
                ']]'));
      });

      testWidgets('renders null value', (WidgetTester tester) async {
        final explained = await explain(
            tester,
            HtmlWidget(
              html,
              key: helper.hwKey,
              webView: true,
              webViewJs: null,
            ));
        expect(
            explained,
            equals('[CssBlock:child=[WebView:'
                'url=$webViewSrc,'
                'aspectRatio=$webViewDefaultAspectRatio,'
                'js=false'
                ']]'));
      });
    });
  });
}
