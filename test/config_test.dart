import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

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
                '[CircularProgressIndicator:]'
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
    final explain = (WidgetTester tester, String html, bool enableCaching) =>
        helper.explain(tester, null,
            hw: HtmlWidget(
              html,
              enableCaching: enableCaching,
              key: helper.hwKey,
            ));

    testWidgets('caches built widget tree', (WidgetTester tester) async {
      final html = 'Foo';
      final explained = await explain(tester, html, true);
      expect(explained, equals('[RichText:(:Foo)]'));

      final built1 = helper.buildCurrentState();
      final built2 = helper.buildCurrentState();
      expect(built1 == built2, isTrue);
    });

    testWidgets('invalidates cache on new html', (WidgetTester tester) async {
      final html1 = 'Foo';
      final html2 = 'Bar';

      final explained1 = await explain(tester, html1, true);
      expect(explained1, equals('[RichText:(:Foo)]'));

      final explained2 = await explain(tester, html2, true);
      expect(explained2, equals('[RichText:(:Bar)]'));
    });

    testWidgets('skips caching', (WidgetTester tester) async {
      final html = 'Foo';
      final explained = await explain(tester, html, false);
      expect(explained, equals('[RichText:(:Foo)]'));

      final built1 = helper.buildCurrentState();
      final built2 = helper.buildCurrentState();
      expect(built1 == built2, isFalse);
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
          equals('[ImageLayout('
              'CachedNetworkImageProvider("http://base.com/path/image.png", scale: 1.0), '
              'text: "image dot png"'
              ')]'));
    });
  });

  group('customStylesBuilder', () {
    final CustomStylesBuilder customStylesBuilder =
        (_) => ['font-style', 'italic'];
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
          customStylesBuilder: customStylesBuilder,
          key: helper.hwKey,
        ),
      );
      expect(explained, equals('[RichText:(+i:Foo)]'));
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
      expect(explained, equals('[Text:Bar]'));
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

    testWidgets('renders default value', (WidgetTester tester) async {
      final e = await explain(tester, HtmlWidget(html, key: helper.hwKey));
      expect(e, equals('[GestureDetector:child=[Text:$webViewSrc]]'));
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
          equals('[WebView('
              '"$webViewSrc", '
              'aspectRatio=1.78, '
              'getDimensions: true'
              ')]'));
    });

    testWidgets('renders false value', (WidgetTester tester) async {
      final e = await explain(
          tester,
          HtmlWidget(
            html,
            key: helper.hwKey,
            webView: false,
          ));
      expect(e, equals('[GestureDetector:child=[Text:http://domain.com]]'));
    });

    testWidgets('renders null value', (WidgetTester tester) async {
      final e = await explain(
          tester,
          HtmlWidget(
            html,
            key: helper.hwKey,
            webView: null,
          ));
      expect(e, equals('[GestureDetector:child=[Text:http://domain.com]]'));
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
            equals('[WebView('
                '"$webViewSrc", '
                'aspectRatio=1.78, '
                'getDimensions: true, '
                'unsupportedWorkaroundForIssue37: true'
                ')]'));
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
            equals('[WebView('
                '"$webViewSrc", '
                'aspectRatio=1.78, '
                'getDimensions: true'
                ')]'));
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
            equals('[WebView('
                '"$webViewSrc", '
                'aspectRatio=1.78, '
                'getDimensions: true'
                ')]'));
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
            equals('[WebView('
                '"$webViewSrc", '
                'aspectRatio=1.78, '
                'getDimensions: true'
                ')]'));
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
            equals('[WebView('
                '"$webViewSrc", '
                'aspectRatio=1.78, '
                'js: false'
                ')]'));
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
            equals('[WebView('
                '"$webViewSrc", '
                'aspectRatio=1.78, '
                'js: false'
                ')]'));
      });
    });
  });
}
