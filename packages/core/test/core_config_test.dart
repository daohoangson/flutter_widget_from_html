import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '_.dart' as _;

Future<String> explain(WidgetTester t, HtmlWidget hw) =>
    _.explain(t, null, hw: hw);

void main() {
  group('baseUrl', () {
    final baseUrl = Uri.parse('http://base.com/path/');
    final html = '<img src="image.png" alt="image dot png" />';

    testWidgets('renders without value', (WidgetTester tester) async {
      final explained = await explain(tester, HtmlWidget(html, key: _.hwKey));
      expect(
          explained,
          equals('[Padding:(10,10,10,10),child='
              '[RichText:(:image dot png)]]'));
    });

    testWidgets('renders with value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        HtmlWidget(html, baseUrl: baseUrl, key: _.hwKey),
      );
      expect(
          explained,
          equals('[Padding:(10,10,10,10),child=[RichText:[ImageLayout:'
              'child=[NetworkImage:url=http://base.com/path/image.png],'
              'text=image dot png'
              ']]]'));
    });
  });

  group('bodyPadding', () {
    final bodyPadding = EdgeInsets.all(5);
    final html = 'Foo';

    testWidgets('renders default value', (WidgetTester tester) async {
      final explained = await explain(tester, HtmlWidget(html, key: _.hwKey));
      expect(
        explained,
        equals('[Padding:(10,10,10,10),child=[RichText:(:Foo)]]'),
      );
    });

    testWidgets('renders custom value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        HtmlWidget(html, bodyPadding: bodyPadding, key: _.hwKey),
      );
      expect(explained, equals('[Padding:(5,5,5,5),child=[RichText:(:Foo)]]'));
    });

    testWidgets('renders null value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        HtmlWidget(html, bodyPadding: null, key: _.hwKey),
      );
      expect(explained, equals('[RichText:(:Foo)]'));
    });
  });

  group('builderCallback', () {
    final NodeMetadataCollector builderCallback =
        (m, e) => lazySet(null, fontStyleItalic: true);
    final html = '<span>Foo</span>';

    testWidgets('renders without value', (WidgetTester tester) async {
      final explained = await explain(tester, HtmlWidget(html, key: _.hwKey));
      expect(
        explained,
        equals('[Padding:(10,10,10,10),child=[RichText:(:Foo)]]'),
      );
    });

    testWidgets('renders with value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        HtmlWidget(html, builderCallback: builderCallback, key: _.hwKey),
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

    testWidgets('renders default value', (WidgetTester tester) async {
      final explained = await explain(tester, HtmlWidget(html, key: _.hwKey));
      expect(
          explained,
          equals('[Padding:(10,10,10,10),child='
              '[RichText:(#FF0000FF+u:Foo)]]'));
    });

    testWidgets('renders custom value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        HtmlWidget(html, hyperlinkColor: hyperlinkColor, key: _.hwKey),
      );
      expect(
          explained,
          equals('[Padding:(10,10,10,10),child='
              '[RichText:(#FFFF0000+u:Foo)]]'));
    });

    testWidgets('renders null value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        HtmlWidget(html, hyperlinkColor: null, key: _.hwKey),
      );
      expect(
          explained,
          equals('[Padding:(10,10,10,10),child='
              '[RichText:(+u:Foo)]]'));
    });
  });

  // TODO: onTapUrl

  group('tableCellPadding', () {
    final tableCellPadding = EdgeInsets.all(10);
    final html = '<table><tr><td>Foo</td></tr></table>';

    testWidgets('renders default value', (WidgetTester tester) async {
      final explained = await explain(tester, HtmlWidget(html, key: _.hwKey));
      expect(
          explained,
          equals('[Padding:(10,10,10,10),child=[Table:\n'
              '[Padding:(5,5,5,5),child=[RichText:(:Foo)]]\n]]'));
    });

    testWidgets('renders custom value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        HtmlWidget(html, key: _.hwKey, tableCellPadding: tableCellPadding),
      );
      expect(
          explained,
          equals('[Padding:(10,10,10,10),child=[Table:\n'
              '[Padding:(10,10,10,10),child=[RichText:(:Foo)]]\n]]'));
    });

    testWidgets('renders null value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        HtmlWidget(html, key: _.hwKey, tableCellPadding: null),
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
      final explained = await explain(tester, HtmlWidget(html, key: _.hwKey));
      expect(
        explained,
        equals('[Padding:(10,10,10,10),child=[RichText:(:Foo)]]'),
      );
    });

    testWidgets('renders with value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        HtmlWidget(
          html,
          key: _.hwKey,
          textStyle: TextStyle(fontStyle: FontStyle.italic),
        ),
      );
      expect(
        explained,
        equals('[Padding:(10,10,10,10),child=[RichText:(+i:Foo)]]'),
      );
    });
  });
}
