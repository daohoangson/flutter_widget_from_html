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
    var aspectRatio = double.nan;
    const defaultAspectRatio = 16 / 9;

    Future<void> runAutoResizeApp(WidgetTester tester, String url) async {
      final child = Measurer(
        onMeasure: (v, _) => aspectRatio = v.width / v.height,
        child: WebView(url, aspectRatio: defaultAspectRatio),
      );

      aspectRatio = double.nan;
      runApp(MaterialApp(home: Scaffold(body: child)));
      await tester.runAsync(
        () => Future.delayed(const Duration(milliseconds: 100)),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('ratio 1.0', (tester) async {
      const url = 'http://foo.bar/?message=[10,10]';
      await runAutoResizeApp(tester, url);
      expect(aspectRatio, equals(1.0));
    });

    testWidgets('ratio 2.0', (tester) async {
      const url = 'http://foo.bar/?message=[20.0,10]';
      await runAutoResizeApp(tester, url);
      expect(aspectRatio, equals(2.0));
    });

    testWidgets('ratio .5', (tester) async {
      const url = 'http://foo.bar/?message=[10.0,20.0]';
      await runAutoResizeApp(tester, url);
      expect(aspectRatio, equals(.5));
    });

    group('error handling', () {
      testWidgets('empty array', (tester) async {
        const url = 'http://foo.bar/?message=[]';
        await runAutoResizeApp(tester, url);
        expect(aspectRatio, equals(defaultAspectRatio));
      });

      testWidgets('array of one item', (tester) async {
        const url = 'http://foo.bar/?message=[10]';
        await runAutoResizeApp(tester, url);
        expect(aspectRatio, equals(defaultAspectRatio));
      });

      testWidgets('array of string', (tester) async {
        const url = 'http://foo.bar/?message=["10","10"]';
        await runAutoResizeApp(tester, url);
        expect(aspectRatio, equals(defaultAspectRatio));
      });
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
        runApp(WebView(url, aspectRatio: aspectRatio));
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
        runApp(WebView(url, aspectRatio: aspectRatio));
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
      runApp(WebView(url, aspectRatio: aspectRatio));
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

    group('android', () {
      testWidgets('renders without value', (WidgetTester tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        runApp(WebView(url, aspectRatio: aspectRatio));
        expect(
          FakeWebViewController
              .instance?.androidMediaPlaybackRequiresUserGesture,
          isTrue,
        );
        debugDefaultTargetPlatformOverride = null;
      });

      testWidgets('renders true', (WidgetTester tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        runApp(
          WebView(
            url,
            aspectRatio: aspectRatio,
            mediaPlaybackAlwaysAllow: true,
          ),
        );
        expect(
          FakeWebViewController
              .instance?.androidMediaPlaybackRequiresUserGesture,
          isFalse,
        );
        debugDefaultTargetPlatformOverride = null;
      });

      testWidgets('renders false', (WidgetTester tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        runApp(WebView(url, aspectRatio: aspectRatio));
        expect(
          FakeWebViewController
              .instance?.androidMediaPlaybackRequiresUserGesture,
          isTrue,
        );
        debugDefaultTargetPlatformOverride = null;
      });
    });

    group('ios', () {
      void expectMediaTypesRequiringUserAction(bool require) {
        expect(
          FakeWebViewController.instance?.params,
          isA<WebKitWebViewControllerCreationParams>().having(
            (params) => params.mediaTypesRequiringUserAction,
            'mediaTypesRequiringUserAction',
            require
                ? equals([PlaybackMediaTypes.audio, PlaybackMediaTypes.video])
                : isEmpty,
          ),
        );
      }

      testWidgets('renders without value', (WidgetTester tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        runApp(WebView(url, aspectRatio: aspectRatio));
        expectMediaTypesRequiringUserAction(true);
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
        expectMediaTypesRequiringUserAction(false);
        debugDefaultTargetPlatformOverride = null;
      });

      testWidgets('renders false', (WidgetTester tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        runApp(WebView(url, aspectRatio: aspectRatio));
        expectMediaTypesRequiringUserAction(true);
        debugDefaultTargetPlatformOverride = null;
      });
    });
  });

  testWidgets('onAndroidShowCustomWidget', (WidgetTester tester) async {
    const html = 'foo';
    final url = Uri.dataFromString(html, mimeType: 'text/html').toString();
    const aspectRatio = 16 / 9;

    runApp(
      MaterialApp(
        home: Scaffold(
          body: WebView(
            url,
            aspectRatio: aspectRatio,
          ),
        ),
      ),
    );

    final webViewFinder = find.byType(Placeholder);
    final fullscreenFinder = find.text('Fullscreen');
    await tester.pumpAndSettle();
    expect(webViewFinder, findsOneWidget);
    expect(fullscreenFinder, findsNothing);

    // video goes fullscreen
    FakeWebViewController.instance?.androidOnShowCustomWidget?.call(
      const Scaffold(
        body: Center(
          child: Text('Fullscreen'),
        ),
      ),
      () {},
    );
    await tester.pumpAndSettle();
    expect(webViewFinder, findsNothing);
    expect(fullscreenFinder, findsOneWidget);

    // user exits fullscreen
    FakeWebViewController.instance?.androidOnHideCustomWidget?.call();
    await tester.pumpAndSettle();
    expect(webViewFinder, findsOneWidget);
    expect(fullscreenFinder, findsNothing);
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

  group('url', () {
    testWidgets('handles load error', (WidgetTester tester) async {
      runApp(
        const WebView(
          'http://domain.com?loadRequest=error',
          aspectRatio: 16 / 9,
        ),
      );
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
