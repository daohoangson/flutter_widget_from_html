import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '_.dart';

void main() {
  final imgSizingConstraints = 'height≥0.0,height=auto,width≥0.0,width=auto';

  testWidgets('renders empty string', (WidgetTester tester) async {
    final html = '';
    final explained = await explain(tester, html);
    expect(explained, equals('[widget0]'));
  });

  testWidgets('renders bare string', (WidgetTester tester) async {
    final html = 'Hello world';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:(:Hello world)]'));
  });

  testWidgets('renders textStyle', (WidgetTester tester) async {
    final html = 'Hello world';
    final explained = await explain(
      tester,
      html,
      textStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
    expect(explained, equals('[RichText:(@20.0+b:Hello world)]'));
  });

  testWidgets('renders without erroneous white spaces', (tester) async {
    final html = '''
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
        equals('[Column:children='
            '[CssBlock:child=[RichText:(:(+l+o+u:All decorations... )(:and none))]],'
            '[CssBlock:child=[RichText:(:I​Like​Playing​football​​game)]],'
            '[CssBlock:child=[RichText:(:\u00A0)]]'
            ']'));
  });

  testWidgets('renders white spaces with parent style', (tester) async {
    final html = ' <b>One<em> <u>two </u></em> three</b> ';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:(:(+b:One )(+u+i+b:two)(+b: three))]'));
  });

  group('ABBR tag', () {
    testWidgets('renders ABBR', (WidgetTester tester) async {
      final html = '<abbr>ABBR</abbr>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+u/dotted:ABBR)]'));
    });

    testWidgets('renders ACRONYM', (WidgetTester tester) async {
      final html = '<acronym>ACRONYM</acronym>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+u/dotted:ACRONYM)]'));
    });
  });

  testWidgets('renders ADDRESS tag', (WidgetTester tester) async {
    final html = 'This is an <address>ADDRESS</address>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[Column:children='
            '[RichText:(:This is an)],'
            '[CssBlock:child=[RichText:(+i:ADDRESS)]]'
            ']'));
  });

  group('BR', () {
    testWidgets('renders new line', (WidgetTester tester) async {
      final html = '1<br />2';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:1\n2)]'));
    });

    testWidgets('renders without whitespace on new line', (tester) async {
      final html = '1<br />\n2';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:1\n2)]'));
    });

    testWidgets('renders without whitespace on next SPAN', (tester) async {
      final html = '1<br />\n<span>\n2</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:1\n2)]'));
    });

    testWidgets('renders multiple new lines, 1 of 2', (tester) async {
      final html = '1<br /><br />2';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:1\n\n2)]'));
    });

    testWidgets('renders multiple new lines, 2 of 2', (tester) async {
      final html = '1<br /><br /><br />2';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:1\n\n\n2)]'));
    });

    testWidgets('renders new line before styled text', (tester) async {
      final html = '1<br /><strong>2</strong>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:1\n(+b:2))]'));
    });

    testWidgets('renders new line before IMG', (tester) async {
      final src = 'http://domain.com/image.png';
      final html = '1<br /><img src="$src" />';
      final explained = await mockNetworkImagesFor(() => explain(tester, html));
      expect(
          explained,
          equals('[RichText:(:'
              '1\n'
              '[CssSizing:$imgSizingConstraints,child='
              '[Image:image=NetworkImage("$src", scale: 1.0)]'
              '])]'));
    });

    testWidgets('renders new line between SPANs, 1 of 2', (tester) async {
      final html = '<span>1<br /></span><span>2</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:1\n2)]'));
    });

    testWidgets('renders new line between SPANs, 2 of 2', (tester) async {
      final html = '<span>1</span><br /><span>2</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:1\n2)]'));
    });

    testWidgets('skips new line between SPAN and DIV, 1 of 2', (tester) async {
      final html = '<span>1<br /></span><div>2</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Column:children='
              '[RichText:(:1)],'
              '[CssBlock:child=[RichText:(:2)]]'
              ']'));
    });

    testWidgets('skips new line between SPAN and DIV, 2 of 2', (tester) async {
      final html = '<span>1</span><br /><div>2</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Column:children='
              '[RichText:(:1)],'
              '[CssBlock:child=[RichText:(:2)]]'
              ']'));
    });

    testWidgets('renders new line between DIVs, 1 of 3', (tester) async {
      final html = '<div>1<br /></div><div>2</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Column:children='
              '[CssBlock:child=[RichText:(:1)]],'
              '[CssBlock:child=[RichText:(:2)]]'
              ']'));
    });

    testWidgets('renders new line between DIVs, 2 of 3', (tester) async {
      final html = '<div>1</div><br /><div>2</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Column:children='
              '[CssBlock:child=[RichText:(:1)]],'
              '[SizedBox:0.0x10.0],'
              '[CssBlock:child=[RichText:(:2)]]'
              ']'));
    });

    testWidgets('renders new line between DIVs, 3 of 3', (tester) async {
      final html = '<div>1</div><br /><div>2</div>';
      final explained = await explain(tester, html, useExplainer: false);
      expect(
          explained,
          equals('TshWidget\n'
              '└ColumnPlaceholder(BuildMetadata(root))\n'
              ' └Column()\n'
              '  ├WidgetPlaceholder<BuildTree>(BuildTree#0 tsb#1(parent=#2):\n'
              '  ││  "1"\n'
              '  ││)\n'
              '  │└CssBlock()\n'
              '  │ └RichText(text: "1")\n'
              '  ├HeightPlaceholder(1.0em)\n'
              '  │└SizedBox(height: 10.0)\n'
              '  └WidgetPlaceholder<BuildTree>(BuildTree#3 tsb#4(parent=#2):\n'
              '   │  "2"\n'
              '   │)\n'
              '   └CssBlock()\n'
              '    └RichText(text: "2")\n\n'));
    });

    testWidgets('renders without new line at bottom, 1 of 3', (tester) async {
      final html = 'Foo<br />';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('renders without new line at bottom, 2 of 3', (tester) async {
      final html = '<span>Foo</span><br />';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('renders without new line at bottom, 3 of 3', (tester) async {
      final html = '<div>Foo</div><br />';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });
  });

  testWidgets('renders DD/DL/DT tags', (WidgetTester tester) async {
    final html = '<dl><dt>Foo</dt><dd>Bar</dd></dl>';
    final explained = await explainMargin(tester, html);
    expect(
        explained,
        equals('[CssBlock:child=[Column:children='
            '[CssBlock:child=[RichText:(+b:Foo)]],'
            '[Padding:(0,0,0,40),child=[CssBlock:child=[RichText:(:Bar)]]]'
            ']],'
            '[SizedBox:0.0x10.0]'));
  });

  testWidgets('renders HR tag', (WidgetTester tester) async {
    final html = '<hr/>';
    final explained = await explainMargin(tester, html);
    expect(
        explained,
        equals(
            '[CssBlock:child=[DecoratedBox:bg=#FF000000,child=[SizedBox:0.0x1.0]]],'
            '[SizedBox:0.0x10.0]'));
  });

  group('block elements', () {
    final blockOutput = '[Column:children='
        '[CssBlock:child=[RichText:(:First.)]],'
        '[CssBlock:child=[RichText:(:Second one.)]]'
        ']';

    testWidgets('renders ARTICLE tag', (WidgetTester tester) async {
      final html = '<article>First.</article><article>Second one.</article>';
      final explained = await explain(tester, html);
      expect(explained, equals(blockOutput));
    });

    testWidgets('renders ASIDE tag', (WidgetTester tester) async {
      final html = '<aside>First.</aside><aside>Second one.</aside>';
      final explained = await explain(tester, html);
      expect(explained, equals(blockOutput));
    });

    testWidgets('renders BLOCKQUOTE tag', (WidgetTester tester) async {
      final html = '<blockquote>Foo</blockquote>';
      final explained = await explainMargin(tester, html);
      expect(
        explained,
        equals('[SizedBox:0.0x10.0],'
            '[Padding:(0,40,0,40),child=[CssBlock:child=[RichText:(:Foo)]]],'
            '[SizedBox:0.0x10.0]'),
      );
    });

    testWidgets('renders DIV tag', (WidgetTester tester) async {
      final html = '<div>First.</div><div>Second one.</div>';
      final explained = await explain(tester, html);
      expect(explained, equals(blockOutput));
    });

    testWidgets(
      'renders FIGURE/FIGCAPTION tags',
      (tester) => mockNetworkImagesFor(() async {
        final src = 'http://domain.com/image.png';
        final html = '''
<figure>
  <img src="$src" />
  <figcaption><i>fig. 1</i> Foo</figcaption>
</figure>
''';
        final explained = await explainMargin(tester, html);
        expect(
            explained,
            equals('[SizedBox:0.0x10.0],'
                '[Padding:(0,40,0,40),child=[CssBlock:child=[Column:children='
                '[CssSizing:$imgSizingConstraints,child=[Image:image=NetworkImage("http://domain.com/image.png", scale: 1.0)]],'
                '[CssBlock:child=[RichText:(:(+i:fig. 1)(: Foo))]]'
                ']]],'
                '[SizedBox:0.0x10.0]'));
      }),
    );

    testWidgets('renders HEADER/FOOTER tag', (WidgetTester tester) async {
      final html = '<header>First.</header><footer>Second one.</footer>';
      final explained = await explain(tester, html);
      expect(explained, equals(blockOutput));
    });

    testWidgets('renders MAIN/NAV tag', (WidgetTester tester) async {
      final html = '<main>First.</main><nav>Second one.</nav>';
      final explained = await explain(tester, html);
      expect(explained, equals(blockOutput));
    });

    testWidgets('renders P tag', (WidgetTester tester) async {
      final html = '<p>First.</p><p>Second one.</p>';
      final explained = await explainMargin(tester, html);
      expect(
        explained,
        equals('[SizedBox:0.0x10.0],'
            '[CssBlock:child=[RichText:(:First.)]],'
            '[SizedBox:0.0x10.0],'
            '[CssBlock:child=[RichText:(:Second one.)]],'
            '[SizedBox:0.0x10.0]'),
      );
    });

    testWidgets('renders SECTION tag', (WidgetTester tester) async {
      final html = '<section>First.</section><section>Second one.</section>';
      final explained = await explain(tester, html);
      expect(explained, equals(blockOutput));
    });
  });

  group('non renderable elements', () {
    testWidgets('skips IFRAME tag', (WidgetTester tester) async {
      final html =
          '''<iframe src="https://www.youtube.com/embed/jNQXAC9IVRw" width="320" height="180">
  Your browser does not support IFRAME.
</iframe>''';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:Your browser does not support IFRAME.)]'));
    });

    testWidgets('skips SCRIPT tag', (WidgetTester tester) async {
      final html = '<script>document.write("SCRIPT is working");</script>'
          '<noscript>SCRIPT is not working</noscript>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:SCRIPT is not working)]'));
    });

    testWidgets('skips STYLE tag', (WidgetTester tester) async {
      final html = '<style>.xxx { color: red; }</style>'
          '<span class="xxx">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('skips SVG tag', (WidgetTester tester) async {
      final html = '''<svg height="100" width="100">
  <circle cx="50" cy="50" r="40" stroke="black" stroke-width="3" fill="red" />
  Your browser does not support inline SVG.
</svg>''';
      final explained = await explain(tester, html);
      expect(explained,
          equals('[RichText:(:Your browser does not support inline SVG.)]'));
    });

    testWidgets('skips VIDEO tag', (WidgetTester tester) async {
      final html = '''<video>
  <source src="mov_bbb.mp4" type="video/mp4">
  <source src="mov_bbb.ogg" type="video/ogg">
  Your browser does not support HTML5 video.
</video>''';
      final explained = await explain(tester, html);
      expect(explained,
          equals('[RichText:(:Your browser does not support HTML5 video.)]'));
    });
  });

  group('code', () {
    testWidgets('renders CODE tag', (WidgetTester tester) async {
      final html = '<code><span style="color: #000000">'
          '<span style="color: #0000BB">&lt;?php phpinfo</span>'
          '<span style="color: #007700">(); </span>'
          '<span style="color: #0000BB">?&gt;</span>'
          '</span></code>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[RichText:(:'
              '(#FF0000BB+font=Courier+fonts=monospace:<?php phpinfo)'
              '(#FF007700+font=Courier+fonts=monospace:(); )'
              '(#FF0000BB+font=Courier+fonts=monospace:?>)'
              ')]'));
    });

    testWidgets('renders empty CODE tag', (WidgetTester tester) async {
      final html = '<code></code>';
      final explained = await explain(tester, html);
      expect(explained, equals('[widget0]'));
    });

    testWidgets('renders KBD tag', (WidgetTester tester) async {
      final html = '<kbd>ESC</kbd>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(+font=Courier+fonts=monospace:ESC)]'));
    });

    testWidgets('renders PRE tag', (WidgetTester tester) async {
      final html = """<pre>&lt;?php
highlight_string('&lt;?php phpinfo(); ?&gt;');
?&gt;</pre>""";
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child=[SingleChildScrollView:child=[RichText:'
              '(+font=Courier+fonts=monospace:<?php\nhighlight_string(\''
              '<?php phpinfo(); ?>\');\n?>)]'
              ']]'));
    });

    testWidgets('renders SAMP tag', (WidgetTester tester) async {
      final html = '<samp>Error</samp>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(+font=Courier+fonts=monospace:Error)]'));
    });

    testWidgets('renders TT tag', (WidgetTester tester) async {
      final html = '<tt>Teletype</tt>';
      final explained = await explain(tester, html);
      expect(explained,
          equals('[RichText:(+font=Courier+fonts=monospace:Teletype)]'));
    });
  });

  group('headings', () {
    testWidgets('render H1 tag', (WidgetTester tester) async {
      final html = '<h1>X</h1>';
      final explained = await explainMargin(tester, html);
      expect(
          explained,
          equals('[SizedBox:0.0x13.4],'
              '[CssBlock:child=[RichText:(@20.0+b:X)]],'
              '[SizedBox:0.0x13.4]'));
    });

    testWidgets('render H2 tag', (WidgetTester tester) async {
      final html = '<h2>X</h2>';
      final explained = await explainMargin(tester, html);
      expect(
          explained,
          equals('[SizedBox:0.0x12.4],'
              '[CssBlock:child=[RichText:(@15.0+b:X)]],'
              '[SizedBox:0.0x12.4]'));
    });

    testWidgets('render H3 tag', (WidgetTester tester) async {
      final html = '<h3>X</h3>';
      final explained = await explainMargin(tester, html);
      expect(
          explained,
          equals('[SizedBox:0.0x11.7],'
              '[CssBlock:child=[RichText:(@11.7+b:X)]],'
              '[SizedBox:0.0x11.7]'));
    });

    testWidgets('render H4 tag', (WidgetTester tester) async {
      final html = '<h4>X</h4>';
      final explained = await explainMargin(tester, html);
      expect(
          explained,
          equals('[SizedBox:0.0x13.3],'
              '[CssBlock:child=[RichText:(+b:X)]],'
              '[SizedBox:0.0x13.3]'));
    });

    testWidgets('render H5 tag', (WidgetTester tester) async {
      final html = '<h5>X</h5>';
      final explained = await explainMargin(tester, html);
      expect(
          explained,
          equals('[SizedBox:0.0x13.9],'
              '[CssBlock:child=[RichText:(@8.3+b:X)]],'
              '[SizedBox:0.0x13.9]'));
    });

    testWidgets('render H6 tag', (WidgetTester tester) async {
      final html = '<h6>X</h6>';
      final explained = await explainMargin(tester, html);
      expect(
          explained,
          equals('[SizedBox:0.0x15.6],'
              '[CssBlock:child=[RichText:(@6.7+b:X)]],'
              '[SizedBox:0.0x15.6]'));
    });
  });

  group('background-color', () {
    testWidgets('renders MARK tag', (WidgetTester tester) async {
      final html = '<mark>Foo</mark>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(bg=#FFFFFF00#FF000000:Foo)]'));
    });

    testWidgets('renders block', (WidgetTester tester) async {
      final html = '<div style="background-color: #f00">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child='
              '[DecoratedBox:bg=#FFFF0000,child='
              '[RichText:(:Foo)]]]'));
    });

    testWidgets('renders with margins and paddings', (tester) async {
      final html = '<div style="background-color: #f00; '
          'margin: 1px; padding: 2px">Foo</div>';
      final explained = await explainMargin(tester, html);
      expect(
          explained,
          equals('[SizedBox:0.0x1.0],'
              '[Padding:(0,1,0,1),child='
              '[CssBlock:child=[DecoratedBox:bg=#FFFF0000,child='
              '[Padding:(2,2,2,2),child=[RichText:(:Foo)]]]'
              ']],[SizedBox:0.0x1.0]'));
    });

    testWidgets('renders blocks', (WidgetTester tester) async {
      final h = '<div style="background-color: #f00"><p>A</p><p>B</p></div>';
      final explained = await explain(tester, h);
      expect(
          explained,
          equals(
              '[CssBlock:child=[DecoratedBox:bg=#FFFF0000,child=[Column:children='
              '[CssBlock:child=[RichText:(:A)]],'
              '[SizedBox:0.0x10.0],'
              '[CssBlock:child=[RichText:(:B)]]'
              ']]]'));
    });

    testWidgets('renders inline', (WidgetTester tester) async {
      final html = 'Foo <span style="background-color: #f00">bar</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo (bg=#FFFF0000:bar))]'));
    });

    testWidgets('renders background', (WidgetTester tester) async {
      final html = 'Foo <span style="background: #f00">bar</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo (bg=#FFFF0000:bar))]'));
    });

    group('renders without erroneous white spaces', () {
      testWidgets('before', (WidgetTester tester) async {
        final html = 'Foo<span style="background-color: #f00"> bar</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(:Foo (bg=#FFFF0000:bar))]'));
      });

      testWidgets('after', (WidgetTester tester) async {
        final html = 'Foo <span style="background-color: #f00">bar </span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(:Foo (bg=#FFFF0000:bar))]'));
      });
    });

    testWidgets('resets in continuous SPANs (#155)', (tester) async {
      final html =
          '<span style="color: #ff0; background-color:#00f;">Foo</span>'
          '<span style="color: #f00;">bar</span>';
      final explained = await explain(tester, html);
      expect(explained,
          equals('[RichText:(:(bg=#FF0000FF#FFFFFF00:Foo)(#FFFF0000:bar))]'));
    });
  });

  group('color (inline style)', () {
    testWidgets('renders hex values', (WidgetTester tester) async {
      final html = '<span style="color: #F00">red</span>'
          '<span style="color: #F008">red 53%</span>'
          '<span style="color: #00FF00">green</span>'
          '<span style="color: #00FF0080">green 50%</span>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[RichText:(:(#FFFF0000:red)(#88FF0000:red 53%)'
              '(#FF00FF00:green)(#8000FF00:green 50%))]'));
    });

    testWidgets('renders overlaps', (WidgetTester tester) async {
      final html = '<span style="color: #FF0000">red '
          '<span style="color: #00FF00">green</span> red again</span>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[RichText:(:(#FFFF0000:red )'
              '(#FF00FF00:green)(#FFFF0000: red again))]'));
    });

    group('hsl/a', () {
      testWidgets('renders hsl red', (WidgetTester tester) async {
        final html = '<span style="color: hsl(0, 100%, 50%)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FFFF0000:Foo)]'));
      });

      testWidgets('renders hsl green', (WidgetTester tester) async {
        final html = '<span style="color: hsl(120, 100%, 50%)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FF00FF00:Foo)]'));
      });

      testWidgets('renders hsl blue', (WidgetTester tester) async {
        final html = '<span style="color: hsl(240, 100%, 50%)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FF0000FF:Foo)]'));
      });

      testWidgets('renders hsla alpha', (WidgetTester tester) async {
        final html = '<span style="color: hsla(0, 0%, 0%, 0.5)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#80000000:Foo)]'));
      });

      testWidgets('renders hsl red in negative', (WidgetTester tester) async {
        final html = '<span style="color: hsl(-360, 100%, 50%)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FFFF0000:Foo)]'));
      });

      testWidgets('renders hsl red in multiple of 360', (tester) async {
        final html = '<span style="color: hsl(720, 100%, 50%)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FFFF0000:Foo)]'));
      });

      testWidgets('renders hsl green in deg', (WidgetTester tester) async {
        final html = '<span style="color: hsl(120deg, 100%, 50%)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FF00FF00:Foo)]'));
      });

      testWidgets('renders hsl green in rad', (WidgetTester tester) async {
        final html = '<span style="color: hsl(2.0944rad,100%,50%)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FF00FF00:Foo)]'));
      });

      testWidgets('renders hsl green in grad', (WidgetTester tester) async {
        final html = '<span style="color:hsl(133.333grad,100%,50%)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FF00FF00:Foo)]'));
      });

      testWidgets('renders hsl green in turn', (WidgetTester tester) async {
        final html = '<span style="color: hsl(0.3333turn,100%,50%)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FF00FF00:Foo)]'));
      });

      testWidgets('renders hsla alpha in percentage', (tester) async {
        final html = '<span style="color: hsla(0, 0%, 0%, 50%)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#80000000:Foo)]'));
      });

      testWidgets('renders without comma', (tester) async {
        final html = '<span style="color: hsla(0 0% 0% / 50%)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#80000000:Foo)]'));
      });

      testWidgets('renders invalids', (WidgetTester tester) async {
        final htmls = [
          '<span style="color: hsl(xxx, 0, 0)">Foo</span>',
          '<span style="color: hsl(0, -1%, 0)">Foo</span>',
          '<span style="color: hsl(0, 1000%, 0)">Foo</span>',
          '<span style="color: hsl(0, xxx, 0)">Foo</span>',
          '<span style="color: hsl(0, 0, -1%)">Foo</span>',
          '<span style="color: hsl(0, 0, 1000%)">Foo</span>',
          '<span style="color: hsl(0, 0, xxx)">Foo</span>',
          '<span style="color: hsla(0, 0, 0, -1)">Foo</span>',
          '<span style="color: hsla(0, 0, 0, 9)">Foo</span>',
          '<span style="color: hsla(0, 0, 0, 1000%)">Foo</span>',
          '<span style="color: hsla(0, 0, 0, x)">Foo</span>',
        ];
        for (final html in htmls) {
          final explained = await explain(tester, html);
          expect(explained, equals('[RichText:(:Foo)]'), reason: html);
        }
      });
    });

    group('named color', () {
      testWidgets('renders red', (WidgetTester tester) async {
        final html = '<span style="color: red">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FFFF0000:Foo)]'));
      });

      testWidgets('renders green', (WidgetTester tester) async {
        final html = '<span style="color: green">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FF008000:Foo)]'));
      });

      testWidgets('renders blue', (WidgetTester tester) async {
        final html = '<span style="color: blue">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FF0000FF:Foo)]'));
      });
    });

    group('rgb/a', () {
      testWidgets('renders rgb red', (WidgetTester tester) async {
        final html = '<span style="color: rgb(255, 0, 0)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FFFF0000:Foo)]'));
      });

      testWidgets('renders rgb green', (WidgetTester tester) async {
        final html = '<span style="color: rgb(0, 255, 0)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FF00FF00:Foo)]'));
      });

      testWidgets('renders rgb blue', (WidgetTester tester) async {
        final html = '<span style="color: rgb(0, 0, 255)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FF0000FF:Foo)]'));
      });

      testWidgets('renders rgba alpha', (WidgetTester tester) async {
        final html = '<span style="color: rgba(0, 0, 0, 0.5)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#80000000:Foo)]'));
      });

      testWidgets('renders rgb red in percentage', (tester) async {
        final html = '<span style="color: rgb(100.0%, 0, 0)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FFFF0000:Foo)]'));
      });

      testWidgets('renders rgb green in percentage', (tester) async {
        final html = '<span style="color: rgb(0, 100.0%, 0)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FF00FF00:Foo)]'));
      });

      testWidgets('renders rgb blue in percentage', (tester) async {
        final html = '<span style="color: rgb(0, 0, 100.0%)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#FF0000FF:Foo)]'));
      });

      testWidgets('renders rgba alpha in percentage', (tester) async {
        final html = '<span style="color: rgba(0, 0, 0, 50%)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#80000000:Foo)]'));
      });

      testWidgets('renders without comma', (WidgetTester tester) async {
        final html = '<span style="color: rgba(0 0 0 / 0.5)">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(#80000000:Foo)]'));
      });

      testWidgets('renders invalids', (WidgetTester tester) async {
        final htmls = [
          '<span style="color: rgb(-1, 0, 0)">Foo</span>',
          '<span style="color: rgb(999, 0, 0)">Foo</span>',
          '<span style="color: rgb(1000%, 0, 0)">Foo</span>',
          '<span style="color: rgb(xxx, 0, 0)">Foo</span>',
          '<span style="color: rgb(0, -1, 0)">Foo</span>',
          '<span style="color: rgb(0, 999, 0)">Foo</span>',
          '<span style="color: rgb(0, 1000%, 0)">Foo</span>',
          '<span style="color: rgb(0, xxx, 0)">Foo</span>',
          '<span style="color: rgb(0, 0, -1)">Foo</span>',
          '<span style="color: rgb(0, 0, 999)">Foo</span>',
          '<span style="color: rgb(0, 0, 1000%)">Foo</span>',
          '<span style="color: rgb(0, 0, xxx)">Foo</span>',
          '<span style="color: rgba(0, 0, 0, -1)">Foo</span>',
          '<span style="color: rgba(0, 0, 0, 9)">Foo</span>',
          '<span style="color: rgba(0, 0, 0, 1000%)">Foo</span>',
          '<span style="color: rgba(0, 0, 0, x)">Foo</span>',
        ];
        for (final html in htmls) {
          final explained = await explain(tester, html);
          expect(explained, equals('[RichText:(:Foo)]'), reason: html);
        }
      });
    });

    testWidgets('renders transparent', (WidgetTester tester) async {
      final html = '<span style="color: transparent">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(#00000000:Foo)]'));
    });
  });

  group('display', () {
    testWidgets('renders SPAN inline by default', (WidgetTester tester) async {
      final html = '<div>1 <span>2</span></div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:1 2)]]'));
    });

    testWidgets('renders display: block', (WidgetTester tester) async {
      final html = '<div>1 <span style="display: block">2</span></div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child='
              '[Column:children='
              '[RichText:(:1)],'
              '[CssBlock:child=[RichText:(:2)]]'
              ']]'));
    });

    testWidgets('renders DIV block by default', (WidgetTester tester) async {
      final html = '<div>1 <div>2</div></div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child='
              '[Column:children='
              '[RichText:(:1)],'
              '[CssBlock:child=[RichText:(:2)]]'
              ']]'));
    });

    testWidgets('renders display: inline', (WidgetTester tester) async {
      final html = '<div>1 <div style="display: inline">2</div></div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:1 2)]]'));
    });

    testWidgets('renders display: inline-block', (WidgetTester tester) async {
      final html = '<div>1 <div style="display: inline-block">2</div></div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:1 2)]]'));
    });

    testWidgets('renders display: none', (WidgetTester tester) async {
      final html = '<div>1 <div style="display: none">2</div></div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:1)]]'));
    });

    group('IMG', () {
      final src = 'http://domain.com/image.png';

      testWidgets(
        'renders IMG inline by default',
        (tester) => mockNetworkImagesFor(() async {
          final html = 'Foo <img src="$src" />';
          final explained = await explain(tester, html);
          expect(
              explained,
              equals('[RichText:(:Foo '
                  '[CssSizing:$imgSizingConstraints,child='
                  '[Image:image=NetworkImage("$src", scale: 1.0)]'
                  '])]'));
        }),
      );

      testWidgets(
        'renders IMG as block',
        (tester) => mockNetworkImagesFor(() async {
          final html = 'Foo <img src="$src" style="display: block" />';
          final explained = await explain(tester, html);
          expect(
              explained,
              equals('[Column:children='
                  '[RichText:(:Foo)],'
                  '[CssSizing:$imgSizingConstraints,child=[Image:image=NetworkImage("$src", scale: 1.0)]]'
                  ']'));
        }),
      );

      testWidgets(
        'renders IMG with dimensions inline',
        (tester) => mockNetworkImagesFor(() async {
          final html = '<img src="$src" width="1" height="1" />';
          final explained = await explain(tester, html);
          expect(
              explained,
              equals(
                  '[CssSizing:height≥0.0,height=1.0,width≥0.0,width=1.0,child='
                  '[AspectRatio:aspectRatio=1.0,child='
                  '[Image:image=NetworkImage("$src", scale: 1.0)]'
                  ']]'));
        }),
      );

      testWidgets(
        'renders IMG with dimensions as block',
        (tester) => mockNetworkImagesFor(() async {
          final html = '<img src="$src" width="1" '
              'height="1" style="display: block" />';
          final explained = await explain(tester, html);
          expect(
              explained,
              equals(
                  '[CssSizing:height≥0.0,height=1.0,width≥0.0,width=1.0,child='
                  '[AspectRatio:aspectRatio=1.0,child='
                  '[Image:image=NetworkImage("$src", scale: 1.0)]'
                  ']]'));
        }),
      );
    });
  });

  group('FONT', () {
    testWidgets('renders color attribute', (WidgetTester tester) async {
      final html = '<font color="#F00">Foo</font>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(#FFFF0000:Foo)]'));
    });

    testWidgets('renders face attribute', (WidgetTester tester) async {
      final html = '<font face="Monospace">Foo</font>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+font=Monospace:Foo)]'));
    });

    group('size attribute', () {
      testWidgets('renders 7', (WidgetTester tester) async {
        final html = '<font size="7">Foo</font>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(@20.0:Foo)]'));
      });

      testWidgets('renders 6', (WidgetTester tester) async {
        final html = '<font size="6">Foo</font>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(@15.0:Foo)]'));
      });

      testWidgets('renders 5', (WidgetTester tester) async {
        final html = '<font size="5">Foo</font>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(@11.3:Foo)]'));
      });

      testWidgets('renders 4', (WidgetTester tester) async {
        final html = '<font size="4">Foo</font>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(:Foo)]'));
      });

      testWidgets('renders 3', (WidgetTester tester) async {
        final html = '<font size="3">Foo</font>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(@8.1:Foo)]'));
      });

      testWidgets('renders 2', (WidgetTester tester) async {
        final html = '<font size="2">Foo</font>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(@6.3:Foo)]'));
      });

      testWidgets('renders 1', (WidgetTester tester) async {
        final html = '<font size="1">Foo</font>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(@5.6:Foo)]'));
      });
    });

    testWidgets('renders all attributes', (WidgetTester tester) async {
      final html = '<font color="#00F" face="Monospace" size="7">Foo</font>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(#FF0000FF+font=Monospace@20.0:Foo)]'));
    });
  });

  group('direction', () {
    group('attribute', () {
      testWidgets('renders auto', (WidgetTester tester) async {
        final html = '<div dir="auto">Foo</div>';
        final e = await explain(tester, html);
        expect(e, equals('[CssBlock:child=[RichText:(:Foo)]]'));
      });

      testWidgets('renders ltr', (WidgetTester tester) async {
        final html = '<div dir="ltr">Foo</div>';
        final explained = await explain(tester, html);
        expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
      });

      testWidgets('renders rtl', (WidgetTester tester) async {
        final html = '<div dir="rtl">Foo</div>';
        final explained = await explain(tester, html);
        expect(explained, equals('[CssBlock:child=[RichText:dir=rtl,(:Foo)]]'));
      });
    });

    group('inline style', () {
      testWidgets('renders ltr', (WidgetTester tester) async {
        final html = '<div style="direction: ltr">Foo</div>';
        final explained = await explain(tester, html);
        expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
      });

      testWidgets('renders rtl', (WidgetTester tester) async {
        final html = '<div style="direction: rtl">Foo</div>';
        final explained = await explain(tester, html);
        expect(explained, equals('[CssBlock:child=[RichText:dir=rtl,(:Foo)]]'));
      });
    });
  });

  group('font-family', () {
    testWidgets('renders one font', (WidgetTester tester) async {
      final html = '<span style="font-family: Monospace">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+font=Monospace:Foo)]'));
    });

    testWidgets('renders multiple fonts', (WidgetTester tester) async {
      final html = '<span style="font-family: Arial, sans-serif">Foo</span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(+font=Arial+fonts=sans-serif:Foo)]'));
    });

    testWidgets('renders font in single quote', (WidgetTester tester) async {
      final html = """<span style="font-family: 'Arial'">Foo</span>""";
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+font=Arial:Foo)]'));
    });

    testWidgets('renders font in double quote', (WidgetTester tester) async {
      final html = """<span style='font-family: "Arial"'>Foo</span>""";
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+font=Arial:Foo)]'));
    });
  });

  group('font-size', () {
    testWidgets('renders BIG tag', (WidgetTester tester) async {
      final html = '<big>Foo</big>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(@12.0:Foo)]'));
    });

    testWidgets('renders SMALL tag', (WidgetTester tester) async {
      final html = '<small>Foo</small>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(@8.3:Foo)]'));
    });

    testWidgets('renders xx-large', (WidgetTester tester) async {
      final html = '<span style="font-size: xx-large">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(@20.0:Foo)]'));
    });

    testWidgets('renders x-large', (WidgetTester tester) async {
      final html = '<span style="font-size: x-large">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(@15.0:Foo)]'));
    });

    testWidgets('renders large', (WidgetTester tester) async {
      final html = '<span style="font-size: large">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(@11.3:Foo)]'));
    });

    testWidgets('renders medium', (WidgetTester tester) async {
      final html = '<span style="font-size: 100px">F'
          '<span style="font-size: medium">o</span>o</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:(@100.0:F)(:o)(@100.0:o))]'));
    });

    testWidgets('renders small', (WidgetTester tester) async {
      final html = '<span style="font-size: small">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(@8.1:Foo)]'));
    });

    testWidgets('renders x-small', (WidgetTester tester) async {
      final html = '<span style="font-size: x-small">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(@6.3:Foo)]'));
    });

    testWidgets('renders xx-small', (WidgetTester tester) async {
      final html = '<span style="font-size: xx-small">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(@5.6:Foo)]'));
    });

    testWidgets('renders larger', (WidgetTester tester) async {
      final html = '<span style="font-size: larger">F'
          '<span style="font-size: larger">o</span>o</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:(@12.0:F)(@14.4:o)(@12.0:o))]'));
    });

    testWidgets('renders smaller', (WidgetTester tester) async {
      final html = '<span style="font-size: smaller">F'
          '<span style="font-size: smaller">o</span>o</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:(@8.3:F)(@6.9:o)(@8.3:o))]'));
    });

    group('renders value', () {
      testWidgets('control group', (WidgetTester tester) async {
        final html = '<span>Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(:Foo)]'));
      });

      testWidgets('renders em', (WidgetTester tester) async {
        final html = '<span style="font-size: 2em">F'
            '<span style="font-size: 2em">o</span>o</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(:(@20.0:F)(@40.0:o)(@20.0:o))]'));
      });

      testWidgets('renders percentage', (WidgetTester tester) async {
        final html = '<span style="font-size: 200%">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(@20.0:Foo)]'));
      });

      testWidgets('renders pt', (WidgetTester tester) async {
        final html = '<span style="font-size: 100pt">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(@133.3:Foo)]'));
      });

      testWidgets('renders px', (WidgetTester tester) async {
        final html = '<span style="font-size: 100px">Foo</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(@100.0:Foo)]'));
      });
    });

    group('textScaleFactor=2', () {
      final explain2x = (WidgetTester tester, String html) async {
        tester.binding.window.textScaleFactorTestValue = 2;
        final explained = await explain(tester, html);
        tester.binding.window.textScaleFactorTestValue = null;
        return explained;
      };

      testWidgets('control group', (WidgetTester tester) async {
        final html = '<span>Foo</span>';
        final explained = await explain2x(tester, html);
        expect(explained, equals('[RichText:(@20.0:Foo)]'));
      });

      testWidgets('renders em', (WidgetTester tester) async {
        final html = '<span style="font-size: 2em">F'
            '<span style="font-size: 2em">o</span>o</span>';
        final e = await explain2x(tester, html);
        expect(e, equals('[RichText:(@20.0:(@40.0:F)(@80.0:o)(@40.0:o))]'));
      });

      testWidgets('renders percentage', (WidgetTester tester) async {
        final html = '<span style="font-size: 200%">Foo</span>';
        final explained = await explain2x(tester, html);
        expect(explained, equals('[RichText:(@40.0:Foo)]'));
      });

      testWidgets('renders pt', (WidgetTester tester) async {
        final html = '<span style="font-size: 100pt">Foo</span>';
        final explained = await explain2x(tester, html);
        expect(explained, equals('[RichText:(@266.7:Foo)]'));
      });

      testWidgets('renders px', (WidgetTester tester) async {
        final html = '<span style="font-size: 100px">Foo</span>';
        final explained = await explain2x(tester, html);
        expect(explained, equals('[RichText:(@200.0:Foo)]'));
      });
    });

    testWidgets('renders multiple em', (WidgetTester tester) async {
      final html = '<span style="font-size: 2em; font-size: 2em">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(@20.0:Foo)]'));
    });

    testWidgets('renders multiple percentage', (WidgetTester tester) async {
      final html = '<span style="font-size: 200%; font-size: 200%">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(@20.0:Foo)]'));
    });

    testWidgets('renders invalid', (WidgetTester tester) async {
      final html = '<span style="font-size: xxx">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });
  });

  group('font-style', () {
    testWidgets('renders CITE tag', (WidgetTester tester) async {
      final html = 'This is a <cite>citation</cite>.';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:This is a (+i:citation)(:.))]'));
    });

    testWidgets('renders DFN tag', (WidgetTester tester) async {
      final html = 'This is a <dfn>definition</dfn>.';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:This is a (+i:definition)(:.))]'));
    });

    testWidgets('renders I tag', (WidgetTester tester) async {
      final html = 'This is an <i>italic</i> text.';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[RichText:(:This is an (+i:italic)(: text.))]'),
      );
    });

    testWidgets('renders EM tag', (WidgetTester tester) async {
      final html = 'This is an <em>emphasized</em> text.';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[RichText:(:This is an (+i:emphasized)(: text.))]'),
      );
    });

    testWidgets('renders VAR tag', (WidgetTester tester) async {
      final html = '<var>x</var> = 1';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:(+i:x)(: = 1))]'));
    });

    testWidgets('renders inline style: italic', (WidgetTester tester) async {
      final html = '<span style="font-style: italic">Italic text</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+i:Italic text)]'));
    });

    testWidgets('renders inline style: normal', (WidgetTester tester) async {
      final html = '<span style="font-style: italic">Italic '
          '<span style="font-style: normal">normal</span></span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:(+i:Italic )(-i:normal))]'));
    });
  });

  group('font-weight', () {
    testWidgets('renders B tag', (WidgetTester tester) async {
      final html = 'This is a <b>bold</b> text.';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:This is a (+b:bold)(: text.))]'));
    });

    testWidgets('renders STRONG tag', (WidgetTester tester) async {
      final html = 'This is a <strong>strong</strong> text.';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:This is a (+b:strong)(: text.))]'));
    });

    testWidgets('renders font-weight inline style',
        (WidgetTester tester) async {
      final html = '''
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
              '[RichText:(:(+b:bold)(: )(+w0:one)(: )(+w1:two)(: )(+w2:three)(: )(:four)(: )'
              '(+w4:five)(: )(+w5:six)(: )(+b:seven)(: )(+w7:eight)(: )(+w8:nine))]'));
    });
  });

  group('line-height', () {
    testWidgets('renders number', (WidgetTester tester) async {
      final html = '<span style="line-height: 1">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+height=1.0:Foo)]'));
    });

    testWidgets('renders decimal', (WidgetTester tester) async {
      final html = '<span style="line-height: 1.1">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+height=1.1:Foo)]'));
    });

    testWidgets('renders em', (WidgetTester tester) async {
      final html = '<span style="line-height: 5em">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+height=5.0:Foo)]'));
    });

    testWidgets('renders percentage', (WidgetTester tester) async {
      final html = '<span style="line-height: 50%">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+height=0.5:Foo)]'));
    });

    testWidgets('renders pt', (WidgetTester tester) async {
      final html = '<span style="line-height: 50pt">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+height=6.7:Foo)]'));
    });

    testWidgets('renders px', (WidgetTester tester) async {
      final html = '<span style="line-height: 50px">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+height=5.0:Foo)]'));
    });

    testWidgets('renders invalid', (WidgetTester tester) async {
      final html = '<span style="line-height: xxx">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('renders child element (same)', (WidgetTester tester) async {
      final html = '<span style="line-height: 1">Foo <em>bar</em></span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:(+height=1.0:Foo )(+height=1.0+i:bar))]'));
    });

    testWidgets('renders child element (override)', (tester) async {
      final html = '<span style="line-height: 1">Foo '
          '<em style="line-height: 2">bar</em></span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:(+height=1.0:Foo )(+height=2.0+i:bar))]'));
    });

    testWidgets('renders child element (normal)', (WidgetTester tester) async {
      final html = '<span style="line-height: 1">Foo '
          '<em style="line-height: normal">bar</em></span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:(+height=1.0:Foo )(+i:bar))]'));
    });
  });

  group('text-decoration', () {
    testWidgets('renders DEL tag', (WidgetTester tester) async {
      final html = 'This is some <del>deleted</del> text.';
      final explained = await explain(tester, html);
      expect(explained,
          equals('[RichText:(:This is some (+l:deleted)(: text.))]'));
    });

    testWidgets('renders INS tag', (WidgetTester tester) async {
      final html = 'This is some <ins>inserted</ins> text.';
      final explained = await explain(tester, html);
      expect(explained,
          equals('[RichText:(:This is some (+u:inserted)(: text.))]'));
    });

    testWidgets('renders S/STRIKE tag', (WidgetTester tester) async {
      final html = '<s>Foo</s> <strike>bar</strike>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:(+l:Foo)(: )(+l:bar))]'));
    });

    testWidgets('renders U tag', (WidgetTester tester) async {
      final html = 'This is an <u>underline</u> text.';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[RichText:(:This is an (+u:underline)(: text.))]'),
      );
    });

    testWidgets('renders line-through', (WidgetTester tester) async {
      final html = '<span style="text-decoration: line-through">line</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+l:line)]'));
    });

    testWidgets('renders overline', (WidgetTester tester) async {
      final html = '<span style="text-decoration: overline">over</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+o:over)]'));
    });

    testWidgets('renders underline', (WidgetTester tester) async {
      final html = '<span style="text-decoration: underline">under</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+u:under)]'));
    });

    testWidgets('renders all', (WidgetTester tester) async {
      final html = '''
<span style="text-decoration: line-through">
<span style="text-decoration: overline">
<span style="text-decoration: underline">
foo bar</span></span></span>
''';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+l+o+u:foo bar)]'));
    });

    testWidgets('skips rendering', (WidgetTester tester) async {
      final html = '''
<span style="text-decoration: line-through">
<span style="text-decoration: overline">
<span style="text-decoration: underline">
foo <span style="text-decoration: none">bar</span></span></span></span>
''';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:(+l+o+u:foo )(:bar))]'));
    });
  });

  group('text-overflow', () {
    testWidgets('renders clip', (WidgetTester tester) async {
      final html = '<div style="text-overflow: clip">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('renders ellipsis', (WidgetTester tester) async {
      final html = '<div style="text-overflow: ellipsis">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained,
          equals('[CssBlock:child=[RichText:overflow=ellipsis,(:Foo)]]'));
    });

    group('max-lines', () {
      testWidgets('renders number', (WidgetTester tester) async {
        final html = '<div style="max-lines: 2">Foo</div>';
        final e = await explain(tester, html);
        expect(e, equals('[CssBlock:child=[RichText:maxLines=2,(:Foo)]]'));
      });

      testWidgets('renders another number (override)', (tester) async {
        final html = '<div style="max-lines: 2; max-lines: 3">Foo</div>';
        final e = await explain(tester, html);
        expect(e, equals('[CssBlock:child=[RichText:maxLines=3,(:Foo)]]'));
      });

      testWidgets('renders none (override)', (tester) async {
        final html = '<div style="max-lines: 2; max-lines: none">Foo</div>';
        final explained = await explain(tester, html);
        expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
      });

      testWidgets('renders -webkit-line-clamp', (WidgetTester tester) async {
        final html = '<div style="-webkit-line-clamp: 2">Foo</div>';
        final e = await explain(tester, html);
        expect(e, equals('[CssBlock:child=[RichText:maxLines=2,(:Foo)]]'));
      });

      testWidgets('renders with ellipsis', (WidgetTester tester) async {
        final html =
            '<div style="max-lines: 2; text-overflow: ellipsis">Foo</div>';
        final explained = await explain(tester, html);
        expect(
            explained,
            equals(
                '[CssBlock:child=[RichText:maxLines=2,overflow=ellipsis,(:Foo)]]'));
      });
    });
  });
}
