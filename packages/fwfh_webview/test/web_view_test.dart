import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fwfh_webview/src/web_view/web_view.dart';
import 'package:measurer/measurer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import 'mock_webview_platform.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  mockWebViewPlatform();

  group('autoResize', () {
    const defaultAspectRatio = 16 / 9;
    const url = 'http://domain.com/?document.body.scrollWidth=1000&'
        'document.body.scrollHeight=1000';

    var aspectRatio = double.nan;

    // ignore: prefer_function_declarations_over_variables
    final run = (
      WidgetTester tester, {
      String urlQueryParams = '',
      Widget Function(Widget)? wrapper,
    }) async {
      final child = Measurer(
        onMeasure: (v, _) => aspectRatio = v.width / v.height,
        child: WebView(
          '$url&$urlQueryParams',
          aspectRatio: defaultAspectRatio,
        ),
      );

      runApp(
        MaterialApp(
          home: Scaffold(
            body: wrapper?.call(child) ?? child,
          ),
        ),
      );

      await tester.runAsync(
        () => Future.delayed(const Duration(milliseconds: 100)),
      );
      await tester.pumpAndSettle();
    };

    // ignore: prefer_function_declarations_over_variables
    final expectAspectRatioEquals = (double expected) => expect(
          aspectRatio.toStringAsFixed(2),
          equals(expected.toStringAsFixed(2)),
        );

    // ignore: prefer_function_declarations_over_variables
    final cleanUp = (WidgetTester tester) async {
      runApp(const SizedBox.shrink());
      await tester.pumpAndSettle();
    };

    testWidgets('ratio 1.0', (tester) async {
      await run(tester);
      expectAspectRatioEquals(1.0);
      await cleanUp(tester);
    });

    testWidgets('handles js error', (tester) async {
      await run(
        tester,
        urlQueryParams: 'runJavaScriptReturningResult=error',
      );
      expectAspectRatioEquals(defaultAspectRatio);
      await cleanUp(tester);
    });
  });

  group('debuggingEnabled', () {
    const html = 'foo';
    final url = Uri.dataFromString(html, mimeType: 'text/html').toString();
    const aspectRatio = 16 / 9;

    group('android', () {
      testWidgets('renders without value', (WidgetTester tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        runApp(WebView(url, aspectRatio: aspectRatio));
        expect(FakeWebViewController.instance?.debuggingEnabled, isFalse);
        debugDefaultTargetPlatformOverride = null;
      });

      testWidgets('renders true', (WidgetTester tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        runApp(WebView(url, aspectRatio: aspectRatio, debuggingEnabled: true));
        expect(FakeWebViewController.instance?.debuggingEnabled, isTrue);
        debugDefaultTargetPlatformOverride = null;
      });

      testWidgets('renders false', (WidgetTester tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        // ignore: avoid_redundant_argument_values
        runApp(WebView(url, aspectRatio: aspectRatio, debuggingEnabled: false));
        expect(FakeWebViewController.instance?.debuggingEnabled, isFalse);
        debugDefaultTargetPlatformOverride = null;
      });
    });

    group('ios', () {
      testWidgets('renders without value', (WidgetTester tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        runApp(WebView(url, aspectRatio: aspectRatio));
        expect(FakeWebViewController.instance?.debuggingEnabled, isFalse);
        debugDefaultTargetPlatformOverride = null;
      });

      testWidgets('renders true', (WidgetTester tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        runApp(WebView(url, aspectRatio: aspectRatio, debuggingEnabled: true));
        expect(FakeWebViewController.instance?.debuggingEnabled, isTrue);
        debugDefaultTargetPlatformOverride = null;
      });

      testWidgets('renders false', (WidgetTester tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        // ignore: avoid_redundant_argument_values
        runApp(WebView(url, aspectRatio: aspectRatio, debuggingEnabled: false));
        expect(FakeWebViewController.instance?.debuggingEnabled, isFalse);
        debugDefaultTargetPlatformOverride = null;
      });
    });
  });

  group('interceptNavigationRequest', () {
    testWidgets('triggers callback', (WidgetTester tester) async {
      const url = 'http://domain.com';
      final navigationRequestUrls = <String>[];

      runApp(
        WebView(
          url,
          aspectRatio: 16 / 9,
          interceptNavigationRequest: (url) {
            navigationRequestUrls.add(url);
            return true;
          },
        ),
      );
      expect(navigationRequestUrls, equals([]));

      await tester.runAsync(
        () => Future.delayed(const Duration(milliseconds: 100)),
      );
      await tester.pumpAndSettle();

      const url2 = 'http://domain.com/2';
      final result2 = await FakeWebViewController.instance
          ?.onNavigationRequest(url: url2, isMainFrame: true);

      expect(navigationRequestUrls, equals([url2]));
      expect(result2, equals(NavigationDecision.prevent));
    });

    testWidgets('skips callback (initial url)', (WidgetTester tester) async {
      const url = 'http://domain.com';
      final navigationRequestUrls = <String>[];

      runApp(
        WebView(
          url,
          aspectRatio: 16 / 9,
          interceptNavigationRequest: (url) {
            navigationRequestUrls.add(url);
            return true;
          },
        ),
      );
      expect(navigationRequestUrls, equals([]));

      await tester.runAsync(
        () => Future.delayed(const Duration(milliseconds: 100)),
      );
      await tester.pumpAndSettle();

      final result = await FakeWebViewController.instance
          ?.onNavigationRequest(url: url, isMainFrame: true);

      expect(navigationRequestUrls, equals([]));
      expect(result, equals(NavigationDecision.navigate));
    });

    testWidgets('skips callback (first url)', (WidgetTester tester) async {
      const url2 = 'http://domain.com/2';
      const url = 'http://domain.com/?redirect_to=$url2';
      final navigationRequestUrls = <String>[];

      runApp(
        WebView(
          url,
          aspectRatio: 16 / 9,
          interceptNavigationRequest: (url) {
            navigationRequestUrls.add(url);
            return true;
          },
        ),
      );
      expect(navigationRequestUrls, equals([]));

      await tester.runAsync(
        () => Future.delayed(const Duration(milliseconds: 100)),
      );
      await tester.pumpAndSettle();

      final result2 = await FakeWebViewController.instance
          ?.onNavigationRequest(url: url2, isMainFrame: true);

      expect(navigationRequestUrls, equals([]));
      expect(result2, equals(NavigationDecision.navigate));
    });

    testWidgets('skips callback (not main frame)', (WidgetTester tester) async {
      const url = 'http://domain.com';
      final navigationRequestUrls = <String>[];

      runApp(
        WebView(
          url,
          aspectRatio: 16 / 9,
          interceptNavigationRequest: (url) {
            navigationRequestUrls.add(url);
            return true;
          },
        ),
      );
      expect(navigationRequestUrls, equals([]));

      await tester.runAsync(
        () => Future.delayed(const Duration(milliseconds: 100)),
      );
      await tester.pumpAndSettle();

      const url2 = 'http://domain.com/2';
      final result2 = await FakeWebViewController.instance
          ?.onNavigationRequest(url: url2, isMainFrame: false);

      expect(navigationRequestUrls, equals([]));
      expect(result2, equals(NavigationDecision.navigate));
    });
  });

  group('js', () {
    const html = 'foo';
    final url = Uri.dataFromString(html, mimeType: 'text/html').toString();
    const aspectRatio = 16 / 9;

    testWidgets('renders without value', (WidgetTester tester) async {
      runApp(WebView(url, aspectRatio: aspectRatio));
      expect(
        FakeWebViewController.instance?.javaScriptMode,
        JavaScriptMode.unrestricted,
      );
    });

    testWidgets('renders true', (WidgetTester tester) async {
      runApp(
        WebView(
          url,
          aspectRatio: aspectRatio,
          // ignore: avoid_redundant_argument_values
          js: true,
        ),
      );
      expect(
        FakeWebViewController.instance?.javaScriptMode,
        JavaScriptMode.unrestricted,
      );
    });

    testWidgets('renders false', (WidgetTester tester) async {
      runApp(WebView(url, aspectRatio: aspectRatio, js: false));
      expect(
        FakeWebViewController.instance?.javaScriptMode,
        JavaScriptMode.disabled,
      );
    });
  });

  group('mediaPlaybackAlwaysAllow', () {
    const html = 'foo';
    final url = Uri.dataFromString(html, mimeType: 'text/html').toString();
    const aspectRatio = 16 / 9;

    // ignore: prefer_function_declarations_over_variables
    final expectMediaTypesRequiringUserAction = (Matcher matcher) {
      expect(
        FakeWebViewController.instance?.params,
        isA<WebKitWebViewControllerCreationParams>().having(
          (_) => _.mediaTypesRequiringUserAction,
          'mediaTypesRequiringUserAction',
          matcher,
        ),
      );
    };

    testWidgets('renders without value', (WidgetTester tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      runApp(
        WebView(
          url,
          aspectRatio: aspectRatio,
        ),
      );

      expectMediaTypesRequiringUserAction(
        equals([PlaybackMediaTypes.audio, PlaybackMediaTypes.video]),
      );

      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('renders true', (WidgetTester tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      runApp(
        WebView(
          url,
          aspectRatio: aspectRatio,
          mediaPlaybackAlwaysAllow: true,
        ),
      );

      expectMediaTypesRequiringUserAction(isEmpty);
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('renders false', (WidgetTester tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      runApp(
        WebView(
          url,
          aspectRatio: aspectRatio,
          // ignore: avoid_redundant_argument_values
          mediaPlaybackAlwaysAllow: false,
        ),
      );

      expectMediaTypesRequiringUserAction(
        equals([PlaybackMediaTypes.audio, PlaybackMediaTypes.video]),
      );

      debugDefaultTargetPlatformOverride = null;
    });
  });

  group('unsupportedWorkaroundForIssue37', () {
    testWidgets('reloads on pause', (WidgetTester tester) async {
      const html = 'reloads on pause';
      final url = Uri.dataFromString(html, mimeType: 'text/html').toString();

      runApp(WebView(url, aspectRatio: 16 / 9));
      expect(FakeWebViewController.instance?.urls, equals([url]));

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      expect(FakeWebViewController.instance?.urls, equals([url, url]));
    });

    testWidgets('reloads on dispose', (WidgetTester tester) async {
      const html = 'reloads on dispose';
      final url = Uri.dataFromString(html, mimeType: 'text/html').toString();

      runApp(WebView(url, aspectRatio: 16 / 9));
      expect(FakeWebViewController.instance?.urls, equals([url]));

      runApp(const SizedBox.shrink());
      await tester.pump();
      expect(FakeWebViewController.instance?.urls, equals([url, url]));
    });
  });

  group('userAgent', () {
    const html = 'foo';
    final url = Uri.dataFromString(html, mimeType: 'text/html').toString();
    const aspectRatio = 16 / 9;

    testWidgets('renders without value', (WidgetTester tester) async {
      runApp(WebView(url, aspectRatio: aspectRatio));
      expect(FakeWebViewController.instance?.userAgent, isNull);
    });

    testWidgets('renders string', (WidgetTester tester) async {
      runApp(WebView(url, aspectRatio: aspectRatio, userAgent: 'fwfh'));
      expect(FakeWebViewController.instance?.userAgent, equals('fwfh'));
    });
  });
}
