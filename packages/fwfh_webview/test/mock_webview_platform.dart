import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

void mockWebViewPlatform() => _FakeWebViewPlatform();

class _FakeNavigationDelegate extends PlatformNavigationDelegate {
  NavigationRequestCallback? _onNavigationRequest;
  PageEventCallback? _onPageFinished;

  _FakeNavigationDelegate(super.params) : super.implementation();

  @override
  Future<void> setOnNavigationRequest(
    NavigationRequestCallback onNavigationRequest,
  ) async {
    _onNavigationRequest = onNavigationRequest;
  }

  @override
  Future<void> setOnPageFinished(PageEventCallback onPageFinished) async {
    _onPageFinished = onPageFinished;
  }
}

class FakeWebViewController extends PlatformWebViewController {
  static FakeWebViewController? _instance;
  static FakeWebViewController? get instance => _instance;

  Uri? _currentUri;
  _FakeNavigationDelegate? _handler;
  bool _js = true;
  Timer? _onPageFinishedTimer;
  final _uris = <Uri>[];

  FakeWebViewController(super.params) : super.implementation() {
    _instance = this;
  }

  Iterable<String> get urls => _uris.map((_) => _.toString());

  FutureOr<NavigationDecision?> onNavigationRequest({
    required String url,
    required bool isMainFrame,
  }) async {
    final req = NavigationRequest(url: url, isMainFrame: isMainFrame);
    return _handler?._onNavigationRequest?.call(req);
  }

  @override
  Future<String?> currentUrl() async {
    return _currentUri.toString();
  }

  @override
  Future<void> loadRequest(LoadRequestParams params) async {
    _onPageStarted(params.uri);
  }

  @override
  Future<void> reload() async {
    final uri = _currentUri;
    if (uri != null) {
      _onPageStarted(uri);
    }
  }

  @override
  Future<Object> runJavaScriptReturningResult(String javascript) async {
    if (!_js) {
      throw UnsupportedError('JavaScript is disabled');
    }

    final params = _currentUri?.queryParameters;
    if (params == null) {
      return '';
    }

    if (params['runJavaScriptReturningResult'] == 'error') {
      throw PlatformException(code: 'code');
    }

    if (params.containsKey(javascript)) {
      return params[javascript] ?? '';
    } else {
      return '';
    }
  }

  @override
  Future<void> setJavaScriptMode(JavaScriptMode javaScriptMode) async {
    _js = javaScriptMode == JavaScriptMode.unrestricted;
  }

  @override
  Future<void> setPlatformNavigationDelegate(
    PlatformNavigationDelegate handler,
  ) async {
    if (handler is _FakeNavigationDelegate) {
      _handler = handler;
    }
  }

  @override
  Future<void> setUserAgent(String? userAgent) async {
    // intentionally left empty
  }

  Future<void> _onPageStarted(Uri uri) async {
    _uris.add(_currentUri = uri);

    _onPageFinishedTimer?.cancel();
    _onPageFinishedTimer = Timer(
      const Duration(milliseconds: 10),
      () {
        final redirectToString =
            _currentUri?.queryParameters['redirect_to'] ?? '';
        if (redirectToString.isNotEmpty) {
          final redirectTo = Uri.tryParse(redirectToString);
          if (redirectTo != null) {
            _onPageStarted(redirectTo);
            return;
          }
        }

        _handler?._onPageFinished?.call(uri.toString());
      },
    );
  }
}

class _FakeWebViewControllerTimerDisposer extends StatefulWidget {
  final Widget child;
  final FakeWebViewController controller;

  const _FakeWebViewControllerTimerDisposer({
    required this.child,
    required this.controller,
  });

  @override
  State<StatefulWidget> createState() =>
      _FakeWebViewControllerTimerDisposerState();
}

class _FakeWebViewControllerTimerDisposerState
    extends State<_FakeWebViewControllerTimerDisposer> {
  @override
  void dispose() {
    widget.controller._onPageFinishedTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class _FakeWebViewWidget extends PlatformWebViewWidget {
  _FakeWebViewWidget(super.params) : super.implementation();

  @override
  Widget build(BuildContext context) {
    return _FakeWebViewControllerTimerDisposer(
      controller: params.controller as FakeWebViewController,
      child: const ColoredBox(
        color: Colors.grey,
        child: Placeholder(
          color: Colors.black,
        ),
      ),
    );
  }
}

class _FakeWebViewPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements WebViewPlatform {
  _FakeWebViewPlatform() {
    WebViewPlatform.instance = this;
  }

  @override
  PlatformNavigationDelegate createPlatformNavigationDelegate(
    PlatformNavigationDelegateCreationParams params,
  ) {
    return _FakeNavigationDelegate(params);
  }

  @override
  PlatformWebViewController createPlatformWebViewController(
    PlatformWebViewControllerCreationParams params,
  ) {
    return FakeWebViewController(params);
  }

  @override
  PlatformWebViewWidget createPlatformWebViewWidget(
    PlatformWebViewWidgetCreationParams params,
  ) {
    return _FakeWebViewWidget(params);
  }
}
