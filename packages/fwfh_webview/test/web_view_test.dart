import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fwfh_webview/src/web_view/web_view.dart';
import 'package:measurer/measurer.dart';

import 'mock_webview_platform.dart';

void main() {
  mockWebViewPlatform();

  group('autoResize', () {
    const defaultAspectRatio = 16 / 9;
    const url = 'http://domain.com/?document.body.scrollWidth=1000&'
        'document.body.scrollHeight=1000';

    var _aspectRatio = double.nan;

    // ignore: prefer_function_declarations_over_variables
    final run = (
      WidgetTester tester, {
      String urlQueryParams = '',
      bool unsupportedWorkaroundForIssue375 = false,
      Widget Function(Widget)? wrapper,
    }) async {
      final child = Measurer(
        onMeasure: (v, _) => _aspectRatio = v.width / v.height,
        child: WebView(
          '$url&$urlQueryParams',
          aspectRatio: defaultAspectRatio,
          unsupportedWorkaroundForIssue375: unsupportedWorkaroundForIssue375,
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
          _aspectRatio.toStringAsFixed(2),
          equals(expected.toStringAsFixed(2)),
        );

    // ignore: prefer_function_declarations_over_variables
    final cleanUp = (WidgetTester tester) async {
      runApp(const SizedBox.shrink());
      await tester.pumpAndSettle();
    };

    testWidgets('unsupportedWorkaroundForIssue375=false', (tester) async {
      await run(tester);
      expectAspectRatioEquals(1.0);
      await cleanUp(tester);
    });

    group('unsupportedWorkaroundForIssue375=true', () {
      testWidgets('requires too much height', (WidgetTester tester) async {
        const testSize = Size(800, 600);
        tester.binding.window.physicalSizeTestValue = testSize;
        addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

        await run(tester, unsupportedWorkaroundForIssue375: true);
        expectAspectRatioEquals(testSize.width / testSize.height);

        await cleanUp(tester);
      });

      testWidgets('height fits', (WidgetTester tester) async {
        const testSize = Size(600, 800);
        tester.binding.window.physicalSizeTestValue = testSize;
        addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

        await run(tester, unsupportedWorkaroundForIssue375: true);
        expectAspectRatioEquals(1.0);

        await cleanUp(tester);
      });

      testWidgets('in vertical ListView', (WidgetTester tester) async {
        const testSize = Size(800, 600);
        tester.binding.window.physicalSizeTestValue = testSize;
        addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

        await run(
          tester,
          unsupportedWorkaroundForIssue375: true,
          wrapper: (child) => ListView(children: [child]),
        );
        expectAspectRatioEquals(testSize.width / testSize.height);

        await cleanUp(tester);
      });

      testWidgets('in horizontal ListView', (WidgetTester tester) async {
        const testSize = Size(800, 600);
        tester.binding.window.physicalSizeTestValue = testSize;
        addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

        await run(
          tester,
          unsupportedWorkaroundForIssue375: true,
          wrapper: (child) => ListView(
            scrollDirection: Axis.horizontal,
            children: [child],
          ),
        );
        expectAspectRatioEquals(testSize.width / testSize.height);

        await cleanUp(tester);
      });
    });

    testWidgets('handles js error', (tester) async {
      await run(
        tester,
        urlQueryParams: 'runJavascriptReturningResult=error',
      );
      expectAspectRatioEquals(defaultAspectRatio);
      await cleanUp(tester);
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
      final result2 = await FakeWebViewController.instance?.handler
          .onNavigationRequest(url: url2, isForMainFrame: true);

      expect(navigationRequestUrls, equals([url2]));
      expect(result2, isFalse);
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

      final result = await FakeWebViewController.instance?.handler
          .onNavigationRequest(url: url, isForMainFrame: true);

      expect(navigationRequestUrls, equals([]));
      expect(result, isTrue);
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

      final result2 = await FakeWebViewController.instance?.handler
          .onNavigationRequest(url: url2, isForMainFrame: true);

      expect(navigationRequestUrls, equals([]));
      expect(result2, isTrue);
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
      final result2 = await FakeWebViewController.instance?.handler
          .onNavigationRequest(url: url2, isForMainFrame: false);

      expect(navigationRequestUrls, equals([]));
      expect(result2, isTrue);
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
}
