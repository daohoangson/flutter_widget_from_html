import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '_.dart' as helper;

Future<String> explain(WidgetTester t, HtmlWidget hw) =>
    helper.explain(t, null, hw: hw);

void main() {
  group('enableCaching', () {
    final explain = (WidgetTester tester, String html, bool enableCaching) =>
        helper.explain(tester, null,
            hw: HtmlWidget(
              html,
              bodyPadding: const EdgeInsets.all(0),
              enableCaching: enableCaching,
              key: helper.hwKey,
            ));

    testWidgets('caches built widget tree', (WidgetTester tester) async {
      final html = 'Foo';
      final explained = await explain(tester, html, true);
      expect(explained, equals('[RichText:(:Foo)]'));

      final hws = helper.hwKey.currentState;
      final built1 = hws.build(hws.context);
      final built2 = hws.build(hws.context);
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

      final hws = helper.hwKey.currentState;
      final built1 = hws.build(hws.context);
      final built2 = hws.build(hws.context);
      expect(built1 == built2, isFalse);
    });
  });

  group('baseUrl', () {
    final baseUrl = Uri.parse('http://base.com/path/');
    final html = '<img src="image.png" alt="image dot png" />';

    testWidgets('renders without value', (WidgetTester tester) async {
      final explained =
          await explain(tester, HtmlWidget(html, key: helper.hwKey));
      expect(
          explained,
          equals('[Padding:(10,10,10,10),child='
              '[RichText:(:image dot png)]]'));
    });

    testWidgets('renders with value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        HtmlWidget(html, baseUrl: baseUrl, key: helper.hwKey),
      );
      expect(
          explained,
          equals('[Padding:(10,10,10,10),child=[ImageLayout:'
              'child=[NetworkImage:url=http://base.com/path/image.png],'
              'text=image dot png'
              ']]'));
    });
  });

  group('bodyPadding', () {
    final bodyPadding = EdgeInsets.all(5);
    final html = 'Foo';

    testWidgets('renders default value', (WidgetTester tester) async {
      final explained =
          await explain(tester, HtmlWidget(html, key: helper.hwKey));
      expect(
        explained,
        equals('[Padding:(10,10,10,10),child=[RichText:(:Foo)]]'),
      );
    });

    testWidgets('renders custom value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        HtmlWidget(html, bodyPadding: bodyPadding, key: helper.hwKey),
      );
      expect(explained, equals('[Padding:(5,5,5,5),child=[RichText:(:Foo)]]'));
    });

    testWidgets('renders null value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        HtmlWidget(html, bodyPadding: null, key: helper.hwKey),
      );
      expect(explained, equals('[RichText:(:Foo)]'));
    });
  });

  group('builderCallback', () {
    final NodeMetadataCollector builderCallback =
        (m, e) => lazySet(null, fontStyleItalic: true);
    final html = '<span>Foo</span>';

    testWidgets('renders without value', (WidgetTester tester) async {
      final explained =
          await explain(tester, HtmlWidget(html, key: helper.hwKey));
      expect(
        explained,
        equals('[Padding:(10,10,10,10),child=[RichText:(:Foo)]]'),
      );
    });

    testWidgets('renders with value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        HtmlWidget(html, builderCallback: builderCallback, key: helper.hwKey),
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
      final explained =
          await explain(tester, HtmlWidget(html, key: helper.hwKey));
      expect(
          explained,
          equals('[Padding:(10,10,10,10),child='
              '[RichText:(#FF0000FF+u:Foo)]]'));
    });

    testWidgets('renders custom value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        HtmlWidget(html, hyperlinkColor: hyperlinkColor, key: helper.hwKey),
      );
      expect(
          explained,
          equals('[Padding:(10,10,10,10),child='
              '[RichText:(#FFFF0000+u:Foo)]]'));
    });

    testWidgets('renders null value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        HtmlWidget(html, hyperlinkColor: null, key: helper.hwKey),
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
      final explained =
          await explain(tester, HtmlWidget(html, key: helper.hwKey));
      expect(
          explained,
          equals('[Padding:(10,10,10,10),child=[Table:\n'
              '[Padding:(5,5,5,5),child=[RichText:(:Foo)]]\n]]'));
    });

    testWidgets('renders custom value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        HtmlWidget(html, key: helper.hwKey, tableCellPadding: tableCellPadding),
      );
      expect(
          explained,
          equals('[Padding:(10,10,10,10),child=[Table:\n'
              '[Padding:(10,10,10,10),child=[RichText:(:Foo)]]\n]]'));
    });

    testWidgets('renders null value', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        HtmlWidget(html, key: helper.hwKey, tableCellPadding: null),
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
      final explained =
          await explain(tester, HtmlWidget(html, key: helper.hwKey));
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
          key: helper.hwKey,
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
