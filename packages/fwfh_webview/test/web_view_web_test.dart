@TestOn('browser')
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_webview/fwfh_webview.dart';
import 'package:web/web.dart' as web;
import 'package:webview_all/webview_all.dart' as lib;
import 'package:webview_all_web/webview_all_web.dart';
import 'package:webview_platform_interface/webview_platform_interface.dart'
    show JavaScriptChannelParams;

void main() {
  setUp(() => lib.WebViewPlatform.instance = _TrackingWebViewPlatform());

  _TrackingWebViewController controllerOf(WidgetTester tester) => tester
      .widget<lib.WebViewWidget>(find.byType(lib.WebViewWidget))
      .platform
      .params
      .controller as _TrackingWebViewController;

  Future<void> loadFrame(
    WidgetTester tester,
    web.HTMLIFrameElement iframe,
    FutureOr<void> Function() load,
  ) async {
    await tester.runAsync(() async {
      final loaded = iframe.onLoad.first.timeout(const Duration(seconds: 5));
      await load();
      await loaded;
    });
    await tester.pumpAndSettle();
  }

  Future<web.HTMLIFrameElement> pumpWebView(
    WidgetTester tester,
    Widget widget,
  ) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));
    await tester.pumpAndSettle();

    final params =
        controllerOf(tester).params as WebWebViewControllerCreationParams;
    // Widget tests do not composite platform views into the browser DOM.
    addTearDown(() => params.iFrame.remove());
    await loadFrame(tester, params.iFrame, () {
      web.document.body!.appendChild(params.iFrame);
    });
    expect(params.iFrame.isConnected, isTrue);
    return params.iFrame;
  }

  HtmlWidget htmlWidget(String attributes) => HtmlWidget(
        '<iframe src="about:blank" width="400" height="300" $attributes></iframe>',
        factoryBuilder: () => _WidgetFactory(),
      );

  testWidgets('forwards iframe permissions through webview_all', (
    tester,
  ) async {
    final iframe = await pumpWebView(
      tester,
      htmlWidget('allow="accelerometer; fullscreen" allowfullscreen'),
    );

    expect(iframe.src, 'about:blank');
    expect(iframe.allow, 'accelerometer; fullscreen');
    expect(iframe.allowFullscreen, isTrue);
  });

  testWidgets('leaves optional iframe permissions unset', (tester) async {
    final iframe = await pumpWebView(tester, htmlWidget(''));

    expect(iframe.hasAttribute('allow'), isFalse);
    expect(iframe.allowFullscreen, isFalse);
    expect(iframe.hasAttribute('sandbox'), isFalse);
  });

  testWidgets('combines autoplay with iframe permissions', (tester) async {
    final iframe = await pumpWebView(
      tester,
      const WebView(
        'about:blank',
        aspectRatio: 16 / 9,
        autoResize: false,
        allow: 'fullscreen',
        mediaPlaybackAlwaysAllow: true,
      ),
    );

    expect(iframe.allow, 'autoplay; fullscreen');
  });

  for (final attributes in [
    'sandbox',
    'sandbox="allow-forms"',
    'sandbox="allow-scripts"',
  ]) {
    testWidgets('keeps sandbox ignored on Web ($attributes)', (tester) async {
      final iframe = await pumpWebView(tester, htmlWidget(attributes));

      expect(iframe.hasAttribute('sandbox'), isFalse);
      expect(
        await controllerOf(tester).runJavaScriptReturningResult('21 * 2'),
        42,
      );
    });
  }

  testWidgets('keeps JavaScript enabled when js is false', (tester) async {
    final iframe = await pumpWebView(
      tester,
      const WebView(
        'about:blank',
        aspectRatio: 16 / 9,
        js: false,
      ),
    );

    expect(iframe.hasAttribute('sandbox'), isFalse);
    expect(
      await controllerOf(tester).runJavaScriptReturningResult('21 * 2'),
      42,
    );
  });

  testWidgets('keeps the supplied aspect ratio when autoResize is true', (
    tester,
  ) async {
    const aspectRatio = 16 / 9;
    final iframe = await pumpWebView(
      tester,
      const WebView('about:blank', aspectRatio: aspectRatio, autoResize: true),
    );

    final controller = controllerOf(tester);
    expect(controller.javaScriptChannels, isEmpty);
    await loadFrame(
      tester,
      iframe,
      () => controller.loadHtmlString(
        '<!doctype html><html><body '
        'style="margin:0;width:400px;height:200px"></body></html>',
      ),
    );

    expect(
      tester.widget<AspectRatio>(find.byType(AspectRatio)).aspectRatio,
      aspectRatio,
    );
  });

  testWidgets('keeps navigation interception disabled on Web', (
    tester,
  ) async {
    final urls = <String>[];
    await pumpWebView(
      tester,
      WebView(
        'about:blank',
        aspectRatio: 16 / 9,
        autoResize: false,
        interceptNavigationRequest: (url) {
          urls.add(url);
          return true;
        },
      ),
    );

    final controller = lib.WebViewController.fromPlatform(controllerOf(tester));
    final nextUrl = Uri.dataFromString(
      '<!doctype html><title>Next page</title>',
      mimeType: 'text/html',
    );
    await controller.loadRequest(nextUrl);

    expect(urls, isEmpty);
    expect(await controller.currentUrl(), nextUrl.toString());
  });

  testWidgets('updates the aspect ratio without recreating the iframe', (
    tester,
  ) async {
    final iframe = await pumpWebView(
      tester,
      const WebView('about:blank', aspectRatio: 16 / 9),
    );
    final controller = controllerOf(tester);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: WebView('about:blank', aspectRatio: 4 / 3)),
      ),
    );
    await tester.pumpAndSettle();

    expect(controllerOf(tester), same(controller));
    expect(
      (controller.params as WebWebViewControllerCreationParams).iFrame,
      same(iframe),
    );
    expect(
      tester.widget<AspectRatio>(find.byType(AspectRatio)).aspectRatio,
      4 / 3,
    );
  });

  testWidgets('resolves relative URLs against the document base', (
    tester,
  ) async {
    const relativeUrl = 'fwfh-relative-frame.txt';
    await tester.pumpWidget(
      const WebView(relativeUrl, aspectRatio: 16 / 9),
    );
    await tester.pumpAndSettle();
    final params =
        controllerOf(tester).params as WebWebViewControllerCreationParams;

    expect(
      params.iFrame.src,
      Uri.parse(web.document.baseURI).resolve(relativeUrl).toString(),
    );
  });

  for (final entry in const {
    'absolute URL backslashes': r'https://example.com/a\b',
    'relative URL backslashes': r'folder\frame.html',
    'surrounding whitespace': ' \nhttps://example.com/frame.html\t',
  }.entries) {
    testWidgets('matches legacy iframe URL handling: ${entry.key}', (
      tester,
    ) async {
      final legacyIframe = web.HTMLIFrameElement()..src = entry.value;
      await tester.pumpWidget(WebView(entry.value, aspectRatio: 16 / 9));
      await tester.pumpAndSettle();
      final params =
          controllerOf(tester).params as WebWebViewControllerCreationParams;

      expect(params.iFrame.src, legacyIframe.src);
    });
  }

  testWidgets('keeps native-only configuration ignored on Web', (tester) async {
    await pumpWebView(
      tester,
      const WebView(
        'about:blank',
        aspectRatio: 16 / 9,
        debuggingEnabled: true,
        gestureRecognizers: {
          Factory<OneSequenceGestureRecognizer>(EagerGestureRecognizer.new),
        },
        userAgent: 'fwfh',
      ),
    );

    expect(controllerOf(tester).userAgents, isEmpty);
    expect(
      tester
          .widget<lib.WebViewWidget>(find.byType(lib.WebViewWidget))
          .gestureRecognizers,
      isEmpty,
    );
  });
}

class _WidgetFactory extends WidgetFactory with WebViewFactory {}

class _TrackingWebViewPlatform extends WebWebViewPlatform {
  @override
  _TrackingWebViewController createPlatformWebViewController(
    lib.PlatformWebViewControllerCreationParams params,
  ) =>
      _TrackingWebViewController(params);
}

class _TrackingWebViewController extends WebWebViewController {
  final javaScriptChannels = <String>[];
  final userAgents = <String?>[];

  _TrackingWebViewController(super.params);

  @override
  Future<void> addJavaScriptChannel(JavaScriptChannelParams params) {
    javaScriptChannels.add(params.name);
    return super.addJavaScriptChannel(params);
  }

  @override
  Future<void> setUserAgent(String? value) {
    userAgents.add(value);
    return super.setUserAgent(value);
  }
}
