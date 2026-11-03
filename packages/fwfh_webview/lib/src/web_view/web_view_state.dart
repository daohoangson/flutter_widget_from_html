import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as flutter_material;
import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart' as material_ui;
import 'package:webview_all/webview_all.dart' as lib;
import 'package:webview_all_android/webview_all_android.dart' as lib;
import 'package:webview_all_wkwebview/webview_all_wkwebview.dart' as lib;

import 'platform.dart' if (dart.library.js_interop) 'platform_web.dart'
    as platform;
import 'web_view.dart';

final _logger = Logger('fwfh_webview');

Future<void>? _ignoreError(Future<void>? future) =>
    future?.onError((error, stackTrace) {
      _logger.warning('Ignored controller error', error, stackTrace);
    });

class WebViewState extends State<WebView> {
  late final lib.WebViewController _controller;
  late final Future<void> _initialization;

  late double _aspectRatio;
  String? _firstFinishedUrl;
  _Issue37? _issue37;
  _ResizeObserver? _resizeObserver;

  bool get _applyWorkaroundForIssue37 =>
      !kIsWeb && widget.unsupportedWorkaroundForIssue37;

  @override
  void initState() {
    super.initState();
    _aspectRatio = widget.aspectRatio;
    _controller = lib.WebViewController.fromPlatformCreationParams(
      platform.controllerCreationParams(widget),
    );

    if (!kIsWeb && widget.autoResize) {
      _resizeObserver = _ResizeObserver(this);
      _resizeObserver?.stream.stream.listen(_autoResize);
    }

    unawaited(_initialization = _ignoreError(_initController())!);

    if (_applyWorkaroundForIssue37) {
      WidgetsBinding.instance.addObserver(_issue37 = _Issue37(this));
    }
  }

  Future<void> _initController() async {
    await _controller.setJavaScriptMode(
      kIsWeb || widget.js
          ? lib.JavaScriptMode.unrestricted
          : lib.JavaScriptMode.disabled,
    );
    if (!kIsWeb) {
      await _configureNativeController();
    }

    final uri = platform.parseUrl(widget.url);
    if (mounted && uri != null) {
      await _controller.loadRequest(uri);
    }
  }

