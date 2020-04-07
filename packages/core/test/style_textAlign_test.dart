import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  testWidgets('renders CENTER tag', (WidgetTester tester) async {
    final html = '<center>Foo</center>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText,align=center:(:Foo)]'));
  });

  group('attribute', () {
    testWidgets('renders center text', (WidgetTester tester) async {
      final html = '<div align="center">_X_</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText,align=center:(:_X_)]'));
    });

    testWidgets('renders justify text', (WidgetTester tester) async {
      final html = '<p align="justify">X_X_X</p>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText,align=justify:(:X_X_X)]'));
    });

    testWidgets('renders left text', (WidgetTester tester) async {
      final html = '<span align="left">X__</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText,align=left:(:X__)]'));
    });

    testWidgets('renders right text', (WidgetTester tester) async {
      final html = '<span align="right">__<b>X</b></span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText,align=right:(:__(+b:X))]'));
    });
  });

  group('inline style', () {
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
  });

  group('block', () {
    final kBlockHtml = '<div>Foo</div>';

    testWidgets('renders center block', (WidgetTester tester) async {
      final html = '<div style="text-align: center">$kBlockHtml</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText,align=center:(:Foo)]'));
    });

    testWidgets('renders left block', (WidgetTester tester) async {
      final html = '<div style="text-align: left">$kBlockHtml</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText,align=left:(:Foo)]'));
    });

    testWidgets('renders right block', (WidgetTester tester) async {
      final html = '<div style="text-align: right">$kBlockHtml</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText,align=right:(:Foo)]'));
    });
  });

  group('image', () {
    final imgSrc = 'http://domain.com/image.png';
    final imgHtml = '<img src="$imgSrc" />';
    final imgRendered = "[NetworkImage:url=$imgSrc]";
    final imgExplain = (WidgetTester t, String html) => explain(t, html);

    testWidgets('renders center image', (WidgetTester tester) async {
      final html = '<div style="text-align: center">$imgHtml</div>';
      final explained = await imgExplain(tester, html);
      expect(explained, equals('[RichText,align=center:$imgRendered]'));
    });

    testWidgets('renders left image', (WidgetTester tester) async {
      final html = '<div style="text-align: left">$imgHtml</div>';
      final explained = await imgExplain(tester, html);
      expect(explained, equals('[RichText,align=left:$imgRendered]'));
    });

    testWidgets('renders right image', (WidgetTester tester) async {
      final html = '<div style="text-align: right">$imgHtml</div>';
      final explained = await imgExplain(tester, html);
      expect(explained, equals('[RichText,align=right:$imgRendered]'));
    });

    testWidgets('renders after image', (WidgetTester tester) async {
      final html = '$imgHtml <center>Foo</center>';
      final explained = await imgExplain(tester, html);
      expect(
          explained,
          equals('[Column:children='
              '$imgRendered,'
              '[RichText,align=center:(:Foo)]'
              ']'));
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
        equals('[SizedBox:0.0x5.0],'
            '[Padding:(0,5,0,5),'
            'child=[RichText,align=center:(:Foo)]],'
            '[SizedBox:0.0x5.0]'));
  });
}
