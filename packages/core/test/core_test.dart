import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
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
            '[RichText:(:(+l+o+u:All decorations... )(:and none))],'
            '[RichText:(:I​Like​Playing​football​​game)],'
            '[RichText:(:\u00A0)]'
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
        equals('[Column:children=[RichText:(:This is an)],'
            '[RichText:(+i:ADDRESS)]]'));
  });

  group('BR', () {
    testWidgets('renders new line', (WidgetTester tester) async {
      final html = '1<br />2';
      final e = await explain(tester, html);
      expect(e, equals('[Column:children=[RichText:(:1)],[RichText:(:2)]]'));
    });

    testWidgets('renders without whitespace on new line', (tester) async {
      final html = '1<br />\n2';
      final e = await explain(tester, html);
      expect(e, equals('[Column:children=[RichText:(:1)],[RichText:(:2)]]'));
    });

    testWidgets('renders without whitespace on next SPAN', (tester) async {
      final html = '1<br />\n<span>\n2</span>';
      final e = await explain(tester, html);
      expect(e, equals('[Column:children=[RichText:(:1)],[RichText:(:2)]]'));
    });

    testWidgets('renders multiple new lines, 1 of 2', (tester) async {
      final html = '1<br /><br />2';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Column:children=[RichText:(:1)],'
              '[SizedBox:0.0x10.0],'
              '[RichText:(:2)]]'));
    });

    testWidgets('renders multiple new lines, 2 of 2', (tester) async {
      final html = '1<br /><br /><br />2';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Column:children=[RichText:(:1)],'
              '[SizedBox:0.0x20.0],'
              '[RichText:(:2)]]'));
    });

    testWidgets('renders new line between SPANs, 1 of 2', (tester) async {
      final html = '<span>1<br /></span><span>2</span>';
      final e = await explain(tester, html);
      expect(e, equals('[Column:children=[RichText:(:1)],[RichText:(:2)]]'));
    });

    testWidgets('renders new line between SPANs, 2 of 2', (tester) async {
      final html = '<span>1</span><br /><span>2</span>';
      final e = await explain(tester, html);
      expect(e, equals('[Column:children=[RichText:(:1)],[RichText:(:2)]]'));
    });

    testWidgets('skips new line between SPAN and DIV, 1 of 2', (tester) async {
      final html = '<span>1<br /></span><div>2</div>';
      final e = await explain(tester, html);
      expect(e, equals('[Column:children=[RichText:(:1)],[RichText:(:2)]]'));
    });

    testWidgets('skips new line between SPAN and DIV, 2 of 2', (tester) async {
      final html = '<span>1</span><br /><div>2</div>';
      final e = await explain(tester, html);
      expect(e, equals('[Column:children=[RichText:(:1)],[RichText:(:2)]]'));
    });

    testWidgets('renders new line between DIVs, 1 of 2', (tester) async {
      final html = '<div>1<br /></div><div>2</div>';
      final e = await explain(tester, html);
      expect(e, equals('[Column:children=[RichText:(:1)],[RichText:(:2)]]'));
    });

    testWidgets('renders new line between DIVs, 2 of 2', (tester) async {
      final html = '<div>1</div><br /><div>2</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Column:children=[RichText:(:1)],'
              '[SizedBox:0.0x10.0],'
              '[RichText:(:2)]]'));
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
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:Foo)]'));
    });
  });

  testWidgets('renders DD/DL/DT tags', (WidgetTester tester) async {
    final html = '<dl><dt>Foo</dt><dd>Bar</dd></dt>';
    final explained = await explainMargin(tester, html);
    expect(
        explained,
        equals('[RichText:(+b:Foo)],'
            '[Padding:(0,0,0,40),child=[RichText:(:Bar)]],'
            '[SizedBox:0.0x10.0]'));
  });

  testWidgets('renders HR tag', (WidgetTester tester) async {
    final html = '<hr/>';
    final explained = await explainMargin(tester, html);
    expect(
        explained,
        equals('[DecoratedBox:bg=#FF000000,child=[SizedBox:0.0x1.0]],'
            '[SizedBox:0.0x10.0]'));
  });

  group('Q tag', () {
    testWidgets('renders quotes', (WidgetTester tester) async {
      final html = 'Someone said <q>Foo</q>.';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Someone said “Foo”.)]'));
    });

    testWidgets('renders quotes without contents', (WidgetTester tester) async {
      final html = 'x<q></q>y';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:x“”y)]'));
    });

    testWidgets('renders quotes alone', (WidgetTester tester) async {
      final html = '<q></q>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:“”)]'));
    });

    testWidgets('renders quotes around IMG', (WidgetTester tester) async {
      final src = 'http://domain.com/image.png';
      final html = '<q><img src="$src" /></q>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[RichText:(:“'
              '[ImageLayout(NetworkImage("$src", scale: 1.0))]'
              '(:”))]'));
    });

    testWidgets('renders styling', (WidgetTester tester) async {
      final html = 'Someone said <q><em>Foo</em></q>.';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Someone said (+i:“Foo”)(:.))]'));
    });

    testWidgets('renders complicated styling', (WidgetTester tester) async {
      final html = 'Someone said <q><u><em>F</em>o<b>o</b></u></q>.';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[RichText:(:Someone said (+u+i:“F)(+u:o)(+u+b:o”)(:.))]'),
      );
    });

    testWidgets('renders within vertical-align middle', (tester) async {
      final html = '<span style="vertical-align: middle"><q>Foo</q></span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:[RichText:(:“Foo”)]@middle]'));
    });
  });

  group('RUBY', () {
    testWidgets('renders with RT', (WidgetTester tester) async {
      final html = '<ruby>明日 <rp>(</rp><rt>Ashita</rt><rp>)</rp></ruby>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[RichText:[Stack:children='
              '[Padding:(3,0,3,0),child=[RichText:(:明日)]],'
              '[Positioned:(0.0,0.0,null,0.0),child=[Center:child=[RichText:(@5.0:Ashita)]]]'
              ']@middle]'));
    });

    testWidgets('renders without RT', (WidgetTester tester) async {
      final html = '<ruby>明日</ruby>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:明日)]'));
    });

    testWidgets('renders with empty RT', (WidgetTester tester) async {
      final html = '<ruby>明日 <rt></rt></ruby>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:明日)]'));
    });

    testWidgets('renders without contents', (WidgetTester tester) async {
      final html = 'Foo <ruby></ruby>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });
  });

  group('block elements', () {
    final blockOutput =
        '[Column:children=[RichText:(:First.)],[RichText:(:Second one.)]]';

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
            '[Padding:(0,40,0,40),child=[RichText:(:Foo)]],'
            '[SizedBox:0.0x10.0]'),
      );
    });

    testWidgets('renders DIV tag', (WidgetTester tester) async {
      final html = '<div>First.</div><div>Second one.</div>';
      final explained = await explain(tester, html);
      expect(explained, equals(blockOutput));
    });

    testWidgets('renders FIGURE/FIGCAPTION tags', (WidgetTester tester) async {
      final src = 'http://domain.com/image.png';
      final html = '''
<figure>
  <img src="$src">
  <figcaption><i>fig. 1</i> Foo</figcaption>
</figure>
''';
      final explained = await explainMargin(tester, html);
      expect(
          explained,
          equals('[SizedBox:0.0x10.0],'
              '[Padding:(0,40,0,40),child=[ImageLayout(NetworkImage("$src", scale: 1.0))]],'
              '[Padding:(0,40,0,40),child=[RichText:(:(+i:fig. 1)(: Foo))]],'
              '[SizedBox:0.0x10.0]'));
    });

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
            '[RichText:(:First.)],'
            '[SizedBox:0.0x10.0],'
            '[RichText:(:Second one.)],'
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
      final html = '<iframe src="iframe.html">Something</iframe>Bye iframe.';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Bye iframe.)]'));
    });

    testWidgets('skips SCRIPT tag', (WidgetTester tester) async {
      final html = '<script>foo = bar</script>Bye script.';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Bye script.)]'));
    });

    testWidgets('skips STYLE tag', (WidgetTester tester) async {
      final html = '<style>body { background: #fff; }</style>Bye style.';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Bye style.)]'));
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
          equals('[SingleChildScrollView:child='
              '[RichText:(+font=Courier+fonts=monospace:(#FF0000BB:<?php phpinfo)'
              '(#FF007700:(); )(#FF0000BB:?>))]]'));
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
          equals('[SingleChildScrollView:child=[RichText:'
              '(+font=Courier+fonts=monospace:<?php\nhighlight_string(\''
              '<?php phpinfo(); ?>\');\n?>)]]'));
    });

    testWidgets('renders SAMP tag', (WidgetTester tester) async {
      final html = '<samp>Error</samp>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(+font=Courier+fonts=monospace:Error)]'));
    });

    testWidgets('renders TT tag', (WidgetTester tester) async {
      final html = '<tt>Teletype</tt>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[SingleChildScrollView:child='
              '[RichText:(+font=Courier+fonts=monospace:Teletype)]]'));
    });
  });

  group('headings', () {
    testWidgets('render H1 tag', (WidgetTester tester) async {
      final html = '<h1>X</h1>';
      final explained = await explainMargin(tester, html);
      expect(
          explained,
          equals('[SizedBox:0.0x13.4],'
              '[RichText:(@20.0+b:X)],'
              '[SizedBox:0.0x13.4]'));
    });

    testWidgets('render H2 tag', (WidgetTester tester) async {
      final html = '<h2>X</h2>';
      final explained = await explainMargin(tester, html);
      expect(
          explained,
          equals('[SizedBox:0.0x12.4],'
              '[RichText:(@15.0+b:X)],'
              '[SizedBox:0.0x12.4]'));
    });

    testWidgets('render H3 tag', (WidgetTester tester) async {
      final html = '<h3>X</h3>';
      final explained = await explainMargin(tester, html);
      expect(
          explained,
          equals('[SizedBox:0.0x11.7],'
              '[RichText:(@11.7+b:X)],'
              '[SizedBox:0.0x11.7]'));
    });

    testWidgets('render H4 tag', (WidgetTester tester) async {
      final html = '<h4>X</h4>';
      final explained = await explainMargin(tester, html);
      expect(
          explained,
          equals('[SizedBox:0.0x13.3],'
              '[RichText:(+b:X)],'
              '[SizedBox:0.0x13.3]'));
    });

    testWidgets('render H5 tag', (WidgetTester tester) async {
      final html = '<h5>X</h5>';
      final explained = await explainMargin(tester, html);
      expect(
          explained,
          equals('[SizedBox:0.0x13.9],'
              '[RichText:(@8.3+b:X)],'
              '[SizedBox:0.0x13.9]'));
    });

    testWidgets('render H6 tag', (WidgetTester tester) async {
      final html = '<h6>X</h6>';
      final explained = await explainMargin(tester, html);
      expect(
          explained,
          equals('[SizedBox:0.0x15.6],'
              '[RichText:(@6.7+b:X)],'
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
      expect(explained,
          equals('[DecoratedBox:bg=#FFFF0000,child=[RichText:(:Foo)]]'));
    });

    testWidgets('renders with margins and paddings', (tester) async {
      final html = '<div style="background-color: #f00; '
          'margin: 1px; padding: 2px">Foo</div>';
      final explained = await explainMargin(tester, html);
      expect(
          explained,
          equals('[SizedBox:0.0x1.0],'
              '[Padding:(0,1,0,1),child='
              '[DecoratedBox:bg=#FFFF0000,child=[Padding:(2,2,2,2),child=[RichText:(:Foo)]]]'
              '],[SizedBox:0.0x1.0]'));
    });

    testWidgets('renders blocks', (WidgetTester tester) async {
      final h = '<div style="background-color: #f00"><p>A</p><p>B</p></div>';
      final explained = await explain(tester, h);
      expect(
          explained,
          equals('[DecoratedBox:bg=#FFFF0000,child=[Column:children='
              '[RichText:(:A)],'
              '[SizedBox:0.0x10.0],'
              '[RichText:(:B)]]]'));
    });

    testWidgets('renders inline', (WidgetTester tester) async {
      final html = 'Foo <span style="background-color: #f00">bar</span>';
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

  group('border', () {
    testWidgets('renders border-top', (WidgetTester tester) async {
      final html = '<span style="border-top: 1px">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+o:Foo)]'));
    });

    testWidgets('resets border-top', (WidgetTester tester) async {
      final html = '<span style="text-decoration: overline">F'
          '<span style="border-top: 0">o</span>o</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:(+o:F)(:o)(+o:o))]'));
    });

    testWidgets('renders border-bottom', (WidgetTester tester) async {
      final html = '<span style="border-bottom: 1px">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+u:Foo)]'));
    });

    testWidgets('resets border-bottom', (WidgetTester tester) async {
      final html = '<u>F<span style="border-bottom: 0">o</span>o</u>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:(+u:F)(:o)(+u:o))]'));
    });

    testWidgets('renders dashed', (WidgetTester tester) async {
      final html = '<span style="border-top: 1px dashed">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+o/dashed:Foo)]'));
    });

    testWidgets('renders dotted', (WidgetTester tester) async {
      final html = '<span style="border-top: 1px dotted">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+o/dotted:Foo)]'));
    });

    testWidgets('renders double', (WidgetTester tester) async {
      final html = '<span style="border-bottom: 1px double">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+u/double:Foo)]'));
    });

    testWidgets('renders solid', (WidgetTester tester) async {
      final html = '<span style="border-bottom: 1px solid">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+u:Foo)]'));
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
      expect(explained, equals('[RichText:(:1 2)]'));
    });

    testWidgets('renders display: block', (WidgetTester tester) async {
      final html = '<div>1 <span style="display: block">2</span></div>';
      final e = await explain(tester, html);
      expect(e, equals('[Column:children=[RichText:(:1)],[RichText:(:2)]]'));
    });

    testWidgets('renders DIV block by default', (WidgetTester tester) async {
      final html = '<div>1 <div>2</div></div>';
      final e = await explain(tester, html);
      expect(e, equals('[Column:children=[RichText:(:1)],[RichText:(:2)]]'));
    });

    testWidgets('renders display: inline', (WidgetTester tester) async {
      final html = '<div>1 <div style="display: inline">2</div></div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:1 2)]'));
    });

    testWidgets('renders display: inline-block', (WidgetTester tester) async {
      final html = '<div>1 <div style="display: inline-block">2</div></div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:1 2)]'));
    });

    testWidgets('renders display: none', (WidgetTester tester) async {
      final html = '<div>1 <div style="display: none">2</div></div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:1)]'));
    });

    group('IMG', () {
      final src = 'http://domain.com/image.png';

      testWidgets('renders IMG inline by default', (WidgetTester tester) async {
        final html = 'Foo <img src="$src" />';
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[RichText:(:Foo '
                '[ImageLayout(NetworkImage("$src", scale: 1.0))]'
                ')]'));
      });

      testWidgets('renders IMG as block', (WidgetTester tester) async {
        final html = 'Foo <img src="$src" style="display: block" />';
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[Column:children='
                '[RichText:(:Foo)],'
                '[ImageLayout(NetworkImage("$src", scale: 1.0))]'
                ']'));
      });

      testWidgets('renders IMG with dimensions inline', (tester) async {
        final html = '<img src="$src" width="1" height="1" />';
        final explained = await explain(
          tester,
          html,
          preTest: (context) => precacheImage(
            NetworkImage(src),
            context,
            onError: (_, __) {},
          ),
        );
        expect(
            explained,
            equals('[ImageLayout('
                'NetworkImage("$src", scale: 1.0), '
                'height: 1.0, '
                'width: 1.0'
                ')]'));
      });

      testWidgets('renders IMG with dimensions as block', (tester) async {
        final html = '<img src="$src" width="1" '
            'height="1" style="display: block" />';
        final explained = await explain(
          tester,
          html,
          preTest: (context) => precacheImage(
            NetworkImage(src),
            context,
            onError: (_, __) {},
          ),
        );
        expect(
            explained,
            equals('[ImageLayout('
                'NetworkImage("$src", scale: 1.0), '
                'height: 1.0, '
                'width: 1.0'
                ')]'));
      });
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
        expect(e, equals('[RichText:(:Foo)]'));
      });

      testWidgets('renders ltr', (WidgetTester tester) async {
        final html = '<div dir="ltr">Foo</div>';
        final e = await explain(tester, html);
        expect(e, equals('[Directionality:ltr,child=[RichText:(:Foo)]]'));
      });

      testWidgets('renders rtl', (WidgetTester tester) async {
        final html = '<div dir="rtl">Foo</div>';
        final e = await explain(tester, html);
        expect(e, equals('[Directionality:rtl,child=[RichText:(:Foo)]]'));
      });
    });

    group('inline style', () {
      testWidgets('renders ltr', (WidgetTester tester) async {
        final html = '<div style="direction: ltr">Foo</div>';
        final e = await explain(tester, html);
        expect(e, equals('[Directionality:ltr,child=[RichText:(:Foo)]]'));
      });

      testWidgets('renders rtl', (WidgetTester tester) async {
        final html = '<div style="direction: rtl">Foo</div>';
        final e = await explain(tester, html);
        expect(e, equals('[Directionality:rtl,child=[RichText:(:Foo)]]'));
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
    testWidgets('renders length value', (WidgetTester tester) async {
      final html = '<span style="font-size: 100px">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(@100.0:Foo)]'));
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

    testWidgets('renders 2em', (WidgetTester tester) async {
      final html = '<span style="font-size: 2em">F'
          '<span style="font-size: 2em">o</span>o</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:(@20.0:F)(@40.0:o)(@20.0:o))]'));
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
              '[RichText:(:(+b:bold)(: )(+w0:one)(: )(+w1:two)(: )(+w2:three)(: four )'
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

    testWidgets('renders percentage', (WidgetTester tester) async {
      final html = '<span style="line-height: 50%">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+height=0.5:Foo)]'));
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
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('renders ellipsis', (WidgetTester tester) async {
      final html = '<div style="text-overflow: ellipsis">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText,overflow=ellipsis:(:Foo)]'));
    });
  });
}
