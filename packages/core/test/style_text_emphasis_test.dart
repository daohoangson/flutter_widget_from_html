import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '_.dart';

// The emphasis mark is rendered inside SelectionContainer.disabled, which the
// explainer renders as an opaque [SelectionContainer] placeholder.
String _em(String base) =>
    '[HtmlRuby:children=[RichText:(:$base)],[SelectionContainer]]';

Future<void> main() async {
  await loadAppFonts();
  group('text-emphasis shorthand — filled shapes (default)', () {
    testWidgets('dot renders glyph above each character', (tester) async {
      const html = '<span style="text-emphasis: dot">Hi</span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:${_em('H')}${_em('i')})]'));
    });

    testWidgets('circle renders glyph above each character', (tester) async {
      const html = '<span style="text-emphasis: circle">\u3070\u306d</span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:${_em('\u3070')}${_em('\u306d')})]'));
    });

    testWidgets('double-circle renders glyph above each character',
        (tester) async {
      const html = '<span style="text-emphasis: double-circle">AB</span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:${_em('A')}${_em('B')})]'));
    });

    testWidgets('triangle renders glyph above each character', (tester) async {
      const html = '<span style="text-emphasis: triangle">AB</span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:${_em('A')}${_em('B')})]'));
    });

    testWidgets('sesame renders glyph above each character', (tester) async {
      const html = '<span style="text-emphasis: sesame">AB</span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:${_em('A')}${_em('B')})]'));
    });
  });

  group('text-emphasis shorthand — open shapes', () {
    testWidgets('open dot renders glyph above each character', (tester) async {
      const html = '<span style="text-emphasis: open dot">Hi</span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:${_em('H')}${_em('i')})]'));
    });

    testWidgets('open circle renders glyph above each character',
        (tester) async {
      const html = '<span style="text-emphasis: open circle">Hi</span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:${_em('H')}${_em('i')})]'));
    });

    testWidgets('open double-circle renders glyph above each character',
        (tester) async {
      const html = '<span style="text-emphasis: open double-circle">Hi</span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:${_em('H')}${_em('i')})]'));
    });

    testWidgets('open triangle renders glyph above each character',
        (tester) async {
      const html = '<span style="text-emphasis: open triangle">Hi</span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:${_em('H')}${_em('i')})]'));
    });

    testWidgets('open sesame renders glyph above each character',
        (tester) async {
      const html = '<span style="text-emphasis: open sesame">Hi</span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:${_em('H')}${_em('i')})]'));
    });

    testWidgets('filled keyword is explicit default', (tester) async {
      const html = '<span style="text-emphasis: filled circle">Hi</span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:${_em('H')}${_em('i')})]'));
    });
  });

  group('text-emphasis-style longhand', () {
    testWidgets('dot renders glyph above each character', (tester) async {
      const html = '<span style="text-emphasis-style: dot">Hi</span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:${_em('H')}${_em('i')})]'));
    });

    testWidgets('circle renders glyph above each character', (tester) async {
      const html = '<span style="text-emphasis-style: circle">Hi</span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:${_em('H')}${_em('i')})]'));
    });
  });

  group('multi-value shorthand with color', () {
    testWidgets(
        'circle crimson — marks rendered (color inside SelectionContainer)',
        (tester) async {
      // Color is applied inside SelectionContainer.disabled which the
      // explainer renders opaquely; we verify the structural output only.
      const html =
          '<span style="text-emphasis: circle crimson">\u3070\u306d</span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:${_em('\u3070')}${_em('\u306d')})]'));
    });
  });

  group('text-emphasis-color longhand', () {
    testWidgets('standalone color with separate style', (tester) async {
      const html = '<span style="text-emphasis-style: dot; '
          'text-emphasis-color: crimson">Hi</span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:${_em('H')}${_em('i')})]'));
    });

    testWidgets('color only without style produces no marks', (tester) async {
      const html = '<span style="text-emphasis-color: red">Hi</span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:Hi)]'));
    });

    testWidgets('inherited color from parent', (tester) async {
      const html = '<div style="text-emphasis-color: blue">'
          '<span style="text-emphasis-style: dot">Hi</span></div>';
      final e = await explain(tester, html);
      expect(
        e,
        equals(
          '[CssBlock:child=[RichText:(:${_em('H')}${_em('i')})]]',
        ),
      );
    });
  });

  group('whitespace handling', () {
    testWidgets('skips space between words', (tester) async {
      const html = '<span style="text-emphasis: dot">a b</span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:${_em('a')}(: )${_em('b')})]'));
    });

    testWidgets('empty span produces no output', (tester) async {
      const html = '<span style="text-emphasis: dot"></span>';
      final e = await explain(tester, html);
      expect(e, equals('[widget0]'));
    });
  });

  group('unsupported values', () {
    testWidgets('none leaves text unchanged', (tester) async {
      const html = '<span style="text-emphasis: none">Hello</span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:Hello)]'));
    });

    testWidgets('unknown keyword leaves text unchanged', (tester) async {
      const html = '<span style="text-emphasis: foobar">Hello</span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:Hello)]'));
    });
  });

  group('custom mark — CSS <string> value', () {
    testWidgets('single-quoted character renders above each character',
        (tester) async {
      const html = '<span style="text-emphasis-style: \'x\'">Hi</span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:${_em('H')}${_em('i')})]'));
    });

    testWidgets('double-quoted character renders above each character',
        (tester) async {
      const html = '<span style=\'text-emphasis-style: "★"\'>Hi</span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:${_em('H')}${_em('i')})]'));
    });

    testWidgets('custom mark with color', (tester) async {
      const html = '<span style="text-emphasis: \'▲\' red">Hi</span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:${_em('H')}${_em('i')})]'));
    });

    testWidgets('empty string is ignored', (tester) async {
      const html = '<span style="text-emphasis-style: \'\'">Hello</span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:Hello)]'));
    });

    testWidgets('only first character of multi-char string is used',
        (tester) async {
      // CSS spec: strings with > 1 char are invalid, but we gracefully use [0].
      const html = '<span style="text-emphasis-style: \'ab\'">Hi</span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:${_em('H')}${_em('i')})]'));
    });
  });

  group('mark isolation', () {
    testWidgets('mark does not inherit underline from base text',
        (tester) async {
      // The base character SHOULD carry +u; SelectionContainer (mark) must NOT.
      const html =
          '<span style="text-emphasis: dot; text-decoration-line: underline">'
          'Hi'
          '</span>';
      final e = await explain(tester, html);
      expect(e, contains('[RichText:(+u:'));
      expect(e, isNot(contains('+u@5.0')));
      expect(e, isNot(contains('@5.0:+u')));
    });
  });

  group('ruby interaction', () {
    testWidgets('emphasis on outer span — ruby children pass through unchanged',
        (tester) async {
      // Marks appear on plain text chars; the <ruby> subtree is untouched.
      const html =
          '<span style="text-emphasis: dot">x<ruby>\u6f22<rt>\u304b\u3093</rt></ruby>y</span>';
      final e = await explain(tester, html);
      expect(e, contains(_em('x')));
      expect(e, contains('[HtmlRuby:'));
      expect(e, contains(_em('y')));
    });

    testWidgets(
        'emphasis directly on ruby — marks stack with ruby annotation above base',
        (tester) async {
      // Emphasis (priority 10) runs before ruby (priority ~11e15).
      // The base character first gets wrapped in HtmlRuby(ruby: 漢, rt: •),
      // then ruby's onParsed wraps that WidgetBit as the ruby base with the
      // <rt> as its annotation. Both marks stack above the character.
      // CSS spec would prefer emphasis under and ruby above, but Flutter's
      // single-slot HtmlRuby cannot represent opposing sides — stacking is
      // the best available option.
      const html =
          '<ruby style="text-emphasis: dot">\u6f22<rt>\u304b\u3093</rt></ruby>';
      final e = await explain(tester, html);
      // Outer HtmlRuby is the ruby op's result; its ruby slot contains the
      // emphasis HtmlRuby.
      expect(e, contains('[HtmlRuby:children=[HtmlRuby:'));
    });

    testWidgets('emphasis on rt — marks appear above each furigana character',
        (tester) async {
      // Emphasis op on <rt> runs (priority 10) and wraps each furigana char.
      // The replacement preserves element.localName == 'rt' so that ruby's
      // isRtTree check still passes. Ruby op then calls rtTree.build() which
      // returns the emphasis-marked furigana for the ruby rt slot.
      // Visual result (bottom→top): 漢 | •か •ん
      const html =
          '<ruby>\u6f22<rt style="text-emphasis: dot">\u304b\u3093</rt></ruby>';
      final e = await explain(tester, html);
      // <rt> inherits 0.5em so furigana chars show as @5.0 in the explainer.
      const emKa =
          '[HtmlRuby:children=[RichText:(@5.0:\u304b)],[SelectionContainer]]';
      const emN =
          '[HtmlRuby:children=[RichText:(@5.0:\u3093)],[SelectionContainer]]';
      expect(e, contains('[HtmlRuby:children=[RichText:(:'));
      expect(e, contains(emKa));
      expect(e, contains(emN));
    });
  });

  final goldenSkipEnvVar = Platform.environment['GOLDEN_SKIP'];
  final goldenSkip = goldenSkipEnvVar == null
      ? Platform.isLinux
          ? null
          : 'Linux only'
      : 'GOLDEN_SKIP=$goldenSkipEnvVar';

  GoldenToolkit.runWithConfiguration(
    () {
      group(
        'golden',
        () {
          final testCases = <String, String>{
            'filled_shapes': '<div style="font-size: 24px">'
                '<p style="text-emphasis: dot">dot</p>'
                '<p style="text-emphasis: circle">circle</p>'
                '<p style="text-emphasis: double-circle">double-circle</p>'
                '<p style="text-emphasis: triangle">triangle</p>'
                '<p style="text-emphasis: sesame">sesame</p>'
                '</div>',
            'open_shapes': '<div style="font-size: 24px">'
                '<p style="text-emphasis: open dot">dot</p>'
                '<p style="text-emphasis: open circle">circle</p>'
                '<p style="text-emphasis: open double-circle">double-circle</p>'
                '<p style="text-emphasis: open triangle">triangle</p>'
                '<p style="text-emphasis: open sesame">sesame</p>'
                '</div>',
            'with_color': '<div style="font-size: 24px">'
                '<p style="text-emphasis: circle crimson">crimson circle</p>'
                '<p style="text-emphasis: dot blue">blue dot</p>'
                '</div>',
            'custom_mark': '<div style="font-size: 24px">'
                '<p style="text-emphasis-style: \'★\'">custom star</p>'
                '</div>',
            'with_ruby': '<div style="font-size: 24px">'
                '<p style="text-emphasis: dot">'
                'x<ruby>漢<rt>かん</rt></ruby>y'
                '</p>'
                '</div>',
          };

          for (final testCase in testCases.entries) {
            testGoldens(
              testCase.key,
              (tester) async {
                await tester.pumpWidgetBuilder(
                  _Golden(testCase.value),
                  wrapper: materialAppWrapper(theme: ThemeData.light()),
                  surfaceSize: const Size(300, 300),
                );

                await screenMatchesGolden(tester, testCase.key);
              },
              skip: goldenSkip != null,
            );
          }
        },
        skip: goldenSkip,
      );
    },
    config: GoldenToolkitConfiguration(
      fileNameFactory: (name) => '$kGoldenFilePrefix/text_emphasis/$name.png',
    ),
  );
}

class _Golden extends StatelessWidget {
  final String html;

  const _Golden(this.html);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: HtmlWidget(html),
        ),
      );
}
