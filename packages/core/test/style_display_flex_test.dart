import 'dart:io';

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

      await tester.runAsync(() => Future.delayed(Duration.zero));
      await tester.pump();
      final built = await explainWithoutPumping(useExplainer: false);
      expect(built, isNot(contains('ProgressIndicator')));

      final box =
          find.byType(RichText).evaluate().first.renderObject! as RenderBox;
      expect(box.size.width, equals(tester.windowWidth));
    });

    testWidgets('#1152: renders super wide block', (tester) async {
      final lipsum =
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. ' * 999;
      final html =
          '<div style="display: flex"><div>Foo</div><div>$lipsum</div></div>';
      final building = await explain(tester, html, useExplainer: false);
      expect(building, contains('ProgressIndicator'));

      await tester
          .runAsync(() => Future.delayed(const Duration(milliseconds: 10)));
      await tester.pump();
      final built = await explainWithoutPumping(useExplainer: false);
      expect(built, isNot(contains('ProgressIndicator')));

      final elements = find.byType(RichText).evaluate();
      final size = elements
          .map((element) => (element.renderObject! as RenderBox).size.width)
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
      final box = findText('Foo').evaluate().first.renderObject! as RenderBox;
      expect(box.size.width, equals(tester.windowWidth));
    });

    testWidgets('renders super wide contents with margins', (tester) async {
      const html = '<div style="display: flex; margin: 5px">'
          '<div style="width: 9999px">Foo</div>'
          '</div>';
      await explain(tester, html);
      final box1 = findText('Foo').evaluate().first.renderObject! as RenderBox;
      expect(box1.size.width, equals(tester.windowWidth - 10));

      await explain(tester, html.replaceFirst('margin: 5px', 'margin: 50px'));
      final box2 = findText('Foo').evaluate().first.renderObject! as RenderBox;
      expect(box2.size.width, equals(tester.windowWidth - 100));
    });

    testWidgets('renders super tall contents', (WidgetTester tester) async {
      const html = '<div style="display: flex; flex-direction: column">'
          '<div style="height: 9999px">Foo</div>'
          '</div>';
      await explain(tester, html);
      final box = findText('Foo').evaluate().first.renderObject! as RenderBox;
      expect(box.size.height, equals(tester.windowHeight));
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
