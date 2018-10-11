import 'package:flutter_test/flutter_test.dart';

import 'html_widget_helper.dart';

void main() {
  group('HtmlWidget', () {
    testWidgets('renders bare string', (WidgetTester tester) async {
      final html = 'Hello world';
      final explained = await explain(tester, html);
      expect(explained, equals('[Text:Hello world]'));
    });

    group('A tag', () {
      testWidgets('renders stylings and on tap', (WidgetTester tester) async {
        final html = 'This is a <a href="href">hyperlink</a>.';
        final explained = await explain(tester, html);
        expect(
            explained,
            equals(
                '[RichText:(:This is a (#FF0000FF+u+onTap:hyperlink)(:.))]'));
      });

      testWidgets('renders inner stylings', (WidgetTester tester) async {
        final html = 'This is a <a href="href"><b><i>hyperlink</i></b></a>.';
        final explained = await explain(tester, html);
        expect(
            explained,
            equals(
                '[RichText:(:This is a (#FF0000FF+u+i+b+onTap:hyperlink)(:.))]'));
      });
    });

    group('IMG tag', () {
      testWidgets('renders src', (WidgetTester tester) async {
        final html = '<img src="image.png" />';
        final explained = await explain(tester, html);
        expect(
            explained,
            equals(
                '[CachedNetworkImage:imageUrl=http://domain.com/image.png]'));
      });

      testWidgets('renders data-src', (WidgetTester tester) async {
        final html = '<img data-src="image.png" />';
        final explained = await explain(tester, html);
        expect(
            explained,
            equals(
                '[CachedNetworkImage:imageUrl=http://domain.com/image.png]'));
      });

      testWidgets('renders data uri', (WidgetTester tester) async {
        // https://stackoverflow.com/questions/6018611/smallest-data-uri-image-possible-for-a-transparent-image
        final html =
            '<img src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" />';
        final explained = await explain(tester, html);
        expect(explained, equals('[Image:image=MemoryImage]'));
      });

      testWidgets('renders dimensions', (WidgetTester tester) async {
        final html = '<img src="image.png" width="800" height="600" />';
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[AspectRatio:aspectRatio=1.33,' +
                'child=[CachedNetworkImage:imageUrl=http://domain.com/image.png]]'));
      });

      testWidgets('renders between texts', (WidgetTester tester) async {
        final html = 'Before text. <img src="image.png" /> After text.';
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[Column:children=[Text:Before text.],' +
                '[CachedNetworkImage:imageUrl=http://domain.com/image.png],' +
                '[Text:After text.]]'));
      });

      testWidgets('renders inside A tag', (WidgetTester tester) async {
        final html = '<a href="href"><img src="image.png" /></a>';
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[GestureDetector:child=' +
                '[CachedNetworkImage:imageUrl=http://domain.com/image.png]]'));
      });
    });

    group('lists', () {
      testWidgets('renders ordered list', (WidgetTester tester) async {
        final html = '<ol><li>One</li><li>Two</li><li><b>Three</b></li><ol>';
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[Padding:child=[Column:children=[Text:1. One],' +
                '[Text:2. Two],[RichText:(:3. (+b:Three))]]]'));
      });

      testWidgets('renders unordered list', (WidgetTester tester) async {
        final html = '<ul><li>One</li><li>Two</li><li><b>Three</b></li><ul>';
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[Padding:child=[Column:children=[Text:- One],' +
                '[Text:- Two],[RichText:(:- (+b:Three))]]]'));
      });

      testWidgets('renders nested list', (WidgetTester tester) async {
        final html = '<ol><li>One</li><li>Two</li><li>Three ' +
            '<ul><li>3.1</li><li>3.2</li></ul></li><ol>';
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[Padding:child=[Column:children=[Text:1. One],' +
                '[Text:2. Two],[Text:3. Three],[Padding:child=' +
                '[Column:children=[Text:- 3.1],[Text:- 3.2]]]]]'));
      });
    });

    group('block elements', () {
      testWidgets('renders BR tag', (WidgetTester tester) async {
        final html = 'First block.<br />Second one.';
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[Column:children=[Text:First block.],' +
                '[Text:Second one.]]'));
      });

      testWidgets('renders DIV tag', (WidgetTester tester) async {
        final html = '<div>First block.</div><div>Second one.</div>';
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[Column:children=[Text:First block.],' +
                '[Text:Second one.]]'));
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
          equals('[Column:children=[RichText:(@1.0:This is heading 1)],' +
              '[RichText:(@2.0:This is heading 2)],' +
              '[RichText:(@3.0:This is heading 3)],' +
              '[RichText:(@4.0:This is heading 4)],' +
              '[RichText:(@5.0:This is heading 5)],' +
              '[RichText:(@6.0:This is heading 6)]]'));
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
        expect(
            explained, equals('[RichText:(:This is a (+b:strong)(: text.))]'));
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

      testWidgets('renders font-style inline style',
          (WidgetTester tester) async {
        final html =
            "This is an <span style=\"font-style: italic\">inlined</span> text.";
        final explained = await explain(tester, html);
        expect(explained,
            equals('[RichText:(:This is an (+i:inlined)(: text.))]'));
      });
    });

    group('text-align', () {
      testWidgets('renders center', (WidgetTester tester) async {
        final html = '<div style="text-align: center">_X_</div>';
        final explained = await explain(tester, html);
        expect(explained, equals('[Text,align=center:_X_]'));
      });

      testWidgets('renders left', (WidgetTester tester) async {
        final html = '<div style="text-align: left">X__</div>';
        final explained = await explain(tester, html);
        expect(explained, equals('[Text,align=left:X__]'));
      });

      testWidgets('renders right', (WidgetTester tester) async {
        final html = '<div style="text-align: right">__<b>X</b></div>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText,align=right:(:__(+b:X))]'));
      });
    });

    group('text-decoration', () {
      testWidgets('renders line-through', (WidgetTester tester) async {
        final html =
            'This is a <span style="text-decoration: line-through">bad</span> good text.';
        final explained = await explain(tester, html);
        expect(explained,
            equals('[RichText:(:This is a (+l:bad)(: good text.))]'));
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
          equals('[Column:children=[RichText:(@1.0:Header)],' +
              '[Text:First line.],[Text:Second line.],[Text:Third line.],' +
              '[CachedNetworkImage:imageUrl=http://domain.com/image.png],' +
              '[RichText:(:This (+b:setence)(: )(+i:has)(: )(+u:everything)(:.))]]'));
    });
  });
}
