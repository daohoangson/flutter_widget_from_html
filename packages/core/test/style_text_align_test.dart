import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '_.dart';

Future<void> main() async {
  await loadAppFonts();

  GoldenToolkit.runWithConfiguration(
    tests,
    config: GoldenToolkitConfiguration(
      fileNameFactory: (name) =>
          '$kGoldenFilePrefix/style_text_align/$name.png',
    ),
  );
}

void tests() {
  testGoldens('renders CENTER tag', (WidgetTester tester) async {
    const html = '<center>Foo</center>';
    await explainScreenMatchesGolden(
      tester,
      html,
      equals(
        '[CssBlock:child=[Center:child='
        '[RichText:align=center,(:Foo)]]]',
      ),
    );
  });

  group('attribute', () {
    testGoldens('renders center text', (WidgetTester tester) async {
      const html = '<div align="center">_X_</div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child=[RichText:align=center,(:_X_)]]',
        ),
      );
    });

    testGoldens('renders justify text', (WidgetTester tester) async {
      const html = '<p align="justify">X_X_X</p>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child=[RichText:align=justify,(:X_X_X)]]',
        ),
      );
    });

    testGoldens('renders left text', (WidgetTester tester) async {
      const html = '<div align="left">X__</div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals('[CssBlock:child=[RichText:align=left,(:X__)]]'),
      );
    });

    testGoldens('renders right text', (WidgetTester tester) async {
      const html = '<div align="right">__X</div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child=[RichText:align=right,(:__X)]]',
        ),
      );
    });
  });

  group('contents: inline', () {
    testGoldens('renders center', (WidgetTester tester) async {
      const html = '<div style="text-align: center">_X_</div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child=[RichText:align=center,(:_X_)]]',
        ),
      );
    });

    testGoldens('renders -moz-center', (WidgetTester tester) async {
      const html = '<div style="text-align: -moz-center">_X_</div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child=[RichText:align=center,(:_X_)]]',
        ),
      );
    });

    testGoldens('renders -webkit-center', (WidgetTester tester) async {
      const html = '<div style="text-align: -webkit-center">_X_</div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child=[Center:child=[RichText:align=center,(:_X_)]]]',
        ),
      );
    });

    testGoldens('renders end', (WidgetTester tester) async {
      const html = '<div style="text-align: end">__X</div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals('[CssBlock:child=[RichText:align=end,(:__X)]]'),
      );
    });

    testGoldens('renders end (rtl)', (WidgetTester tester) async {
      const html =
          '<div dir="rtl"><div style="text-align: end">__X</div></div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals('[CssBlock:child=[RichText:align=end,dir=rtl,(:__X)]]'),
      );
    });

    testGoldens('renders justify', (WidgetTester tester) async {
      const html = '<div style="text-align: justify">X_X_X</div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child=[RichText:align=justify,(:X_X_X)]]',
        ),
      );
    });

    testGoldens('renders left', (WidgetTester tester) async {
      const html = '<div style="text-align: left">X__</div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals('[CssBlock:child=[RichText:align=left,(:X__)]]'),
      );
    });

    testGoldens('renders left (rtl)', (WidgetTester tester) async {
      const html =
          '<div dir="rtl"><div style="text-align: left">X__</div></div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals('[CssBlock:child=[RichText:align=left,dir=rtl,(:X__)]]'),
      );
    });

    testGoldens('renders right', (WidgetTester tester) async {
      const html = '<div style="text-align: right">__X</div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child=[RichText:align=right,(:__X)]]',
        ),
      );
    });

    testGoldens('renders right (rtl)', (WidgetTester tester) async {
      const html =
          '<div dir="rtl"><div style="text-align: right">__X</div></div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child=[RichText:align=right,dir=rtl,(:__X)]]',
        ),
      );
    });

    testGoldens('renders start', (WidgetTester tester) async {
      const html = '<div style="text-align: start">X__</div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals('[CssBlock:child=[RichText:(:X__)]]'),
      );
    });

    testGoldens('renders start (rtl)', (WidgetTester tester) async {
      const html =
          '<div dir="rtl"><div style="text-align: start">X__</div></div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals('[CssBlock:child=[RichText:dir=rtl,(:X__)]]'),
      );
    });
  });

  group('contents: block', () {
    testGoldens('renders tag CENTER', (WidgetTester tester) async {
      const html = '<center><div>_X_</div></center>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child=[Center:child='
          '[CssBlock:child=[RichText:align=center,(:_X_)]]]]',
        ),
      );
    });

    testGoldens('renders center', (WidgetTester tester) async {
      const html = '<div style="text-align: center"><div>_X_</div></div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals('[CssBlock:child=[RichText:align=center,(:_X_)]]'),
      );
    });

    testGoldens('renders -moz-center', (WidgetTester tester) async {
      const html = '<div style="text-align: -moz-center"><div>_X_</div></div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals('[CssBlock:child=[RichText:align=center,(:_X_)]]'),
      );
    });

    testGoldens('renders -webkit-center', (WidgetTester tester) async {
      const html =
          '<div style="text-align: -webkit-center"><div>_X_</div></div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child=[Center:child='
          '[CssBlock:child=[RichText:align=center,(:_X_)]]]]',
        ),
      );
    });

    testGoldens('renders end', (WidgetTester tester) async {
      const html = '<div style="text-align: end"><div>__X</div></div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals('[CssBlock:child=[RichText:align=end,(:__X)]]'),
      );
    });

    testGoldens('renders end (rtl)', (WidgetTester tester) async {
      const html = '<div dir="rtl"><div style="text-align: end">'
          '<div>__X</div></div></div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals('[CssBlock:child=[RichText:align=end,dir=rtl,(:__X)]]'),
      );
    });

    testGoldens('renders justify', (WidgetTester tester) async {
      const html = '<div style="text-align: justify"><div>X_X_X</div></div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals('[CssBlock:child=[RichText:align=justify,(:X_X_X)]]'),
      );
    });

    testGoldens('renders left', (WidgetTester tester) async {
      const html = '<div style="text-align: left"><div>X__</div></div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals('[CssBlock:child=[RichText:align=left,(:X__)]]'),
      );
    });

    testGoldens('renders left (rtl)', (WidgetTester tester) async {
      const html = '<div dir="rtl"><div style="text-align: left">'
          '<div>X__</div></div></div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals('[CssBlock:child=[RichText:align=left,dir=rtl,(:X__)]]'),
      );
    });

    testGoldens('renders right', (WidgetTester tester) async {
      const html = '<div style="text-align: right"><div>__X</div></div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals('[CssBlock:child=[RichText:align=right,(:__X)]]'),
      );
    });

    testGoldens('renders right (rtl)', (WidgetTester tester) async {
      const html = '<div dir="rtl"><div style="text-align: right">'
          '<div>__X</div></div></div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals('[CssBlock:child=[RichText:align=right,dir=rtl,(:__X)]]'),
      );
    });

    testGoldens('renders start', (WidgetTester tester) async {
      const html = '<div style="text-align: start"><div>X__</div></div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals('[CssBlock:child=[RichText:(:X__)]]'),
      );
    });

    testGoldens('renders start (rtl)', (WidgetTester tester) async {
      const html = '<div dir="rtl"><div style="text-align: start">'
          '<div>X__</div></div></div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals('[CssBlock:child=[RichText:dir=rtl,(:X__)]]'),
      );
    });
  });

  group('contents: blocks', () {
    testGoldens('renders tag CENTER', (WidgetTester tester) async {
      const html = '<center><div>Foo</div><div>_X_</div></center>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child=[Center:child='
          '[Column:crossAxisAlignment=center,children='
          '[CssBlock:child=[RichText:align=center,(:Foo)]],'
          '[CssBlock:child=[RichText:align=center,(:_X_)]]'
          ']]]',
        ),
      );
    });

    testGoldens('renders center', (WidgetTester tester) async {
      const html = '<div style="text-align: center">'
          '<div>Foo</div><div>_X_</div></div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child='
          '[Column:crossAxisAlignment=center,children='
          '[CssBlock:child=[RichText:align=center,(:Foo)]],'
          '[CssBlock:child=[RichText:align=center,(:_X_)]]'
          ']]',
        ),
      );
    });

    testGoldens('renders -moz-center', (WidgetTester tester) async {
      const html = '<div style="text-align: -moz-center">'
          '<div>Foo</div><div>_X_</div></div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child='
          '[Column:crossAxisAlignment=center,children='
          '[CssBlock:child=[RichText:align=center,(:Foo)]],'
          '[CssBlock:child=[RichText:align=center,(:_X_)]]'
          ']]',
        ),
      );
    });

    testGoldens('renders -webkit-center', (WidgetTester tester) async {
      const html = '<div style="text-align: -webkit-center">'
          '<div>Foo</div><div>_X_</div></div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child=[Center:child='
          '[Column:crossAxisAlignment=center,children='
          '[CssBlock:child=[RichText:align=center,(:Foo)]],'
          '[CssBlock:child=[RichText:align=center,(:_X_)]]'
          ']]]',
        ),
      );
    });

    testGoldens('renders end', (WidgetTester tester) async {
      const html =
          '<div style="text-align: end"><div>Foo</div><div>__X</div></div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child='
          '[Column:crossAxisAlignment=end,children='
          '[CssBlock:child=[RichText:align=end,(:Foo)]],'
          '[CssBlock:child=[RichText:align=end,(:__X)]]'
          ']]',
        ),
      );
    });

    testGoldens('renders end (rtl)', (WidgetTester tester) async {
      const html = '<div dir="rtl"><div style="text-align: end">'
          '<div>Foo</div><div>__X</div></div></div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child='
          '[Column:dir=rtl,crossAxisAlignment=end,children='
          '[CssBlock:child=[RichText:align=end,dir=rtl,(:Foo)]],'
          '[CssBlock:child=[RichText:align=end,dir=rtl,(:__X)]]'
          ']]',
        ),
      );
    });

    testGoldens('renders justify', (WidgetTester tester) async {
      const html = '<div style="text-align: justify">'
          '<div>Foo</div><div>X_X_X</div></div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child='
          '[Column:crossAxisAlignment=stretch,children='
          '[CssBlock:child=[RichText:align=justify,(:Foo)]],'
          '[CssBlock:child=[RichText:align=justify,(:X_X_X)]]'
          ']]',
        ),
      );
    });

    testGoldens('renders left', (WidgetTester tester) async {
      const html =
          '<div style="text-align: left"><div>Foo</div><div>X__</div></div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child=[Column:children='
          '[CssBlock:child=[RichText:align=left,(:Foo)]],'
          '[CssBlock:child=[RichText:align=left,(:X__)]]'
          ']]',
        ),
      );
    });

    testGoldens('renders left (rtl)', (WidgetTester tester) async {
      const html = '<div dir="rtl"><div style="text-align: left">'
          '<div>Foo</div><div>X__</div></div></div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child='
          '[Column:dir=rtl,crossAxisAlignment=end,children='
          '[CssBlock:child=[RichText:align=left,dir=rtl,(:Foo)]],'
          '[CssBlock:child=[RichText:align=left,dir=rtl,(:X__)]]'
          ']]',
        ),
      );
    });

    testGoldens('renders right', (WidgetTester tester) async {
      const html = '<div style="text-align: right">'
          '<div>Foo</div><div>__X</div></div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child='
          '[Column:crossAxisAlignment=end,children='
          '[CssBlock:child=[RichText:align=right,(:Foo)]],'
          '[CssBlock:child=[RichText:align=right,(:__X)]]'
          ']]',
        ),
      );
    });

    testGoldens('renders right (rtl)', (WidgetTester tester) async {
      const html = '<div dir="rtl"><div style="text-align: right">'
          '<div>Foo</div><div>__X</div></div></div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child=[Column:dir=rtl,children='
          '[CssBlock:child=[RichText:align=right,dir=rtl,(:Foo)]],'
          '[CssBlock:child=[RichText:align=right,dir=rtl,(:__X)]]'
          ']]',
        ),
      );
    });

    testGoldens('renders start', (WidgetTester tester) async {
      const html = '<div style="text-align: start">'
          '<div>Foo</div><div>X__</div></div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child=[Column:children='
          '[CssBlock:child=[RichText:(:Foo)]],'
          '[CssBlock:child=[RichText:(:X__)]]'
          ']]',
        ),
      );
    });

    testGoldens('renders start (rtl)', (WidgetTester tester) async {
      const html = '<div dir="rtl"><div style="text-align: start">'
          '<div>Foo</div><div>X__</div></div></div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child=[Column:dir=rtl,children='
          '[CssBlock:child=[RichText:dir=rtl,(:Foo)]],'
          '[CssBlock:child=[RichText:dir=rtl,(:X__)]]'
          ']]',
        ),
      );
    });
  });

  group('contents: mixed', () {
    testGoldens('renders tag CENTER', (WidgetTester tester) async {
      const html = '<center><div>Foo</div>_X_</center>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child=[Center:child='
          '[Column:crossAxisAlignment=center,children='
          '[CssBlock:child=[RichText:align=center,(:Foo)]],'
          '[RichText:align=center,(:_X_)]'
          ']]]',
        ),
      );
    });

    testGoldens('renders center', (WidgetTester tester) async {
      const html = '<div style="text-align: center"><div>Foo</div>_X_</div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child=[Column:crossAxisAlignment=center,children='
          '[CssBlock:child=[RichText:align=center,(:Foo)]],'
          '[RichText:align=center,(:_X_)]'
          ']]',
        ),
      );
    });

    testGoldens('renders -moz-center', (WidgetTester tester) async {
      const html =
          '<div style="text-align: -moz-center"><div>Foo</div>_X_</div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child=[Column:crossAxisAlignment=center,children='
          '[CssBlock:child=[RichText:align=center,(:Foo)]],'
          '[RichText:align=center,(:_X_)]'
          ']]',
        ),
      );
    });

    testGoldens('renders -webkit-center', (WidgetTester tester) async {
      const html =
          '<div style="text-align: -webkit-center"><div>Foo</div>_X_</div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child=[Center:child='
          '[Column:crossAxisAlignment=center,children='
          '[CssBlock:child=[RichText:align=center,(:Foo)]],'
          '[RichText:align=center,(:_X_)]'
          ']]]',
        ),
      );
    });

    testGoldens('renders end', (WidgetTester tester) async {
      const html = '<div style="text-align: end"><div>Foo</div>__X</div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child=[Column:crossAxisAlignment=end,children='
          '[CssBlock:child=[RichText:align=end,(:Foo)]],'
          '[RichText:align=end,(:__X)]'
          ']]',
        ),
      );
    });

    testGoldens('renders end (rtl)', (WidgetTester tester) async {
      const html = '<div dir="rtl"><div style="text-align: end">'
          '<div>Foo</div>__X</div></div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child=[Column:dir=rtl,crossAxisAlignment=end,children='
          '[CssBlock:child=[RichText:align=end,dir=rtl,(:Foo)]],'
          '[RichText:align=end,dir=rtl,(:__X)]'
          ']]',
        ),
      );
    });

    testGoldens('renders justify', (WidgetTester tester) async {
      const html = '<div style="text-align: justify"><div>Foo</div>X_X_X</div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child=[Column:crossAxisAlignment=stretch,children='
          '[CssBlock:child=[RichText:align=justify,(:Foo)]],'
          '[RichText:align=justify,(:X_X_X)]'
          ']]',
        ),
      );
    });

    testGoldens('renders left', (WidgetTester tester) async {
      const html = '<div style="text-align: left"><div>Foo</div>X__</div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child=[Column:children='
          '[CssBlock:child=[RichText:align=left,(:Foo)]],'
          '[RichText:align=left,(:X__)]'
          ']]',
        ),
      );
    });

    testGoldens('renders left (rtl)', (WidgetTester tester) async {
      const html = '<div dir="rtl"><div style="text-align: left">'
          '<div>Foo</div>X__</div></div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child='
          '[Column:dir=rtl,crossAxisAlignment=end,children='
          '[CssBlock:child=[RichText:align=left,dir=rtl,(:Foo)]],'
          '[RichText:align=left,dir=rtl,(:X__)]'
          ']]',
        ),
      );
    });

    testGoldens('renders right', (WidgetTester tester) async {
      const html = '<div style="text-align: right"><div>Foo</div>__X</div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child=[Column:crossAxisAlignment=end,children='
          '[CssBlock:child=[RichText:align=right,(:Foo)]],'
          '[RichText:align=right,(:__X)]'
          ']]',
        ),
      );
    });

    testGoldens('renders right (rtl)', (WidgetTester tester) async {
      const html = '<div dir="rtl"><div style="text-align: right">'
          '<div>Foo</div>__X</div></div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child=[Column:dir=rtl,children='
          '[CssBlock:child=[RichText:align=right,dir=rtl,(:Foo)]],'
          '[RichText:align=right,dir=rtl,(:__X)]'
          ']]',
        ),
      );
    });

    testGoldens('renders start', (WidgetTester tester) async {
      const html = '<div style="text-align: start"><div>Foo</div>X__</div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child=[Column:children='
          '[CssBlock:child=[RichText:(:Foo)]],'
          '[RichText:(:X__)]'
          ']]',
        ),
      );
    });

    testGoldens('renders start (rtl)', (WidgetTester tester) async {
      const html = '<div dir="rtl"><div style="text-align: start">'
          '<div>Foo</div>X__</div></div>';
      await explainScreenMatchesGolden(
        tester,
        html,
        equals(
          '[CssBlock:child=[Column:dir=rtl,children='
          '[CssBlock:child=[RichText:dir=rtl,(:Foo)]],'
          '[RichText:dir=rtl,(:X__)]'
          ']]',
        ),
      );
    });
  });

  testGoldens('renders styling from outside', (WidgetTester tester) async {
    // https://github.com/daohoangson/flutter_widget_from_html/issues/10
    const html = '<em><span style="color: red;">'
        '<div style="text-align: right;">right</div></span></em>';
    await explainScreenMatchesGolden(
      tester,
      html,
      equals(
        '[CssBlock:child='
        '[RichText:align=right,(#FFFF0000+i:right)]]',
      ),
    );
  });

  testGoldens('renders margin inside', (WidgetTester tester) async {
    const html = '<div style="text-align: center">'
        '<div style="margin: 5px">Foo</div></div>';
    await explainScreenMatchesGolden(
      tester,
      html,
      equals(
        '[SizedBox:0.0x5.0],'
        '[CssBlock:child='
        '[Padding:(0,5,0,5),child='
        '[CssBlock:child=[RichText:align=center,(:Foo)]]'
        ']],'
        '[SizedBox:0.0x5.0]',
      ),
      explained: await explainMargin(tester, html),
    );
  });

  testGoldens('renders padding with block & inline', (tester) async {
    const html = '<div style="text-align: right; padding: 5px">'
        '<div>Foo</div><span>Bar</span></div>';
    await explainScreenMatchesGolden(
      tester,
      html,
      equals(
        '[CssBlock:child=[Padding:(5,5,5,5),child='
        '[CssBlock:child=[Column:crossAxisAlignment=end,children='
        '[CssBlock:child=[RichText:align=right,(:Foo)]],'
        '[RichText:align=right,(:Bar)]'
        ']]]]',
      ),
      explained: await explainMargin(tester, html),
    );
  });
}
