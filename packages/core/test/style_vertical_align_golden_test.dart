import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

Future<void> main() async {
  await loadAppFonts();
  final skip =
      !Platform.isLinux || Platform.environment.containsKey('GOLDEN_SKIP');
  // Preserve the original reproduction verbatim: its top/bottom labels describe
  // the reported bug, not the expected CSS alignment.
  // https://github.com/daohoangson/flutter_widget_from_html/pull/1613#issuecomment-5356510230
  const authorHtml =
      'Normal text <span style="vertical-align:super;">Raised to full height</span> '
      'Normal text <span style="vertical-align:sub;">lowered to full height</span>\n'
      '<span style="vertical-align:top;">Relegated to the bottom of the line</span> '
      'Normal text <span style="vertical-align:bottom;">Raised to the top of the line</span>\n';

  GoldenToolkit.runWithConfiguration(() {
    for (final direction in ['ltr', 'rtl']) {
      testGoldens('author_$direction', (tester) async {
        await tester.pumpWidgetBuilder(
          Scaffold(
              body: Padding(
                  padding: const EdgeInsets.all(16),
                  child: HtmlWidget(
                    '<div dir="$direction">$authorHtml</div>',
                    textStyle: const TextStyle(fontSize: 26, height: 1.4),
                  ))),
          wrapper: materialAppWrapper(theme: ThemeData.light()),
          surfaceSize: const Size(1029, 220),
        );
        await screenMatchesGolden(tester, 'author_$direction');
      }, skip: skip);
    }
    testGoldens('sizes_and_line_heights', (tester) async {
      final html = StringBuffer();
      for (final height in [1, 1.4, 2]) {
        for (final size in [10, 26, 40]) {
          html.write('<div style="font-size:26px;line-height:$height">'
              'M ($height / $size) '
              '<span style="vertical-align:top;font-size:${size}px;background:#b2dfdb">top</span> '
              '<span style="vertical-align:bottom;font-size:${size}px;background:#bbdefb">bottom</span>'
              '</div>');
        }
      }
      await tester.pumpWidgetBuilder(
        Scaffold(
            body: Padding(
                padding: const EdgeInsets.all(16),
                child: HtmlWidget(html.toString()))),
        wrapper: materialAppWrapper(theme: ThemeData.light()),
        surfaceSize: const Size(750, 570),
      );
      await screenMatchesGolden(tester, 'sizes_and_line_heights');
    }, skip: skip);
  },
      config: GoldenToolkitConfiguration(
        fileNameFactory: (name) => 'images/vertical_align/$name.png',
      ));
}
