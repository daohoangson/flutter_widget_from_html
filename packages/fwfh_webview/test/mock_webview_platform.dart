import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      _onPageStarted(url);
    }
  }

  Map<String, String>? get _currentQueryParameters {
    final url = _currentUrl;
    if (url == null) {
      return null;
    }

    final uri = Uri.tryParse(url);
    if (uri == null) {
      return null;
    }

    return uri.queryParameters;
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
      _onPageStarted(url);
    }
  }

  @override
  Future<String> runJavascriptReturningResult(String javascript) async {
    if (!_js) {
      return '';
    }

    final params = _currentQueryParameters;
    if (params == null) {
      return '';
    }

    if (params['runJavascriptReturningResult'] == 'error') {
      throw PlatformException(code: 'code');
    }

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

  Future<void> _onPageStarted(String url) async {
    handler.onPageStarted(url);
    _urls.add(_currentUrl = url);

    _onPageFinishedTimer = Timer(
      const Duration(milliseconds: 10),
      () {
        final params = _currentQueryParameters;
        if (params != null) {
          final redirectTo = params['redirect_to'];
          if (redirectTo?.isNotEmpty == true) {
            _onPageStarted(redirectTo!);
            return;
          }
        }

        handler.onPageFinished(url);
      },
    );
  }

  void _updateSettings(WebSettings settings) {
    if (settings.javascriptMode != null) {
      _js = settings.javascriptMode == JavascriptMode.unrestricted;
    }
  }
}

// TODO: remove workaround when our minimum Flutter version >2.12
WidgetsBinding? get _widgetsBindingInstance => WidgetsBinding.instance;

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
    _widgetsBindingInstance?.addPostFrameCallback((_) {
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
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey,
      ),
      child: Placeholder(
        color: Colors.black,
      ),
    );
  }
}
