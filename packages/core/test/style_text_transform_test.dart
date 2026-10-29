import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '_.dart';

void main() {
  group('text-transform', () {
    testWidgets('renders uppercase', (WidgetTester tester) async {
      const html = '<span style="text-transform: uppercase">foo bar</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:FOO BAR)]'));
    });

    testWidgets('renders lowercase', (WidgetTester tester) async {
      const html = '<span style="text-transform: lowercase">FOO Bar</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:foo bar)]'));
    });

    testWidgets('renders capitalize', (WidgetTester tester) async {
      const html = '<span style="text-transform: capitalize">foo bar</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo Bar)]'));
    });

    testWidgets('capitalize leaves the rest of each word unchanged', (
      WidgetTester tester,
    ) async {
      const html = '<span style="text-transform: capitalize">fOO bAR</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:FOO BAR)]'));
    });

    testWidgets('capitalize starts a word after a hyphen', (
      WidgetTester tester,
    ) async {
      const html = '<span style="text-transform: capitalize">foo-bar</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo-Bar)]'));
    });

    testWidgets('capitalize keeps an apostrophe inside the word', (
      WidgetTester tester,
    ) async {
      const html =
          '<span style="text-transform: capitalize">don\'t stop</span>';
      final explained = await explain(tester, html);
      expect(explained, equals("[RichText:(:Don't Stop)]"));
    });

    testWidgets('does not recapitalize after an apostrophe split', (
      WidgetTester tester,
    ) async {
      const html = '<span style="text-transform: capitalize">don\''
          '<span>t</span></span>';
      final explained = await explain(tester, html);
      expect(explained, equals("[RichText:(:Don't)]"));
    });

    testWidgets('uppercases non-ascii letters', (WidgetTester tester) async {
      const html = '<span style="text-transform: uppercase">straße</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:STRAßE)]'));
    });

    testWidgets('capitalize uppercases a precomposed lowercase letter', (
      WidgetTester tester,
    ) async {
      const html = '<span style="text-transform: capitalize">école</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:École)]'));
    });

    testWidgets('capitalize keeps a combining mark on the first letter', (
      WidgetTester tester,
    ) async {
      const html =
          '<span style="text-transform: capitalize">e\u0301cole</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:E\u0301cole)]'));
    });

    testWidgets('renders none', (WidgetTester tester) async {
      const html = '<span style="text-transform: none">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('none resets an inherited transform', (
      WidgetTester tester,
    ) async {
      const html = '<span style="text-transform: uppercase">ab'
          '<span style="text-transform: none">cd</span>ef</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:ABcdEF)]'));
    });

    testWidgets('inherits to child text', (WidgetTester tester) async {
      const html =
          '<span style="text-transform: uppercase">ab <b>cd</b></span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:AB (+b:CD))]'));
    });

    testWidgets('child overrides the inherited transform', (
      WidgetTester tester,
    ) async {
      const html = '<span style="text-transform: uppercase">ab '
          '<span style="text-transform: lowercase">CD</span></span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:AB cd)]'));
    });

    testWidgets('ignores an invalid value and keeps the inherited one', (
      WidgetTester tester,
    ) async {
      const html = '<span style="text-transform: uppercase">'
          '<span style="text-transform: nope">ab</span></span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:AB)]'));
    });

    testWidgets('ignores an invalid value on its own', (
      WidgetTester tester,
    ) async {
      const html = '<span style="text-transform: nope">ab</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:ab)]'));
    });

    testWidgets('matches keywords case-insensitively', (
      WidgetTester tester,
    ) async {
      const html = '<span style="text-transform: UPPERCASE">ab</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:AB)]'));
    });

    testWidgets('the last declaration wins', (WidgetTester tester) async {
      const html = '<span style="text-transform: uppercase; '
          'text-transform: lowercase">AB</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:ab)]'));
    });

    testWidgets('combines with other text styles', (WidgetTester tester) async {
      const html = '<span style="font-style: italic; '
          'text-transform: uppercase">ab</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+i:AB)]'));
    });

    testWidgets('does not recapitalize a word split across elements', (
      WidgetTester tester,
    ) async {
      const html = '<span style="text-transform: capitalize">hel'
          '<span>lo</span></span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Hello)]'));
    });

    testWidgets('capitalizes the next word across elements', (
      WidgetTester tester,
    ) async {
      const html = '<span style="text-transform: capitalize">hello '
          '<b>world</b></span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Hello (+b:World))]'));
    });

    testWidgets('a nested block starts a new word',
        (WidgetTester tester) async {
      const html = '<div style="text-transform: capitalize">hello'
          '<div>world</div></div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssBlock:child=[Column:children=[RichText:(:Hello)],'
          '[CssBlock:child=[RichText:(:World)]]]]',
        ),
      );
    });

    testWidgets('a line break starts a new word', (WidgetTester tester) async {
      const html = '<span style="text-transform: capitalize">hello<br>world'
          '</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Hello\nWorld)]'));
    });

    testWidgets('preserves whitespace while uppercasing', (
      WidgetTester tester,
    ) async {
      const html = '<div style="white-space: pre; text-transform: uppercase">'
          'a b</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[CssBlock:child=[RichText:(:A B)]]'),
      );
    });

    testWidgets('uppercases ruby base and annotation', (
      WidgetTester tester,
    ) async {
      const html = '<ruby style="text-transform: uppercase">ab<rt>cd</rt>'
          '</ruby>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[HtmlRuby:children=[RichText:(:AB)],[RichText:(@5.0:CD)]]',
        ),
      );
    });

    testWidgets('none on rt resets the ruby transform', (
      WidgetTester tester,
    ) async {
      const html = '<ruby style="text-transform: uppercase">ab'
          '<rt style="text-transform: none">cd</rt></ruby>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[HtmlRuby:children=[RichText:(:AB)],[RichText:(@5.0:cd)]]',
        ),
      );
    });

    testWidgets('uppercase is applied before text-emphasis splits characters', (
      WidgetTester tester,
    ) async {
      const html = '<span style="text-transform: uppercase; '
          'text-emphasis: dot">ab</span>';
      final explained = await explain(tester, html);
      expect(explained, contains(_emphasis('A')));
      expect(explained, contains(_emphasis('B')));
    });

    testWidgets('capitalize is not reapplied to each emphasis character', (
      WidgetTester tester,
    ) async {
      const html = '<span style="text-transform: capitalize; '
          'text-emphasis: dot">ab</span>';
      final explained = await explain(tester, html);
      expect(explained, contains(_emphasis('A')));
      expect(explained, contains(_emphasis('b')));
      expect(explained, isNot(contains(_emphasis('B'))));
    });

    testWidgets('customStylesBuilder applies text-transform', (
      WidgetTester tester,
    ) async {
      const html = '<span class="name">ab</span>';
      final explained = await explain(
        tester,
        null,
        hw: HtmlWidget(
          html,
          customStylesBuilder: (element) => element.classes.contains('name')
              ? const {'text-transform': 'uppercase'}
              : null,
          key: hwKey,
        ),
      );
      expect(explained, equals('[RichText:(:AB)]'));
    });
  });
}

String _emphasis(String base) =>
    '[HtmlRuby:children=[RichText:(:$base)],[SelectionContainer]]';
