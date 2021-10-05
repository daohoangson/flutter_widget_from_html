import 'dart:convert';
import 'dart:io';

import 'package:demo_app/screens/golden.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../packages/fwfh_chewie/test/_.dart';

void _test(String name, String html) => testGoldens(
      name,
      (tester) async {
        const platform = TargetPlatform.android;
        debugDefaultTargetPlatformOverride = platform;
        WidgetFactory.debugDeterministicLoadingWidget = true;
        final key = UniqueKey();

        await tester.pumpWidgetBuilder(
          Golden(name, html, targetKey: key),
          wrapper: materialAppWrapper(
            platform: platform,
            theme: ThemeData.light(),
          ),
          surfaceSize: const Size(400, 1200),
        );

        await screenMatchesGolden(tester, name, finder: find.byKey(key));
        debugDefaultTargetPlatformOverride = null;
        WidgetFactory.debugDeterministicLoadingWidget = false;
      },
      skip: !Platform.isLinux,
    );

void main() {
  mockVideoPlayerPlatform();

  const audioSessionMc = MethodChannel('com.ryanheise.audio_session');
  audioSessionMc.setMockMethodCallHandler((_) async {});

  const platformViewsMc = MethodChannel('flutter/platform_views');
  platformViewsMc.setMockMethodCallHandler((_) async {});

  final json = File('test/goldens.json').readAsStringSync();
  final map = jsonDecode(json) as Map<String, dynamic>;
  for (final entry in map.entries) {
    _test(entry.key, entry.value as String);
  }
}
