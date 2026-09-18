import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html/dom.dart' as dom;

import '_.dart' as helper;

Finder findRichText(String text) => find.byWidgetPredicate(
      (widget) => widget is RichText && widget.text.toPlainText() == text,
    );

void main() {
  group('BR geometry', () {
    testWidgets('uses stable line boxes after an inline widget', (
      tester,
    ) async {
      for (var count = 1; count <= 4; count++) {
        final inlineKey = GlobalKey();
        final htmlWidgetKey = GlobalKey<HtmlWidgetState>();

        Widget? customWidgetBuilder(dom.Element element) {
          if (element.localName != 'x-inline') {
            return null;
          }

          return InlineCustomWidget(
            child: SizedBox(key: inlineKey, width: 20, height: 20),
          );
        }

        final breaks = List.filled(count, '<br>').join();
        await helper.explain(
          tester,
          null,
          hw: HtmlWidget(
            '<x-inline></x-inline>$breaks<div>After</div>',
            customWidgetBuilder: customWidgetBuilder,
            key: htmlWidgetKey,
          ),
          key: htmlWidgetKey,
        );

        final rootTop = tester.getTopLeft(find.byKey(htmlWidgetKey)).dy;
        final afterTop = tester.getTopLeft(findRichText('After')).dy;
        expect(afterTop - rootTop, 20.0 + (count - 1) * 10.0);
      }
    });

    testWidgets('uses resolved line-height', (tester) async {
      const html = '<div style="line-height:3">'
          'Before<br><br><div>After</div>'
          '</div>';
      await helper.explain(tester, html);

      final rootTop = tester.getTopLeft(find.byKey(helper.hwKey)).dy;
      final afterTop = tester.getTopLeft(findRichText('After')).dy;
      expect(afterTop - rootTop, 60.0);
    });

    testWidgets('uses terminal break metrics before a block', (tester) async {
      const html = 'Foo<br style="font-size:30px;line-height:1">'
          '<div>After</div>';
      await helper.explain(tester, html);

      final rootTop = tester.getTopLeft(find.byKey(helper.hwKey)).dy;
      final afterTop = tester.getTopLeft(findRichText('After')).dy;
      expect(afterTop - rootTop, 30.0);
    });

    testWidgets('limits trailing breaks with max-lines', (tester) async {
      const html = '<div style="max-lines:1">'
          'Foo<br><br><div>After</div>'
          '</div>';
      await helper.explain(tester, html);

      final rootTop = tester.getTopLeft(find.byKey(helper.hwKey)).dy;
      final afterTop = tester.getTopLeft(findRichText('After')).dy;
      expect(afterTop - rootTop, 10.0);
    });

    testWidgets('preserves a leading break with max-lines', (tester) async {
      const html = '<div style="max-lines:1"><br><div>After</div></div>';
      await helper.explain(tester, html);

      final rootTop = tester.getTopLeft(find.byKey(helper.hwKey)).dy;
      final afterTop = tester.getTopLeft(findRichText('After')).dy;
      expect(afterTop - rootTop, 10.0);
    });

    testWidgets('uses terminal break metrics with max-lines', (tester) async {
      const html = '<div style="max-lines:1">'
          'Foo<br style="font-size:30px;line-height:1"><div>After</div>'
          '</div>';
      await helper.explain(tester, html);

      final rootTop = tester.getTopLeft(find.byKey(helper.hwKey)).dy;
      final afterTop = tester.getTopLeft(findRichText('After')).dy;
      expect(afterTop - rootTop, 30.0);
    });

    testWidgets('counts inline breaks toward max-lines', (tester) async {
      const html = '<div style="max-lines:2">'
          'Foo<br>Bar<br><br><div>After</div>'
          '</div>';
      await helper.explain(tester, html);

      final rootTop = tester.getTopLeft(find.byKey(helper.hwKey)).dy;
      final afterTop = tester.getTopLeft(findRichText('After')).dy;
      expect(afterTop - rootTop, 20.0);
    });

    testWidgets('uses scaled text metrics', (tester) async {
      tester.setTextScaleFactor(2);
      const html = 'Before<br><br><div>After</div>';
      await helper.explain(tester, html);

      final rootTop = tester.getTopLeft(find.byKey(helper.hwKey)).dy;
      final afterTop = tester.getTopLeft(findRichText('After')).dy;
      expect(afterTop - rootTop, 40.0);
    });

    testWidgets('adds to adjacent margins', (tester) async {
      const html = '<div>Before</div><br><br>'
          '<div style="margin-top:30px">After</div>';
      await helper.explain(tester, html);

      final beforeBottom = tester.getBottomLeft(findRichText('Before')).dy;
      final afterTop = tester.getTopLeft(findRichText('After')).dy;
      expect(afterTop - beforeBottom, 50.0);
    });

    testWidgets('preserves leading breaks', (tester) async {
      const html = '<br><br>\n<div>After</div>';
      await helper.explain(tester, html);

      final rootTop = tester.getTopLeft(find.byKey(helper.hwKey)).dy;
      final afterTop = tester.getTopLeft(findRichText('After')).dy;
      expect(afterTop - rootTop, 20.0);
    });

    testWidgets('preserves a break-only block', (tester) async {
      const html = '<p style="margin:0"><br></p><div>After</div>';
      await helper.explain(tester, html);

      final rootTop = tester.getTopLeft(find.byKey(helper.hwKey)).dy;
      final afterTop = tester.getTopLeft(findRichText('After')).dy;
      expect(afterTop - rootTop, 10.0);
    });

    testWidgets('preserves the terminal break with white-space pre', (
      tester,
    ) async {
      const html = '<div style="white-space:pre">'
          'Before<br><div>After</div>'
          '</div>';
      await helper.explain(tester, html);

      final rootTop = tester.getTopLeft(find.byKey(helper.hwKey)).dy;
      final afterTop = tester.getTopLeft(findRichText('After')).dy;
      expect(afterTop - rootTop, 20.0);
    });

    testWidgets('preserves whitespace after a preformatted break', (
      tester,
    ) async {
      const html = '<div style="white-space:pre">'
          'Before<br>\n<div>After</div>'
          '</div>';
      await helper.explain(tester, html);

      final rootTop = tester.getTopLeft(find.byKey(helper.hwKey)).dy;
      final afterTop = tester.getTopLeft(findRichText('After')).dy;
      expect(afterTop - rootTop, 30.0);
    });

    testWidgets('handles trailing breaks inside image paragraphs', (
      tester,
    ) async {
      const image = '<img src="${helper.kDataUri}" '
          'width="20" height="20"><br><br>';
      const html = '<p>$image</p><p>$image</p>';
      await helper.explain(tester, html);

      final rect = tester.getRect(find.byKey(helper.hwKey));
      expect(rect.height, 70.0);
    });
  });
}
