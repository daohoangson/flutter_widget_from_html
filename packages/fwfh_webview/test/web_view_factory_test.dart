import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../core/test/_.dart' as helper;
import '_.dart';
import 'mock_webview_platform.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  mockWebViewPlatform();

  const src = 'http://domain.com';
  const defaultAspectRatio = '1.78';

  testWidgets('renders clickable text', (tester) async {
    const html = '<iframe src="$src"></iframe>';
    final explained = await explain(tester, html, webView: false);
    expect(explained, equals('[GestureDetector:child=[Text:$src]]'));
  });

  group('renders web view', () {
    Future<void> test(
      WidgetTester tester,
      String html,
      String fullUrl, {
      String baseUrl = 'http://base.com/path/',
    }) async {
      final explained = await explain(
        tester,
        html,
        baseUrl: baseUrl.isNotEmpty ? Uri.parse(baseUrl) : null,
      );
      expect(
        explained,
        equals(
          '[WebView:'
          'url=$fullUrl,'
          'aspectRatio=$defaultAspectRatio,'
          'autoResize=true'
          ']',
        ),
      );
    }

    testWidgets('with full url', (WidgetTester tester) async {
      const fullUrl = 'http://domain.com/iframe';
      const html = '<iframe src="$fullUrl"></iframe>';
      await test(tester, html, fullUrl);
    });

    testWidgets('with protocol relative url', (WidgetTester tester) async {
      const html = '<iframe src="//protocol.relative"></iframe>';
      const fullUrl = 'http://protocol.relative';
      await test(tester, html, fullUrl);
    });

    testWidgets('with protocol relative url (https)', (tester) async {
      const html = '<iframe src="//protocol.relative/secured"></iframe>';
      const fullUrl = 'https://protocol.relative/secured';
      await test(tester, html, fullUrl, baseUrl: 'https://base.com/secured');
    });

    testWidgets('with protocol relative url (no base)', (tester) async {
      const html = '<iframe src="//protocol.relative/secured"></iframe>';
      const fullUrl = 'https://protocol.relative/secured';
      await test(tester, html, fullUrl, baseUrl: '');
    });

    testWidgets('with root relative url', (WidgetTester tester) async {
      const html = '<iframe src="/root.relative"></iframe>';
      const fullUrl = 'http://base.com/root.relative';
      await test(tester, html, fullUrl);
    });

    testWidgets('with relative url', (WidgetTester tester) async {
      const html = '<iframe src="relative"></iframe>';
      const fullUrl = 'http://base.com/path/relative';
      await test(tester, html, fullUrl);
    });
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

  group('gestureTapCallback', () {
    testWidgets('triggers callback', (tester) async {
      const html = '<iframe src="http://domain.com/iframe"></iframe>';
      final urls = <String>[];
      await helper.explain(
        tester,
        null,
        hw: HtmlWidget(
          html,
          key: helper.hwKey,
          factoryBuilder: () => WebViewWidgetFactory(),
          onTapUrl: (url) {
            urls.add(url);
            return false;
          },
        ),
      );

      await tester.runAsync(
        () => Future.delayed(const Duration(milliseconds: 100)),
      );
      await tester.pumpAndSettle();

      await FakeWebViewController.instance?.onNavigationRequest(
        url: 'http://domain.com/tap',
        isMainFrame: true,
      );
      expect(urls, equals(['http://domain.com/tap']));
    });
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
