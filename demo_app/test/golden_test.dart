import 'dart:convert';
import 'dart:io';

import 'package:demo_app/screens/golden.dart';
import 'package:demo_app/widgets/popup_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../packages/fwfh_chewie/test/mock_video_player_platform.dart';
import '../../packages/fwfh_webview/test/mock_webview_platform.dart';

final goldenSkipEnvVar = Platform.environment['GOLDEN_SKIP'];
final goldenSkip = goldenSkipEnvVar == null
    ? Platform.isLinux
        ? null
        : 'Linux only'
    : 'GOLDEN_SKIP=$goldenSkipEnvVar';

void _test(
  String name,
  String html, {
  bool isSelectable = false,
  double textScaleSize = 1.0,
}) =>
    testGoldens(
      name,
      (tester) async {
        const platform = TargetPlatform.android;
        debugDefaultTargetPlatformOverride = platform;
        WidgetFactory.debugDeterministicLoadingWidget = true;
        final key = UniqueKey();

        await tester.pumpWidgetBuilder(
          PopupMenuStateProvider(
            builder: (_) => Golden(name, html, targetKey: key),
            initialIsSelectable: isSelectable,
          ),
          wrapper: materialAppWrapper(
            platform: platform,
            theme: ThemeData.light(),
          ),
          surfaceSize: const Size(400, 1200),
          textScaleSize: textScaleSize,
        );

        await screenMatchesGolden(tester, name, finder: find.byKey(key));
        debugDefaultTargetPlatformOverride = null;
        WidgetFactory.debugDeterministicLoadingWidget = false;
      },
      skip: goldenSkip != null,
    );

void main() {
  mockVideoPlayerPlatform();
  mockWebViewPlatform();

  const audioSessionMc = MethodChannel('com.ryanheise.audio_session');
  audioSessionMc.setMockMethodCallHandler((_) async {});

  final json = File('test/goldens.json').readAsStringSync();
  final map = jsonDecode(json) as Map<String, dynamic>;
  for (final entry in map.entries) {
    final name = entry.key;
    final html = entry.value as String;
    _test(name, html);

    if (name == 'FONT') {
      _test('x2/$name', html, textScaleSize: 2.0);
    }

    if (!name.contains('/')) {
      _test('selectable/$name', html, isSelectable: true);

      if (name == 'FONT') {
        _test(
          'selectable/x2/$name',
          html,
          isSelectable: true,
          textScaleSize: 2.0,
        );
      }
    }
  }
}
