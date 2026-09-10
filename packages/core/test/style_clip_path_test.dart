import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:flutter_widget_from_html_core/src/internal/core_ops.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '_.dart';

Future<void> main() async {
  await loadAppFonts();
  Future<CssClipPathClipper> getClipper(
      WidgetTester tester, String style) async {
    final html =
        '<div style="width: 200px; height: 100px; clip-path: $style">Foo</div>';
    await explain(tester, html);

    final clipPath = tester.widget<ClipPath>(find.byType(ClipPath));
    final clipper = clipPath.clipper;
    expect(clipper, isA<CssClipPathClipper>());

    return clipper! as CssClipPathClipper;
  }

  testWidgets('polygon', (WidgetTester tester) async {
    final clipper = await getClipper(
      tester,
      'polygon(0% 0%, 100% 0%, 50% 100%)',
    );

    final path = clipper.getClip(const Size(200, 100));
    expect(path.contains(const Offset(100, 20)), isTrue);
    expect(path.contains(const Offset(20, 90)), isFalse);
  });

  testWidgets('circle', (WidgetTester tester) async {
    final clipper = await getClipper(tester, 'circle(25% at 50% 50%)');

    // On a 200x100 box the spec resolves % against sqrt(w²+h²)/sqrt(2):
    //   sqrt(200²+100²)/sqrt(2) * 25% ≈ 39.5px
    // A point 35px from the centre must be inside (visible with correct radius,
    // would be outside with the wrong min(w,h)=100 * 25% = 25px radius).
    final path = clipper.getClip(const Size(200, 100));
    expect(path.contains(const Offset(100, 50)), isTrue);
    expect(path.contains(const Offset(135, 50)), isTrue); // 35px from centre, within ~39.5px radius
    expect(path.contains(const Offset(160, 50)), isFalse); // 60px from centre, outside
  });

  testWidgets('ellipse', (WidgetTester tester) async {
    final clipper = await getClipper(tester, 'ellipse(25% 40% at 50% 50%)');

    final path = clipper.getClip(const Size(200, 100));
    expect(path.contains(const Offset(100, 50)), isTrue);
    expect(path.contains(const Offset(10, 50)), isFalse);
  });

  testWidgets('inset', (WidgetTester tester) async {
    final clipper = await getClipper(tester, 'inset(10% 20% 30% 40%)');

    final path = clipper.getClip(const Size(200, 100));
    expect(path.contains(const Offset(100, 40)), isTrue);
    expect(path.contains(const Offset(40, 10)), isFalse);
  });

  testWidgets('inset round', (WidgetTester tester) async {
    final clipper =
        await getClipper(tester, 'inset(10% 20% 30% 40% round 20px)');

    final path = clipper.getClip(const Size(200, 100));
    expect(path.contains(const Offset(100, 40)), isTrue);
    expect(path.contains(const Offset(81, 11)), isFalse);
  });

  testWidgets('rect', (WidgetTester tester) async {
    // rect(top right bottom left): absolute edge coordinates (not insets).
    // rect(10% 80% 90% 20%) on 200x100 → visible rect x:[40,160], y:[10,90].
    final clipper = await getClipper(tester, 'rect(10% 80% 90% 20%)');

    final path = clipper.getClip(const Size(200, 100));
    expect(path.contains(const Offset(100, 50)), isTrue);
    expect(path.contains(const Offset(30, 5)), isFalse);
  });

  testWidgets('rect round', (WidgetTester tester) async {
    final clipper =
        await getClipper(tester, 'rect(10% 80% 90% 20% round 10px)');

    // Same visible area as plain rect, points near the corner are cut by the
    // rounded corner.
    final path = clipper.getClip(const Size(200, 100));
    expect(path.contains(const Offset(100, 50)), isTrue);
    expect(path.contains(const Offset(41, 11)), isFalse); // just inside corner, clipped by radius
  });

  testWidgets('xywh', (WidgetTester tester) async {
    final clipper = await getClipper(tester, 'xywh(10% 20% 50% 40%)');

    final path = clipper.getClip(const Size(200, 100));
    expect(path.contains(const Offset(60, 40)), isTrue);
    expect(path.contains(const Offset(10, 10)), isFalse);
  });

  testWidgets('xywh round', (WidgetTester tester) async {
    // xywh(10% 20% 50% 40% round 10px): origin (20,20), size (100,40).
    // Corner at (20,20); a point just inside the corner box is cut by radius.
    final clipper =
        await getClipper(tester, 'xywh(10% 20% 50% 40% round 10px)');

    final path = clipper.getClip(const Size(200, 100));
    expect(path.contains(const Offset(70, 40)), isTrue);
    expect(path.contains(const Offset(21, 21)), isFalse); // clipped by radius
  });

  testWidgets('none', (WidgetTester tester) async {
    const html = '<div style="clip-path: none">Foo</div>';
    await explain(tester, html);

    expect(find.byType(ClipPath), findsNothing);
  });

  // path("...") requires SvgFactory — without it the widget is not clipped.
  testWidgets('path() no-op without SvgFactory', (WidgetTester tester) async {
    const html =
        '<div style="clip-path: path(\'M 0 0 L 100 0 L 50 100 Z\')">Foo</div>';
    await explain(tester, html);

    expect(find.byType(ClipPath), findsNothing);
  });

  group('empty element', () {
    // Regression: empty divs with explicit size + clip-path must render a
    // ClipPath. Previously _sizingBlock bailed on isEmpty, leaving the element
    // at 0x0 and invisible.
    testWidgets('circle on empty div', (WidgetTester tester) async {
      const html =
          '<div style="width: 200px; height: 100px; clip-path: circle(50% at 50% 50%)"></div>';
      await explain(tester, html);

      expect(find.byType(ClipPath), findsOneWidget);
      final clipPath = tester.widget<ClipPath>(find.byType(ClipPath));
      expect(clipPath.clipper, isA<CssClipPathClipper>());
    });

    testWidgets('polygon on empty div', (WidgetTester tester) async {
      const html =
          '<div style="width: 200px; height: 100px; clip-path: polygon(0% 0%, 100% 0%, 50% 100%)"></div>';
      await explain(tester, html);

      expect(find.byType(ClipPath), findsOneWidget);
    });

    testWidgets('empty div without clip-path collapses', (WidgetTester tester) async {
      const html = '<div></div>';
      await explain(tester, html);

      expect(find.byType(ClipPath), findsNothing);
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
        'goldens',
        () {
          const testCases = <String, String>{
            'polygon': '<div style="width: 100px; height: 100px; background: #E91E63; clip-path: polygon(0% 0%, 100% 0%, 50% 100%);"></div>',
            'circle': '<div style="width: 100px; height: 100px; background: #2196F3; clip-path: circle(50% at 50% 50%);"></div>',
            'ellipse': '<div style="width: 100px; height: 100px; background: #4CAF50; clip-path: ellipse(25% 40% at 50% 50%);"></div>',
            'inset': '<div style="width: 100px; height: 100px; background: #FF9800; clip-path: inset(10% 20% round 8px);"></div>',
            'rect': '<div style="width: 100px; height: 100px; background: #9C27B0; clip-path: rect(10% 80% 90% 20%);"></div>',
            'rect_round': '<div style="width: 100px; height: 100px; background: #9C27B0; clip-path: rect(10% 80% 90% 20% round 10px);"></div>',
            'xywh': '<div style="width: 100px; height: 100px; background: #00BCD4; clip-path: xywh(10% 20% 50% 40%);"></div>',
            'xywh_round': '<div style="width: 100px; height: 100px; background: #00BCD4; clip-path: xywh(10% 20% 50% 40% round 10px);"></div>',
            'none': '<div style="width: 100px; height: 100px; background: #795548; clip-path: none;"></div>',
            // path() requires SvgFactory; without it the element renders unclipped.
            'path': '<div style="width: 100px; height: 100px; background: #000; clip-path: path(\'M 50 5 L 61 35 L 95 35 L 68 57 L 79 91 L 50 70 L 21 91 L 32 57 L 5 35 L 39 35 Z\');"></div>',
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
      fileNameFactory: (name) => '$kGoldenFilePrefix/clip_path/$name.png',
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
