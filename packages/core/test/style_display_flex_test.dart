import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:flutter_widget_from_html_core/src/internal/core_ops.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '_.dart';

Future<void> main() async {
  await loadAppFonts();

  testWidgets('renders text', (WidgetTester tester) async {
    const html = '<div style="display: flex">Foo</div>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[Flex:direction=horizontal,mainAxisAlignment=start,'
        'crossAxisAlignment=start,children=[RichText:(:Foo)]]',
      ),
    );
  });

  testWidgets('renders blocks', (WidgetTester tester) async {
    const html =
        '<div style="display: flex"><div>Foo</div><div>Bar</div></div>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[Flex:direction=horizontal,mainAxisAlignment=start,crossAxisAlignment=start,children='
        '[CssBlock:child=[RichText:(:Foo)]],'
        '[CssBlock:child=[RichText:(:Bar)]]'
        ']',
      ),
    );
  });

  testWidgets('ignores whitesplace', (WidgetTester tester) async {
    const html =
        '<div style="display: flex">\n<div>Foo</div>\n<div>Bar</div>\n</div>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[Flex:direction=horizontal,mainAxisAlignment=start,crossAxisAlignment=start,children='
        '[CssBlock:child=[RichText:(:Foo)]],'
        '[CssBlock:child=[RichText:(:Bar)]]'
        ']',
      ),
    );
  });

  group('error handling', () {
    testWidgets('#1152: renders super long text', (WidgetTester tester) async {
      final lipsum =
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. ' * 999;
      final html = '<div style="display: flex">$lipsum</div>';
      final building = await explain(tester, html, useExplainer: false);
      expect(building, contains('ProgressIndicator'));

      await tester.runAsync(() => Future.delayed(const Duration(seconds: 1)));
      await tester.pump();
      final built = await explainWithoutPumping(useExplainer: false);
      expect(built, isNot(contains('ProgressIndicator')));

      final box =
          find.byType(RichText).evaluate().first.renderObject?.renderBox;
      expect(box?.size.width, equals(tester.windowWidth));
    });

    testWidgets('#1152: renders super wide block', (tester) async {
      final lipsum =
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. ' * 999;
      final html =
          '<div style="display: flex"><div>Foo</div><div>$lipsum</div></div>';
      final building = await explain(tester, html, useExplainer: false);
      expect(building, contains('ProgressIndicator'));

      await tester.runAsync(() => Future.delayed(const Duration(seconds: 1)));
      await tester.pump();
      final built = await explainWithoutPumping(useExplainer: false);
      expect(built, isNot(contains('ProgressIndicator')));

      final elements = find.byType(RichText).evaluate();
      final size = elements
          .map((element) => element.renderBox.size.width)
          .toList(growable: false);
      expect(size.length, equals(2));
      expect(size[0], lessThan(20));
      expect(size[0] + size[1], equals(tester.windowWidth));
    });

    testWidgets('#1169: renders super wide contents', (tester) async {
      const html = '<div style="display: flex">'
          '<div style="width: 9999px">Foo</div>'
          '</div>';
      await explain(tester, html);
      expect(tester.foo.size.width, equals(tester.windowWidth));
    });

    testWidgets('renders super wide contents with margins', (tester) async {
      const html = '<div style="display: flex; margin: 5px">'
          '<div style="width: 9999px">Foo</div>'
          '</div>';
      await explain(tester, html);
      expect(tester.foo.size.width, equals(tester.windowWidth - 10));

      await explain(tester, html.replaceFirst('margin: 5px', 'margin: 50px'));
      expect(tester.foo.size.width, equals(tester.windowWidth - 100));
    });

    testWidgets('renders super tall contents', (WidgetTester tester) async {
      const html = '<div style="display: flex; flex-direction: column">'
          '<div style="height: 9999px">Foo</div>'
          '</div>';
      await explain(tester, html);
      expect(tester.foo.size.height, equals(tester.windowHeight));
    });
  });

  group('HtmlFlex', () {
    group('_HtmlFlexRenderObject setters', () {
      testWidgets('updates crossAxisAlignment', (WidgetTester tester) async {
        await explain(
          tester,
          '<div style="display: flex; flex-direction: column; align-items: flex-end">'
          '<div style="background: red; width: 200px">Foo</div>'
          '<div style="background: blue; width: 200px">Bar</div>'
          '</div>',
        );
        final fooBefore = tester.foo.size.width;
        final barBefore = tester.bar.size.width;

        await explain(
          tester,
          '<div style="display: flex; flex-direction: column; align-items: stretch">'
          '<div style="background: red; width: 200px">Foo</div>'
          '<div style="background: blue; width: 200px">Bar</div>'
          '</div>',
        );
        final fooAfter = tester.foo.size.width;
        final barAfter = tester.bar.size.width;
        expect(fooAfter, greaterThan(fooBefore));
        expect(barAfter, greaterThan(barBefore));
      });

      testWidgets('updates direction', (WidgetTester tester) async {
        await explain(
          tester,
          '<div style="display: flex; flex-direction: column">'
          '<div>Foo</div><div>Bar</div>'
          '</div>',
        );
        final fooBefore = tester.foo;
        final barBefore = tester.bar;
        expect(fooBefore.left, equals(barBefore.left));
        expect(fooBefore.top, lessThan(barBefore.top));

        await explain(
          tester,
          '<div style="display: flex; flex-direction: row">'
          '<div>Foo</div><div>Bar</div>'
          '</div>',
        );
        final fooAfter = tester.foo;
        final barAfter = tester.bar;
        expect(fooAfter.left, lessThan(barAfter.left));
        expect(fooAfter.top, equals(barAfter.top));
      });

      testWidgets('updates mainAxisAlignment', (WidgetTester tester) async {
        await explain(
          tester,
          '<div style="display: flex; justify-content: flex-start">'
          '<div>Foo</div><div>Bar</div>'
          '</div>',
        );
        final barBefore = tester.bar;
        final barRightBefore = barBefore.left + barBefore.size.width;
        expect(barRightBefore, lessThan(tester.windowWidth));

        await explain(
          tester,
          '<div style="display: flex; justify-content: space-between">'
          '<div>Foo</div><div>Bar</div>'
          '</div>',
        );
        final barAfter = tester.bar;
        final barRightAfter = barAfter.left + barAfter.size.width;
        expect(barRightAfter, equals(tester.windowWidth));
      });

      testWidgets('updates textDirection', (WidgetTester tester) async {
        await explain(
            tester,
            '<div dir="ltr"><div style="display: flex; flex-direction: row">'
            '<div>Foo</div><div>Bar</div>'
            '</div></div>');
        expect(tester.foo.left, lessThan(tester.bar.left));

        await explain(
            tester,
            '<div dir="rtl"><div style="display: flex; flex-direction: row">'
            '<div>Foo</div><div>Bar</div>'
            '</div></div>');
        expect(tester.foo.left, greaterThan(tester.bar.left));
      });
    });

    group('computeDistanceToActualBaseline', () {
      testWidgets('direction=horizontal', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  HtmlFlex(
                    direction: Axis.horizontal,
                    children: const [Text('Foo')],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('Bar'),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
      });

      testWidgets('direction=vertical', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  HtmlFlex(
                    direction: Axis.vertical,
                    children: const [Text('Foo')],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('Bar'),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
      });
    });

    group('computeDryLayout', () {
      testWidgets('direction=horizontal', (WidgetTester tester) async {
        final flex = GlobalKey();
        final foo = GlobalKey();
        final bar = GlobalKey();
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: HtmlFlex(
                direction: Axis.horizontal,
                key: flex,
                children: [
                  Text('Foo', key: foo),
                  Text('Bar', key: bar),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final flexBox = flex.renderBox;
        final fooSize = foo.renderBox.size;
        final barSize = bar.renderBox.size;
        expect(
          flexBox.getDryLayout(const BoxConstraints()),
          equals(
            Size(
              fooSize.width + barSize.width,
              max(fooSize.height, barSize.height),
            ),
          ),
        );
      });

      testWidgets('direction=vertical', (WidgetTester tester) async {
        final flex = GlobalKey();
        final foo = GlobalKey();
        final bar = GlobalKey();
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: HtmlFlex(
                direction: Axis.vertical,
                key: flex,
                children: [
                  Text('Foo', key: foo),
                  Text('Bar', key: bar),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final flexBox = flex.renderBox;
        final fooSize = foo.renderBox.size;
        final barSize = bar.renderBox.size;
        expect(
          flexBox.getDryLayout(const BoxConstraints()),
          equals(
            Size(
              max(fooSize.width, barSize.width),
              fooSize.height + barSize.height,
            ),
          ),
        );
      });
    });

    group('computeIntrinsic', () {
      testWidgets('direction=horizontal', (WidgetTester tester) async {
        final flex = GlobalKey();
        final foo = GlobalKey();
        final bar = GlobalKey();
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: HtmlFlex(
                direction: Axis.horizontal,
                key: flex,
                children: [
                  Text('Foo', key: foo),
                  Text('Bar', key: bar),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final flexBox = flex.renderBox;
        final fooBox = foo.renderBox;
        final barBox = bar.renderBox;
        expect(flexBox.getMaxIntrinsicHeight(100), equals(fooBox.size.height));
        expect(
          flexBox.getMaxIntrinsicWidth(100),
          equals(fooBox.size.width + barBox.size.width),
        );
        expect(flexBox.getMinIntrinsicHeight(100), equals(fooBox.size.height));
        expect(
          flexBox.getMinIntrinsicWidth(100),
          equals(fooBox.size.width + barBox.size.width),
        );
      });

      testWidgets('direction=vertical', (WidgetTester tester) async {
        final flex = GlobalKey();
        final foo = GlobalKey();
        final bar = GlobalKey();
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: HtmlFlex(
                direction: Axis.vertical,
                key: flex,
                children: [
                  Text('Foo', key: foo),
                  Text('Bar', key: bar),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final flexBox = flex.renderBox;
        final fooBox = foo.renderBox;
        final barBox = bar.renderBox;
        expect(
          flexBox.getMaxIntrinsicHeight(100),
          equals(fooBox.size.height + barBox.size.height),
        );
        expect(flexBox.getMaxIntrinsicWidth(100), equals(fooBox.size.width));
        expect(
          flexBox.getMinIntrinsicHeight(100),
          equals(fooBox.size.height + barBox.size.height),
        );
        expect(flexBox.getMinIntrinsicWidth(100), equals(fooBox.size.width));
      });
    });

    testWidgets('hitTestChildren', (tester) async {
      const href = 'href';
      final urls = <String>[];

      await tester.pumpWidget(
        HitTestApp(
          html: '<div style="display: flex"><a href="$href">Tap me</a></div>',
          list: urls,
        ),
      );
      expect(await tapText(tester, 'Tap me'), equals(1));

      await tester.pumpAndSettle();
      expect(urls, equals(const [href]));
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
        'display: flex',
        () {
          const flexDirections = [
            kCssFlexDirectionColumn,
            kCssFlexDirectionRow,
          ];

          const alignItems = [
            kCssAlignItemsFlexStart,
            kCssAlignItemsFlexEnd,
            kCssAlignItemsCenter,
            kCssAlignItemsBaseline,
            kCssAlignItemsStretch,
          ];

          const justifyContents = [
            kCssJustifyContentFlexStart,
            kCssJustifyContentFlexEnd,
            kCssJustifyContentCenter,
            kCssJustifyContentSpaceBetween,
            kCssJustifyContentSpaceAround,
            kCssJustifyContentSpaceEvenly,
          ];

          for (final flexDirection in flexDirections) {
            for (final alignItem in alignItems) {
              for (final justifyContent in justifyContents) {
                final key = '$flexDirection/$alignItem/$justifyContent';
                testGoldens(
                  key,
                  (tester) async {
                    await tester.pumpWidgetBuilder(
                      _Golden(
                        flexDirection: flexDirection,
                        alignItem: alignItem,
                        justifyContent: justifyContent,
                      ),
                      wrapper: materialAppWrapper(theme: ThemeData.light()),
                      surfaceSize: const Size(316, 166),
                    );

                    await screenMatchesGolden(tester, key);
                  },
                  skip: goldenSkip != null,
                );
              }
            }
          }
        },
        skip: goldenSkip,
      );
    },
    config: GoldenToolkitConfiguration(
      fileNameFactory: (name) => '$kGoldenFilePrefix/flex/$name.png',
    ),
  );
}

extension on WidgetTester {
  RenderBox get bar => findText('Bar').evaluate().first.renderBox;

  RenderBox get foo => findText('Foo').evaluate().first.renderBox;
}

class _Golden extends StatelessWidget {
  final String flexDirection;
  final String alignItem;
  final String justifyContent;

  const _Golden({
    required this.flexDirection,
    required this.alignItem,
    required this.justifyContent,
  });

  @override
  Widget build(BuildContext _) {
    final inlineStyle = '$kCssDisplay: $kCssDisplayFlex; '
        '$kCssFlexDirection: $flexDirection; '
        '$kCssAlignItems: $alignItem; '
        '$kCssJustifyContent: $justifyContent';
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: HtmlWidget('''
<div style="background: lightgray; height: 150px; width: 300px; $inlineStyle">
  <div style="background: red; padding: 5px">$flexDirection</div>
  <div style="background: green; margin-top: 5px; padding: 5px">$alignItem</div><!-- added margin to verify baseline alignment -->
  <div style="background: blue; color: white; padding: 5px">$justifyContent</div>
</div>'''),
      ),
    );
  }
}
