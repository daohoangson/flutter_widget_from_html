import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:flutter_widget_from_html_core/src/internal/core_ops.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '_.dart';

Future<void> main() async {
  await loadAppFonts();

  group('background-color', () {
    testWidgets('renders MARK tag', (WidgetTester tester) async {
      const html = '<mark>Foo</mark>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(color=#FFFFFF00#FF000000:Foo)]'));
    });

    testWidgets('renders block', (WidgetTester tester) async {
      const html = '<div style="background-color: #f00">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:color=#FFFF0000,child='
          '[CssBlock:child='
          '[RichText:(:Foo)]]]',
        ),
      );
    });

    testWidgets('renders with margins and paddings', (tester) async {
      const html = '<div style="background-color: #f00; '
          'margin: 1px; padding: 2px">Foo</div>';
      final explained = await explainMargin(tester, html);
      expect(
        explained,
        equals(
          '[SizedBox:0.0x1.0],'
          '[HorizontalMargin:left=1,right=1,child='
          '[Container:color=#FFFF0000,child='
          '[Padding:(2,2,2,2),child='
          '[CssBlock:child='
          '[RichText:(:Foo)]]]'
          ']],[SizedBox:0.0x1.0]',
        ),
      );
    });

    testWidgets('renders blocks', (WidgetTester tester) async {
      const h = '<div style="background-color: #f00"><p>A</p><p>B</p></div>';
      final explained = await explain(tester, h);
      expect(
        explained,
        equals(
          '[Container:color=#FFFF0000,child='
          '[CssBlock:child='
          '[Column:children='
          '[CssBlock:child=[RichText:(:A)]],'
          '[SizedBox:0.0x10.0],'
          '[CssBlock:child=[RichText:(:B)]]'
          ']]]',
        ),
      );
    });

    testWidgets('renders inline', (WidgetTester tester) async {
      const html = 'Foo <span style="background-color: #f00">bar</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo (color=#FFFF0000:bar))]'));
    });

    testWidgets('renders currentcolor', (WidgetTester tester) async {
      const html = '<div style="background-color: currentcolor">Foo</div>';
      final explained = await explain(tester, html);
      expect(explained, contains('color=#FF001234'));
    });

    group('renders without erroneous white spaces', () {
      testWidgets('before', (WidgetTester tester) async {
        const html = 'Foo<span style="background-color: #f00"> bar</span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(:Foo (color=#FFFF0000:bar))]'));
      });

      testWidgets('after', (WidgetTester tester) async {
        const html = 'Foo <span style="background-color: #f00">bar </span>';
        final explained = await explain(tester, html);
        expect(explained, equals('[RichText:(:Foo (color=#FFFF0000:bar))]'));
      });
    });

    testWidgets('resets in continuous SPANs', (tester) async {
      // https://github.com/daohoangson/flutter_widget_from_html/issues/155
      const html =
          '<span style="color: #ff0; background-color:#00f;">Foo</span>'
          '<span style="color: #f00;">bar</span>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[RichText:(:(color=#FF0000FF#FFFFFF00:Foo)(#FFFF0000:bar))]',
        ),
      );
    });
  });

  group('background-image', () {
    testWidgets('renders network', (WidgetTester tester) async {
      const src = 'http://domain.com/image.png';
      const html = '<div style="background-image: url($src)">Foo</div>';
      final explained = await mockNetworkImages(() => explain(tester, html));
      expect(
        explained,
        equals(
          '[Container:image=NetworkImage("$src", scale: 1.0),child='
          '[CssBlock:child=[RichText:(:Foo)]]'
          ']',
        ),
      );
    });

    group('asset', () {
      const assetName = 'test/images/logo.png';

      testWidgets('renders asset', (WidgetTester tester) async {
        const html =
            '<div style="background-image: url(asset:$assetName)">Foo</div>';
        final explained = await explain(tester, html);
        expect(
          explained,
          equals(
            '[Container:image=AssetImage(bundle: null, name: "$assetName"),child='
            '[CssBlock:child=[RichText:(:Foo)]]'
            ']',
          ),
        );
      });

      testWidgets('renders asset (specified package)', (tester) async {
        const package = 'flutter_widget_from_html_core';
        const html =
            '<div style="background-image: url(asset:$assetName?package=$package)">Foo</div>';
        final explained = await explain(tester, html);
        expect(
          explained,
          equals(
            '[Container:image=AssetImage(bundle: null, name: "packages/$package/$assetName"),child='
            '[CssBlock:child=[RichText:(:Foo)]]'
            ']',
          ),
        );
      });
    });

    testWidgets('data uri', (WidgetTester tester) async {
      const html = '<div style="background-image: url($kDataUri)">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:image=MemoryImage(bytes, scale: 1.0),child='
          '[CssBlock:child=[RichText:(:Foo)]]'
          ']',
        ),
      );
    });

    testWidgets('file uri', (WidgetTester tester) async {
      final filePath = '${Directory.current.path}/test/images/logo.png';
      final fileUri = 'file://$filePath';
      final html = '<div style="background-image: url($fileUri)">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:image=FileImage("$filePath", scale: 1.0),child='
          '[CssBlock:child=[RichText:(:Foo)]]'
          ']',
        ),
      );
    });

    group('background-position', () {
      const backgroundAssetImage =
          'background-image: url(asset:test/images/logo.png)';

      final positionTestCases = ValueVariant<_PositionTestCase>(
        {
          // bottom
          'bottom'.position(Alignment.bottomCenter),
          'bottom bottom'.position(Alignment.bottomCenter),
          'bottom center'.position(Alignment.bottomCenter),
          'bottom left'.position(Alignment.bottomLeft),
          'bottom right'.position(Alignment.bottomRight),
          'bottom top'.position(Alignment.bottomCenter),

          // center
          'center'.position(Alignment.center),
          'center bottom'.position(Alignment.bottomCenter),
          'center center'.position(Alignment.center),
          'center left'.position(Alignment.centerLeft),
          'center right'.position(Alignment.centerRight),
          'center top'.position(Alignment.topCenter),

          // left
          'left'.position(Alignment.centerLeft),
          'left bottom'.position(Alignment.bottomLeft),
          'left center'.position(Alignment.centerLeft),
          'left left'.position(Alignment.centerLeft),
          'left right'.position(Alignment.centerLeft),
          'left top'.position(Alignment.topLeft),

          // right
          'right'.position(Alignment.centerRight),
          'right bottom'.position(Alignment.bottomRight),
          'right center'.position(Alignment.centerRight),
          'right left'.position(Alignment.centerRight),
          'right right'.position(Alignment.centerRight),
          'right top'.position(Alignment.topRight),

          // top
          'top'.position(Alignment.topCenter),
          'top bottom'.position(Alignment.topCenter),
          'top center'.position(Alignment.topCenter),
          'top left'.position(Alignment.topLeft),
          'top right'.position(Alignment.topRight),
          'top top'.position(Alignment.topCenter),

          // default
          'foo'.position(Alignment.topLeft),
        },
      );

      testWidgets(
        'renders alignment',
        (WidgetTester tester) async {
          final testCase = positionTestCases.currentValue!;
          final html = '<div style="$backgroundAssetImage; '
              'background-position: ${testCase.value}">Foo</div>';

          await explain(tester, html);
          final container = tester.widget<Container>(find.byType(Container));
          expect(
            container.decoration,
            isA<BoxDecoration>().having(
              (deco) => deco.image?.alignment,
              'image.alignment',
              equals(testCase.alignment),
            ),
          );
        },
        variant: positionTestCases,
      );
    });
  });

  group('shorthand', () {
    const assetName = 'test/images/logo.png';
    const assetImage = 'AssetImage(bundle: null, name: "$assetName")';

    testWidgets('renders color', (WidgetTester tester) async {
      const html = 'Foo <span style="background: #f00">bar</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo (color=#FFFF0000:bar))]'));
    });

    testWidgets('renders image', (WidgetTester tester) async {
      const html = '<div style="background: url(asset:$assetName)">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:image=$assetImage,child='
          '[CssBlock:child=[RichText:(:Foo)]]'
          ']',
        ),
      );
    });

    testWidgets('renders position (single)', (WidgetTester tester) async {
      const html =
          '<div style="background: url(asset:$assetName) right">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:image=$assetImage,alignment=centerRight,child='
          '[CssBlock:child=[RichText:(:Foo)]]'
          ']',
        ),
      );
    });

    testWidgets('renders position (double)', (WidgetTester tester) async {
      const html =
          '<div style="background: url(asset:$assetName) bottom right">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:image=$assetImage,alignment=bottomRight,child='
          '[CssBlock:child=[RichText:(:Foo)]]'
          ']',
        ),
      );
    });

    testWidgets('renders repeat', (WidgetTester tester) async {
      const html =
          '<div style="background: url(asset:$assetName) repeat">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:image=$assetImage,repeat=repeat,child='
          '[CssBlock:child=[RichText:(:Foo)]]'
          ']',
        ),
      );
    });

    testWidgets('renders size', (WidgetTester tester) async {
      const html =
          '<div style="background: url(asset:$assetName) cover">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:image=$assetImage,fit=cover,child='
          '[CssBlock:child=[RichText:(:Foo)]]'
          ']',
        ),
      );
    });

    testWidgets('renders everything', (WidgetTester tester) async {
      const html = '<div style="background: #f00 '
          'url(asset:$assetName) bottom right repeat cover">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:color=#FFFF0000,'
          'image=$assetImage,'
          'alignment=bottomRight,'
          'fit=cover,'
          'repeat=repeat,'
          'child=[CssBlock:child=[RichText:(:Foo)]]]',
        ),
      );
    });

    testWidgets('renders unrecognized values', (WidgetTester tester) async {
      const html = '<div style="background: foo1 #f00 foo2 '
          'url(asset:$assetName) foo3 bottom right '
          'foo4 repeat foo5 cover">Foo</div>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Container:color=#FFFF0000,'
          'image=$assetImage,'
          'alignment=bottomRight,'
          'fit=cover,'
          'repeat=repeat,'
          'child=[CssBlock:child=[RichText:(:Foo)]]]',
        ),
      );
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
        'background-image',
        () {
          const image44 = 'background-image: url(asset:test/images/44px.png)';
          const size100x75 = 'width: 100px; height: 75px';
          const size100x100 = 'width: 100px; height: 100px';
          const testCases = <String, String>{
            'position/center':
                '<div style="background-position: center; $image44; $size100x100">Foo</div>',
            'position/top':
                '<div style="background-position: top; $image44; $size100x100">Foo</div>',
            'position/top_right':
                '<div style="background-position: top right; $image44; $size100x100">Foo</div>',
            'position/right':
                '<div style="background-position: right; $image44; $size100x100">Foo</div>',
            'position/bottom_right':
                '<div style="background-position: bottom right; $image44; $size100x100">Foo</div>',
            'position/bottom':
                '<div style="background-position: bottom; $image44; $size100x100">Foo</div>',
            'position/bottom_left':
                '<div style="background-position: bottom left; $image44; $size100x100">Foo</div>',
            'position/left':
                '<div style="background-position: left; $image44; $size100x100">Foo</div>',
            'position/top_left':
                '<div style="background-position: top left; $image44; $size100x100">Foo</div>',
            'repeat/no-repeat':
                '<div style="background-repeat: no-repeat; $image44; $size100x100">Foo</div>',
            'repeat/repeat-x':
                '<div style="background-repeat: repeat-x; $image44; $size100x100">Foo</div>',
            'repeat/repeat-y':
                '<div style="background-repeat: repeat-y; $image44; $size100x100">Foo</div>',
            'repeat/repeat':
                '<div style="background-repeat: repeat; $image44; $size100x100">Foo</div>',
            'size/auto':
                '<div style="background-size: auto; $image44; $size100x75">Foo</div>',
            'size/contain':
                '<div style="background-size: contain; $image44; $size100x75">Foo</div>',
            'size/cover':
                '<div style="background-size: cover; $image44; $size100x75">Foo</div>',
          };

          for (final testCase in testCases.entries) {
            testGoldens(
              testCase.key,
              (tester) async {
                await tester.pumpWidgetBuilder(
                  _Golden(testCase.value),
                  wrapper: materialAppWrapper(theme: ThemeData.light()),
                  surfaceSize: const Size(116, 116),
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
      fileNameFactory: (name) => '$kGoldenFilePrefix/background/$name.png',
    ),
  );
}

extension on String {
  _PositionTestCase position(AlignmentGeometry alignment) =>
      _PositionTestCase(this, alignment);
}

class _Golden extends StatelessWidget {
  final String html;

  const _Golden(this.html);

  @override
  Widget build(BuildContext _) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: HtmlWidget(
            html,
            customStylesBuilder: (element) {
              if (element.localName == 'div') {
                return const {kCssBackgroundColor: 'lightgray'};
              }

              return null;
            },
          ),
        ),
      );
}

@immutable
class _PositionTestCase {
  final String value;
  final AlignmentGeometry alignment;
  const _PositionTestCase(this.value, this.alignment);

  @override
  String toString() => value;
}
