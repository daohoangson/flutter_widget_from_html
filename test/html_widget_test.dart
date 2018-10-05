import 'package:flutter_test/flutter_test.dart';

import 'html_widget_helper.dart';

void main() {
  group('HtmlWidget', () {
    testWidgets('renders bare string', (WidgetTester tester) async {
      final html = 'Hello world';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Hello world)]'));
    });

    testWidgets('renders A tag', (WidgetTester tester) async {
      final html = 'This is a <a>hyperlink</a>.';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:This is a ((0,0,255,255)+u:hyperlink)(:.))]'));
    });

    testWidgets('renders heading tags', (WidgetTester tester) async {
      final html = """<h1>This is heading 1</h1>
  <h2>This is heading 2</h2>
  <h3>This is heading 3</h3>
  <h4>This is heading 4</h4>
  <h5>This is heading 5</h5>
  <h6>This is heading 6</h6>""";
      final explained = await explain(tester, html);
      expect(explained, equals("""[RichText:(:(@1.0:This is heading 1)(:
  )(@2.0:This is heading 2)(:
  )(@3.0:This is heading 3)(:
  )(@4.0:This is heading 4)(:
  )(@5.0:This is heading 5)(:
  )(@6.0:This is heading 6))]"""));
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

      testWidgets('renders font-weight inline style', (WidgetTester tester) async {
        final html = """<span style="font-weight: 100">one</span>
  <span style="font-weight: 200">two</span>
  <span style="font-weight: 300">three</span>
  <span style="font-weight: 400">four</span>
  <span style="font-weight: 500">five</span>
  <span style="font-weight: 600">six</span>
  <span style="font-weight: 700">seven</span>
  <span style="font-weight: 800">eight</span>
  <span style="font-weight: 900">nine</span>
  """;
        final explained = await explain(tester, html);
        expect(explained, equals("""[RichText:(:(+w0:one)(:
  )(+w1:two)(:
  )(+w2:three)(:
  )(:four)(:
  )(+w4:five)(:
  )(+w5:six)(:
  )(+b:seven)(:
  )(+w7:eight)(:
  )(+w8:nine)(:
  ))]"""));
      });
    });

    group('font-style', () {
      testWidgets('renders I tag', (WidgetTester tester) async {
        final html = 'This is an <i>italic</i> text.';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(:This is an (+i:italic)(: text.))]'));
      });

      testWidgets('renders EM tag', (WidgetTester tester) async {
        final html = 'This is an <em>emphasized</em> text.';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(:This is an (+i:emphasized)(: text.))]'));
      });

      testWidgets('renders font-style inline style', (WidgetTester tester) async {
        final html = "This is an <span style=\"font-style: italic\">inlined</span> text.";
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(:This is an (+i:inlined)(: text.))]'));
      });
    });

    group('text-decoration', () {
      testWidgets('renders line-through', (WidgetTester tester) async {
        final html = 'This is a <span style="text-decoration: line-through">bad</span> good text.';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(:This is a (+l:bad)(: good text.))]'));
      });

      testWidgets('renders overline', (WidgetTester tester) async {
        final html = 'This is <span style="text-decoration: overline">some</span> text.';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(:This is (+o:some)(: text.))]'));
      });

      testWidgets('renders underline', (WidgetTester tester) async {
        final html = 'This is an <span style="text-decoration: underline">important</span> text.';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(:This is an (+u:important)(: text.))]'));
      });
    });
  });
}
