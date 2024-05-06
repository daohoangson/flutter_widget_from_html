import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:webview_flutter/webview_flutter.dart' as lib;
import 'package:webview_flutter_android/webview_flutter_android.dart' as lib;
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart'
    as lib;

import 'web_view.dart';

final _logger = Logger('fwfh_webview');

Future<void>? _ignoreError(Future<void>? future) => future?.onError(
      (error, stackTrace) {
        _logger.warning('Ignored controller error', error, stackTrace);
      },
    );

class WebViewState extends State<WebView> {
  late final lib.WebViewController _controller;

  late double _aspectRatio;
  _DocumentResizeObserver? _documentResizeObserver;
  String? _firstFinishedUrl;
  _Issue37? _issue37;

  @override
  void initState() {
    super.initState();
    _aspectRatio = widget.aspectRatio;

    if (widget.autoResize) {
      _documentResizeObserver = _DocumentResizeObserver(this);
      _documentResizeObserver?.stream.stream.listen(_autoResize);
    }

    _ignoreError(_initController());

    if (widget.unsupportedWorkaroundForIssue37) {
      WidgetsBinding.instance.addObserver(_issue37 = _Issue37(this));
    }
  }

  Future<void> _initController() async {
    var params = const lib.PlatformWebViewControllerCreationParams();
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      params = lib.WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: widget.mediaPlaybackAlwaysAllow
            ? {}
            : {...lib.PlaybackMediaTypes.values},
      );
    }

    _controller = lib.WebViewController.fromPlatformCreationParams(params);
    await _controller.setJavaScriptMode(
      widget.js ? lib.JavaScriptMode.unrestricted : lib.JavaScriptMode.disabled,
    );
    if (widget.js) {
      await _ignoreError(_documentResizeObserver?.initialize());
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

    final uri = Uri.tryParse(widget.url);
    if (mounted && uri != null) {
      await _controller.loadRequest(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _aspectRatio,
      child: _buildWebView(),
    );
  }

  @override
  void deactivate() {
    super.deactivate();

    if (widget.unsupportedWorkaroundForIssue37) {
      _controller.reload();
    }
  }

  @override
  void dispose() {
    final observer = _issue37;
    if (observer != null) {
      WidgetsBinding.instance.removeObserver(observer);
    }

    _documentResizeObserver?.close();

    super.dispose();
  }

  Future<String> eval(String js) async {
    try {
      final result = await _controller.runJavaScriptReturningResult(js);
      return '$result';
    } catch (error, stackTrace) {
      _logger.warning('Could not eval JS', error, stackTrace);
    }

    return '';
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
        key: Key(widget.url),
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => child,
        fullscreenDialog: true,
      ),
    );
  }

  void _onPageFinished(String url) {
    _firstFinishedUrl ??= url;
    _ignoreError(_documentResizeObserver?.onPageFinished());
  }
}

class _DocumentResizeObserver {
  final WebViewState wvs;

  final stream = StreamController<Size>.broadcast();

  _DocumentResizeObserver(this.wvs);

  static const _channelName = '_DocumentResizeObserver';

  Future<dynamic> close() => stream.close();

  Future<void> initialize() async {
    await wvs._controller.addJavaScriptChannel(
      _channelName,
      onMessageReceived: (message) {
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

  Future<void> onPageFinished() async {
    if (!wvs.mounted) {
      return;
    }

    await wvs._controller.runJavaScript('''
(function() {
  const resizeObserver = new ResizeObserver(entries => {
    let size = []
    for (const entry of entries) {
      const { target } = entry
      size = [ target.scrollWidth, target.scrollHeight ]
    }
    window.$_channelName.postMessage(JSON.stringify(size));
  })

  resizeObserver.observe(document.documentElement);
})();
''');
  }
}

class _Issue37 with WidgetsBindingObserver {
  final WebViewState wvs;

  _Issue37(this.wvs);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      wvs._controller.reload();
    }
  }
}
