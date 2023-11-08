import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

void mockWebViewPlatform() {
  _FakeWebViewPlatform();

  const codec = StandardMessageCodec();
  final emptyList = codec.encodeMessage([]);
  final messenger =
      // TODO: remove lint ignore when our minimum Flutter version >= 3.10
      // ignore: unnecessary_non_null_assertion
      TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger;
  messenger.setMockMessageHandler(
    'dev.flutter.pigeon.webview_flutter_android.InstanceManagerHostApi.clear',
    (_) => Future.value(emptyList),
  );
  messenger.setMockMessageHandler(
    'dev.flutter.pigeon.webview_flutter_android.WebViewHostApi.setWebContentsDebuggingEnabled',
    (message) async {
      final decodedMessage = codec.decodeMessage(message) as List<Object?>;
      FakeWebViewController.instance?.debuggingEnabled =
          decodedMessage[0] == true;
      return emptyList;
    },
  );
}

abstract class FakeWebViewController extends PlatformWebViewController {
  static FakeWebViewController? _instance;
  static FakeWebViewController? get instance => _instance;

  bool? androidMediaPlaybackRequiresUserGesture;
  OnHideCustomWidgetCallback? androidOnHideCustomWidget;
  OnShowCustomWidgetCallback? androidOnShowCustomWidget;
  bool? debuggingEnabled;
  JavaScriptMode? javaScriptMode;
  String? userAgent;

  Uri? _currentUri;
  _FakeNavigationDelegate? _handler;
  Timer? _onPageFinishedTimer;
  final _uris = <Uri>[];

  FakeWebViewController(super.params) : super.implementation() {
    _instance = this;
  }

  Iterable<String> get urls => _uris.map((uri) => uri.toString());

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
    final uri = params.uri;
    const queryParam = 'loadRequest';
    if (uri.queryParameters[queryParam] == 'error') {
      throw PlatformException(code: queryParam);
    } else {
      _onPageStarted(uri);
    }
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
    final params = _currentUri?.queryParameters;
    if (params == null) {
      return '';
    }

    const queryParam = 'runJavaScriptReturningResult';
    if (params[queryParam] == 'error') {
      throw PlatformException(code: queryParam);
    }

    if (params.containsKey(javascript)) {
      return params[javascript] ?? '';
    } else {
      return '';
    }
  }

  @override
  Future<void> setJavaScriptMode(JavaScriptMode value) async {
    javaScriptMode = value;
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
  Future<void> setUserAgent(String? value) async {
    userAgent = value;
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

class __FakeAndroidWebViewController extends FakeWebViewController
    implements AndroidWebViewController {
  __FakeAndroidWebViewController(super.params);

  @override
  Future<void> setCustomWidgetCallbacks({
    required OnHideCustomWidgetCallback? onHideCustomWidget,
    required OnShowCustomWidgetCallback? onShowCustomWidget,
  }) async {
    androidOnHideCustomWidget = onHideCustomWidget;
    androidOnShowCustomWidget = onShowCustomWidget;
  }

  @override
  Future<void> setGeolocationPermissionsPromptCallbacks({
    OnGeolocationPermissionsShowPrompt? onShowPrompt,
    OnGeolocationPermissionsHidePrompt? onHidePrompt,
  }) =>
      throw UnimplementedError();

  @override
  Future<void> setMediaPlaybackRequiresUserGesture(bool require) async {
    androidMediaPlaybackRequiresUserGesture = require;
  }

  @override
  Future<void> setOnShowFileSelector(
    Future<List<String>> Function(FileSelectorParams params)?
        onShowFileSelector,
  ) =>
      throw UnimplementedError();

  @override
  Future<void> setTextZoom(int textZoom) => throw UnimplementedError();

  @override
  int get webViewIdentifier => throw UnimplementedError();
}

class __FakeWebKitWebViewController extends FakeWebViewController
    implements WebKitWebViewController {
  __FakeWebKitWebViewController(super.params);

  @override
  Future<void> setAllowsBackForwardNavigationGestures(bool enabled) =>
      throw UnimplementedError();

  @override
  Future<void> setInspectable(bool value) async {
    debuggingEnabled = value;
  }

  @override
  int get webViewIdentifier => throw UnimplementedError();
}

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
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return __FakeWebKitWebViewController(params);
    } else {
      return __FakeAndroidWebViewController(params);
    }
  }

  @override
  PlatformWebViewWidget createPlatformWebViewWidget(
    PlatformWebViewWidgetCreationParams params,
  ) {
    return _FakeWebViewWidget(params);
  }
}
