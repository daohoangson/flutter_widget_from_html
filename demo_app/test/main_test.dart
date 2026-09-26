import 'package:demo_app/main.dart';
import 'package:flutter/material.dart' as legacy;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:material_ui/material_ui.dart';

import '../../packages/fwfh_chewie/test/mock_video_player_platform.dart';

void main() {
  mockVideoPlayerPlatform();

  for (final brightness in Brightness.values) {
    testWidgets('demo uses material_ui in $brightness mode', (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = brightness;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final home = tester.element(find.text('Demo app'));
      Navigator.of(home).pushNamed('/smilie');
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(HtmlWidget));
      final resolved = resolveMaterialThemeMode(
        context,
        MaterialThemeMode.auto,
      );
      expect(resolved.mode, MaterialThemeMode.materialUi);
      expect(resolved.brightness, brightness);
      expect(resolved.primaryColor, Theme.of(context).colorScheme.primary);
      expect(find.textContaining('Hello', findRichText: true), findsWidgets);

      // Legacy video controls must inherit matching colors and localizations.
      expect(legacy.Theme.of(context).brightness, brightness);
      expect(
        legacy.Theme.of(context).colorScheme.primary,
        resolved.primaryColor,
      );
      expect(
        legacy.MaterialLocalizations.of(context).backButtonTooltip,
        'Back',
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('legacy video controls work in the material_ui demo', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    Navigator.of(tester.element(find.text('Demo app'))).pushNamed('/video');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(CheckboxListTile, 'controls'));
    await tester.pumpAndSettle();

    expect(find.byIcon(legacy.Icons.fullscreen), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
}
