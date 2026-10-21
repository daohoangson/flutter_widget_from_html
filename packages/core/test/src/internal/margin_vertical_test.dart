import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:flutter_widget_from_html_core/src/internal/margin_vertical.dart';

import '../../_.dart' as helper;

void main() {
  group('HeightPlaceholder', () {
    final resolvers = InheritanceResolvers();

    Future<double> pumpHeight(WidgetTester tester, Widget child) async {
      await tester.pumpWidget(
        Directionality(textDirection: TextDirection.ltr, child: child),
      );
      return tester.widget<SizedBox>(find.byType(SizedBox)).height!;
    }

    testWidgets('mergedWith renders the largest height', (tester) async {
      final a = HeightPlaceholder(const CssLength(10), resolvers);
      final b = HeightPlaceholder(const CssLength(20), resolvers);
      expect(await pumpHeight(tester, a.mergedWith(b)), equals(20));
      expect(await pumpHeight(tester, b.mergedWith(a)), equals(20));
    });

    testWidgets('mergedWith keeps the originals intact', (tester) async {
      final a = HeightPlaceholder(const CssLength(10), resolvers);
      final b = HeightPlaceholder(const CssLength(20), resolvers);
      a.mergedWith(b);
      expect(await pumpHeight(tester, a), equals(10));
      expect(await pumpHeight(tester, b), equals(20));
    });

    testWidgets('mergedWith includes merged heights', (tester) async {
      final a = HeightPlaceholder(const CssLength(10), resolvers);
      final b = HeightPlaceholder(const CssLength(5), resolvers);
      final c = HeightPlaceholder(const CssLength(30), resolvers);
      expect(await pumpHeight(tester, a.mergedWith(b.mergedWith(c))), 30);
    });
  });

  group('ColumnPlaceholder', () {
    testWidgets('collapses nested margins', (tester) async {
      const html = '<div style="margin-bottom: 10px">a</div>'
          '<div style="margin-top: 5px">'
          '<div style="margin-top: 30px">b</div></div>';
      final explained = await helper.explainMargin(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[RichText:(:a)]],'
          '[SizedBox:0.0x30.0],'
          '[CssBlock:child=[RichText:(:b)]]',
        ),
      );
    });

    testWidgets('renders the same after rebuilds', (tester) async {
      const html = '<p>a</p><p>b</p><div style="margin: 5px"><p>c</p></div>';
      final expected = await helper.explain(tester, html);

      for (var i = 0; i < 10; i++) {
        await tester.pumpWidget(
          MediaQuery(
            data: MediaQueryData(
              textScaler: TextScaler.linear(i.isEven ? 1.5 : 1.0),
            ),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: HtmlWidget(html, key: helper.hwKey),
            ),
          ),
        );
      }

      expect(await helper.explain(tester, html), equals(expected));
    });
  });
}
