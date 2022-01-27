import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  testWidgets('renders CENTER tag', (WidgetTester tester) async {
    const html = '<center>Foo</center>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[CssBlock:child=[_TextAlignCenter:child='
        '[RichText:align=center,(:Foo)]]]',
      ),
    );
  });

  group('attribute', () {
    testWidgets('renders center text', (WidgetTester tester) async {
      const html = '<div align="center">_X_</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[RichText:align=center,(:_X_)]]',
        ),
      );
    });

    testWidgets('renders justify text', (WidgetTester tester) async {
      const html = '<p align="justify">X_X_X</p>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[RichText:align=justify,(:X_X_X)]]',
        ),
      );
    });

    testWidgets('renders left text', (WidgetTester tester) async {
      const html = '<div align="left">X__</div>';
      final e = await explain(tester, html);
      expect(e, equals('[CssBlock:child=[RichText:align=left,(:X__)]]'));
    });

    testWidgets('renders right text', (WidgetTester tester) async {
      const html = '<div align="right">__X</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[RichText:align=right,(:__X)]]',
        ),
      );
    });
  });

  group('contents: inline', () {
    testWidgets('renders center', (WidgetTester tester) async {
      const html = '<div style="text-align: center">_X_</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[RichText:align=center,(:_X_)]]',
        ),
      );
    });

    testWidgets('renders end', (WidgetTester tester) async {
      const html = '<div style="text-align: end">__X</div>';
      final e = await explain(tester, html);
      expect(e, equals('[CssBlock:child=[RichText:align=end,(:__X)]]'));
    });

    testWidgets('renders justify', (WidgetTester tester) async {
      const html = '<div style="text-align: justify">X_X_X</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[RichText:align=justify,(:X_X_X)]]',
        ),
      );
    });

    testWidgets('renders left', (WidgetTester tester) async {
      const html = '<div style="text-align: left">X__</div>';
      final e = await explain(tester, html);
      expect(e, equals('[CssBlock:child=[RichText:align=left,(:X__)]]'));
    });

    testWidgets('renders right', (WidgetTester tester) async {
      const html = '<div style="text-align: right">__X</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[RichText:align=right,(:__X)]]',
        ),
      );
    });

    testWidgets('renders start', (WidgetTester tester) async {
      const html = '<div style="text-align: start">X__</div>';
      final e = await explain(tester, html);
      expect(e, equals('[CssBlock:child=[RichText:(:X__)]]'));
    });
  });

  group('contents: block', () {
    testWidgets('renders tag CENTER', (WidgetTester tester) async {
      const html = '<center><div>_X_</div></center>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[_TextAlignCenter:child='
          '[CssBlock:child=[RichText:align=center,(:_X_)]]]]',
        ),
      );
    });

    testWidgets('renders center', (WidgetTester tester) async {
      const html = '<div style="text-align: center"><div>_X_</div></div>';
      final e = await explain(tester, html);
      expect(e, equals('[CssBlock:child=[RichText:align=center,(:_X_)]]'));
    });

    testWidgets('renders end', (WidgetTester tester) async {
      const html = '<div style="text-align: end"><div>__X</div></div>';
      final e = await explain(tester, html);
      expect(e, equals('[CssBlock:child=[RichText:align=end,(:__X)]]'));
    });

    testWidgets('renders justify', (WidgetTester tester) async {
      const html = '<div style="text-align: justify"><div>X_X_X</div></div>';
      final e = await explain(tester, html);
      expect(e, equals('[CssBlock:child=[RichText:align=justify,(:X_X_X)]]'));
    });

    testWidgets('renders left', (WidgetTester tester) async {
      const html = '<div style="text-align: left"><div>X__</div></div>';
      final e = await explain(tester, html);
      expect(e, equals('[CssBlock:child=[RichText:align=left,(:X__)]]'));
    });

    testWidgets('renders right', (WidgetTester tester) async {
      const html = '<div style="text-align: right"><div>__X</div></div>';
      final e = await explain(tester, html);
      expect(e, equals('[CssBlock:child=[RichText:align=right,(:__X)]]'));
    });

    testWidgets('renders start', (WidgetTester tester) async {
      const html = '<div style="text-align: start"><div>X__</div></div>';
      final e = await explain(tester, html);
      expect(e, equals('[CssBlock:child=[RichText:(:X__)]]'));
    });
  });

  group('contents: blocks', () {
    testWidgets('renders tag CENTER', (WidgetTester tester) async {
      const html = '<center><div>Foo</div><div>_X_</div></center>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[Column:children='
          '[_TextAlignCenter:child=[CssBlock:child='
          '[RichText:align=center,(:Foo)]]],'
          '[_TextAlignCenter:child=[CssBlock:child='
          '[RichText:align=center,(:_X_)]]]'
          ']]',
        ),
      );
    });

    testWidgets('renders center', (WidgetTester tester) async {
      const html =
          '<div style="text-align: center"><div>Foo</div><div>_X_</div></div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[Column:children='
          '[CssBlock:child=[RichText:align=center,(:Foo)]],'
          '[CssBlock:child=[RichText:align=center,(:_X_)]]'
          ']]',
        ),
      );
    });

    testWidgets('renders end', (WidgetTester tester) async {
      const html =
          '<div style="text-align: end"><div>Foo</div><div>__X</div></div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[Column:children='
          '[CssBlock:child=[RichText:align=end,(:Foo)]],'
          '[CssBlock:child=[RichText:align=end,(:__X)]]'
          ']]',
        ),
      );
    });

    testWidgets('renders justify', (WidgetTester tester) async {
      const html =
          '<div style="text-align: justify"><div>Foo</div><div>X_X_X</div></div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[Column:children='
          '[CssBlock:child=[RichText:align=justify,(:Foo)]],'
          '[CssBlock:child=[RichText:align=justify,(:X_X_X)]]'
          ']]',
        ),
      );
    });

    testWidgets('renders left', (WidgetTester tester) async {
      const html =
          '<div style="text-align: left"><div>Foo</div><div>X__</div></div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[Column:children='
          '[CssBlock:child=[RichText:align=left,(:Foo)]],'
          '[CssBlock:child=[RichText:align=left,(:X__)]]'
          ']]',
        ),
      );
    });

    testWidgets('renders right', (WidgetTester tester) async {
      const html =
          '<div style="text-align: right"><div>Foo</div><div>__X</div></div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[Column:children='
          '[CssBlock:child=[RichText:align=right,(:Foo)]],'
          '[CssBlock:child=[RichText:align=right,(:__X)]]'
          ']]',
        ),
      );
    });

    testWidgets('renders start', (WidgetTester tester) async {
      const html =
          '<div style="text-align: start"><div>Foo</div><div>X__</div></div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[Column:children='
          '[CssBlock:child=[RichText:(:Foo)]],'
          '[CssBlock:child=[RichText:(:X__)]]'
          ']]',
        ),
      );
    });
  });

  group('contents: mixed', () {
    testWidgets('renders tag CENTER', (WidgetTester tester) async {
      const html = '<center><div>Foo</div>_X_</center>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[Column:children='
          '[_TextAlignCenter:child=[CssBlock:child='
          '[RichText:align=center,(:Foo)]]],'
          '[_TextAlignCenter:child=[RichText:align=center,(:_X_)]]'
          ']]',
        ),
      );
    });

    testWidgets('renders center', (WidgetTester tester) async {
      const html = '<div style="text-align: center"><div>Foo</div>_X_</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[Column:children='
          '[CssBlock:child=[RichText:align=center,(:Foo)]],'
          '[CssBlock:child=[RichText:align=center,(:_X_)]]'
          ']]',
        ),
      );
    });

    testWidgets('renders end', (WidgetTester tester) async {
      const html = '<div style="text-align: end"><div>Foo</div>__X</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[Column:children='
          '[CssBlock:child=[RichText:align=end,(:Foo)]],'
          '[CssBlock:child=[RichText:align=end,(:__X)]]'
          ']]',
        ),
      );
    });

    testWidgets('renders justify', (WidgetTester tester) async {
      const html = '<div style="text-align: justify"><div>Foo</div>X_X_X</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[Column:children='
          '[CssBlock:child=[RichText:align=justify,(:Foo)]],'
          '[CssBlock:child=[RichText:align=justify,(:X_X_X)]]'
          ']]',
        ),
      );
    });

    testWidgets('renders left', (WidgetTester tester) async {
      const html = '<div style="text-align: left"><div>Foo</div>X__</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[Column:children='
          '[CssBlock:child=[RichText:align=left,(:Foo)]],'
          '[CssBlock:child=[RichText:align=left,(:X__)]]'
          ']]',
        ),
      );
    });

    testWidgets('renders right', (WidgetTester tester) async {
      const html = '<div style="text-align: right"><div>Foo</div>__X</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[Column:children='
          '[CssBlock:child=[RichText:align=right,(:Foo)]],'
          '[CssBlock:child=[RichText:align=right,(:__X)]]'
          ']]',
        ),
      );
    });

    testWidgets('renders start', (WidgetTester tester) async {
      const html = '<div style="text-align: start"><div>Foo</div>X__</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[Column:children='
          '[CssBlock:child=[RichText:(:Foo)]],'
          '[RichText:(:X__)]'
          ']]',
        ),
      );
    });
  });

  testWidgets('renders styling from outside', (WidgetTester tester) async {
    // https://github.com/daohoangson/flutter_widget_from_html/issues/10
    const html = '<em><span style="color: red;">'
        '<div style="text-align: right;">right</div></span></em>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[CssBlock:child='
        '[RichText:align=right,(#FFFF0000+i:right)]]',
      ),
    );
  });

  testWidgets('renders margin inside', (WidgetTester tester) async {
    const html = '<div style="text-align: center">'
        '<div style="margin: 5px">Foo</div></div>';
    final explained = await explainMargin(tester, html);
    expect(
      explained,
      equals(
        '[SizedBox:0.0x5.0],'
        '[CssBlock:child='
        '[Padding:(0,5,0,5),child='
        '[CssBlock:child=[RichText:align=center,(:Foo)]]'
        ']],'
        '[SizedBox:0.0x5.0]',
      ),
    );
  });

  testWidgets('renders padding with block & inline', (tester) async {
    const html = '<div style="text-align: right; padding: 5px">'
        '<div>Foo</div><span>Bar</span></div>';
    final explained = await explainMargin(tester, html);
    expect(
      explained,
      equals(
        '[CssBlock:child=[Padding:(5,5,5,5),child=[Column:children='
        '[CssBlock:child=[RichText:align=right,(:Foo)]],'
        '[CssBlock:child=[RichText:align=right,(:Bar)]]'
        ']]]',
      ),
    );
  });
}
