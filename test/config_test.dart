import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '_.dart' as _;

Future<String> explain(WidgetTester t, HtmlWidget hw) =>
    _.explain(t, null, hw: hw);

void main() {
  group('baseUrl', () {
    final baseUrl = Uri.parse('http://base.com/path/');
    final html = '<img src="image.png" alt="image dot png" />';

    testWidgets('renders without value', (WidgetTester tester) async {
      final e = await explain(tester, HtmlWidget(html, key: _.coreHwKey));
      expect(e,
          equals('[Padding:(10,10,10,10),child=[RichText:(:image dot png)]]'));
    });

    testWidgets('renders with value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        HtmlWidget(html, baseUrl: baseUrl, key: _.coreHwKey),
      );
      expect(
          explained,
          equals('[Padding:(10,10,10,10),child='
              '[RichText:[ImageLayout:'
              'child=[CachedNetworkImageProvider:],'
              'text=image dot png'
              ']]]'));
    });
  });

  group('bodyPadding', () {
    final bodyPadding = EdgeInsets.all(5);
    final html = 'Foo';

    testWidgets('renders default value', (WidgetTester tester) async {
      final e = await explain(tester, HtmlWidget(html, key: _.coreHwKey));
      expect(e, equals('[Padding:(10,10,10,10),child=[RichText:(:Foo)]]'));
    });

    testWidgets('renders custom value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        HtmlWidget(html, bodyPadding: bodyPadding, key: _.coreHwKey),
      );
      expect(explained, equals('[Padding:(5,5,5,5),child=[RichText:(:Foo)]]'));
    });

    testWidgets('renders null value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        HtmlWidget(html, bodyPadding: null, key: _.coreHwKey),
      );
      expect(explained, equals('[RichText:(:Foo)]'));
    });
  });

  group('builderCallback', () {
    final NodeMetadataCollector builderCallback =
        (m, e) => lazySet(null, fontStyleItalic: true);
    final html = '<span>Foo</span>';

    testWidgets('renders without value', (WidgetTester tester) async {
      final e = await explain(tester, HtmlWidget(html, key: _.coreHwKey));
      expect(e, equals('[Padding:(10,10,10,10),child=[RichText:(:Foo)]]'));
    });

    testWidgets('renders with value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        HtmlWidget(html, builderCallback: builderCallback, key: _.coreHwKey),
      );
      expect(
        explained,
        equals('[Padding:(10,10,10,10),child=[RichText:(+i:Foo)]]'),
      );
    });
  });

  group('hyperlinkColor', () {
    final hyperlinkColor = Color.fromRGBO(255, 0, 0, 1);
    final html = '<a>Foo</a>';

    testWidgets('renders without value', (WidgetTester tester) async {
      final e = await explain(tester, HtmlWidget(html, key: _.coreHwKey));
      expect(
          e,
          equals('[Padding:(10,10,10,10),child='
              '[RichText:(#FF123456+u:Foo)]]'));
    });

    testWidgets('renders with value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        HtmlWidget(html, hyperlinkColor: hyperlinkColor, key: _.coreHwKey),
      );
      expect(
          explained,
          equals('[Padding:(10,10,10,10),child='
              '[RichText:(#FFFF0000+u:Foo)]]'));
    });
  });

  // TODO: onTapUrl

  group('tableCellPadding', () {
    final tableCellPadding = EdgeInsets.all(10);
    final html = '<table><tr><td>Foo</td></tr></table>';

    testWidgets('renders default value', (WidgetTester tester) async {
      final e = await explain(tester, HtmlWidget(html, key: _.coreHwKey));
      expect(
          e,
          equals('[Padding:(10,10,10,10),child=[Table:\n'
              '[Padding:(5,5,5,5),child=[RichText:(:Foo)]]\n]]'));
    });

    testWidgets('renders custom value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        HtmlWidget(html, key: _.coreHwKey, tableCellPadding: tableCellPadding),
      );
      expect(
          explained,
          equals('[Padding:(10,10,10,10),child=[Table:\n'
              '[Padding:(10,10,10,10),child=[RichText:(:Foo)]]\n]]'));
    });

    testWidgets('renders null value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        HtmlWidget(html, key: _.coreHwKey, tableCellPadding: null),
      );
      expect(
        explained,
        equals('[Padding:(10,10,10,10),child=[Table:\n[RichText:(:Foo)]\n]]'),
      );
    });
  });

  group('textStyle', () {
    final html = 'Foo';

    testWidgets('renders without value', (WidgetTester tester) async {
      final e = await explain(tester, HtmlWidget(html, key: _.coreHwKey));
      expect(e, equals('[Padding:(10,10,10,10),child=[RichText:(:Foo)]]'));
    });

    testWidgets('renders with value', (WidgetTester tester) async {
      final e = await explain(
        tester,
        HtmlWidget(
          html,
          key: _.coreHwKey,
          textStyle: TextStyle(fontStyle: FontStyle.italic),
        ),
      );
      expect(e, equals('[Padding:(10,10,10,10),child=[RichText:(+i:Foo)]]'));
    });
  });

  group('webView', () {
    final webViewSrc = 'http://domain.com';
    final html = '<iframe src="$webViewSrc"></iframe>';

    testWidgets('renders default value', (WidgetTester tester) async {
      final e = await explain(tester, HtmlWidget(html, key: _.coreHwKey));
      expect(
          e,
          equals('[Padding:(10,10,10,10),child='
              "[GestureDetector:child=[Text:$webViewSrc]]"
              ']'));
    });

    testWidgets('renders true value', (WidgetTester tester) async {
      final explained = await explain(
          tester,
          HtmlWidget(
            html,
            key: _.coreHwKey,
            webView: true,
          ));
      expect(
          explained,
          equals('[Padding:(10,10,10,10),child='
              "[WebView:url=$webViewSrc,aspectRatio=1.78,getDimensions=1,js=1]"
              ']'));
    });

    testWidgets('renders false value', (WidgetTester tester) async {
      final explained = await explain(
          tester,
          HtmlWidget(
            html,
            key: _.coreHwKey,
            webView: false,
          ));
      expect(
          explained,
          equals('[Padding:(10,10,10,10),child='
              '[GestureDetector:child=[Text:http://domain.com]]]'));
    });

    testWidgets('renders null value', (WidgetTester tester) async {
      final explained = await explain(
          tester,
          HtmlWidget(
            html,
            key: _.coreHwKey,
            webView: null,
          ));
      expect(
          explained,
          equals('[Padding:(10,10,10,10),child='
              '[GestureDetector:child=[Text:http://domain.com]]]'));
    });

    group('webViewJs', () {
      final webViewJsSrc = 'http://domain.com';

      testWidgets('renders true value', (WidgetTester tester) async {
        final explained = await explain(
            tester,
            HtmlWidget(
              html,
              key: _.coreHwKey,
              webView: true,
              webViewJs: true,
            ));
        expect(
            explained,
            equals('[Padding:(10,10,10,10),child='
                "[WebView:url=$webViewJsSrc,aspectRatio=1.78,getDimensions=1,js=1]"
                ']'));
      });

      testWidgets('renders false value', (WidgetTester tester) async {
        final explained = await explain(
            tester,
            HtmlWidget(
              html,
              key: _.coreHwKey,
              webView: true,
              webViewJs: false,
            ));
        expect(
            explained,
            equals('[Padding:(10,10,10,10),child='
                "[WebView:url=$webViewJsSrc,aspectRatio=1.78,getDimensions=0,js=0]"
                ']'));
      });

      testWidgets('renders null value', (WidgetTester tester) async {
        final explained = await explain(
            tester,
            HtmlWidget(
              html,
              key: _.coreHwKey,
              webView: true,
              webViewJs: null,
            ));
        expect(
            explained,
            equals('[Padding:(10,10,10,10),child='
                "[WebView:url=$webViewJsSrc,aspectRatio=1.78,getDimensions=0,js=0]"
                ']'));
      });
    });
  });
}
