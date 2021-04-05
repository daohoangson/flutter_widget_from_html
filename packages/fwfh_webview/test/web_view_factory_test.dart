import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webview_flutter/webview_flutter.dart' as lib;

import '_.dart';

void main() {
  final src = 'http://domain.com';
  final defaultAspectRatio = '1.78';

  testWidgets('renders clickable text', (tester) async {
    final html = '<iframe src="$src"></iframe>';
    final explained = await explain(tester, html, webView: false);
    expect(explained, equals('[GestureDetector:child=[Text:$src]]'));
  });

  testWidgets('renders web view', (tester) async {
    final html = '<iframe src="$src"></iframe>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[WebView:'
            'url=$src,'
            'aspectRatio=$defaultAspectRatio,'
            'autoResize=true'
            ']'));
  });

  group('useExplainer: false', () {
    final html = '<iframe src="$src"></iframe>';
    final _explain = (WidgetTester tester) async {
      lib.WebView.platform = null;
      final explained = await explain(tester, html, useExplainer: false);
      return explained;
    };

    testWidgets('renders web view (Android)', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      final explained = await _explain(tester);
      expect(
          explained,
          equals('TshWidget\n'
              '└WidgetPlaceholder<Widget>(WebView)\n'
              ' └WebView(state: WebViewState)\n'
              '  └LayoutBuilder()\n'
              '   └SizedBox(width: 800.0, height: 450.0)\n'
              "    └WebView-[<'$src'>](state: _WebViewState)\n"
              '     └GestureDetector(startBehavior: start)\n'
              '      └RawGestureDetector(...)\n'
              '       └Listener(...)\n'
              '        └AndroidView(state: _AndroidViewState)\n'
              '         └Focus(...)\n'
              '          └_FocusMarker\n'
              '           └Semantics(...)\n'
              '            └_AndroidPlatformView()\n'
              '\n'));
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('renders web view (iOS)', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      final explained = await _explain(tester);
      expect(
          explained,
          equals('TshWidget\n'
              '└WidgetPlaceholder<Widget>(WebView)\n'
              ' └WebView(state: WebViewState)\n'
              '  └AspectRatio(aspectRatio: 1.8)\n'
              "   └WebView-[<'$src'>](state: _WebViewState)\n"
              '    └UiKitView(state: _UiKitViewState)\n'
              '     └SizedBox.expand()\n'
              '\n'));
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('skips web view (linux)', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      final explained = await _explain(tester);
      expect(
          explained,
          equals('TshWidget\n'
              '└WidgetPlaceholder<Widget>(WebView)\n'
              ' └WebView(state: WebViewState)\n'
              '  └AspectRatio(aspectRatio: 1.8)\n'
              '   └DecoratedBox(bg: BoxDecoration(color: Color(0x7f000000)))\n'
              '    └Center(alignment: center)\n'
              '     └Text("platform=TargetPlatform.linux")\n'
              '      └RichText(text: "platform=TargetPlatform.linux")\n'
              '\n'));
      debugDefaultTargetPlatformOverride = null;
    });
  });

  testWidgets('renders web view with specified dimensions', (tester) async {
    final html = '<iframe src="$src" width="400" height="300"></iframe>';
    final explained = await explain(tester, html);
    expect(explained, equals('[WebView:url=$src,aspectRatio=1.33]'));
  });

  group('sandbox', () {
    testWidgets('renders with js', (tester) async {
      final html = '<iframe src="$src"></iframe>';
      final e = await explain(tester, html);
      expect(e, equals('[WebView:url=$src,aspectRatio=1.78,autoResize=true]'));
    });

    testWidgets('renders without js', (tester) async {
      final html = '<iframe src="$src" sandbox></iframe>';
      final e = await explain(tester, html);
      expect(e, equals('[WebView:url=$src,aspectRatio=1.78,js=false]'));
    });

    testWidgets('renders without js (empty)', (tester) async {
      final html = '<iframe src="$src" sandbox=""></iframe>';
      final e = await explain(tester, html);
      expect(e, equals('[WebView:url=$src,aspectRatio=1.78,js=false]'));
    });

    testWidgets('renders without js (allow-forms)', (tester) async {
      final html = '<iframe src="$src" sandbox="allow-forms"></iframe>';
      final e = await explain(tester, html);
      expect(e, equals('[WebView:url=$src,aspectRatio=1.78,js=false]'));
    });

    testWidgets('renders with js (allow-scripts)', (tester) async {
      final html = '<iframe src="$src" sandbox="allow-scripts"></iframe>';
      final e = await explain(tester, html);
      expect(e, equals('[WebView:url=$src,aspectRatio=1.78,autoResize=true]'));
    });
  });

  group('errors', () {
    testWidgets('no src', (tester) async {
      final html = '<iframe></iframe>';
      final explained = await explain(tester, html);
      expect(explained, equals('[widget0]'));
    });

    testWidgets('bad src (cannot build full url)', (tester) async {
      final html = '<iframe src="bad"></iframe>';
      final explained = await explain(tester, html);
      expect(explained, equals('[widget0]'));
    });
  });
}
