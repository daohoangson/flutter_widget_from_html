import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '_.dart';

Future<void> main() async {
  await loadAppFonts();

  group('height', () {
    testWidgets('renders em', (WidgetTester tester) async {
      const html = '<div style="height: 2em">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:height=20.0,width=100.0%,child='
          '[RichText:(:Foo)]]',
        ),
      );
    });

    testWidgets('renders pt', (WidgetTester tester) async {
      const html = '<div style="height: 100pt">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:height=133.3,width=100.0%,child='
          '[RichText:(:Foo)]'
          ']',
        ),
      );
    });

    testWidgets('renders px', (WidgetTester tester) async {
      const html = '<div style="height: 100px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:height=100.0,width=100.0%,child='
          '[RichText:(:Foo)]'
          ']',
        ),
      );
    });

    testWidgets('renders invalid', (WidgetTester tester) async {
      const html = '<div style="height: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('ignores invalid', (WidgetTester tester) async {
      const html = '<div style="height: 2em; height: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:height=20.0,width=100.0%,child='
          '[RichText:(:Foo)]]',
        ),
      );
    });
  });

  group('max-height', () {
    testWidgets('renders em', (WidgetTester tester) async {
      const html = '<div style="max-height: 2em">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:height≤20.0,width=100.0%,child='
          '[RichText:(:Foo)]'
          ']',
        ),
      );
    });

    testWidgets('renders pt', (WidgetTester tester) async {
      const html = '<div style="max-height: 100pt">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:height≤133.3,width=100.0%,child='
          '[RichText:(:Foo)]'
          ']',
        ),
      );
    });

    testWidgets('renders px', (WidgetTester tester) async {
      const html = '<div style="max-height: 100px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:height≤100.0,width=100.0%,child='
          '[RichText:(:Foo)]'
          ']',
        ),
      );
    });

    testWidgets('renders invalid', (WidgetTester tester) async {
      const html = '<div style="max-height: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('ignores invalid', (WidgetTester tester) async {
      const html = '<div style="max-height: 2em; max-height: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:height≤20.0,width=100.0%,child='
          '[RichText:(:Foo)]'
          ']',
        ),
      );
    });
  });

  group('max-width', () {
    testWidgets('renders em', (WidgetTester tester) async {
      const html = '<div style="max-width: 2em">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:width≤20.0,width=100.0%,child='
          '[RichText:(:Foo)]'
          ']',
        ),
      );
    });

    testWidgets('renders pt', (WidgetTester tester) async {
      const html = '<div style="max-width: 100pt">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:width≤133.3,width=100.0%,child='
          '[RichText:(:Foo)]'
          ']',
        ),
      );
    });

    testWidgets('renders px', (WidgetTester tester) async {
      const html = '<div style="max-width: 100px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:width≤100.0,width=100.0%,child='
          '[RichText:(:Foo)]'
          ']',
        ),
      );
    });

    testWidgets('renders invalid', (WidgetTester tester) async {
      const html = '<div style="max-width: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('ignores invalid', (WidgetTester tester) async {
      const html = '<div style="max-width: 2em">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:width≤20.0,width=100.0%,child='
          '[RichText:(:Foo)]'
          ']',
        ),
      );
    });
  });

  group('min-height', () {
    testWidgets('renders em', (WidgetTester tester) async {
      const html = '<div style="min-height: 2em">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:height≥20.0,width=100.0%,child='
          '[RichText:(:Foo)]'
          ']',
        ),
      );
    });

    testWidgets('renders pt', (WidgetTester tester) async {
      const html = '<div style="min-height: 100pt">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:height≥133.3,width=100.0%,child='
          '[RichText:(:Foo)]'
          ']',
        ),
      );
    });

    testWidgets('renders px', (WidgetTester tester) async {
      const html = '<div style="min-height: 100px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:height≥100.0,width=100.0%,child='
          '[RichText:(:Foo)]'
          ']',
        ),
      );
    });

    testWidgets('renders invalid', (WidgetTester tester) async {
      const html = '<div style="min-height: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('ignores invalid', (WidgetTester tester) async {
      const html = '<div style="min-height: 2em">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:height≥20.0,width=100.0%,child='
          '[RichText:(:Foo)]'
          ']',
        ),
      );
    });

    testWidgets('renders 100%', (WidgetTester tester) async {
      const html = '<div style="min-height: 100%">Foo</div>';
      final explained = await explain(
        tester,
        null,
        hw: SingleChildScrollView(
          child: HtmlWidget(
            html,
            key: hwKey,
          ),
        ),
      );
      expect(
        explained,
        equals(
          '[CssSizing:height≥100.0%,width=100.0%,child='
          '[RichText:(:Foo)]]',
        ),
      );
    });
  });

  group('min-width', () {
    testWidgets('renders em', (WidgetTester tester) async {
      const html = '<div style="min-width: 2em">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:width≥20.0,width=100.0%,child='
          '[RichText:(:Foo)]'
          ']',
        ),
      );
    });

    testWidgets('renders pt', (WidgetTester tester) async {
      const html = '<div style="min-width: 100pt">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:width≥133.3,width=100.0%,child='
          '[RichText:(:Foo)]'
          ']',
        ),
      );
    });

    testWidgets('renders px', (WidgetTester tester) async {
      const html = '<div style="min-width: 100px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:width≥100.0,width=100.0%,child='
          '[RichText:(:Foo)]'
          ']',
        ),
      );
    });

    testWidgets('renders invalid', (WidgetTester tester) async {
      const html = '<div style="min-width: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('ignores invalid', (WidgetTester tester) async {
      const html = '<div style="min-width: 2em">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:width≥20.0,width=100.0%,child='
          '[RichText:(:Foo)]'
          ']',
        ),
      );
    });

    testWidgets('renders 100%', (WidgetTester tester) async {
      const html = '<div style="min-width: 100%">Foo</div>';
      final explained = await explain(
        tester,
        null,
        hw: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: HtmlWidget(
            html,
            key: hwKey,
          ),
        ),
      );
      expect(
        explained,
        equals(
          '[CssSizing:width≥100.0%,width=100.0%,child='
          '[RichText:(:Foo)]]',
        ),
      );
    });
  });

  group('width', () {
    testWidgets('renders em', (WidgetTester tester) async {
      const html = '<div style="width: 2em">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:width=20.0,child='
          '[RichText:(:Foo)]'
          ']',
        ),
      );
    });

    testWidgets('renders pt', (WidgetTester tester) async {
      const html = '<div style="width: 100pt">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:width=133.3,child='
          '[RichText:(:Foo)]'
          ']',
        ),
      );
    });

    testWidgets('renders px', (WidgetTester tester) async {
      const html = '<div style="width: 100px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:width=100.0,child='
          '[RichText:(:Foo)]'
          ']',
        ),
      );
    });

    testWidgets('renders invalid', (WidgetTester tester) async {
      const html = '<div style="width: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('ignores invalid', (WidgetTester tester) async {
      const html = '<div style="width: 2em">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:width=20.0,child='
          '[RichText:(:Foo)]'
          ']',
        ),
      );
    });
  });

  testWidgets('renders complicated box', (WidgetTester tester) async {
    const html = '''
<div style="background-color: red; color: white; padding: 20px;">
  <div style="background-color: green;">
    <div style="background-color: blue; height: 100px; margin: 15px; padding: 5px; width: 100px;">
      Foo
    </div>
  </div>
</div>
''';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[Container:color=#FFFF0000,child='
        '[Padding:(20,20,20,20),child='
        '[Column:children=[SizedBox:0.0x15.0],'
        '[CssBlock:child='
        '[Container:color=#FF008000,child='
        '[CssBlock:child='
        '[HorizontalMargin:left=15,right=15,child='
        '[Container:color=#FF0000FF,child='
        '[Padding:(5,5,5,5),child='
        '[CssSizing:height=100.0,width=100.0,child='
        '[RichText:(#FFFFFFFF:Foo)]'
        ']]]]]]],'
        '[SizedBox:0.0x15.0]'
        ']]]',
      ),
    );
  });

  group('block', () {
    testWidgets('renders block within block', (WidgetTester tester) async {
      const html =
          '<div style="width: 10px; height: 10px;"><div>Foo</div></div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:height=10.0,width=10.0,child='
          '[CssBlock:child=[RichText:(:Foo)]]'
          ']',
        ),
      );
    });

    testWidgets('renders block within non-block', (tester) async {
      const html =
          '<span style="width: 10px; height: 10px;"><div>Foo</div></span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:height=10.0,width=10.0,child='
          '[CssBlock:child=[RichText:(:Foo)]]'
          ']',
        ),
      );
    });
  });

  group('inline', () {
    testWidgets('renders img with sizing', (WidgetTester tester) async {
      const src = 'https://domain.com/image.jpg';
      const html = 'Foo <img src="$src" style="width: 10px; height: 10px;" />';
      final explained = await mockNetworkImages(() => explain(tester, html));
      expect(
        explained,
        equals(
          '[RichText:(:Foo '
          '[CssSizing:height≥0.0,height=10.0,width≥0.0,width=10.0,child='
          '[Image:image=NetworkImage("$src", scale: 1.0)]'
          '])]',
        ),
      );
    });

    testWidgets('renders text-align / vertical-align', (tester) async {
      const src = 'https://domain.com/image.jpg';
      const html = '<div style="text-align: center">'
          '<img src="$src" width="10" height="10" style="vertical-align: middle" /></div>';
      final explained = await mockNetworkImages(() => explain(tester, html));
      expect(
        explained,
        equals(
          '[CssBlock:child=[RichText:align=center,'
          '[CssSizing:height≥0.0,height=10.0,width≥0.0,width=10.0,child='
          '[AspectRatio:aspectRatio=1.0,child='
          '[Image:image=NetworkImage("$src", scale: 1.0)]'
          ']]'
          '@middle]]',
        ),
      );
    });
  });

  group('CssSizing', () {
    testWidgets('updates constraints', (tester) async {
      final before = await explain(
        tester,
        '<div style="max-height: 0px; max-width: auto; min-height: 100px; min-width: 100%;">Foo</div>',
        useExplainer: false,
      );
      expect(
        before,
        contains(
          'CssSizing(maxHeight: 0.0, maxWidth: auto, '
          'minHeight: 100.0, minWidth: 100.0%, preferredWidth: 100.0%)',
        ),
      );

      final after = await explain(
        tester,
        '<div style="max-height: auto; max-width: 0px; min-height: 10px; min-width: 10%;">Foo</div>',
        useExplainer: false,
      );
      expect(
        after,
        contains(
          'CssSizing(maxHeight: auto, maxWidth: 0.0, '
          'minHeight: 10.0, minWidth: 10.0%, preferredWidth: 100.0%)',
        ),
      );
    });

    testWidgets('updates size', (tester) async {
      final before = await explain(
        tester,
        '<div style="height: 10px; width: 20px;">Foo</div>',
        useExplainer: false,
      );
      expect(
        before,
        contains(
          'CssSizing(preferredHeight: 10.0, preferredWidth*: 20.0)',
        ),
      );

      final after = await explain(
        tester,
        '<div style="width: 10px; height: 20px;">Foo</div>',
        useExplainer: false,
      );
      expect(
        after,
        contains(
          'CssSizing(preferredHeight*: 20.0, preferredWidth: 10.0)',
        ),
      );
    });

    testWidgets('computeDryLayout', (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        CssSizing(
          key: key,
          child: const SizedBox(width: 50, height: 50),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        key.renderBox.getDryLayout(const BoxConstraints()),
        equals(const Size(50, 50)),
      );
    });

    testWidgets('computeDryLayout without child', (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(CssSizing(key: key));
      await tester.pumpAndSettle();

      expect(
        key.renderBox.getDryLayout(const BoxConstraints()),
        equals(Size.zero),
      );
    });

    group('_guessChildSize with 2 dimensions', () {
      testWidgets('respect wide child', (tester) async {
        final key = GlobalKey();
        await tester.pumpWidget(
          Center(
            child: CssSizing(
              key: key,
              preferredHeight: const CssSizingValue.value(100),
              preferredWidth: const CssSizingValue.value(100),
              child: const AspectRatio(aspectRatio: 2),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(key.renderBox.size, equals(const Size(100, 50)));
      });

      testWidgets('respect wide child (vertical)', (tester) async {
        final key = GlobalKey();
        await tester.pumpWidget(
          Center(
            child: CssSizing(
              key: key,
              preferredAxis: Axis.vertical,
              preferredHeight: const CssSizingValue.value(100),
              preferredWidth: const CssSizingValue.value(100),
              child: const AspectRatio(aspectRatio: 2),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(key.renderBox.size, equals(const Size(200, 100)));
      });

      testWidgets('child too wide', (tester) async {
        final key = GlobalKey();
        await tester.pumpWidget(
          Center(
            child: CssSizing(
              key: key,
              preferredAxis: Axis.vertical,
              preferredHeight: const CssSizingValue.value(100),
              preferredWidth: const CssSizingValue.value(100),
              child: const AspectRatio(aspectRatio: 20),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(key.renderBox.size, equals(const Size(800, 40)));
      });

      testWidgets('respect tall child', (tester) async {
        final key = GlobalKey();
        await tester.pumpWidget(
          Center(
            child: CssSizing(
              key: key,
              preferredHeight: const CssSizingValue.value(100),
              preferredWidth: const CssSizingValue.value(100),
              child: const AspectRatio(aspectRatio: .5),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(key.renderBox.size, equals(const Size(100, 200)));
      });

      testWidgets('respect tall child (vertical)', (tester) async {
        final key = GlobalKey();
        await tester.pumpWidget(
          Center(
            child: CssSizing(
              key: key,
              preferredAxis: Axis.vertical,
              preferredHeight: const CssSizingValue.value(100),
              preferredWidth: const CssSizingValue.value(100),
              child: const AspectRatio(aspectRatio: .5),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(key.renderBox.size, equals(const Size(50, 100)));
      });

      testWidgets('child too tall', (tester) async {
        final key = GlobalKey();
        await tester.pumpWidget(
          Center(
            child: CssSizing(
              key: key,
              preferredHeight: const CssSizingValue.value(100),
              preferredWidth: const CssSizingValue.value(100),
              child: const AspectRatio(aspectRatio: .05),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(key.renderBox.size, equals(const Size(30, 600)));
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
          '_guessChildSize',
          () {
            setUp(() => WidgetFactory.debugDeterministicLoadingWidget = true);
            tearDown(
              () => WidgetFactory.debugDeterministicLoadingWidget = false,
            );

            const assetName = 'test/images/logo.png';
            const childHeightGtMaxHeight = 'child_height_gt_max_height';
            const testCases = <String, String>{
              'native_192x192':
                  '<img src="asset:$assetName" width="192" height="192" />',
              'child_width_gt_max_width':
                  '<img src="asset:$assetName" width="192" height="192" style="width: 96px; height: 250px;" />',
              childHeightGtMaxHeight:
                  '<img src="asset:$assetName" width="192" height="192" style="height: 96px; width: 250px;" />',
              'sized_inline_block': '''
<!-- https://github.com/daohoangson/flutter_widget_from_html/issues/799 -->
<p>
  <span style="display: inline-block; width: 18px; height: 22px; line-height: 22px; float: left; font-size: 15px; background: 0px 0px; margin-right: 4px; color: #FF6600; letter-spacing: -1px; opacity: 1;">1</span>
  <a target="_blank" href="http://domain.com" style="color: rgb(36, 64, 179); text-decoration-line: none; max-width: 260px; white-space: nowrap; text-overflow: ellipsis; overflow: hidden; vertical-align: middle; display: inline-block; -webkit-line-clamp: 1; font-variant-numeric: normal; font-variant-east-asian: normal; font-stretch: normal; font-size: 14px; line-height: 22px;">Foo</a>
  <span style="display: inline-block; padding: 0px 2px; text-align: center; vertical-align: middle; font-size: 12px; line-height: 16px; color: #FFFFFF; overflow: hidden; margin-left: 6px; height: 16px; border-radius: 4px; background-color: #FF6600;">bar</span>
</p>
''',
            };

            for (final testCase in testCases.entries) {
              testGoldens(
                testCase.key,
                (tester) async {
                  await tester.pumpWidgetBuilder(
                    _Golden(testCase.value),
                    wrapper: materialAppWrapper(theme: ThemeData.light()),
                    surfaceSize: testCase.key == childHeightGtMaxHeight
                        ? const Size(250, 200)
                        : const Size(200, 250),
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
        fileNameFactory: (name) =>
            '$kGoldenFilePrefix/sizing/_guessChildSize/$name.png',
      ),
    );

    GoldenToolkit.runWithConfiguration(
      () {
        group(
          '100 percent',
          () {
            testGoldens(
              'width',
              (tester) async {
                await tester.pumpWidgetBuilder(
                  const Scaffold(
                    body: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: HtmlWidget('<div style="width: 100%">Foo</div>'),
                      ),
                    ),
                  ),
                  wrapper: materialAppWrapper(theme: ThemeData.light()),
                  surfaceSize: const Size(200, 200),
                );

                await screenMatchesGolden(tester, 'width');
              },
              skip: goldenSkip != null,
            );

            testGoldens(
              'height',
              (tester) async {
                await tester.pumpWidgetBuilder(
                  const Scaffold(
                    body: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child:
                            HtmlWidget('<div style="height: 100%">Foo</div>'),
                      ),
                    ),
                  ),
                  wrapper: materialAppWrapper(theme: ThemeData.light()),
                  surfaceSize: const Size(200, 200),
                );

                await screenMatchesGolden(tester, 'height');
              },
              skip: goldenSkip != null,
            );
          },
          skip: goldenSkip,
        );
      },
      config: GoldenToolkitConfiguration(
        fileNameFactory: (name) =>
            '$kGoldenFilePrefix/sizing/100_percent/$name.png',
      ),
    );
  });
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
