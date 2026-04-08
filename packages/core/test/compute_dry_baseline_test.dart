import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '_.dart';

void main() {
  group('computeDryBaseline', () {
    testWidgets('HtmlListItem', (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HtmlListItem(
              key: key,
              marker: const Text('1.'),
              textDirection: TextDirection.ltr,
              child: const Text('Hello'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final renderBox = key.renderBox;
      final baseline = renderBox.getDryBaseline(
        renderBox.constraints,
        TextBaseline.alphabetic,
      );
      expect(baseline, isNotNull);
    });

    testWidgets('HtmlListMarker', (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HtmlListItem(
              marker: HtmlListMarker(
                key: key,
                markerType: HtmlListMarkerType.disc,
                textStyle: const TextStyle(fontSize: 14),
              ),
              textDirection: TextDirection.ltr,
              child: const Text('Hello'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final renderBox = key.renderBox;
      final baseline = renderBox.getDryBaseline(
        renderBox.constraints,
        TextBaseline.alphabetic,
      );
      expect(baseline, isNotNull);
    });

    testWidgets('HtmlRuby', (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HtmlRuby(
              key: key,
              ruby: const Text('漢'),
              rt: const Text('かん'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final renderBox = key.renderBox;
      final baseline = renderBox.getDryBaseline(
        renderBox.constraints,
        TextBaseline.alphabetic,
      );
      expect(baseline, isNotNull);
    });

    testWidgets('HtmlTable', (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        HtmlTable(
          key: key,
          children: const [
            HtmlTableCell(
              columnStart: 0,
              rowStart: 0,
              child: Text('Cell'),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final renderBox = key.renderBox;
      final baseline = renderBox.getDryBaseline(
        const BoxConstraints(maxWidth: 100, maxHeight: 100),
        TextBaseline.alphabetic,
      );
      expect(baseline, isNotNull);
    });

    testWidgets('HorizontalMargin', (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 100,
              child: HorizontalMargin(
                key: key,
                left: 10,
                right: 10,
                child: const Text('Hello'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final renderBox = key.renderBox;
      final baseline = renderBox.getDryBaseline(
        renderBox.constraints,
        TextBaseline.alphabetic,
      );
      expect(baseline, isNotNull);
    });

    testWidgets('CssSizing', (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CssSizing(
              key: key,
              child: const Text('Hello'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final renderBox = key.renderBox;
      final baseline = renderBox.getDryBaseline(
        renderBox.constraints,
        TextBaseline.alphabetic,
      );
      expect(baseline, isNotNull);
    });

    testWidgets('ValignBaseline', (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ValignBaselineContainer(
              child: ValignBaseline(
                key: key,
                index: 0,
                child: const Text('Hello'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final renderBox = key.renderBox;
      final baseline = renderBox.getDryBaseline(
        renderBox.constraints,
        TextBaseline.alphabetic,
      );
      expect(baseline, isNotNull);
    });
  });
}
