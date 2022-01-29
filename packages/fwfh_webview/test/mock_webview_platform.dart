import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void mockWebViewPlatform() => _FakeWebViewPlatform();

class FakeWebViewController extends WebViewPlatformController {
  static FakeWebViewController? _instance;
  static FakeWebViewController? get instance => _instance;

  final CreationParams creationParams;
  final WebViewPlatformCallbacksHandler handler;

  String? _currentUrl;
  bool _js = true;
  Timer? _onPageFinishedTimer;
  final _urls = <String>[];

  FakeWebViewController(
    this.handler, {
    required this.creationParams,
  }) : super(handler) {
    _instance = this;

    final settings = creationParams.webSettings;
    if (settings != null) {
      _updateSettings(settings);
    }

    final url = creationParams.initialUrl;
    if (url != null) {
      _triggerOnPageFinished(url);
    }
  }

  Iterable<String> get urls => [..._urls];

  @override
  Future<String?> currentUrl() async {
    return _currentUrl;
  }

  @override
  Future<void> reload() async {
    final url = _currentUrl;
    if (url != null) {
      _onPageFinishedTimer?.cancel();
      _triggerOnPageFinished(url);
    }
  }

  @override
  Future<String> runJavascriptReturningResult(String javascript) async {
    if (!_js) {
      return '';
    }

    final url = await currentUrl();
    if (url == null) {
      return '';
    }

    final uri = Uri.tryParse(url);
    if (uri == null) {
      return '';
    }

    final params = uri.queryParameters;
    if (params.containsKey(javascript)) {
      return params[javascript] ?? '';
    } else {
      return '';
    }
  }

  @override
  Future<void> updateSettings(WebSettings settings) async {
    _updateSettings(settings);
  }

  void _dispose() {
    _onPageFinishedTimer?.cancel();
  }

  Future<void> _triggerOnPageFinished(String url) async {
    _urls.add(_currentUrl = url);

    _onPageFinishedTimer = Timer(
      const Duration(milliseconds: 10),
      () => handler.onPageFinished(url),
    );
  }

  void _updateSettings(WebSettings settings) {
    if (settings.javascriptMode != null) {
      _js = settings.javascriptMode == JavascriptMode.unrestricted;
    }
  }
}

class _FakeWebViewPlatform extends WebViewPlatform {
  _FakeWebViewPlatform() {
    WebView.platform = this;
  }

  @override
  Widget build({
    required BuildContext context,
    required CreationParams creationParams,
    required WebViewPlatformCallbacksHandler webViewPlatformCallbacksHandler,
    required JavascriptChannelRegistry javascriptChannelRegistry,
    WebViewPlatformCreatedCallback? onWebViewPlatformCreated,
    Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers,
  }) {
    return _FakeWebViewWidget(
      creationParams: creationParams,
      onWebViewPlatformCreated: onWebViewPlatformCreated,
      webViewPlatformCallbacksHandler: webViewPlatformCallbacksHandler,
    );
  }
}

class _FakeWebViewWidget extends StatefulWidget {
  final CreationParams creationParams;
  final WebViewPlatformCreatedCallback? onWebViewPlatformCreated;
  final WebViewPlatformCallbacksHandler webViewPlatformCallbacksHandler;

  const _FakeWebViewWidget({
    required this.creationParams,
    Key? key,
    this.onWebViewPlatformCreated,
    required this.webViewPlatformCallbacksHandler,
  }) : super(key: key);

  @override
  State<_FakeWebViewWidget> createState() => _FakeWebViewState();
}

class _FakeWebViewState extends State<_FakeWebViewWidget> {
  late FakeWebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = FakeWebViewController(
      widget.webViewPlatformCallbacksHandler,
      creationParams: widget.creationParams,
    );
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      widget.onWebViewPlatformCreated?.call(controller);
    });
  }

  @override
  void dispose() {
    controller._dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
