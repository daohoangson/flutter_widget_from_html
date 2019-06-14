import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '_.dart' as _;
import '../packages/core/test/_.dart' as _coreTesting;

Future<String> explain(WidgetTester t, _coreTesting.HtmlWidgetBuilder hw) =>
    _.explain(t, null, hw: hw);

void main() {
  group('baseUrl', () {
    final baseUrl = Uri.parse('http://base.com/path');
    final html = '<img src="image.png" />';

    testWidgets('renders without value', (WidgetTester tester) async {
      final explained = await explain(tester, (_) => HtmlWidget(html));
      expect(
          explained,
          equals('[Padding:(10,10,10,10),child='
              '[Wrap:spacing=5.0,runSpacing=5.0,'
              'children=[CachedNetworkImage:image.png]]]'));
    });

    testWidgets('renders with value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        (_) => HtmlWidget(html, baseUrl: baseUrl),
      );
      expect(
          explained,
          equals('[Padding:(10,10,10,10),child='
              '[Wrap:spacing=5.0,runSpacing=5.0,'
              'children=[CachedNetworkImage:http://base.com/path/image.png]]]'));
    });
  });

  group('bodyPadding', () {
    final bodyPadding = EdgeInsets.all(5);
    final html = 'Foo';

    testWidgets('renders default value', (WidgetTester tester) async {
      final explained = await explain(tester, (_) => HtmlWidget(html));
      expect(
        explained,
        equals('[Padding:(10,10,10,10),child=[RichText:(:Foo)]]'),
      );
    });

    testWidgets('renders custom value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        (_) => HtmlWidget(html, bodyPadding: bodyPadding),
      );
      expect(explained, equals('[Padding:(5,5,5,5),child=[RichText:(:Foo)]]'));
    });

    testWidgets('renders null value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        (_) => HtmlWidget(html, bodyPadding: null),
      );
      expect(explained, equals('[RichText:(:Foo)]'));
    });
  });

  group('builderCallback', () {
    final NodeMetadataCollector builderCallback =
        (m, e) => lazySet(null, fontStyleItalic: true);
    final html = '<span>Foo</span>';

    testWidgets('renders without value', (WidgetTester tester) async {
      final explained = await explain(tester, (_) => HtmlWidget(html));
      expect(
        explained,
        equals('[Padding:(10,10,10,10),child=[RichText:(:Foo)]]'),
      );
    });

    testWidgets('renders with value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        (_) => HtmlWidget(html, builderCallback: builderCallback),
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
      final explained = await explain(tester, (_) => HtmlWidget(html));
      expect(
          explained,
          equals('[Padding:(10,10,10,10),child='
              '[RichText:(#FF123456+u+onTap:Foo)]]'));
    });

    testWidgets('renders with value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        (_) => HtmlWidget(html, hyperlinkColor: hyperlinkColor),
      );
      expect(
          explained,
          equals('[Padding:(10,10,10,10),child='
              '[RichText:(#FFFF0000+u+onTap:Foo)]]'));
    });
  });

  // TODO: onTapUrl

  group('tableCellPadding', () {
    final tableCellPadding = EdgeInsets.all(10);
    final html = '<table><tr><td>Foo</td></tr></table>';

    testWidgets('renders default value', (WidgetTester tester) async {
      final explained = await explain(tester, (_) => HtmlWidget(html));
      expect(
          explained,
          equals('[Padding:(10,10,10,10),child=[Table:\n'
              '[Padding:(5,5,5,5),child=[RichText:(:Foo)]]\n]]'));
    });

    testWidgets('renders custom value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        (_) => HtmlWidget(html, tableCellPadding: tableCellPadding),
      );
      expect(
          explained,
          equals('[Padding:(10,10,10,10),child=[Table:\n'
              '[Padding:(10,10,10,10),child=[RichText:(:Foo)]]\n]]'));
    });

    testWidgets('renders null value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        (_) => HtmlWidget(html, tableCellPadding: null),
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
      final explained = await explain(tester, (_) => HtmlWidget(html));
      expect(
        explained,
        equals('[Padding:(10,10,10,10),child=[RichText:(:Foo)]]'),
      );
    });

    testWidgets('renders with value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        (context) => HtmlWidget(
              html,
              textStyle: DefaultTextStyle.of(context)
                  .style
                  .copyWith(fontStyle: FontStyle.italic),
            ),
      );
      expect(
        explained,
        equals('[Padding:(10,10,10,10),child=[RichText:(+i:Foo)]]'),
      );
    });
  });

  group('wrapSpacing', () {
    final wrapSpacing = 10.0;
    final html = '<img src="image.png" />';

    testWidgets('renders default value', (WidgetTester tester) async {
      final explained = await explain(tester, (_) => HtmlWidget(html));
      expect(
          explained,
          equals('[Padding:(10,10,10,10),child='
              '[Wrap:spacing=5.0,runSpacing=5.0,'
              'children=[CachedNetworkImage:image.png]]]'));
    });

    testWidgets('renders custom value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        (_) => HtmlWidget(html, wrapSpacing: wrapSpacing),
      );
      expect(
          explained,
          equals('[Padding:(10,10,10,10),child='
              '[Wrap:spacing=10.0,runSpacing=10.0,'
              'children=[CachedNetworkImage:image.png]]]'));
    });

    testWidgets('renders null value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        (_) => HtmlWidget(html, wrapSpacing: null),
      );
      expect(
          explained,
          equals('[Padding:(10,10,10,10),child='
              '[Wrap:children=[CachedNetworkImage:image.png]]]'));
    });
  });

  group('webView', () {
    final html = '<iframe src="http://domain.com"></iframe>';

    testWidgets('renders default value', (WidgetTester tester) async {
      final explained = await explain(tester, (_) => HtmlWidget(html));
      expect(
          explained,
          equals('[Padding:(10,10,10,10),child='
              '[GestureDetector:child=[Text:http://domain.com]]]'));
    });

    testWidgets('renders true value', (WidgetTester tester) async {
      final explained = await explain(
          tester,
          (_) => HtmlWidget(
                html,
                webView: true,
              ));
      expect(
          explained,
          equals('[Padding:(10,10,10,10),child='
              '[WebView:url=http://domain.com,aspectRatio=1.78,getDimensions=true,js=true]]'));
    });

    testWidgets('renders false value', (WidgetTester tester) async {
      final explained = await explain(
          tester,
          (_) => HtmlWidget(
                html,
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
          (_) => HtmlWidget(
                html,
                webView: null,
              ));
      expect(
          explained,
          equals('[Padding:(10,10,10,10),child='
              '[GestureDetector:child=[Text:http://domain.com]]]'));
    });

    group('webViewJs', () {
      testWidgets('renders true value', (WidgetTester tester) async {
        final explained = await explain(
            tester,
            (_) => HtmlWidget(
                  html,
                  webView: true,
                  webViewJs: true,
                ));
        expect(
            explained,
            equals('[Padding:(10,10,10,10),child='
                '[WebView:url=http://domain.com,aspectRatio=1.78,getDimensions=true,js=true]]'));
      });

      testWidgets('renders false value', (WidgetTester tester) async {
        final explained = await explain(
            tester,
            (_) => HtmlWidget(
                  html,
                  webView: true,
                  webViewJs: false,
                ));
        expect(
            explained,
            equals('[Padding:(10,10,10,10),child='
                '[WebView:url=http://domain.com,aspectRatio=1.78,getDimensions=false,js=false]]'));
      });

      testWidgets('renders null value', (WidgetTester tester) async {
        final explained = await explain(
            tester,
            (_) => HtmlWidget(
                  html,
                  webView: true,
                  webViewJs: null,
                ));
        expect(
            explained,
            equals('[Padding:(10,10,10,10),child='
                '[WebView:url=http://domain.com,aspectRatio=1.78,getDimensions=false,js=false]]'));
      });
    });
  });
}