  Future<void> _configureNativeController() async {
    if (widget.js) {
      await _ignoreError(_resizeObserver?.initialize());
    }

    await _controller.setNavigationDelegate(
      lib.NavigationDelegate(
        onPageFinished: _onPageFinished,
        onNavigationRequest: widget.interceptNavigationRequest != null
            ? (req) => _interceptNavigationRequest(req)
            : null,
      ),
    );
    await _controller.setUserAgent(widget.userAgent);

    final platformController = _controller.platform;
    if (platformController is lib.AndroidWebViewController) {
      await _ignoreError(
        lib.AndroidWebViewController.enableDebugging(widget.debuggingEnabled),
      );
      await platformController.setMediaPlaybackRequiresUserGesture(
        !widget.mediaPlaybackAlwaysAllow,
      );

      final onHideCustomWidget =
          widget.onAndroidHideCustomWidget ?? _onAndroidHideCustomWidgetDefault;
      final onShowCustomWidget =
          widget.onAndroidShowCustomWidget ?? _onAndroidShowCustomWidgetDefault;
      await platformController.setCustomWidgetCallbacks(
        onHideCustomWidget: onHideCustomWidget,
        onShowCustomWidget: (child, _) => onShowCustomWidget(child),
      );
    } else if (platformController is lib.WebKitWebViewController) {
      await _ignoreError(
        platformController.setInspectable(widget.debuggingEnabled),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: kIsWeb ? widget.aspectRatio : _aspectRatio,
      child: _buildWebView(),
    );
  }

  @override
  void deactivate() {
    super.deactivate();

    if (_applyWorkaroundForIssue37) {
      unawaited(_ignoreError(_controller.reload()));
    }
  }

  @override
  void dispose() {
    final observer = _issue37;
    if (observer != null) {
      WidgetsBinding.instance.removeObserver(observer);
    }

    _resizeObserver?.close();
    unawaited(
      _ignoreError(
        _initialization.then((_) => _controller.platform.closeWebViewSession()),
      ),
    );

    super.dispose();
  }

  Future<void> _autoResize(Size size) async {
    if (!mounted) {
      return;
    }

    final w = size.width;
    final h = size.height;
    final r = (h > 0 && w > 0) ? (w / h) : _aspectRatio;
    final changed = (r - _aspectRatio).abs() > 0.0001;
    if (changed) {
      setState(() => _aspectRatio = r);
    }
  }

  Widget _buildWebView() => lib.WebViewWidget(
        controller: _controller,
        gestureRecognizers: kIsWeb ? const {} : widget.gestureRecognizers,
        key: kIsWeb ? null : Key(widget.url),
      );

  lib.NavigationDecision _interceptNavigationRequest(
    lib.NavigationRequest req,
  ) {
    var intercepted = false;
    final callback = widget.interceptNavigationRequest;
    if (callback != null &&
        _firstFinishedUrl != null &&
        req.isMainFrame &&
        req.url != widget.url &&
        req.url != _firstFinishedUrl) {
      intercepted = callback(req.url);
    }

    return intercepted
        ? lib.NavigationDecision.prevent
        : lib.NavigationDecision.navigate;
  }

  void _onAndroidHideCustomWidgetDefault() {
    Navigator.of(context).pop();
  }

  void _onAndroidShowCustomWidgetDefault(Widget child) {
    final mode = resolveMaterialThemeMode(
      context,
      widget.materialThemeMode,
    ).mode;
    Navigator.of(context).push(
      mode == MaterialThemeMode.materialUi
          ? material_ui.MaterialPageRoute<void>(
              builder: (_) => child,
              fullscreenDialog: true,
            )
          : flutter_material.MaterialPageRoute<void>(
              builder: (_) => child,
              fullscreenDialog: true,
            ),
    );
  }

  void _onPageFinished(String url) {
    if (!mounted) {
      return;
    }

    _firstFinishedUrl ??= url;
    unawaited(_ignoreError(_resizeObserver?.observe('document.body')));
  }
}

class _Issue37 with WidgetsBindingObserver {
  final WebViewState wvs;

  _Issue37(this.wvs);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      unawaited(_ignoreError(wvs._controller.reload()));
    }
  }
}

class _ResizeObserver {
  final String channelName;
  final stream = StreamController<Size>();
  final WebViewState wvs;

  _ResizeObserver(this.wvs)
      : channelName = 'FwfhWebViewResizeObserver${wvs.hashCode}';

  Future<dynamic> close() => stream.close();

  Future<void> initialize() async {
    await wvs._controller.addJavaScriptChannel(
      channelName,
      onMessageReceived: (message) {
        if (stream.isClosed) {
          return;
        }

        final parsed = jsonDecode(message.message);
        if (parsed is List && parsed.length == 2) {
          final width = parsed[0];
          final height = parsed[1];
          if (width is num && height is num) {
            stream.sink.add(Size(width.toDouble(), height.toDouble()));
          }
        }
      },
    );
  }

  Future<void> observe(String target) async {
    if (!wvs.mounted) {
      return;
    }

    await wvs._controller.runJavaScript('''
(function() {
  if (typeof window['$channelName'] === 'undefined') { return; }
  const channel = window['$channelName'];
  delete window['$channelName'];

  const resizeObserver = new ResizeObserver(entries => {
    let size = []
    for (const entry of entries) {
      const { target } = entry
      size = [ target.scrollWidth, target.scrollHeight ]
    }
    channel.postMessage(JSON.stringify(size));
  })

  resizeObserver.observe($target);
})();
''');
  }
}
