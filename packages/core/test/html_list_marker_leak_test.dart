import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:leak_tracker_flutter_testing/leak_tracker_flutter_testing.dart';

void main() {
  LeakTesting.enable();

  testWidgets(
    'disposes list marker TextPainters',
    experimentalLeakTesting: LeakTesting.settings.withTrackedAll(),
    (tester) async {
      Widget build(double fontSize) => Directionality(
            textDirection: TextDirection.ltr,
            child: DefaultTextStyle(
              style: TextStyle(fontSize: fontSize),
              child: const HtmlWidget(
                '<ul><li>a</li><li>b</li></ul><ol><li>c</li></ol>',
              ),
            ),
          );

      await tester.pumpWidget(build(10));
      await tester.pumpWidget(build(20));
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
