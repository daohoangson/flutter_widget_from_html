import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_webview/fwfh_webview.dart';

import '../../core/test/_.dart' as helper;
import '_.dart';
import 'mock_webview_platform.dart';

void main() {
  const sizingConstraints = 'height≥0.0,height=auto,width≥0.0,width=auto';

  TestWidgetsFlutterBinding.ensureInitialized();
  mockWebViewPlatform();

  const src = 'http://domain.com';
  const defaultAspectRatio = '1.78';

  group('getters', () {
    const html = '<iframe src="$src"></iframe>';

    testWidgets('webView=false', (tester) async {
      final explained = await helper.explain(
        tester,
        null,
        hw: HtmlWidget(
          html,
          key: helper.hwKey,
          factoryBuilder: () => _WebViewFalse(),
        ),
      );
      expect(
        explained,
        equals(
          '[CssSizing:$sizingConstraints,child='
          '[GestureDetector:child=[Text:$src]]'
          ']',
        ),
      );
    });

    testWidgets('webViewDebuggingEnabled', (tester) async {
      final explained = await helper.explain(
        tester,
        null,
        explainer: webViewExplainer,
        hw: HtmlWidget(
          html,
          key: helper.hwKey,
          factoryBuilder: () => _WebViewDebuggingEnabled(),
        ),
      );
      expect(explained, contains('debuggingEnabled=true'));
    });

    testWidgets('webViewGestureRecognizers={Eager}', (tester) async {
      final explained = await helper.explain(
        tester,
        null,
        explainer: webViewExplainer,
        hw: HtmlWidget(
          html,
          key: helper.hwKey,
          factoryBuilder: () => _WebViewEagerGestureRecognizer(),
        ),
      );
      expect(
        explained,
        contains(
          'gestureRecognizers={Factory(type: OneSequenceGestureRecognizer)}',
        ),
      );
    });

    testWidgets('webViewMediaPlaybackAlwaysAllow', (tester) async {
      final explained = await helper.explain(
        tester,
        null,
        explainer: webViewExplainer,
        hw: HtmlWidget(
          html,
          key: helper.hwKey,
          factoryBuilder: () => _WebViewMediaPlaybackAlwaysAllow(),
        ),
      );
      expect(explained, contains('mediaPlaybackAlwaysAllow=true'));
    });

    testWidgets('webViewUnsupportedWorkaroundForIssue37', (tester) async {
      final explained = await helper.explain(
        tester,
        null,
        explainer: webViewExplainer,
        hw: HtmlWidget(
          html,
          key: helper.hwKey,
          factoryBuilder: () => _WebViewUnsupportedWorkaroundForIssue37False(),
        ),
      );
      expect(explained, contains('unsupportedWorkaroundForIssue37=false'));
    });

    testWidgets('webViewUserAgent=foo', (tester) async {
      final explained = await helper.explain(
        tester,
        null,
        explainer: webViewExplainer,
        hw: HtmlWidget(
          html,
          key: helper.hwKey,
          factoryBuilder: () => _WebViewUserAgentFoo(),
        ),
      );
      expect(explained, contains('userAgent=foo'));
    });
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
          '[CssSizing:$sizingConstraints,child='
          '[WebView:'
          'url=$fullUrl,'
          'aspectRatio=$defaultAspectRatio,'
          'autoResize=true'
          ']]',
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
    expect(
      explained,
      equals(
        '[CssSizing:height≥0.0,height=300.0,width≥0.0,width=400.0,child='
        '[WebView:url=$src,aspectRatio=1.33]'
        ']',
      ),
    );
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
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:$sizingConstraints,child='
          '[WebView:url=$src,aspectRatio=1.78,autoResize=true]'
          ']',
        ),
      );
    });

    testWidgets('renders without js', (tester) async {
      const html = '<iframe src="$src" sandbox></iframe>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:$sizingConstraints,child='
          '[WebView:url=$src,aspectRatio=1.78,js=false]'
          ']',
        ),
      );
    });

    testWidgets('renders without js (empty)', (tester) async {
      const html = '<iframe src="$src" sandbox=""></iframe>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:$sizingConstraints,child='
          '[WebView:url=$src,aspectRatio=1.78,js=false]'
          ']',
        ),
      );
    });

    testWidgets('renders without js (allow-forms)', (tester) async {
      const html = '<iframe src="$src" sandbox="allow-forms"></iframe>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:$sizingConstraints,child='
          '[WebView:url=$src,aspectRatio=1.78,js=false]'
          ']',
        ),
      );
    });

    testWidgets('renders with js (allow-scripts)', (tester) async {
      const html = '<iframe src="$src" sandbox="allow-scripts"></iframe>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[CssSizing:$sizingConstraints,child='
          '[WebView:url=$src,aspectRatio=1.78,autoResize=true]'
          ']',
        ),
      );
    });
  });

  group('data-src attribute', () {
    testWidgets('renders with data-src', (tester) async {
      const html = '<iframe data-src="$src"></iframe>';
      final explained = await explain(tester, html);
      expect(explained, contains('url=$src,'));
    });

    testWidgets('src takes priority over data-src', (tester) async {
      const html = '<iframe data-src="$src/1" src="$src/2"></iframe>';
      final explained = await explain(tester, html);
      expect(explained, contains('url=$src/2,'));
    });

    testWidgets('falls back to data-src when src is empty', (tester) async {
      const html = '<iframe data-src="$src" src=""></iframe>';
      final explained = await explain(tester, html);
      expect(explained, contains('url=$src,'));
    });

    testWidgets('uses src when data-src is missing', (tester) async {
      const html = '<iframe src="$src"></iframe>';
      final explained = await explain(tester, html);
      expect(explained, contains('url=$src,'));
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

    testWidgets('bad data-src (cannot build full url)', (tester) async {
      const html = '<iframe data-src="bad"></iframe>';
      final explained = await explain(tester, html);
      expect(explained, equals('[widget0]'));
    });
  });
}

class _WebViewFalse extends WidgetFactory with WebViewFactory {
  @override
  bool get webView => false;
}

class _WebViewDebuggingEnabled extends WidgetFactory with WebViewFactory {
  @override
  bool get webViewDebuggingEnabled => true;
}

class _WebViewEagerGestureRecognizer extends WidgetFactory with WebViewFactory {
  @override
  Set<Factory<OneSequenceGestureRecognizer>> get webViewGestureRecognizers =>
      const {
        Factory<OneSequenceGestureRecognizer>(EagerGestureRecognizer.new),
      };
}

class _WebViewMediaPlaybackAlwaysAllow extends WidgetFactory
    with WebViewFactory {
  @override
  bool get webViewMediaPlaybackAlwaysAllow => true;
}

class _WebViewUnsupportedWorkaroundForIssue37False extends WidgetFactory
    with WebViewFactory {
  @override
  bool get webViewUnsupportedWorkaroundForIssue37 => false;
}

class _WebViewUserAgentFoo extends WidgetFactory with WebViewFactory {
  @override
  String? get webViewUserAgent => 'foo';
}
