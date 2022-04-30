import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '_.dart';

Future<void> main() async {
  const imgSizingConstraints = 'height≥0.0,height=auto,width≥0.0,width=auto';

  testWidgets('renders empty string', (WidgetTester tester) async {
    const html = '';
    final explained = await explain(tester, html);
    expect(explained, equals('[widget0]'));
  });

  testWidgets('renders bare string', (WidgetTester tester) async {
    const html = 'Hello world';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:(:Hello world)]'));
  });

  testWidgets('renders textStyle', (WidgetTester tester) async {
    const html = 'Hello world';
    final explained = await explain(
      tester,
      html,
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
    expect(explained, equals('[RichText:(@20.0+b:Hello world)]'));
  });

  testWidgets('renders without erroneous white spaces', (tester) async {
    const html = '''
<div>
  <span style="text-decoration: line-through">
    <span style="text-decoration: overline">
      <span style="text-decoration: underline">
        All   decorations...
        <span style="text-decoration: none">and none</span>
      </span>
    </span>
  </span>
</div>
<!-- https://github.com/daohoangson/flutter_widget_from_html/issues/119 -->
<div>I​Like​Playing​football​​game</div>
<!-- https://github.com/daohoangson/flutter_widget_from_html/issues/185 -->
<div> &nbsp; </div>
''';
    final str = await explain(tester, html);
    expect(
      str,
      equals(
        '[Column:children='
        '[CssBlock:child=[RichText:(:(+l+o+u:All decorations... )'
        '(:and none))]],'
        '[CssBlock:child=[RichText:(:I​Like​Playing​football​​game)]],'
        '[CssBlock:child=[RichText:(:\u00A0)]]'
        ']',
      ),
    );
  });

  testWidgets('renders white spaces with parent style', (tester) async {
    const html = ' <b>One<em> <u>two </u></em> three</b> ';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:(:(+b:One )(+u+i+b:two)(+b: three))]'));
  });

  testWidgets('renders ADDRESS tag', (WidgetTester tester) async {
    const html = 'This is an <address>ADDRESS</address>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[Column:children='
        '[RichText:(:This is an)],'
        '[CssBlock:child=[RichText:(+i:ADDRESS)]]'
        ']',
      ),
    );
  });

  group('BR', () {
    testWidgets('renders new line', (WidgetTester tester) async {
      const html = '1<br />2';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:1\n2)]'));
    });

    testWidgets('renders without whitespace on new line', (tester) async {
      const html = '1<br />\n2';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:1\n2)]'));
    });

    testWidgets('renders without whitespace on next SPAN', (tester) async {
      const html = '1<br />\n<span>\n2</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:1\n2)]'));
    });

    testWidgets('renders multiple new lines, 1 of 2', (tester) async {
      const html = '1<br /><br />2';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:1\n\n2)]'));
    });

    testWidgets('renders multiple new lines, 2 of 2', (tester) async {
      const html = '1<br /><br /><br />2';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:1\n\n\n2)]'));
    });

    testWidgets('renders new line before styled text', (tester) async {
      const html = '1<br /><strong>2</strong>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:1\n(+b:2))]'));
    });

    testWidgets('renders new line before IMG', (tester) async {
      const src = 'http://domain.com/image.png';
      const html = '1<br /><img src="$src" />';
      final explained = await mockNetworkImages(() => explain(tester, html));
      expect(
        explained,
        equals(
          '[RichText:(:'
          '1\n'
          '[CssSizing:$imgSizingConstraints,child='
          '[Image:image=NetworkImage("$src", scale: 1.0)]'
          '])]',
        ),
      );
    });

    testWidgets('renders new line between SPANs, 1 of 2', (tester) async {
      const html = '<span>1<br /></span><span>2</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:1\n2)]'));
    });

    testWidgets('renders new line between SPANs, 2 of 2', (tester) async {
      const html = '<span>1</span><br /><span>2</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:1\n2)]'));
    });

    testWidgets('skips new line between SPAN and DIV, 1 of 2', (tester) async {
      const html = '<span>1<br /></span><div>2</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Column:children='
          '[RichText:(:1)],'
          '[CssBlock:child=[RichText:(:2)]]'
          ']',
        ),
      );
    });

    testWidgets('skips new line between SPAN and DIV, 2 of 2', (tester) async {
      const html = '<span>1</span><br /><div>2</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Column:children='
          '[RichText:(:1)],'
          '[CssBlock:child=[RichText:(:2)]]'
          ']',
        ),
      );
    });

    testWidgets('renders new line between DIVs, 1 of 3', (tester) async {
      const html = '<div>1<br /></div><div>2</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Column:children='
          '[CssBlock:child=[RichText:(:1)]],'
          '[CssBlock:child=[RichText:(:2)]]'
          ']',
        ),
      );
    });

    testWidgets('renders new line between DIVs, 2 of 3', (tester) async {
      const html = '<div>1</div><br /><div>2</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Column:children='
          '[CssBlock:child=[RichText:(:1)]],'
          '[SizedBox:0.0x10.0],'
          '[CssBlock:child=[RichText:(:2)]]'
          ']',
        ),
      );
    });

    testWidgets('renders new line between DIVs, 3 of 3', (tester) async {
      const html = '<div>1</div><br /><div>2</div>';
      final explained = await explain(tester, html, useExplainer: false);
      expect(
        explained,
        equals(
          'TshWidget\n'
          '└ColumnPlaceholder(BuildMetadata(<root></root>))\n'
          ' └Column()\n'
          '  ├CssBlock()\n'
          '  │└RichText(text: "1")\n'
          '  ├HeightPlaceholder(1.0em)\n'
          '  │└SizedBox(height: 10.0)\n'
          '  └CssBlock()\n'
          '   └RichText(text: "2")\n\n',
        ),
      );
    });

    testWidgets('renders without new line at bottom, 1 of 3', (tester) async {
      const html = 'Foo<br />';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('renders without new line at bottom, 2 of 3', (tester) async {
      const html = '<span>Foo</span><br />';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('renders without new line at bottom, 3 of 3', (tester) async {
      const html = '<div>Foo</div><br />';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });
  });

  testWidgets('renders DD/DL/DT tags', (WidgetTester tester) async {
    const html = '<dl><dt>Foo</dt><dd>Bar</dd></dl>';
    final explained = await explainMargin(tester, html);
    expect(
      explained,
      equals(
        '[CssBlock:child=[Column:children='
        '[CssBlock:child=[RichText:(+b:Foo)]],'
        '[Padding:(0,0,0,40),child=[CssBlock:child=[RichText:(:Bar)]]]'
        ']],'
        '[SizedBox:0.0x10.0]',
      ),
    );
  });

  testWidgets('renders HR tag', (WidgetTester tester) async {
    const html = '<hr/>';
    final explained = await explainMargin(tester, html);
    expect(
      explained,
      equals(
        '[CssBlock:child=[DecoratedBox:bg=#FF000000,child=[SizedBox:0.0x1.0]]],'
        '[SizedBox:0.0x10.0]',
      ),
    );
  });

  group('block elements', () {
    const blockOutput = '[Column:children='
        '[CssBlock:child=[RichText:(:First.)]],'
        '[CssBlock:child=[RichText:(:Second one.)]]'
        ']';

    testWidgets('renders ARTICLE tag', (WidgetTester tester) async {
      const html = '<article>First.</article><article>Second one.</article>';
      final explained = await explain(tester, html);
      expect(explained, equals(blockOutput));
    });

    testWidgets('renders ASIDE tag', (WidgetTester tester) async {
      const html = '<aside>First.</aside><aside>Second one.</aside>';
      final explained = await explain(tester, html);
      expect(explained, equals(blockOutput));
    });

    testWidgets('renders BLOCKQUOTE tag', (WidgetTester tester) async {
      const html = '<blockquote>Foo</blockquote>';
      final explained = await explainMargin(tester, html);
      expect(
        explained,
        equals(
          '[SizedBox:0.0x10.0],'
          '[Padding:(0,40,0,40),child=[CssBlock:child=[RichText:(:Foo)]]],'
          '[SizedBox:0.0x10.0]',
        ),
      );
    });

    testWidgets('renders DIV tag', (WidgetTester tester) async {
      const html = '<div>First.</div><div>Second one.</div>';
      final explained = await explain(tester, html);
      expect(explained, equals(blockOutput));
    });

    testWidgets(
      'renders FIGURE/FIGCAPTION tags',
      (tester) => mockNetworkImages(() async {
        const src = 'http://domain.com/image.png';
        const html = '''
<figure>
  <img src="$src" />
  <figcaption><i>fig. 1</i> Foo</figcaption>
</figure>
''';
        final explained = await explainMargin(tester, html);
        expect(
          explained,
          equals(
            '[SizedBox:0.0x10.0],'
            '[Padding:(0,40,0,40),child=[CssBlock:child=[Column:children='
            '[CssSizing:$imgSizingConstraints,child=[Image:image=NetworkImage("http://domain.com/image.png", scale: 1.0)]],'
            '[CssBlock:child=[RichText:(:(+i:fig. 1)(: Foo))]]'
            ']]],'
            '[SizedBox:0.0x10.0]',
          ),
        );
      }),
    );

    testWidgets('renders HEADER/FOOTER tag', (WidgetTester tester) async {
      const html = '<header>First.</header><footer>Second one.</footer>';
      final explained = await explain(tester, html);
      expect(explained, equals(blockOutput));
    });

    testWidgets('renders MAIN/NAV tag', (WidgetTester tester) async {
      const html = '<main>First.</main><nav>Second one.</nav>';
      final explained = await explain(tester, html);
      expect(explained, equals(blockOutput));
    });

    testWidgets('renders P tag', (WidgetTester tester) async {
      const html = '<p>First.</p><p>Second one.</p>';
      final explained = await explainMargin(tester, html);
      expect(
        explained,
        equals(
          '[SizedBox:0.0x10.0],'
          '[CssBlock:child=[RichText:(:First.)]],'
          '[SizedBox:0.0x10.0],'
          '[CssBlock:child=[RichText:(:Second one.)]],'
          '[SizedBox:0.0x10.0]',
        ),
      );
    });

    testWidgets('renders SECTION tag', (WidgetTester tester) async {
      const html = '<section>First.</section><section>Second one.</section>';
      final explained = await explain(tester, html);
      expect(explained, equals(blockOutput));
    });
  });

  group('non renderable elements', () {
    testWidgets('skips IFRAME tag', (WidgetTester tester) async {
      const html = '''
<iframe src="https://www.youtube.com/embed/jNQXAC9IVRw" width="320" height="180">
  IFRAME support is not enabled.
</iframe>''';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:IFRAME support is not enabled.)]'));
    });

    testWidgets('skips SCRIPT tag', (WidgetTester tester) async {
      const html = '<script>document.write("SCRIPT is working");</script>'
          '<noscript>SCRIPT is not working</noscript>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:SCRIPT is not working)]'));
    });

    testWidgets('skips STYLE tag', (WidgetTester tester) async {
      const html = '<style>.xxx { color: red; }</style>'
          '<span class="xxx">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('skips SVG tag', (WidgetTester tester) async {
      const html = '''
<svg height="100" width="100">
  <circle cx="50" cy="50" r="40" stroke="black" stroke-width="3" fill="red" />
  SVG support is not enabled.
</svg>''';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:SVG support is not enabled.)]'));
    });

    testWidgets('skips VIDEO tag', (WidgetTester tester) async {
      const html = '''
<video>
  <source src="http://domain.com/video.mp4" type="video/mp4">
  <code>VIDEO</code> support is not enabled.
</video>''';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[RichText:(:(+font=Courier+fonts=monospace:VIDEO)'
          '(: support is not enabled.))]',
        ),
      );
    });
  });

  group('code', () {
    const php = '<span style="color: #000000">'
        '<span style="color: #0000BB">&lt;?php\n'
        'phpinfo</span>'
        '<span style="color: #007700">();\n'
        '</span>'
        '<span style="color: #0000BB">?&gt;</span>'
        '</span>';

    testWidgets('renders CODE tag', (WidgetTester tester) async {
      const html = '<code>$php</code>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[RichText:(:'
          '(#FF0000BB+font=Courier+fonts=monospace:<?php phpinfo)'
          '(#FF007700+font=Courier+fonts=monospace:(); )'
          '(#FF0000BB+font=Courier+fonts=monospace:?>)'
          ')]',
        ),
      );
    });

    testWidgets('renders empty CODE tag', (WidgetTester tester) async {
      const html = '<code></code>';
      final explained = await explain(tester, html);
      expect(explained, equals('[widget0]'));
    });

    testWidgets('renders KBD tag', (WidgetTester tester) async {
      const html = '<kbd>ESC</kbd>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(+font=Courier+fonts=monospace:ESC)]'));
    });

    testWidgets('renders PRE tag', (WidgetTester tester) async {
      const html = '<pre>$php</pre>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[SingleChildScrollView:child=[RichText:'
          '(+font=Courier+fonts=monospace:'
          '(#FF0000BB:<?php\nphpinfo)'
          '(#FF007700:();\n)'
          '(#FF0000BB:?>)'
          ')'
          ']]]',
        ),
      );
    });

    testWidgets('renders SAMP tag', (WidgetTester tester) async {
      const html = '<samp>Error</samp>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(+font=Courier+fonts=monospace:Error)]'));
    });

    testWidgets('renders TT tag', (WidgetTester tester) async {
      const html = '<tt>Teletype</tt>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[RichText:(+font=Courier+fonts=monospace:Teletype)]',
        ),
      );
    });
  });

  group('headings', () {
    testWidgets('render H1 tag', (WidgetTester tester) async {
      const html = '<h1>X</h1>';
      final explained = await explainMargin(tester, html);
      expect(
        explained,
        equals(
          '[SizedBox:0.0x13.4],'
          '[CssBlock:child=[RichText:(@20.0+b:X)]],'
          '[SizedBox:0.0x13.4]',
        ),
      );
    });

    testWidgets('render H2 tag', (WidgetTester tester) async {
      const html = '<h2>X</h2>';
      final explained = await explainMargin(tester, html);
      expect(
        explained,
        equals(
          '[SizedBox:0.0x12.4],'
          '[CssBlock:child=[RichText:(@15.0+b:X)]],'
          '[SizedBox:0.0x12.4]',
        ),
      );
    });

    testWidgets('render H3 tag', (WidgetTester tester) async {
      const html = '<h3>X</h3>';
      final explained = await explainMargin(tester, html);
      expect(
        explained,
        equals(
          '[SizedBox:0.0x11.7],'
          '[CssBlock:child=[RichText:(@11.7+b:X)]],'
          '[SizedBox:0.0x11.7]',
        ),
      );
    });

    testWidgets('render H4 tag', (WidgetTester tester) async {
      const html = '<h4>X</h4>';
      final explained = await explainMargin(tester, html);
      expect(
        explained,
        equals(
          '[SizedBox:0.0x13.3],'
          '[CssBlock:child=[RichText:(+b:X)]],'
          '[SizedBox:0.0x13.3]',
        ),
      );
    });

    testWidgets('render H5 tag', (WidgetTester tester) async {
      const html = '<h5>X</h5>';
      final explained = await explainMargin(tester, html);
      expect(
        explained,
        equals(
          '[SizedBox:0.0x13.9],'
          '[CssBlock:child=[RichText:(@8.3+b:X)]],'
          '[SizedBox:0.0x13.9]',
        ),
      );
    });

    testWidgets('render H6 tag', (WidgetTester tester) async {
      const html = '<h6>X</h6>';
      final explained = await explainMargin(tester, html);
      expect(
        explained,
        equals(
          '[SizedBox:0.0x15.6],'
          '[CssBlock:child=[RichText:(@6.7+b:X)]],'
          '[SizedBox:0.0x15.6]',
        ),
      );
    });
  });

  group('background-color', () {
    testWidgets('renders MARK tag', (WidgetTester tester) async {
      const html = '<mark>Foo</mark>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(bg=#FFFFFF00#FF000000:Foo)]'));
    });

    testWidgets('renders block', (WidgetTester tester) async {
      const html = '<div style="background-color: #f00">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child='
          '[DecoratedBox:bg=#FFFF0000,child='
          '[RichText:(:Foo)]]]',
        ),
      );
    });

    testWidgets('renders with margins and paddings', (tester) async {
      const html = '<div style="background-color: #f00; '
          'margin: 1px; padding: 2px">Foo</div>';
      final explained = await explainMargin(tester, html);
      expect(
        explained,
        equals(
          '[SizedBox:0.0x1.0],'
          '[Padding:(0,1,0,1),child='
          '[CssBlock:child=[DecoratedBox:bg=#FFFF0000,child='
          '[Padding:(2,2,2,2),child=[RichText:(:Foo)]]]'
          ']],[SizedBox:0.0x1.0]',
        ),
      );
    });

    testWidgets('renders blocks', (WidgetTester tester) async {
      const h = '<div style="background-color: #f00"><p>A</p><p>B</p></div>';
      final explained = await explain(tester, h);
      expect(
        explained,
        equals(
          '[CssBlock:child=[DecoratedBox:bg=#FFFF0000,child=[Column:children='
          '[CssBlock:child=[RichText:(:A)]],'
          '[SizedBox:0.0x10.0],'
          '[CssBlock:child=[RichText:(:B)]]'
          ']]]',
        ),
      );
    });

    testWidgets('renders inline', (WidgetTester tester) async {
      const html = 'Foo <span style="background-color: #f00">bar</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo (bg=#FFFF0000:bar))]'));
    });

    testWidgets('renders background', (WidgetTester tester) async {
      const html = 'Foo <span style="background: #f00">bar</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo (bg=#FFFF0000:bar))]'));
    });

    group('renders without erroneous white spaces', () {
      testWidgets('before', (WidgetTester tester) async {
        const html = 'Foo<span style="background-color: #f00"> bar</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(:Foo (bg=#FFFF0000:bar))]'));
      });

      testWidgets('after', (WidgetTester tester) async {
        const html = 'Foo <span style="background-color: #f00">bar </span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(:Foo (bg=#FFFF0000:bar))]'));
      });
    });

    testWidgets('resets in continuous SPANs (#155)', (tester) async {
      const html =
          '<span style="color: #ff0; background-color:#00f;">Foo</span>'
          '<span style="color: #f00;">bar</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[RichText:(:(bg=#FF0000FF#FFFFFF00:Foo)(#FFFF0000:bar))]',
        ),
      );
    });
  });

  group('color (inline style)', () {
    testWidgets('renders hex values', (WidgetTester tester) async {
      const html = '<span style="color: #F00">red</span>'
          '<span style="color: #F008">red 53%</span>'
          '<span style="color: #00FF00">green</span>'
          '<span style="color: #00FF0080">green 50%</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[RichText:(:(#FFFF0000:red)(#88FF0000:red 53%)'
          '(#FF00FF00:green)(#8000FF00:green 50%))]',
        ),
      );
    });

    testWidgets('renders overlaps', (WidgetTester tester) async {
      const html = '<span style="color: #FF0000">red '
          '<span style="color: #00FF00">green</span> red again</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[RichText:(:(#FFFF0000:red )'
          '(#FF00FF00:green)(#FFFF0000: red again))]',
        ),
      );
    });

    group('hsl/a', () {
      testWidgets('renders hsl red', (WidgetTester tester) async {
        const html = '<span style="color: hsl(0, 100%, 50%)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FFFF0000:Foo)]'));
      });

      testWidgets('renders hsl green', (WidgetTester tester) async {
        const html = '<span style="color: hsl(120, 100%, 50%)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FF00FF00:Foo)]'));
      });

      testWidgets('renders hsl blue', (WidgetTester tester) async {
        const html = '<span style="color: hsl(240, 100%, 50%)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FF0000FF:Foo)]'));
      });

      testWidgets('renders hsla alpha', (WidgetTester tester) async {
        const html = '<span style="color: hsla(0, 0%, 0%, 0.5)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#80000000:Foo)]'));
      });

      testWidgets('renders hsl red in negative', (WidgetTester tester) async {
        const html = '<span style="color: hsl(-360, 100%, 50%)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FFFF0000:Foo)]'));
      });

      testWidgets('renders hsl red in multiple of 360', (tester) async {
        const html = '<span style="color: hsl(720, 100%, 50%)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FFFF0000:Foo)]'));
      });

      testWidgets('renders hsl green in deg', (WidgetTester tester) async {
        const html = '<span style="color: hsl(120deg, 100%, 50%)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FF00FF00:Foo)]'));
      });

      testWidgets('renders hsl green in rad', (WidgetTester tester) async {
        const html = '<span style="color: hsl(2.0944rad,100%,50%)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FF00FF00:Foo)]'));
      });

      testWidgets('renders hsl green in grad', (WidgetTester tester) async {
        const html = '<span style="color:hsl(133.333grad,100%,50%)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FF00FF00:Foo)]'));
      });

      testWidgets('renders hsl green in turn', (WidgetTester tester) async {
        const html = '<span style="color: hsl(0.3333turn,100%,50%)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FF00FF00:Foo)]'));
      });

      testWidgets('renders hsla alpha in percentage', (tester) async {
        const html = '<span style="color: hsla(0, 0%, 0%, 50%)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#80000000:Foo)]'));
      });

      testWidgets('renders without comma', (tester) async {
        const html = '<span style="color: hsla(0 0% 0% / 50%)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#80000000:Foo)]'));
      });

      testWidgets('renders invalids', (WidgetTester tester) async {
        final htmls = [
          '<span style="color: hsl(xxx, 0%, 0%)">Foo</span>',
          '<span style="color: hsl(0, xxx, 0%)">Foo</span>',
          '<span style="color: hsl(0, 0%, xxx)">Foo</span>',
          '<span style="color: hsla(0, 0%, 0%, x)">Foo</span>',
        ];
        for (final html in htmls) {
          final explained = await explain(tester, html);
          expect(explained, equals('[RichText:(:Foo)]'), reason: html);
        }
      });
    });

    group('named color', () {
      testWidgets('renders red', (WidgetTester tester) async {
        const html = '<span style="color: red">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FFFF0000:Foo)]'));
      });

      testWidgets('renders green', (WidgetTester tester) async {
        const html = '<span style="color: green">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FF008000:Foo)]'));
      });

      testWidgets('renders blue', (WidgetTester tester) async {
        const html = '<span style="color: blue">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FF0000FF:Foo)]'));
      });
    });

    group('rgb/a', () {
      testWidgets('renders rgb red', (WidgetTester tester) async {
        const html = '<span style="color: rgb(255, 0, 0)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FFFF0000:Foo)]'));
      });

      testWidgets('renders rgb red overflow', (WidgetTester tester) async {
        const html = '<span style="color: rgb(1000, 0, 0)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FFFF0000:Foo)]'));
      });

      testWidgets('renders rgb green', (WidgetTester tester) async {
        const html = '<span style="color: rgb(0, 255, 0)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FF00FF00:Foo)]'));
      });

      testWidgets('renders rgb green overflow', (WidgetTester tester) async {
        const html = '<span style="color: rgb(0, 1000, 0)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FF00FF00:Foo)]'));
      });

      testWidgets('renders rgb blue', (WidgetTester tester) async {
        const html = '<span style="color: rgb(0, 0, 255)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FF0000FF:Foo)]'));
      });

      testWidgets('renders rgb blue overflow', (WidgetTester tester) async {
        const html = '<span style="color: rgb(0, 0, 255)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FF0000FF:Foo)]'));
      });

      testWidgets('renders rgba alpha', (WidgetTester tester) async {
        const html = '<span style="color: rgba(0, 0, 0, 0.5)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#80000000:Foo)]'));
      });

      testWidgets('renders rgba alpha negative', (WidgetTester tester) async {
        const html = '<span style="color: rgba(0, 0, 0, -1)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#00000000:Foo)]'));
      });

      testWidgets('renders rgb red in percentage', (tester) async {
        const html = '<span style="color: rgb(100.0%, 0, 0)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FFFF0000:Foo)]'));
      });

      testWidgets('renders rgb green in percentage', (tester) async {
        const html = '<span style="color: rgb(0, 100.0%, 0)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FF00FF00:Foo)]'));
      });

      testWidgets('renders rgb blue in percentage', (tester) async {
        const html = '<span style="color: rgb(0, 0, 100.0%)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FF0000FF:Foo)]'));
      });

      testWidgets('renders rgba alpha in percentage', (tester) async {
        const html = '<span style="color: rgba(0, 0, 0, 50%)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#80000000:Foo)]'));
      });

      testWidgets('renders without comma', (WidgetTester tester) async {
        const html = '<span style="color: rgba(0 0 0 / 0.5)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#80000000:Foo)]'));
      });

      testWidgets('renders invalids', (WidgetTester tester) async {
        final htmls = [
          '<span style="color: rgb(255)">Foo</span>',
          '<span style="color: rgb(255, 255)">Foo</span>',
          '<span style="color: rgb(xxx, 0, 0)">Foo</span>',
          '<span style="color: rgb(0, xxx, 0)">Foo</span>',
          '<span style="color: rgb(0, 0, xxx)">Foo</span>',
          '<span style="color: rgba(0, 0, 0, x)">Foo</span>',
        ];
        for (final html in htmls) {
          final explained = await explain(tester, html);
          expect(explained, equals('[RichText:(:Foo)]'), reason: html);
        }
      });
    });

    testWidgets('renders transparent', (WidgetTester tester) async {
      const html = '<span style="color: transparent">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(#00000000:Foo)]'));
    });
  });

  group('display', () {
    testWidgets('renders SPAN inline by default', (WidgetTester tester) async {
      const html = '<div>1 <span>2</span></div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:1 2)]]'));
    });

    testWidgets('renders display: block', (WidgetTester tester) async {
      const html = '<div>1 <span style="display: block">2</span></div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child='
          '[Column:children='
          '[RichText:(:1)],'
          '[CssBlock:child=[RichText:(:2)]]'
          ']]',
        ),
      );
    });

    testWidgets('renders DIV block by default', (WidgetTester tester) async {
      const html = '<div>1 <div>2</div></div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child='
          '[Column:children='
          '[RichText:(:1)],'
          '[CssBlock:child=[RichText:(:2)]]'
          ']]',
        ),
      );
    });

    testWidgets('renders display: inline', (WidgetTester tester) async {
      const html = '<div>1 <div style="display: inline">2</div></div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:1 2)]]'));
    });

    testWidgets('renders display: inline-block', (WidgetTester tester) async {
      const html = '<div>1 <div style="display: inline-block">2</div></div>';
      final e = await explain(tester, html);
      expect(e, equals('[CssBlock:child=[RichText:(:1 [RichText:(:2)])]]'));
    });

    testWidgets('#646: renders onWidgets inline', (WidgetTester tester) async {
      const html = '<span style="display:inline-block;">Foo</span>';
      final explained = await explain(
        tester,
        null,
        hw: HtmlWidget(
          html,
          factoryBuilder: () => _InlineBlockOnWidgetsFactory(),
          key: hwKey,
        ),
      );

      expect(explained, equals('[Text:Bar]'));
    });

    testWidgets('renders display: none', (WidgetTester tester) async {
      const html = '<div>1 <div style="display: none">2</div></div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:1)]]'));
    });

    group('IMG', () {
      const src = 'http://domain.com/image.png';

      testWidgets(
        'renders IMG inline by default',
        (tester) => mockNetworkImages(() async {
          const html = 'Foo <img src="$src" />';
          final explained = await explain(tester, html);
          expect(
            explained,
            equals(
              '[RichText:(:Foo '
              '[CssSizing:$imgSizingConstraints,child='
              '[Image:image=NetworkImage("$src", scale: 1.0)]'
              '])]',
            ),
          );
        }),
      );

      testWidgets(
        'renders IMG as block',
        (tester) => mockNetworkImages(() async {
          const html = 'Foo <img src="$src" style="display: block" />';
          final explained = await explain(tester, html);
          expect(
            explained,
            equals(
              '[Column:children='
              '[RichText:(:Foo)],'
              '[CssSizing:$imgSizingConstraints,child='
              '[Image:image=NetworkImage("$src", scale: 1.0)]'
              ']]',
            ),
          );
        }),
      );

      testWidgets(
        'renders IMG with dimensions inline',
        (tester) => mockNetworkImages(() async {
          const html = '<img src="$src" width="1" height="1" />';
          final explained = await explain(tester, html);
          expect(
            explained,
            equals(
              '[CssSizing:height≥0.0,height=1.0,width≥0.0,width=1.0,child='
              '[AspectRatio:aspectRatio=1.0,child='
              '[Image:image=NetworkImage("$src", scale: 1.0)]'
              ']]',
            ),
          );
        }),
      );

      testWidgets(
        'renders IMG with dimensions as block',
        (tester) => mockNetworkImages(() async {
          const html = '<img src="$src" width="1" '
              'height="1" style="display: block" />';
          final explained = await explain(tester, html);
          expect(
            explained,
            equals(
              '[CssSizing:height≥0.0,height=1.0,width≥0.0,width=1.0,child='
              '[AspectRatio:aspectRatio=1.0,child='
              '[Image:image=NetworkImage("$src", scale: 1.0)]'
              ']]',
            ),
          );
        }),
      );
    });
  });

  group('FONT', () {
    testWidgets('renders color attribute', (WidgetTester tester) async {
      const html = '<font color="#F00">Foo</font>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(#FFFF0000:Foo)]'));
    });

    testWidgets('renders face attribute', (WidgetTester tester) async {
      const html = '<font face="Monospace">Foo</font>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+font=Monospace:Foo)]'));
    });

    group('size attribute', () {
      testWidgets('renders 7', (WidgetTester tester) async {
        const html = '<font size="7">Foo</font>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(@20.0:Foo)]'));
      });

      testWidgets('renders 6', (WidgetTester tester) async {
        const html = '<font size="6">Foo</font>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(@15.0:Foo)]'));
      });

      testWidgets('renders 5', (WidgetTester tester) async {
        const html = '<font size="5">Foo</font>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(@11.3:Foo)]'));
      });

      testWidgets('renders 4', (WidgetTester tester) async {
        const html = '<font size="4">Foo</font>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(:Foo)]'));
      });

      testWidgets('renders 3', (WidgetTester tester) async {
        const html = '<font size="3">Foo</font>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(@8.1:Foo)]'));
      });

      testWidgets('renders 2', (WidgetTester tester) async {
        const html = '<font size="2">Foo</font>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(@6.3:Foo)]'));
      });

      testWidgets('renders 1', (WidgetTester tester) async {
        const html = '<font size="1">Foo</font>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(@5.6:Foo)]'));
      });
    });

    testWidgets('renders all attributes', (WidgetTester tester) async {
      const html = '<font color="#00F" face="Monospace" size="7">Foo</font>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(#FF0000FF+font=Monospace@20.0:Foo)]'));
    });
  });

  group('direction', () {
    group('attribute', () {
      testWidgets('renders auto', (WidgetTester tester) async {
        const html = '<div dir="auto">Foo</div>';
        final e = await explain(tester, html);
        expect(e, equals('[CssBlock:child=[RichText:(:Foo)]]'));
      });

      testWidgets('renders ltr', (WidgetTester tester) async {
        const html = '<div dir="ltr">Foo</div>';
        final explained = await explain(tester, html);
        expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
      });

      testWidgets('renders rtl', (WidgetTester tester) async {
        const html = '<div dir="rtl">Foo</div>';
        final explained = await explain(tester, html);
        expect(explained, equals('[CssBlock:child=[RichText:dir=rtl,(:Foo)]]'));
      });
    });

    group('inline style', () {
      testWidgets('renders ltr', (WidgetTester tester) async {
        const html = '<div style="direction: ltr">Foo</div>';
        final explained = await explain(tester, html);
        expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
      });

      testWidgets('renders rtl', (WidgetTester tester) async {
        const html = '<div style="direction: rtl">Foo</div>';
        final explained = await explain(tester, html);
        expect(explained, equals('[CssBlock:child=[RichText:dir=rtl,(:Foo)]]'));
      });
    });
  });

  group('font-family', () {
    testWidgets('renders one font', (WidgetTester tester) async {
      const html = '<span style="font-family: Monospace">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+font=Monospace:Foo)]'));
    });

    testWidgets('renders multiple fonts', (WidgetTester tester) async {
      const html = '<span style="font-family: Arial, sans-serif">Foo</span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(+font=Arial+fonts=sans-serif:Foo)]'));
    });

    testWidgets('renders font in single quote', (WidgetTester tester) async {
      const html = """<span style="font-family: 'Arial'">Foo</span>""";
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+font=Arial:Foo)]'));
    });

    testWidgets('renders font in double quote', (WidgetTester tester) async {
      const html = """<span style='font-family: "Arial"'>Foo</span>""";
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+font=Arial:Foo)]'));
    });
  });

  group('font-size', () {
    testWidgets('renders BIG tag', (WidgetTester tester) async {
      const html = '<big>Foo</big>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(@12.0:Foo)]'));
    });

    testWidgets('renders SMALL tag', (WidgetTester tester) async {
      const html = '<small>Foo</small>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(@8.3:Foo)]'));
    });

    testWidgets('renders xx-large', (WidgetTester tester) async {
      const html = '<span style="font-size: xx-large">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(@20.0:Foo)]'));
    });

    testWidgets('renders x-large', (WidgetTester tester) async {
      const html = '<span style="font-size: x-large">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(@15.0:Foo)]'));
    });

    testWidgets('renders large', (WidgetTester tester) async {
      const html = '<span style="font-size: large">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(@11.3:Foo)]'));
    });

    testWidgets('renders medium', (WidgetTester tester) async {
      const html = '<span style="font-size: 100px">F'
          '<span style="font-size: medium">o</span>o</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:(@100.0:F)(:o)(@100.0:o))]'));
    });

    testWidgets('renders small', (WidgetTester tester) async {
      const html = '<span style="font-size: small">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(@8.1:Foo)]'));
    });

    testWidgets('renders x-small', (WidgetTester tester) async {
      const html = '<span style="font-size: x-small">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(@6.3:Foo)]'));
    });

    testWidgets('renders xx-small', (WidgetTester tester) async {
      const html = '<span style="font-size: xx-small">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(@5.6:Foo)]'));
    });

    testWidgets('renders larger', (WidgetTester tester) async {
      const html = '<span style="font-size: larger">F'
          '<span style="font-size: larger">o</span>o</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:(@12.0:F)(@14.4:o)(@12.0:o))]'));
    });

    testWidgets('renders smaller', (WidgetTester tester) async {
      const html = '<span style="font-size: smaller">F'
          '<span style="font-size: smaller">o</span>o</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:(@8.3:F)(@6.9:o)(@8.3:o))]'));
    });

    group('renders value', () {
      testWidgets('control group', (WidgetTester tester) async {
        const html = '<span>Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(:Foo)]'));
      });

      testWidgets('renders em', (WidgetTester tester) async {
        const html = '<span style="font-size: 2em">F'
            '<span style="font-size: 2em">o</span>o</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(:(@20.0:F)(@40.0:o)(@20.0:o))]'));
      });

      testWidgets('renders percentage', (WidgetTester tester) async {
        const html = '<span style="font-size: 200%">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(@20.0:Foo)]'));
      });

      testWidgets('renders pt', (WidgetTester tester) async {
        const html = '<span style="font-size: 100pt">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(@133.3:Foo)]'));
      });

      testWidgets('renders px', (WidgetTester tester) async {
        const html = '<span style="font-size: 100px">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(@100.0:Foo)]'));
      });
    });

    group('textScaleFactor=2', () {
      Future<String> explain2x(WidgetTester tester, String html) async {
        tester.binding.window.textScaleFactorTestValue = 2;
        final explained = await explain(tester, html);
        tester.binding.window.clearTextScaleFactorTestValue();
        return explained;
      }

      testWidgets('control group', (WidgetTester tester) async {
        const html = '<span>Foo</span>';
        final explained = await explain2x(tester, html);
        expect(explained, equals('[RichText:(@20.0:Foo)]'));
      });

      testWidgets('renders em', (WidgetTester tester) async {
        const html = '<span style="font-size: 2em">F'
            '<span style="font-size: 2em">o</span>o</span>';
        final e = await explain2x(tester, html);
        expect(e, equals('[RichText:(@20.0:(@40.0:F)(@80.0:o)(@40.0:o))]'));
      });

      testWidgets('renders percentage', (WidgetTester tester) async {
        const html = '<span style="font-size: 200%">Foo</span>';
        final explained = await explain2x(tester, html);
        expect(explained, equals('[RichText:(@40.0:Foo)]'));
      });

      testWidgets('renders pt', (WidgetTester tester) async {
        const html = '<span style="font-size: 100pt">Foo</span>';
        final explained = await explain2x(tester, html);
        expect(explained, equals('[RichText:(@266.7:Foo)]'));
      });

      testWidgets('renders px', (WidgetTester tester) async {
        const html = '<span style="font-size: 100px">Foo</span>';
        final explained = await explain2x(tester, html);
        expect(explained, equals('[RichText:(@200.0:Foo)]'));
      });
    });

    testWidgets('renders multiple em', (WidgetTester tester) async {
      const html = '<span style="font-size: 2em; font-size: 2em">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(@20.0:Foo)]'));
    });

    testWidgets('renders multiple percentage', (WidgetTester tester) async {
      const html = '<span style="font-size: 200%; font-size: 200%">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(@20.0:Foo)]'));
    });

    testWidgets('renders invalid', (WidgetTester tester) async {
      const html = '<span style="font-size: xxx">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });
  });

  group('font-style', () {
    testWidgets('renders CITE tag', (WidgetTester tester) async {
      const html = 'This is a <cite>citation</cite>.';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:This is a (+i:citation)(:.))]'));
    });

    testWidgets('renders DFN tag', (WidgetTester tester) async {
      const html = 'This is a <dfn>definition</dfn>.';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:This is a (+i:definition)(:.))]'));
    });

    testWidgets('renders I tag', (WidgetTester tester) async {
      const html = 'This is an <i>italic</i> text.';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[RichText:(:This is an (+i:italic)(: text.))]'),
      );
    });

    testWidgets('renders EM tag', (WidgetTester tester) async {
      const html = 'This is an <em>emphasized</em> text.';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[RichText:(:This is an (+i:emphasized)(: text.))]'),
      );
    });

    testWidgets('renders VAR tag', (WidgetTester tester) async {
      const html = '<var>x</var> = 1';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:(+i:x)(: = 1))]'));
    });

    testWidgets('renders inline style: italic', (WidgetTester tester) async {
      const html = '<span style="font-style: italic">Italic text</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+i:Italic text)]'));
    });

    testWidgets('renders inline style: normal', (WidgetTester tester) async {
      const html = '<span style="font-style: italic">Italic '
          '<span style="font-style: normal">normal</span></span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:(+i:Italic )(-i:normal))]'));
    });
  });

  group('font-weight', () {
    testWidgets('renders B tag', (WidgetTester tester) async {
      const html = 'This is a <b>bold</b> text.';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:This is a (+b:bold)(: text.))]'));
    });

    testWidgets('renders STRONG tag', (WidgetTester tester) async {
      const html = 'This is a <strong>strong</strong> text.';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:This is a (+b:strong)(: text.))]'));
    });

    testWidgets('renders font-weight inline style',
        (WidgetTester tester) async {
      const html = '''
<span style="font-weight: bold">bold</span>
<span style="font-weight: 100">one</span>
<span style="font-weight: 200">two</span>
<span style="font-weight: 300">three</span>
<span style="font-weight: 400">four</span>
<span style="font-weight: 500">five</span>
<span style="font-weight: 600">six</span>
<span style="font-weight: 700">seven</span>
<span style="font-weight: 800">eight</span>
<span style="font-weight: 900">nine</span>
''';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[RichText:(:(+b:bold)(: )(+w0:one)(: )(+w1:two)(: )(+w2:three)(: )'
          '(:four)(: )(+w4:five)(: )(+w5:six)(: )'
          '(+b:seven)(: )(+w7:eight)(: )(+w8:nine))]',
        ),
      );
    });
  });

  group('line-height', () {
    testWidgets('renders number', (WidgetTester tester) async {
      const html = '<span style="line-height: 1">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+height=1.0:Foo)]'));
    });

    testWidgets('renders decimal', (WidgetTester tester) async {
      const html = '<span style="line-height: 1.1">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+height=1.1:Foo)]'));
    });

    testWidgets('renders em', (WidgetTester tester) async {
      const html = '<span style="line-height: 5em">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+height=5.0:Foo)]'));
    });

    testWidgets('renders percentage', (WidgetTester tester) async {
      const html = '<span style="line-height: 50%">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+height=0.5:Foo)]'));
    });

    testWidgets('renders pt', (WidgetTester tester) async {
      const html = '<span style="line-height: 50pt">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+height=6.7:Foo)]'));
    });

    testWidgets('renders px', (WidgetTester tester) async {
      const html = '<span style="line-height: 50px">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+height=5.0:Foo)]'));
    });

    testWidgets('renders invalid', (WidgetTester tester) async {
      const html = '<span style="line-height: xxx">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('renders child element (same)', (WidgetTester tester) async {
      const html = '<span style="line-height: 1">Foo <em>bar</em></span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:(+height=1.0:Foo )(+height=1.0+i:bar))]'));
    });

    testWidgets('renders child element (override)', (tester) async {
      const html = '<span style="line-height: 1">Foo '
          '<em style="line-height: 2">bar</em></span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:(+height=1.0:Foo )(+height=2.0+i:bar))]'));
    });

    testWidgets('renders child element (normal)', (WidgetTester tester) async {
      const html = '<span style="line-height: 1">Foo '
          '<em style="line-height: normal">bar</em></span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:(+height=1.0:Foo )(+i:bar))]'));
    });
  });

  group('text-overflow', () {
    testWidgets('renders clip', (WidgetTester tester) async {
      const html = '<div style="text-overflow: clip">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('renders ellipsis', (WidgetTester tester) async {
      const html = '<div style="text-overflow: ellipsis">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[RichText:overflow=ellipsis,(:Foo)]]',
        ),
      );
    });

    group('max-lines', () {
      testWidgets('renders number', (WidgetTester tester) async {
        const html = '<div style="max-lines: 2">Foo</div>';
        final e = await explain(tester, html);
        expect(e, equals('[CssBlock:child=[RichText:maxLines=2,(:Foo)]]'));
      });

      testWidgets('renders another number (override)', (tester) async {
        const html = '<div style="max-lines: 2; max-lines: 3">Foo</div>';
        final e = await explain(tester, html);
        expect(e, equals('[CssBlock:child=[RichText:maxLines=3,(:Foo)]]'));
      });

      testWidgets('renders none (override)', (tester) async {
        const html = '<div style="max-lines: 2; max-lines: none">Foo</div>';
        final explained = await explain(tester, html);
        expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
      });

      testWidgets('renders -webkit-line-clamp', (WidgetTester tester) async {
        const html = '<div style="-webkit-line-clamp: 2">Foo</div>';
        final e = await explain(tester, html);
        expect(e, equals('[CssBlock:child=[RichText:maxLines=2,(:Foo)]]'));
      });

      testWidgets('renders with ellipsis', (WidgetTester tester) async {
        const html =
            '<div style="max-lines: 2; text-overflow: ellipsis">Foo</div>';
        final explained = await explain(tester, html);
        expect(
          explained,
          equals(
            '[CssBlock:child=[RichText:maxLines=2,overflow=ellipsis,(:Foo)]]',
          ),
        );
      });
    });
  });

  group('white-space', () {
    testWidgets('renders normal', (tester) async {
      const html = '<div style="white-space: normal">Foo\nbar</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo bar)]]'));
    });

    testWidgets('renders pre', (tester) async {
      const code = '\n  Foo\n  bar  \n';
      const html = '<div style="white-space: pre">$code</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:$code)]]'));
    });

    group('PRE tag', () {
      testWidgets('renders without inline styling', (tester) async {
        const html = '<pre>Foo\nbar</pre>';
        final explained = await explain(tester, html);
        expect(
          explained,
          equals(
            '[CssBlock:child=[SingleChildScrollView:child='
            '[RichText:(+font=Courier+fonts=monospace:Foo\nbar)]]]',
          ),
        );
      });

      testWidgets('renders normal', (tester) async {
        const html = '<pre style="white-space: normal">Foo\nbar</pre>';
        final explained = await explain(tester, html);
        expect(
          explained,
          equals(
            '[CssBlock:child=[SingleChildScrollView:child='
            '[RichText:(+font=Courier+fonts=monospace:Foo bar)]]]',
          ),
        );
      });
    });
  });

  group('#698', () {
    testWidgets('MaterialApp > CupertinoPageScaffold', (tester) async {
      const html = 'Hello world';
      final key = GlobalKey<HtmlWidgetState>();

      await tester.pumpWidget(
        MaterialApp(
          home: CupertinoPageScaffold(
            child: HtmlWidget(html, key: key),
          ),
        ),
      );

      final explained = await explainWithoutPumping(key: key);
      expect(explained, equals('[RichText:(#D0FF0000:$html)]'));
    });

    testWidgets('Typography.material2018', (tester) async {
      const html = 'Hello world';
      final key = GlobalKey<HtmlWidgetState>();

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            typography: Typography.material2018(),
          ),
          home: Scaffold(
            body: HtmlWidget(html, key: key),
          ),
        ),
      );

      final explained = await explainWithoutPumping(key: key);
      expect(explained, equals('[RichText:(#DD000000:$html)]'));
    });
  });
}

class _InlineBlockOnWidgetsFactory extends WidgetFactory {
  @override
  void parse(BuildMetadata meta) {
    if (meta.element.localName == 'span') {
      meta.register(
        BuildOp(
          onWidgets: (_, __) => const [Text('Bar')],
        ),
      );
    }
    super.parse(meta);
  }
}
