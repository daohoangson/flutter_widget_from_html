import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  testWidgets('renders CENTER tag', (WidgetTester tester) async {
    final html = '<center>Foo</center>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText,align=center:(:Foo)]'));
  });

  testWidgets('renders center text', (WidgetTester tester) async {
    final html = '<div style="text-align: center">_X_</div>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText,align=center:(:_X_)]'));
  });

  testWidgets('renders justify text', (WidgetTester tester) async {
    final html = '<div style="text-align: justify">X_X_X</div>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText,align=justify:(:X_X_X)]'));
  });

  testWidgets('renders left text', (WidgetTester tester) async {
    final html = '<div style="text-align: left">X__</div>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText,align=left:(:X__)]'));
  });

  testWidgets('renders right text', (WidgetTester tester) async {
    final html = '<div style="text-align: right">__<b>X</b></div>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText,align=right:(:__(+b:X))]'));
  });

  group('block', () {
    final kBlockHtml = '<div>Foo</div>';
    final kBlockRendered = '[RichText:(:Foo)]';

    testWidgets('renders center block', (WidgetTester t) async {
      final h = '<div style="text-align: center">$kBlockHtml</div>';
      final e = await explain(t, h, imageUrlToPrecache: 'image.png');
      expect(e, equals('[Align:alignment=center,child=$kBlockRendered]'));
    });

    testWidgets('renders left block', (WidgetTester tester) async {
      final html = '<div style="text-align: left">$kBlockHtml</div>';
      final e = await explain(tester, html);
      expect(e, equals('[Align:alignment=centerLeft,child=$kBlockRendered]'));
    });

    testWidgets('renders right block', (WidgetTester tester) async {
      final html = '<div style="text-align: right">$kBlockHtml</div>';
      final e = await explain(tester, html);
      expect(e, equals('[Align:alignment=centerRight,child=$kBlockRendered]'));
    });
  });

  group('image', () {
    final kImgHtml = '<img src="image.png" />';
    final kImgRendered = '[NetworkImage:url=image.png]';

    testWidgets('renders center image', (WidgetTester t) async {
      final h = '<div style="text-align: center">$kImgHtml</div>';
      final explained = await explain(t, h, imageUrlToPrecache: 'image.png');
      expect(explained, equals('[RichText,align=center:$kImgRendered]'));
    });

    testWidgets('renders left image', (WidgetTester tester) async {
      final html = '<div style="text-align: left">$kImgHtml</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText,align=left:$kImgRendered]'));
    });

    testWidgets('renders right image', (WidgetTester tester) async {
      final html = '<div style="text-align: right">$kImgHtml</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText,align=right:$kImgRendered]'));
    });
  });

  testWidgets('renders styling from outside', (WidgetTester tester) async {
    // https://github.com/daohoangson/flutter_widget_from_html/issues/10
    final html = '<em><span style="color: red;">' +
        '<div style="text-align: right;">right</div></span></em>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText,align=right:(+i:right)]'));
  });

  testWidgets('renders margin inside', (WidgetTester tester) async {
    final html = '<div style="text-align: center">'
        '<div style="margin: 5px">Foo</div></div>';
    final explained = await explainMargin(tester, html);
    expect(
        explained,
        equals('[Padding:(5,5,5,5),child='
            '[Align:alignment=center,child=[RichText:(:Foo)]]]'));
  });
}
