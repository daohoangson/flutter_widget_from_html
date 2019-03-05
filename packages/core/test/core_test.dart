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

  group('IMG tag', () {
    testWidgets('renders src', (WidgetTester tester) async {
      final html = '<img src="image.png" />';
      final explained = await explain(tester, html);
      expect(explained, equals('[Text:imageUrl=image.png]'));
    });

    testWidgets('renders data-src', (WidgetTester tester) async {
      final html = '<img data-src="image.png" />';
      final explained = await explain(tester, html);
      expect(explained, equals('[Text:imageUrl=image.png]'));
    });

    testWidgets('renders data uri', (WidgetTester tester) async {
      // https://stackoverflow.com/questions/6018611/smallest-data-uri-image-possible-for-a-transparent-image
      final html = '<img src="data:image/gif;base64,' +
          'R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" />';
      final explained = await explain(tester, html);
      expect(explained, equals('[Image:image=MemoryImage]'));
    });

    testWidgets('renders dimensions', (WidgetTester tester) async {
      final html = '<img src="image.png" width="800" height="600" />';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[AspectRatio:aspectRatio=1.33,' +
              'child=[Text:imageUrl=image.png]]'));
    });

    testWidgets('renders between texts', (WidgetTester tester) async {
      final html = 'Before text. <img src="image.png" /> After text.';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Column:children=[Text:Before text.],' +
              '[Text:imageUrl=image.png],' +
              '[Text:After text.]]'));
    });
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
    testWidgets('renders BR tag', (WidgetTester tester) async {
      final html = 'First block.<br />Second one.';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals(
              '[Column:children=[Text:First block.],' + '[Text:Second one.]]'));
    });

    testWidgets('renders DIV tag', (WidgetTester tester) async {
      final html = '<div>First block.</div><div>Second one.</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals(
              '[Column:children=[Text:First block.],' + '[Text:Second one.]]'));
    });

    testWidgets('renders P tag', (WidgetTester tester) async {
      final html = '<p>First paragraph.</p><p><b>Second</b> one.</p>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Column:children=[Text:First paragraph.],' +
              '[RichText:(:(+b:Second)(: one.))]]'));
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
          equals('[SingleChildScrollView:child=[RichText:' +
              '(#FF000000+font=monospace:(#FF0000BB:<?php phpinfo)' +
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

  testWidgets('renders heading tags', (WidgetTester tester) async {
    final html = """<h1>This is heading 1</h1>
<h2>This is heading 2</h2>
<h3>This is heading 3</h3>
<h4>This is heading 4</h4>
<h5>This is heading 5</h5>
<h6>This is heading 6</h6>""";
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[Column:children=[RichText:(@20.0:This is heading 1)],' +
            '[RichText:(@15.0:This is heading 2)],' +
            '[RichText:(@11.7:This is heading 3)],' +
            '[RichText:(@11.2:This is heading 4)],' +
            '[RichText:(@8.3:This is heading 5)],' +
            '[RichText:(@7.5:This is heading 6)]]'));
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
          equals('[RichText:(:(#FFFF0000:red)(#8800FF00:red 53%)' +
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
      final html = """<span style="font-weight: 100">one</span>
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
          equals('[RichText:(:(+w0:one)(: )(+w1:two)(: )(+w2:three)(: )(:four)(: )' +
              '(+w4:five)(: )(+w5:six)(: )(+b:seven)(: )(+w7:eight)(: )(+w8:nine))]'));
    });
  });

  group('font-style', () {
    testWidgets('renders I tag', (WidgetTester tester) async {
      final html = 'This is an <i>italic</i> text.';
      final explained = await explain(tester, html);
      expect(
          explained, equals('[RichText:(:This is an (+i:italic)(: text.))]'));
    });

    testWidgets('renders EM tag', (WidgetTester tester) async {
      final html = 'This is an <em>emphasized</em> text.';
      final explained = await explain(tester, html);
      expect(explained,
          equals('[RichText:(:This is an (+i:emphasized)(: text.))]'));
    });

    testWidgets('renders font-style inline style', (WidgetTester tester) async {
      final html =
          "This is an <span style=\"font-style: italic\">inlined</span> text.";
      final explained = await explain(tester, html);
      expect(
          explained, equals('[RichText:(:This is an (+i:inlined)(: text.))]'));
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
              'child=[Text:imageUrl=image.png]]'));
    });

    testWidgets('renders left image', (WidgetTester tester) async {
      final html = '<div style="text-align: left"><img src="image.png"></div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Align:alignment=topLeft,' +
              'child=[Text:imageUrl=image.png]]'));
    });

    testWidgets('renders right image', (WidgetTester tester) async {
      final html = '<div style="text-align: right"><img src="image.png"></div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Align:alignment=topRight,' +
              'child=[Text:imageUrl=image.png]]'));
    });
  });

  group('text-decoration', () {
    testWidgets('renders line-through', (WidgetTester tester) async {
      final html =
          'This is a <span style="text-decoration: line-through">bad</span> good text.';
      final explained = await explain(tester, html);
      expect(
          explained, equals('[RichText:(:This is a (+l:bad)(: good text.))]'));
    });

    testWidgets('renders overline', (WidgetTester tester) async {
      final html =
          'This is <span style="text-decoration: overline">some</span> text.';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:This is (+o:some)(: text.))]'));
    });

    testWidgets('renders underline', (WidgetTester tester) async {
      final html =
          'This is an <span style="text-decoration: underline">important</span> text.';
      final explained = await explain(tester, html);
      expect(explained,
          equals('[RichText:(:This is an (+u:important)(: text.))]'));
    });
  });

  testWidgets('a little bit of everything', (WidgetTester tester) async {
    final html = """<h1>Header</h1>

First line.<br/>Second line.<br>Third line.

<div><img src="image.png" /></div>

<p>This <b>setence</b> <em>has</em> <span style="text-decoration: underline">everything</span>.</p>
""";
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[Column:children=[RichText:(@20.0:Header)],' +
            '[Text:First line.],[Text:Second line.],[Text:Third line.],' +
            '[Text:imageUrl=image.png],' +
            '[RichText:(:This (+b:setence)(: )(+i:has)(: )(+u:everything)(:.))]]'));
  });
}
