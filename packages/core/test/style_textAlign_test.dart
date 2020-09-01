import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '_.dart';

void main() {
  testWidgets('renders CENTER tag', (WidgetTester tester) async {
    final html = '<center>Foo</center>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[CssBlock:child='
            '[Center:child='
            '[RichText:align=center,(:Foo)]'
            ']]'));
  });

  group('attribute', () {
    testWidgets('renders center text', (WidgetTester tester) async {
      final html = '<div align="center">_X_</div>';
      final e = await explain(tester, html);
      expect(e, equals('[CssBlock:child=[RichText:align=center,(:_X_)]]'));
    });

    testWidgets('renders justify text', (WidgetTester tester) async {
      final html = '<p align="justify">X_X_X</p>';
      final e = await explain(tester, html);
      expect(e, equals('[CssBlock:child=[RichText:align=justify,(:X_X_X)]]'));
    });

    testWidgets('renders left text', (WidgetTester tester) async {
      final html = '<div align="left">X__</div>';
      final e = await explain(tester, html);
      expect(e, equals('[CssBlock:child=[RichText:align=left,(:X__)]]'));
    });

    testWidgets('renders right text', (WidgetTester tester) async {
      final html = '<div align="right">__X</div>';
      final e = await explain(tester, html);
      expect(e, equals('[CssBlock:child=[RichText:align=right,(:__X)]]'));
    });
  });

  group('inline style', () {
    testWidgets('renders center text', (WidgetTester tester) async {
      final html = '<div style="text-align: center">_X_</div>';
      final e = await explain(tester, html);
      expect(e, equals('[CssBlock:child=[RichText:align=center,(:_X_)]]'));
    });

    testWidgets('renders end text', (WidgetTester tester) async {
      final html = '<div style="text-align: end">__X</div>';
      final e = await explain(tester, html);
      expect(e, equals('[CssBlock:child=[RichText:align=end,(:__X)]]'));
    });

    testWidgets('renders justify text', (WidgetTester tester) async {
      final html = '<div style="text-align: justify">X_X_X</div>';
      final e = await explain(tester, html);
      expect(e, equals('[CssBlock:child=[RichText:align=justify,(:X_X_X)]]'));
    });

    testWidgets('renders left text', (WidgetTester tester) async {
      final html = '<div style="text-align: left">X__</div>';
      final e = await explain(tester, html);
      expect(e, equals('[CssBlock:child=[RichText:align=left,(:X__)]]'));
    });

    testWidgets('renders right text', (WidgetTester tester) async {
      final html = '<div style="text-align: right">__<b>X</b></div>';
      final e = await explain(tester, html);
      expect(e, equals('[CssBlock:child=[RichText:align=right,(:__(+b:X))]]'));
    });

    testWidgets('renders start text', (WidgetTester tester) async {
      final html = '<div style="text-align: start">X__</div>';
      final e = await explain(tester, html);
      expect(e, equals('[CssBlock:child=[RichText:(:X__)]]'));
    });
  });

  group('block', () {
    final kBlockHtml = '<div>Foo</div>';

    testWidgets('renders center block', (WidgetTester tester) async {
      final html = '<div style="text-align: center">$kBlockHtml</div>';
      final e = await explain(tester, html);
      expect(e, equals('[CssBlock:child=[RichText:align=center,(:Foo)]]'));
    });

    testWidgets('renders left block', (WidgetTester tester) async {
      final html = '<div style="text-align: left">$kBlockHtml</div>';
      final e = await explain(tester, html);
      expect(e, equals('[CssBlock:child=[RichText:align=left,(:Foo)]]'));
    });

    testWidgets('renders right block', (WidgetTester tester) async {
      final html = '<div style="text-align: right">$kBlockHtml</div>';
      final e = await explain(tester, html);
      expect(e, equals('[CssBlock:child=[RichText:align=right,(:Foo)]]'));
    });
  });

  group('image', () {
    final imgSrc = 'http://domain.com/image.png';
    final imgHtml = '<img src="$imgSrc" />';
    final img = '[Image:image=NetworkImage("$imgSrc", scale: 1.0)]';
    final imgExplain = (WidgetTester t, String html) =>
        mockNetworkImagesFor(() => explain(t, html));

    testWidgets('renders center image', (WidgetTester tester) async {
      final html = '<div style="text-align: center">$imgHtml</div>';
      final e = await imgExplain(tester, html);
      expect(e, equals('[CssBlock:child=[RichText:align=center,$img]]'));
    });

    testWidgets('renders left image', (WidgetTester tester) async {
      final html = '<div style="text-align: left">$imgHtml</div>';
      final e = await imgExplain(tester, html);
      expect(e, equals('[CssBlock:child=[RichText:align=left,$img]]'));
    });

    testWidgets('renders right image', (WidgetTester tester) async {
      final html = '<div style="text-align: right">$imgHtml</div>';
      final e = await imgExplain(tester, html);
      expect(e, equals('[CssBlock:child=[RichText:align=right,$img]]'));
    });
  });

  testWidgets('renders styling from outside', (WidgetTester tester) async {
    // https://github.com/daohoangson/flutter_widget_from_html/issues/10
    final html = '<em><span style="color: red;">'
        '<div style="text-align: right;">right</div></span></em>';
    final explained = await explain(tester, html);
    expect(explained,
        equals('[CssBlock:child=[RichText:align=right,(#FFFF0000+i:right)]]'));
  });

  testWidgets('renders margin inside', (WidgetTester tester) async {
    final html = '<div style="text-align: center">'
        '<div style="margin: 5px">Foo</div></div>';
    final explained = await explainMargin(tester, html);
    expect(
        explained,
        equals('[SizedBox:0.0x5.0],'
            '[CssBlock:child=[Padding:(0,5,0,5),child='
            '[CssBlock:child=[RichText:align=center,(:Foo)]]'
            ']],'
            '[SizedBox:0.0x5.0]'));
  });
}
