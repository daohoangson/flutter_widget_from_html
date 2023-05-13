import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import '_.dart';
import 'mock_webview_platform.dart';

void main() {
  mockWebViewPlatform();

  const src = 'http://domain.com';
  const defaultAspectRatio = '1.78';

  testWidgets('renders clickable text', (tester) async {
    const html = '<iframe src="$src"></iframe>';
    final explained = await explain(tester, html, webView: false);
    expect(explained, equals('[GestureDetector:child=[Text:$src]]'));
  });

  testWidgets('renders web view', (tester) async {
    const html = '<iframe src="$src"></iframe>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[WebView:'
        'url=$src,'
        'aspectRatio=$defaultAspectRatio,'
        'autoResize=true'
        ']',
      ),
    );
  });

  group('useExplainer: false', () {
    const html = '<iframe src="$src"></iframe>';
    Future<String> explainWithoutExplainer(WidgetTester tester) async {
      final explained = await explain(tester, html, useExplainer: false);
      return explained;
    }

    testWidgets('renders web view (Android)', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      final explained = await explainWithoutExplainer(tester);
      expect(explained, contains('└WebViewWidget'));
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('renders web view (iOS)', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      final explained = await explainWithoutExplainer(tester);
      expect(explained, contains('└WebViewWidget'));
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('skips web view (linux)', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      final explained = await explainWithoutExplainer(tester);
      expect(explained, isNot(contains('└WebViewWidget')));
      debugDefaultTargetPlatformOverride = null;
    });
  });

  testWidgets('renders web view with specified dimensions', (tester) async {
    const html = '<iframe src="$src" width="400" height="300"></iframe>';
    final explained = await explain(tester, html);
    expect(explained, equals('[WebView:url=$src,aspectRatio=1.33]'));
  });

  group('sandbox', () {
    testWidgets('renders with js', (tester) async {
      const html = '<iframe src="$src"></iframe>';
      final e = await explain(tester, html);
      expect(e, equals('[WebView:url=$src,aspectRatio=1.78,autoResize=true]'));
    });

    testWidgets('renders without js', (tester) async {
      const html = '<iframe src="$src" sandbox></iframe>';
      final e = await explain(tester, html);
      expect(e, equals('[WebView:url=$src,aspectRatio=1.78,js=false]'));
    });

    testWidgets('renders without js (empty)', (tester) async {
      const html = '<iframe src="$src" sandbox=""></iframe>';
      final e = await explain(tester, html);
      expect(e, equals('[WebView:url=$src,aspectRatio=1.78,js=false]'));
    });

    testWidgets('renders without js (allow-forms)', (tester) async {
      const html = '<iframe src="$src" sandbox="allow-forms"></iframe>';
      final e = await explain(tester, html);
      expect(e, equals('[WebView:url=$src,aspectRatio=1.78,js=false]'));
    });

    testWidgets('renders with js (allow-scripts)', (tester) async {
      const html = '<iframe src="$src" sandbox="allow-scripts"></iframe>';
      final e = await explain(tester, html);
      expect(e, equals('[WebView:url=$src,aspectRatio=1.78,autoResize=true]'));
    });
  });

  group('errors', () {
    testWidgets('no src', (tester) async {
      const html = '<iframe></iframe>';
      final explained = await explain(tester, html);
      expect(explained, equals('[widget0]'));
    });

    testWidgets('bad src (cannot build full url)', (tester) async {
      const html = '<iframe src="bad"></iframe>';
      final explained = await explain(tester, html);
      expect(explained, equals('[widget0]'));
    });
  });
}
