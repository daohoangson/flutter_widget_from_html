import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html/dom.dart' as dom;

import '_.dart' as helper;

void main() {
  // Some special test cases for BR handling, note that most of the tests for BR are in `core_test.dart`
  group('BR', () {
    testWidgets(
      'avoids WidgetSpan newline artifact before block',
      (WidgetTester tester) async {
        Widget? customWidgetBuilder(dom.Element element) {
          if (element.localName != 'x-inline') {
            return null;
          }

          return const InlineCustomWidget(
            child: SizedBox(width: 20, height: 20),
          );
        }

        // Keep BR spacing outside RichText for inline widgets before a block:
        // if a trailing newline remains in the same paragraph as WidgetSpan,
        // paragraph line metrics may produce unexpectedly large vertical gaps.
        const html = '<x-inline></x-inline><br><br><div>Next line!</div>';
        final explained = await helper.explain(
          tester,
          null,
          hw: HtmlWidget(
            html,
            customWidgetBuilder: customWidgetBuilder,
            key: helper.hwKey,
          ),
        );

        expect(
          explained,
          allOf(
            startsWith('[Column:children=['),
            contains('[SizedBox:20.0x20.0],'),
            contains('[SizedBox:0.0x10.0],'),
            contains('[CssBlock:child=[RichText:(:Next line!)]]'),
            isNot(contains('[RichText:(:[SizedBox:20.0x20.0]')),
          ),
        );
      },
    );
  });
}
