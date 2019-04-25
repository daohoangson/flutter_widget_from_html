import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  testWidgets('renders empty string', (WidgetTester tester) async {
    final html = '';
    final explained = await explain(tester, html);
    expect(explained, equals('[Text:]'));
  });

  testWidgets('renders bare string', (WidgetTester tester) async {
    final html = 'Hello world';
    final explained = await explain(tester, html);
    expect(explained, equals('[Text:Hello world]'));
  });

  testWidgets('renders without erroneous white spaces', (WidgetTester t) async {
    final html = """
<div>
  <span style="text-decoration: line-through">
    <span style="text-decoration: overline">
      <span style="text-decoration: underline">
        All decorations...
        <span style="text-decoration: none">and none</span>
      </span>
    </span>
  </span>
</div>
""";
    final str = await explain(t, html);
    expect(str, equals('[RichText:(+l+o+u:All decorations... (:and none))]'));
  });

  group('A tag', () {
    testWidgets('renders stylings', (WidgetTester tester) async {
      final html = 'This is a <a href="href">hyperlink</a>.';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:This is a (+u:hyperlink)(:.))]'));
    });

    testWidgets('renders inner stylings', (WidgetTester tester) async {
      final html = 'This is a <a href="href"><b><i>hyperlink</i></b></a>.';
      final explained = await explain(tester, html);
      expect(
          explained, equals('[RichText:(:This is a (+u+i+b:hyperlink)(:.))]'));
    });
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
      equals('[Column:children=[Text:This is an],[RichText:(+i:ADDRESS)]]'),
    );
  });

  testWidgets('renders DD/DL/DT tags', (WidgetTester tester) async {
    final html = '<dl><dt>Foo</dt><dd>Bar</dd></dt>';
    final explained = await explainMargin(tester, html);
    expect(
      explained,
      equals('[RichText:(+b:Foo)],[Padding:(0,0,10,40),child=[Text:Bar]]'),
    );
  });

  group('IMG tag', () {
    testWidgets('renders src', (WidgetTester tester) async {
      final html = '<img src="image.png" />';
      final explained = await explain(tester, html);
      expect(explained, equals('[Image:image=[NetworkImage:url=image.png]]'));
    });

    testWidgets('renders data-src', (WidgetTester tester) async {
      final html = '<img data-src="image.png" />';
      final explained = await explain(tester, html);
      expect(explained, equals('[Image:image=[NetworkImage:url=image.png]]'));
    });

    testWidgets('renders data uri', (WidgetTester tester) async {
      // https://stackoverflow.com/questions/6018611/smallest-data-uri-image-possible-for-a-transparent-image
      final html = '<img src="data:image/gif;base64,' +
          'R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" />';
      final explained = await explain(tester, html);
      expect(explained, equals('[Image:image=[MemoryImage:]]'));
    });

    testWidgets('renders alt', (WidgetTester tester) async {
      final html = '<img alt="Foo" />';
      final explained = await explain(tester, html);
      expect(explained, equals('[Text:Foo]'));
    });

    testWidgets('renders title', (WidgetTester tester) async {
      final html = '<img title="Foo" />';
      final explained = await explain(tester, html);
      expect(explained, equals('[Text:Foo]'));
    });

    testWidgets('renders dimensions', (WidgetTester tester) async {
      final html = '<img src="image.png" width="800" height="600" />';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[AspectRatio:aspectRatio=1.33,' +
              'child=[Image:image=[NetworkImage:url=image.png]]]'));
    });

    testWidgets('renders between texts', (WidgetTester tester) async {
      final html = 'Before text. <img src="image.png" /> After text.';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Column:children=[Text:Before text.],' +
              '[Image:image=[NetworkImage:url=image.png]],' +
              '[Text:After text.]]'));
    });
  });

  testWidgets('renders KBD tag', (WidgetTester tester) async {
    final html = '<kbd>ESC</kbd> = exit';
    final actual = await explain(tester, html);
    expect(actual, equals('[RichText:(+font=monospace:ESC(: = exit))]'));
  });

  group('lists', () {
    testWidgets('renders ordered list', (WidgetTester tester) async {
      final html = '<ol><li>One</li><li>Two</li><li><b>Three</b></li><ol>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Column:children=[Text:One],' +
              '[Text:Two],[RichText:(+b:Three)]]'));
    });

    testWidgets('renders unordered list', (WidgetTester tester) async {
      final html = '<ul><li>One</li><li>Two</li><li><em>Three</em></li><ul>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Column:children=[Text:One],' +
              '[Text:Two],[RichText:(+i:Three)]]'));
    });

    testWidgets('renders nested list', (WidgetTester tester) async {
      final html = '<ol><li>One</li><li>Two</li><li>Three ' +
          '<ul><li>3.1</li><li>3.2</li></ul></li><li>Four</li><ol>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Column:children=[Text:One],' +
              '[Text:Two],' +
              '[Text:Three],[Text:3.1],[Text:3.2],' +
              '[Text:Four]]'));
    });
  });

  group('block elements', () {
    final blockOutput = '[Column:children=[Text:First.],[Text:Second one.]]';

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
      final html = 'x<blockquote>Foo</blockquote>x';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Column:children=[Text:x],' +
              '[Padding:(10,40,10,40),child=[Text:Foo]]' +
              ',[Text:x]]'));
    });

    testWidgets('renders BR tag', (WidgetTester tester) async {
      final html = 'First.<br />Second one.';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Column:children=[Text:First.],' +
              '[Padding:(0,0,10,0),child=[Container:]],' +
              '[Text:Second one.]]'));
    });

    testWidgets('renders DIV tag', (WidgetTester tester) async {
      final html = '<div>First.</div><div>Second one.</div>';
      final explained = await explain(tester, html);
      expect(explained, equals(blockOutput));
    });

    testWidgets('renders FIGURE/FIGCAPTION tags', (WidgetTester tester) async {
      final html = """
<figure>
  <img src="image.png">
  <figcaption><i>fig. 1</i> Foo</figcaption>
</figure>
""";
      final explained = await explainMargin(tester, html);
      expect(
        explained,
        equals('[Padding:(10,40,10,40),child=[Column:children=' +
            '[Image:image=[NetworkImage:url=image.png]],' +
            '[RichText:(+i:fig. 1(: Foo))]]]'),
      );
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
        equals('[Padding:(10,0,10,0),child=[Text:First.]],' +
            '[Padding:(0,0,10,0),child=[Text:Second one.]]'),
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
      expect(explained, equals('[Text:Bye iframe.]'));
    });

    testWidgets('skips SCRIPT tag', (WidgetTester tester) async {
      final html = '<script>foo = bar</script>Bye script.';
      final explained = await explain(tester, html);
      expect(explained, equals('[Text:Bye script.]'));
    });

    testWidgets('skips STYLE tag', (WidgetTester tester) async {
      final html = '<style>body { background: #fff; }</style>Bye style.';
      final explained = await explain(tester, html);
      expect(explained, equals('[Text:Bye style.]'));
    });
  });

  group('code', () {
    testWidgets('renders CODE tag', (WidgetTester tester) async {
      final html =
          """<code><span style="color: #000000"><span style="color: #0000BB">&lt;?php phpinfo</span><span style="color: #007700">(); </span><span style="color: #0000BB">?&gt;</span></span></code>""";
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[SingleChildScrollView:child=' +
              '[RichText:(#FF0000BB+font=monospace:<?php phpinfo' +
              '(#FF007700:(); )(#FF0000BB:?>))]]'));
    });

    testWidgets('renders PRE tag', (WidgetTester tester) async {
      final html = """<pre>&lt;?php
highlight_string('&lt;?php phpinfo(); ?&gt;');
?&gt;</pre>""";
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[SingleChildScrollView:child=[RichText:' +
              '(+font=monospace:<?php\nhighlight_string(\'' +
              '<?php phpinfo(); ?>\');\n?>)]]'));
    });
  });

  group('headings', () {
    testWidgets('render H1 tag', (WidgetTester tester) async {
      final html = '<h1>X</h1>';
      final e = await explainMargin(tester, html);
      expect(e, equals('[Padding:(13,0,13,0),child=[RichText:(@20.0+b:X)]]'));
    });

    testWidgets('render H2 tag', (WidgetTester tester) async {
      final html = '<h2>X</h2>';
      final e = await explainMargin(tester, html);
      expect(e, equals('[Padding:(12,0,12,0),child=[RichText:(@15.0+b:X)]]'));
    });

    testWidgets('render H3 tag', (WidgetTester tester) async {
      final html = '<h3>X</h3>';
      final e = await explainMargin(tester, html);
      expect(e, equals('[Padding:(11,0,11,0),child=[RichText:(@11.7+b:X)]]'));
    });

    testWidgets('render H4 tag', (WidgetTester tester) async {
      final html = '<h4>X</h4>';
      final e = await explainMargin(tester, html);
      expect(e, equals('[Padding:(13,0,13,0),child=[RichText:(+b:X)]]'));
    });

    testWidgets('render H5 tag', (WidgetTester tester) async {
      final html = '<h5>X</h5>';
      final e = await explainMargin(tester, html);
      expect(e, equals('[Padding:(13,0,13,0),child=[RichText:(@8.3+b:X)]]'));
    });

    testWidgets('render H6 tag', (WidgetTester tester) async {
      final html = '<h6>X</h6>';
      final e = await explainMargin(tester, html);
      expect(e, equals('[Padding:(15,0,15,0),child=[RichText:(@6.7+b:X)]]'));
    });
  });

  group('background-color', () {
    testWidgets('renders MARK tag', (WidgetTester tester) async {
      final html = '<mark>Foo</mark>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(bg=#FFFFFF00#FF000000:Foo)]'));
    });

    testWidgets('renders block', (WidgetTester tester) async {
      final html = '<div style="background-color: #f00"><div>Foo</div></div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[DecoratedBox:bg=#FFFF0000,child=[Text:Foo]]'));
    });

    testWidgets('renders inline', (WidgetTester tester) async {
      final html = 'Foo <span style="background-color: #f00">bar</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo (bg=#FFFF0000:bar))]'));
    });
  });

  group('border', () {
    testWidgets('renders border-top', (WidgetTester tester) async {
      final html = '<span style="border-top: 1px">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+o:Foo)]'));
    });

    testWidgets('resets border-top', (WidgetTester tester) async {
      final html = '<span style="text-decoration: overline">F' +
          '<span style="border-top: 0">o</span>o</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+o:F(:o)(+o:o))]'));
    });

    testWidgets('renders border-bottom', (WidgetTester tester) async {
      final html = '<span style="border-bottom: 1px">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+u:Foo)]'));
    });

    testWidgets('resets border-bottom', (WidgetTester tester) async {
      final html = '<u>F<span style="border-bottom: 0">o</span>o</u>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+u:F(:o)(+u:o))]'));
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
      final html = '<span style="color: #F00">red</span>' +
          '<span style="color: #0F08">red 53%</span>' +
          '<span style="color: #00FF00">green</span>' +
          '<span style="color: #00FF0080">green 50%</span>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[RichText:(#FFFF0000:red(#8800FF00:red 53%)' +
              '(#FF00FF00:green)(#8000FF00:green 50%))]'));
    });

    testWidgets('renders overlaps', (WidgetTester tester) async {
      final html = '<span style="color: #FF0000">red ' +
          '<span style="color: #00FF00">green</span> red again</span>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[RichText:(#FFFF0000:red ' +
              '(#FF00FF00:green)(#FFFF0000: red again))]'));
    });
  });

  testWidgets('renders font-family inline style', (WidgetTester tester) async {
    final html = '<span style="font-family: Monospace">Foo</span>';
    final explained = await explain(tester, html);
    expect(explained, equals('[RichText:(+font=Monospace:Foo)]'));
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
      final html = '<span style="font-size: 100px">F' +
          '<span style="font-size: medium">o</span>o</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(@100.0:F(@10.0:o)(:o))]'));
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
      final html = '<span style="font-size: larger">F' +
          '<span style="font-size: larger">o</span>o</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(@12.0:F(@14.4:o)(:o))]'));
    });

    testWidgets('renders smaller', (WidgetTester tester) async {
      final html = '<span style="font-size: smaller">F' +
          '<span style="font-size: smaller">o</span>o</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(@8.3:F(@6.9:o)(:o))]'));
    });

    testWidgets('renders 2em', (WidgetTester tester) async {
      final html = '<span style="font-size: 2em">F' +
          '<span style="font-size: 2em">o</span>o</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(@20.0:F(@40.0:o)(:o))]'));
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
      final html = 'This is a <cite>definition</cite>.';
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

    testWidgets('renders inline style: italic', (WidgetTester tester) async {
      final html = '<span style="font-style: italic">Italic text</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+i:Italic text)]'));
    });

    testWidgets('renders inline style: normal', (WidgetTester tester) async {
      final html = '<span style="font-style: italic">Italic ' +
          '<span style="font-style: normal">normal</span></span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+i:Italic (-i:normal))]'));
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
      final html = """<span style="font-weight: bold">bold</span>
<span style="font-weight: 100">one</span>
<span style="font-weight: 200">two</span>
<span style="font-weight: 300">three</span>
<span style="font-weight: 400">four</span>
<span style="font-weight: 500">five</span>
<span style="font-weight: 600">six</span>
<span style="font-weight: 700">seven</span>
<span style="font-weight: 800">eight</span>
<span style="font-weight: 900">nine</span>""";
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[RichText:(+b:bold(: )(+w0:one)(: )(+w1:two)(: )(+w2:three)(: )(:four)(: )' +
              '(+w4:five)(: )(+w5:six)(: )(+b:seven)(: )(+w7:eight)(: )(+w8:nine))]'));
    });
  });

  group('text-align', () {
    testWidgets('renders center text', (WidgetTester tester) async {
      final html = '<div style="text-align: center">_X_</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[Text,align=center:_X_]'));
    });

    testWidgets('renders justify text', (WidgetTester tester) async {
      final html = '<div style="text-align: justify">X_X_X</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[Text,align=justify:X_X_X]'));
    });

    testWidgets('renders left text', (WidgetTester tester) async {
      final html = '<div style="text-align: left">X__</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[Text,align=left:X__]'));
    });

    testWidgets('renders right text', (WidgetTester tester) async {
      final html = '<div style="text-align: right">__<b>X</b></div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText,align=right:(:__(+b:X))]'));
    });

    testWidgets('renders center image', (WidgetTester tester) async {
      final html =
          '<div style="text-align: center"><img src="image.png"></div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Align:alignment=topCenter,' +
              'child=[Image:image=[NetworkImage:url=image.png]]]'));
    });

    testWidgets('renders left image', (WidgetTester tester) async {
      final html = '<div style="text-align: left"><img src="image.png"></div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Align:alignment=topLeft,' +
              'child=[Image:image=[NetworkImage:url=image.png]]]'));
    });

    testWidgets('renders right image', (WidgetTester tester) async {
      final html = '<div style="text-align: right"><img src="image.png"></div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Align:alignment=topRight,' +
              'child=[Image:image=[NetworkImage:url=image.png]]]'));
    });

    testWidgets('renders styling from outside', (WidgetTester tester) async {
      // https://github.com/daohoangson/flutter_widget_from_html/issues/10
      final html = '<em><span style="color: red;">' +
          '<div style="text-align: right;">right</div></span></em>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText,align=right:(+i:right)]'));
    });
  });

  group('text-decoration', () {
    testWidgets('renders DEL/INS tags', (WidgetTester tester) async {
      final html = 'This is some <del>deleted</del> <ins>inserted</ins> text.';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[RichText:(:This is some (+l:deleted)(: )' +
              '(+u:inserted)(: text.))]'));
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
      final html = '<span style="text-decoration: line-through">' +
          '<span style="text-decoration: overline">' +
          '<span style="text-decoration: underline">' +
          'foo bar</span></span></span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+l+o+u:foo bar)]'));
    });

    testWidgets('skips rendering', (WidgetTester tester) async {
      final html = '<span style="text-decoration: line-through">' +
          '<span style="text-decoration: overline">' +
          '<span style="text-decoration: underline">' +
          'foo <span style="text-decoration: none">bar</span></span></span></span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+l+o+u:foo (:bar))]'));
    });
  });
}
