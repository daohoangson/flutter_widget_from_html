import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '_.dart';

void main() {
  group('height', () {
    testWidgets('renders em', (WidgetTester tester) async {
      final html = '<div style="height: 2em">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:height=20.0,width=100.0%,child='
              '[RichText:(:Foo)]]'));
    });

    testWidgets('renders pt', (WidgetTester tester) async {
      final html = '<div style="height: 100pt">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:height=133.3,width=100.0%,child='
              '[RichText:(:Foo)]'
              ']'));
    });

    testWidgets('renders px', (WidgetTester tester) async {
      final html = '<div style="height: 100px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:height=100.0,width=100.0%,child='
              '[RichText:(:Foo)]'
              ']'));
    });

    testWidgets('renders invalid', (WidgetTester tester) async {
      final html = '<div style="height: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('ignores invalid', (WidgetTester tester) async {
      final html = '<div style="height: 2em; height: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:height=20.0,width=100.0%,child='
              '[RichText:(:Foo)]]'));
    });
  });

  group('max-height', () {
    testWidgets('renders em', (WidgetTester tester) async {
      final html = '<div style="max-height: 2em">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:height≤20.0,width=100.0%,child='
              '[RichText:(:Foo)]'
              ']'));
    });

    testWidgets('renders pt', (WidgetTester tester) async {
      final html = '<div style="max-height: 100pt">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:height≤133.3,width=100.0%,child='
              '[RichText:(:Foo)]'
              ']'));
    });

    testWidgets('renders px', (WidgetTester tester) async {
      final html = '<div style="max-height: 100px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:height≤100.0,width=100.0%,child='
              '[RichText:(:Foo)]'
              ']'));
    });

    testWidgets('renders invalid', (WidgetTester tester) async {
      final html = '<div style="max-height: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('ignores invalid', (WidgetTester tester) async {
      final html = '<div style="max-height: 2em; max-height: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:height≤20.0,width=100.0%,child='
              '[RichText:(:Foo)]'
              ']'));
    });
  });

  group('max-width', () {
    testWidgets('renders em', (WidgetTester tester) async {
      final html = '<div style="max-width: 2em">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:width≤20.0,width=100.0%,child='
              '[RichText:(:Foo)]'
              ']'));
    });

    testWidgets('renders pt', (WidgetTester tester) async {
      final html = '<div style="max-width: 100pt">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:width≤133.3,width=100.0%,child='
              '[RichText:(:Foo)]'
              ']'));
    });

    testWidgets('renders px', (WidgetTester tester) async {
      final html = '<div style="max-width: 100px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:width≤100.0,width=100.0%,child='
              '[RichText:(:Foo)]'
              ']'));
    });

    testWidgets('renders invalid', (WidgetTester tester) async {
      final html = '<div style="max-width: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('ignores invalid', (WidgetTester tester) async {
      final html = '<div style="max-width: 2em">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:width≤20.0,width=100.0%,child='
              '[RichText:(:Foo)]'
              ']'));
    });
  });

  group('min-height', () {
    testWidgets('renders em', (WidgetTester tester) async {
      final html = '<div style="min-height: 2em">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:height≥20.0,width=100.0%,child='
              '[RichText:(:Foo)]'
              ']'));
    });

    testWidgets('renders pt', (WidgetTester tester) async {
      final html = '<div style="min-height: 100pt">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:height≥133.3,width=100.0%,child='
              '[RichText:(:Foo)]'
              ']'));
    });

    testWidgets('renders px', (WidgetTester tester) async {
      final html = '<div style="min-height: 100px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:height≥100.0,width=100.0%,child='
              '[RichText:(:Foo)]'
              ']'));
    });

    testWidgets('renders invalid', (WidgetTester tester) async {
      final html = '<div style="min-height: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('ignores invalid', (WidgetTester tester) async {
      final html = '<div style="min-height: 2em">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:height≥20.0,width=100.0%,child='
              '[RichText:(:Foo)]'
              ']'));
    });
  });

  group('min-width', () {
    testWidgets('renders em', (WidgetTester tester) async {
      final html = '<div style="min-width: 2em">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:width≥20.0,width=100.0%,child='
              '[RichText:(:Foo)]'
              ']'));
    });

    testWidgets('renders pt', (WidgetTester tester) async {
      final html = '<div style="min-width: 100pt">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:width≥133.3,width=100.0%,child='
              '[RichText:(:Foo)]'
              ']'));
    });

    testWidgets('renders px', (WidgetTester tester) async {
      final html = '<div style="min-width: 100px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:width≥100.0,width=100.0%,child='
              '[RichText:(:Foo)]'
              ']'));
    });

    testWidgets('renders invalid', (WidgetTester tester) async {
      final html = '<div style="min-width: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('ignores invalid', (WidgetTester tester) async {
      final html = '<div style="min-width: 2em">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:width≥20.0,width=100.0%,child='
              '[RichText:(:Foo)]'
              ']'));
    });
  });

  group('width', () {
    testWidgets('renders em', (WidgetTester tester) async {
      final html = '<div style="width: 2em">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:width=20.0,child='
              '[RichText:(:Foo)]'
              ']'));
    });

    testWidgets('renders pt', (WidgetTester tester) async {
      final html = '<div style="width: 100pt">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:width=133.3,child='
              '[RichText:(:Foo)]'
              ']'));
    });

    testWidgets('renders px', (WidgetTester tester) async {
      final html = '<div style="width: 100px">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:width=100.0,child='
              '[RichText:(:Foo)]'
              ']'));
    });

    testWidgets('renders invalid', (WidgetTester tester) async {
      final html = '<div style="width: xxx">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, equals('[CssBlock:child=[RichText:(:Foo)]]'));
    });

    testWidgets('ignores invalid', (WidgetTester tester) async {
      final html = '<div style="width: 2em">Foo</div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:width=20.0,child='
              '[RichText:(:Foo)]'
              ']'));
    });
  });

  testWidgets('renders complicated box', (WidgetTester tester) async {
    final html = '''
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
        equals('[CssBlock:child=[DecoratedBox:bg=#FFFF0000,child='
            '[Padding:(20,20,20,20),child='
            '[CssBlock:child=[DecoratedBox:bg=#FF008000,child='
            '[Padding:(0,15,0,15),child='
            '[CssSizing:height=100.0,width=100.0,child='
            '[DecoratedBox:bg=#FF0000FF,child='
            '[Padding:(5,5,5,5),child='
            '[RichText:(#FFFFFFFF:Foo)]'
            ']]]]]]]]]'));
  });

  group('block', () {
    testWidgets('renders block within block', (WidgetTester tester) async {
      final html =
          '<div style="width: 10px; height: 10px;"><div>Foo</div></div>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:height=10.0,width=10.0,child='
              '[CssBlock:child=[RichText:(:Foo)]]'
              ']'));
    });

    testWidgets('renders block within non-block', (tester) async {
      final html =
          '<span style="width: 10px; height: 10px;"><div>Foo</div></span>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:height=10.0,width=10.0,child='
              '[CssBlock:child=[RichText:(:Foo)]]'
              ']'));
    });
  });

  group('inline', () {
    testWidgets('renders img with sizing', (WidgetTester tester) async {
      final src = 'https://domain.com/image.jpg';
      final html = 'Foo <img src="$src" style="width: 10px; height: 10px;" />';
      final explained = await mockNetworkImagesFor(() => explain(tester, html));
      expect(
          explained,
          equals('[RichText:(:Foo '
              '[CssSizing:height≥0.0,height=10.0,width≥0.0,width=10.0,child=[Image:image=NetworkImage("$src", scale: 1.0)]]'
              ')]'));
    });

    testWidgets('renders text-align / vertical-align', (tester) async {
      final src = 'https://domain.com/image.jpg';
      final html = '<div style="text-align: center">'
          '<img src="$src" width="10" height="10" style="vertical-align: middle" /></div>';
      final explained = await mockNetworkImagesFor(() => explain(tester, html));
      expect(
          explained,
          equals('[_TextAlignBlock:child=[RichText:align=center,'
              '[CssSizing:height≥0.0,height=10.0,width≥0.0,width=10.0,child='
              '[AspectRatio:aspectRatio=1.0,child='
              '[Image:image=NetworkImage("$src", scale: 1.0)]'
              ']]'
              '@middle]]'));
    });
  });

  group('CssSizing', () {
    testWidgets('updates constraints', (tester) async {
      final before = await explain(tester,
          '<div style="max-height: 0px; max-width: auto; min-height: 100px; min-width: 100%;">Foo</div>',
          useExplainer: false);
      expect(
          before,
          contains('CssSizing(maxHeight: 0.0, maxWidth: auto, '
              'minHeight: 100.0, minWidth: 100.0%, preferredWidth: 100.0%)'));

      final after = await explain(tester,
          '<div style="max-height: auto; max-width: 0px; min-height: 10px; min-width: 10%;">Foo</div>',
          useExplainer: false);
      expect(
          after,
          contains('CssSizing(maxHeight: auto, maxWidth: 0.0, '
              'minHeight: 10.0, minWidth: 10.0%, preferredWidth: 100.0%)'));
    });

    testWidgets('updates size', (tester) async {
      final before = await explain(
          tester, '<div style="height: 10px; width: 20px;">Foo</div>',
          useExplainer: false);
      expect(before,
          contains('CssSizing(preferredHeight: 10.0, preferredWidth*: 20.0)'));

      final after = await explain(
          tester, '<div style="width: 10px; height: 20px;">Foo</div>',
          useExplainer: false);
      expect(after,
          contains('CssSizing(preferredHeight*: 20.0, preferredWidth: 10.0)'));
    });

    final goldenSkip = Platform.isLinux ? null : 'Linux only';
    GoldenToolkit.runWithConfiguration(
      () {
        group('_guessChildSize', () {
          final assetName = 'test/images/logo.png';
          final childHeightGtMaxHeight = 'child_height_gt_max_height';
          final testCases = <String, String>{
            'native_192x192':
                '<img src="asset:$assetName" width="192" height="192" />',
            'child_width_gt_max_width':
                '<img src="asset:$assetName" width="192" height="192" style="width: 96px; height: 250px;" />',
            childHeightGtMaxHeight:
                '<img src="asset:$assetName" width="192" height="192" style="height: 96px; width: 250px;" />'
          };

          for (final testCase in testCases.entries) {
            testGoldens(testCase.key, (tester) async {
              await tester.pumpWidgetBuilder(
                _Golden(testCase.value),
                wrapper: materialAppWrapper(theme: ThemeData.light()),
                surfaceSize: testCase.key == childHeightGtMaxHeight
                    ? Size(250, 200)
                    : Size(200, 250),
              );

              await screenMatchesGolden(tester, testCase.key);
            }, skip: null);
          }
        }, skip: goldenSkip);
      },
      config: GoldenToolkitConfiguration(
        fileNameFactory: (name) =>
            '$kGoldenFilePrefix/sizing/_guessChildSize/$name.png',
      ),
    );

    GoldenToolkit.runWithConfiguration(
      () {
        group('100 percent', () {
          testGoldens('width', (tester) async {
            await tester.pumpWidgetBuilder(
              Scaffold(
                body: SingleChildScrollView(
                  child: Padding(
                    child: HtmlWidget('<div style="width: 100%">Foo</div>'),
                    padding: const EdgeInsets.all(8.0),
                  ),
                  scrollDirection: Axis.horizontal,
                ),
              ),
              wrapper: materialAppWrapper(theme: ThemeData.light()),
              surfaceSize: Size(200, 200),
            );

            await screenMatchesGolden(tester, 'width');
          }, skip: null);

          testGoldens('height', (tester) async {
            await tester.pumpWidgetBuilder(
              Scaffold(
                body: SingleChildScrollView(
                    child: Padding(
                      child: HtmlWidget('<div style="height: 100%">Foo</div>'),
                      padding: const EdgeInsets.all(8.0),
                    ),
                    scrollDirection: Axis.vertical),
              ),
              wrapper: materialAppWrapper(theme: ThemeData.light()),
              surfaceSize: Size(200, 200),
            );

            await screenMatchesGolden(tester, 'height');
          }, skip: null);
        }, skip: goldenSkip);
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

  const _Golden(this.html, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext _) => Scaffold(
        body: Padding(
          child: HtmlWidget(html),
          padding: const EdgeInsets.all(8.0),
        ),
      );
}
