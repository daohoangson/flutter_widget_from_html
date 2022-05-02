import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '_.dart';

Future<void> main() async {
  await loadAppFonts();

  testWidgets('renders RUBY tag', (WidgetTester tester) async {
    const html = '<ruby>明日 <rp>(</rp><rt>Ashita</rt><rp>)</rp></ruby>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[HtmlRuby:children='
        '[RichText:(:明日)],'
        '[RichText:(@5.0:Ashita)]'
        ']',
      ),
    );
  });

  testWidgets('renders text after RT', (WidgetTester tester) async {
    const html = '<ruby>ruby <rt>rt</rt> foo</ruby>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[RichText:(:'
        '[HtmlRuby:children=[RichText:(:ruby)],[RichText:(@5.0:rt)]]'
        '(: foo)'
        ')]',
      ),
    );
  });

  testWidgets('renders with multiple RTs', (WidgetTester tester) async {
    const html = '<ruby>漢<rt>かん</rt>字<rt>じ</rt></ruby>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[RichText:(:'
        '[HtmlRuby:children=[RichText:(:漢)],[RichText:(@5.0:かん)]]'
        '[HtmlRuby:children=[RichText:(:字)],[RichText:(@5.0:じ)]]'
        ')]',
      ),
    );
  });

  testWidgets('renders without erroneous white spaces', (tester) async {
    const html = '<ruby>\n漢\n<rt>かん</rt>\n\n字\n<rt>じ</rt></ruby>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[RichText:(:'
        '[HtmlRuby:children=[RichText:(:漢)],[RichText:(@5.0:かん)]]'
        '(: )'
        '[HtmlRuby:children=[RichText:(:字)],[RichText:(@5.0:じ)]]'
        ')]',
      ),
    );
  });

  group('possible conflict', () {
    testWidgets('triple renders', (WidgetTester tester) async {
      const html = '<ruby><ruby>ruby1 <rt>ruby2</rt></ruby> '
          '<rt><ruby>rt1 <rt>rt2</rt></ruby></rt></ruby>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[HtmlRuby:children='
          '[HtmlRuby:children=[RichText:(:ruby1)],[RichText:(@5.0:ruby2)]],'
          '[HtmlRuby:children=[RichText:(@5.0:rt1)],[RichText:(@2.5:rt2)]]'
          ']',
        ),
      );
    });

    testWidgets('renders with A tag', (WidgetTester tester) async {
      const html = '<ruby><a href="http://domain.com/foo">foo</a> '
          '<rt><a href="http://domain.com/bar">bar</a></rt></ruby>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[HtmlRuby:children='
          '[RichText:(#FF123456+u+onTap:foo)],'
          '[RichText:(#FF123456+u@5.0+onTap:bar)]'
          ']',
        ),
      );
    });

    testWidgets('renders with BR tag', (WidgetTester tester) async {
      const html = '<ruby>1<br/>2 <rt>3<br/>4</rt></ruby>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[HtmlRuby:children='
          '[RichText:(:1\n2)],'
          '[RichText:(@5.0:3\n4)]'
          ']',
        ),
      );
    });

    testWidgets('renders with Q tag', (WidgetTester tester) async {
      const html = '<ruby><q>foo</q> <rt><q>bar</q></rt></ruby>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[HtmlRuby:children='
          '[RichText:(:“foo”)],'
          '[RichText:(@5.0:“bar”)]'
          ']',
        ),
      );
    });
  });

  group('error handling', () {
    testWidgets('renders without RT', (WidgetTester tester) async {
      const html = '<ruby>明日</ruby>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:明日)]'));
    });

    testWidgets('renders with empty RT', (WidgetTester tester) async {
      const html = '<ruby>明日 <rt></rt></ruby>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:明日)]'));
    });

    testWidgets('renders without contents', (WidgetTester tester) async {
      const html = 'Foo <ruby></ruby>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('renders with only RT', (WidgetTester tester) async {
      const html = 'Foo <ruby><rt>Ashita</rt></ruby>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo (@5.0:Ashita))]'));
    });

    testWidgets('renders with only empty RT', (WidgetTester tester) async {
      const html = 'Foo <ruby><rt></rt></ruby>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });
  });

  group('HtmlRuby', () {
    testWidgets('computeIntrinsic', (tester) async {
      final rt = GlobalKey();
      final ruby = GlobalKey();
      final key = GlobalKey();
      await tester.pumpWidget(
        HtmlRuby(
          SizedBox(key: ruby, width: 50, height: 10),
          SizedBox(key: rt, width: 10, height: 5),
          key: key,
        ),
      );
      await tester.pumpAndSettle();

      final rtRenderBox = rt.currentContext!.findRenderObject()! as RenderBox;
      final rubyRenderBox =
          ruby.currentContext!.findRenderObject()! as RenderBox;
      final htmlRubyRenderBox =
          key.currentContext!.findRenderObject()! as RenderBox;
      expect(
        htmlRubyRenderBox.getMaxIntrinsicHeight(100),
        equals(
          rubyRenderBox.getMaxIntrinsicHeight(100) +
              rtRenderBox.getMaxIntrinsicHeight(100),
        ),
      );
      expect(
        htmlRubyRenderBox.getMaxIntrinsicWidth(100),
        equals(
          max(
            rubyRenderBox.getMaxIntrinsicWidth(100),
            rtRenderBox.getMaxIntrinsicWidth(100),
          ),
        ),
      );
      expect(
        htmlRubyRenderBox.getMinIntrinsicHeight(100),
        equals(
          rubyRenderBox.getMinIntrinsicHeight(100) +
              rtRenderBox.getMinIntrinsicHeight(100),
        ),
      );
      expect(
        htmlRubyRenderBox.getMinIntrinsicWidth(100),
        equals(
          min(
            rubyRenderBox.getMinIntrinsicWidth(100),
            rtRenderBox.getMinIntrinsicWidth(100),
          ),
        ),
      );
    });

    testWidgets('performs hit test', (tester) async {
      const href = 'href';
      final urls = <String>[];

      await tester.pumpWidget(
        HitTestApp(
          html: '<ruby><a href="$href">Tap me</a> <rt>Foo</rt></ruby>',
          list: urls,
        ),
      );
      expect(await tapText(tester, 'Tap me'), equals(1));

      await tester.pumpAndSettle();
      expect(urls, equals(const [href]));
    });

    final goldenSkipEnvVar = Platform.environment['GOLDEN_SKIP'];
    final goldenSkip = goldenSkipEnvVar == ''
        ? Platform.isLinux
            ? null
            : 'Linux only'
        : 'GOLDEN_SKIP=$goldenSkipEnvVar';

    GoldenToolkit.runWithConfiguration(
      () {
        testGoldens(
          'computeDryLayout',
          (tester) async {
            await tester.pumpWidgetBuilder(
              const Scaffold(
                body: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: HtmlWidget(
                    '<div style="background: black; color: white; '
                    'width: 200px; height: 200px">'
                    '<ruby>Foo <rt>bar</rt></ruby>'
                    '<div>',
                  ),
                ),
              ),
              wrapper: materialAppWrapper(theme: ThemeData.light()),
              surfaceSize: const Size(600, 400),
            );

            await screenMatchesGolden(tester, 'computeDryLayout');
          },
          skip: goldenSkip != null,
        );
      },
      config: GoldenToolkitConfiguration(
        fileNameFactory: (name) => '$kGoldenFilePrefix/ruby/$name.png',
      ),
    );
  });
}
