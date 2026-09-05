import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../lib/main.dart';

void main() {
  for (final mode in [
    RenderMode.column,
    RenderMode.listView,
    RenderMode.sliverList,
  ]) {
    for (final async in [false, true]) {
      testWidgets('first body paint ${mode.runtimeType} async=$async', (
        tester,
      ) async {
        var paints = 0;
        final html = HtmlWidget(
          '<p>Ready</p><p>Body</p>',
          buildAsync: async,
          factoryBuilder: () => PaintFactory(() => paints++),
          renderMode: mode,
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: mode == RenderMode.sliverList
                  ? CustomScrollView(slivers: [html])
                  : html,
            ),
          ),
        );
        await tester.runAsync(() async {
          for (var i = 0; i < 100 && paints == 0; i++) {
            await Future<void>.delayed(const Duration(milliseconds: 10));
            await tester.pump();
          }
        });
        expect(paints, 1);
        await tester.pump();
        expect(paints, 1);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
