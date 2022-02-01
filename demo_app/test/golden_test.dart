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

import '../../packages/fwfh_chewie/test/_.dart';

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
      skip: !Platform.isLinux,
    );

void main() {
  mockVideoPlayerPlatform();

  const audioSessionMc = MethodChannel('com.ryanheise.audio_session');
  audioSessionMc.setMockMethodCallHandler((_) async {});

  const platformViewsMc = MethodChannel('flutter/platform_views');
  platformViewsMc.setMockMethodCallHandler((_) async {});

  for (final name in [
    'dev.flutter.pigeon.DownloadListenerHostApi.create',
    'dev.flutter.pigeon.WebChromeClientHostApi.create',
    'dev.flutter.pigeon.WebSettingsHostApi.create',
    'dev.flutter.pigeon.WebSettingsHostApi.setBuiltInZoomControls',
    'dev.flutter.pigeon.WebSettingsHostApi.setDisplayZoomControls',
    'dev.flutter.pigeon.WebSettingsHostApi.setDomStorageEnabled',
    // ignore: lines_longer_than_80_chars
    'dev.flutter.pigeon.WebSettingsHostApi.setJavaScriptCanOpenWindowsAutomatically',
    'dev.flutter.pigeon.WebSettingsHostApi.setJavaScriptEnabled',
    'dev.flutter.pigeon.WebSettingsHostApi.setLoadWithOverviewMode',
    'dev.flutter.pigeon.WebSettingsHostApi.setMediaPlaybackRequiresUserGesture',
    'dev.flutter.pigeon.WebSettingsHostApi.setSupportMultipleWindows',
    'dev.flutter.pigeon.WebSettingsHostApi.setSupportZoom',
    'dev.flutter.pigeon.WebSettingsHostApi.setUseWideViewPort',
    'dev.flutter.pigeon.WebSettingsHostApi.setUserAgentString',
    'dev.flutter.pigeon.WebViewClientHostApi.create',
    'dev.flutter.pigeon.WebViewHostApi.create',
    'dev.flutter.pigeon.WebViewHostApi.loadUrl',
    'dev.flutter.pigeon.WebViewHostApi.setDownloadListener',
    'dev.flutter.pigeon.WebViewHostApi.setWebChromeClient',
    'dev.flutter.pigeon.WebViewHostApi.setWebContentsDebuggingEnabled',
    'dev.flutter.pigeon.WebViewHostApi.setWebViewClient',
  ]) {
    BasicMessageChannel(name, const StandardMessageCodec())
        .setMockMessageHandler((input) async => {'foo': 'bar'});
  }

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
