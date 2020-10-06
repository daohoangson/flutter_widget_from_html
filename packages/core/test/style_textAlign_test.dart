import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  testWidgets('renders CENTER tag', (WidgetTester tester) async {
    final html = '<center>Foo</center>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[CssBlock:child=[_TextAlignCenter:child='
            '[RichText:align=center,(:Foo)]]]'));
  });

  group('attribute', () {
    testWidgets('renders center text', (WidgetTester tester) async {
      final html = '<div align="center">_X_</div>';
      final explained = await explain(tester, html);
      expect(explained,
          equals('[_TextAlignBlock:child=[RichText:align=center,(:_X_)]]'));
    });

    testWidgets('renders justify text', (WidgetTester tester) async {
      final html = '<p align="justify">X_X_X</p>';
      final explained = await explain(tester, html);
      expect(explained,
          equals('[_TextAlignBlock:child=[RichText:align=justify,(:X_X_X)]]'));
    });

    testWidgets('renders left text', (WidgetTester tester) async {
      final html = '<div align="left">X__</div>';
      final e = await explain(tester, html);
      expect(e, equals('[_TextAlignBlock:child=[RichText:align=left,(:X__)]]'));
    });

    testWidgets('renders right text', (WidgetTester tester) async {
      final html = '<div align="right">__X</div>';
      final explained = await explain(tester, html);
      expect(explained,
          equals('[_TextAlignBlock:child=[RichText:align=right,(:__X)]]'));
    });
  });

  group('contents: inline', () {
    testWidgets('renders center', (WidgetTester tester) async {
      final html = '<div style="text-align: center">_X_</div>';
      final explained = await explain(tester, html);
      expect(explained,
          equals('[_TextAlignBlock:child=[RichText:align=center,(:_X_)]]'));
    });

    testWidgets('renders end', (WidgetTester tester) async {
      final html = '<div style="text-align: end">__X</div>';
      final e = await explain(tester, html);
      expect(e, equals('[_TextAlignBlock:child=[RichText:align=end,(:__X)]]'));
    });

    testWidgets('renders justify', (WidgetTester tester) async {
      final html = '<div style="text-align: justify">X_X_X</div>';
      final explained = await explain(tester, html);
      expect(explained,
          equals('[_TextAlignBlock:child=[RichText:align=justify,(:X_X_X)]]'));
    });

    testWidgets('renders left', (WidgetTester tester) async {
      final html = '<div style="text-align: left">X__</div>';
      final e = await explain(tester, html);
      expect(e, equals('[_TextAlignBlock:child=[RichText:align=left,(:X__)]]'));
    });

    testWidgets('renders right', (WidgetTester tester) async {
      final html = '<div style="text-align: right">__X</div>';
      final explained = await explain(tester, html);
      expect(explained,
          equals('[_TextAlignBlock:child=[RichText:align=right,(:__X)]]'));
    });

    testWidgets('renders start', (WidgetTester tester) async {
      final html = '<div style="text-align: start">X__</div>';
      final e = await explain(tester, html);
      expect(e, equals('[CssBlock:child=[RichText:(:X__)]]'));
    });
  });

  group('contents: block', () {
    testWidgets('renders tag CENTER', (WidgetTester tester) async {
      final html = '<center><div>_X_</div></center>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child=[_TextAlignCenter:child='
              '[CssBlock:child=[RichText:align=center,(:_X_)]]]]'));
    });

    testWidgets('renders center', (WidgetTester tester) async {
      final html = '<div style="text-align: center"><div>_X_</div></div>';
      final e = await explain(tester, html);
      expect(e, equals('[CssBlock:child=[RichText:align=center,(:_X_)]]'));
    });

    testWidgets('renders end', (WidgetTester tester) async {
      final html = '<div style="text-align: end"><div>__X</div></div>';
      final e = await explain(tester, html);
      expect(e, equals('[CssBlock:child=[RichText:align=end,(:__X)]]'));
    });

    testWidgets('renders justify', (WidgetTester tester) async {
      final html = '<div style="text-align: justify"><div>X_X_X</div></div>';
      final e = await explain(tester, html);
      expect(e, equals('[CssBlock:child=[RichText:align=justify,(:X_X_X)]]'));
    });

    testWidgets('renders left', (WidgetTester tester) async {
      final html = '<div style="text-align: left"><div>X__</div></div>';
      final e = await explain(tester, html);
      expect(e, equals('[CssBlock:child=[RichText:align=left,(:X__)]]'));
    });

    testWidgets('renders right', (WidgetTester tester) async {
      final html = '<div style="text-align: right"><div>__X</div></div>';
      final e = await explain(tester, html);
      expect(e, equals('[CssBlock:child=[RichText:align=right,(:__X)]]'));
    });

    testWidgets('renders start', (WidgetTester tester) async {
      final html = '<div style="text-align: start"><div>X__</div></div>';
      final e = await explain(tester, html);
      expect(e, equals('[CssBlock:child=[RichText:(:X__)]]'));
    });
  });

  group('contents: blocks', () {
    testWidgets('renders tag CENTER', (WidgetTester tester) async {
      final html = '<center><div>Foo</div><div>_X_</div></center>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child=[Column:children='
              '[_TextAlignCenter:child=[CssBlock:child=[RichText:align=center,(:Foo)]]],'
              '[_TextAlignCenter:child=[CssBlock:child=[RichText:align=center,(:_X_)]]]'
              ']]'));
    });

    testWidgets('renders center', (WidgetTester tester) async {
      final html =
          '<div style="text-align: center"><div>Foo</div><div>_X_</div></div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child=[Column:children='
              '[CssBlock:child=[RichText:align=center,(:Foo)]],'
              '[CssBlock:child=[RichText:align=center,(:_X_)]]'
              ']]'));
    });

    testWidgets('renders end', (WidgetTester tester) async {
      final html =
          '<div style="text-align: end"><div>Foo</div><div>__X</div></div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child=[Column:children='
              '[CssBlock:child=[RichText:align=end,(:Foo)]],'
              '[CssBlock:child=[RichText:align=end,(:__X)]]'
              ']]'));
    });

    testWidgets('renders justify', (WidgetTester tester) async {
      final html =
          '<div style="text-align: justify"><div>Foo</div><div>X_X_X</div></div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child=[Column:children='
              '[CssBlock:child=[RichText:align=justify,(:Foo)]],'
              '[CssBlock:child=[RichText:align=justify,(:X_X_X)]]'
              ']]'));
    });

    testWidgets('renders left', (WidgetTester tester) async {
      final html =
          '<div style="text-align: left"><div>Foo</div><div>X__</div></div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child=[Column:children='
              '[CssBlock:child=[RichText:align=left,(:Foo)]],'
              '[CssBlock:child=[RichText:align=left,(:X__)]]'
              ']]'));
    });

    testWidgets('renders right', (WidgetTester tester) async {
      final html =
          '<div style="text-align: right"><div>Foo</div><div>__X</div></div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child=[Column:children='
              '[CssBlock:child=[RichText:align=right,(:Foo)]],'
              '[CssBlock:child=[RichText:align=right,(:__X)]]'
              ']]'));
    });

    testWidgets('renders start', (WidgetTester tester) async {
      final html =
          '<div style="text-align: start"><div>Foo</div><div>X__</div></div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child=[Column:children='
              '[CssBlock:child=[RichText:(:Foo)]],'
              '[CssBlock:child=[RichText:(:X__)]]'
              ']]'));
    });
  });

  testWidgets('renders styling from outside', (WidgetTester tester) async {
    // https://github.com/daohoangson/flutter_widget_from_html/issues/10
    final html = '<em><span style="color: red;">'
        '<div style="text-align: right;">right</div></span></em>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[_TextAlignBlock:child='
            '[RichText:align=right,(#FFFF0000+i:right)]]'));
  });

  testWidgets('renders margin inside', (WidgetTester tester) async {
    final html = '<div style="text-align: center">'
        '<div style="margin: 5px">Foo</div></div>';
    final explained = await explainMargin(tester, html);
    expect(
        explained,
        equals('[SizedBox:0.0x5.0],'
            '[CssBlock:child='
            '[_TextAlignBlock:child='
            '[Padding:(0,5,0,5),child='
            '[CssBlock:child=[RichText:align=center,(:Foo)]]'
            ']]],'
            '[SizedBox:0.0x5.0]'));
  });
}
