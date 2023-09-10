import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart' as lib;
import 'package:webview_flutter_android/webview_flutter_android.dart' as lib;
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart'
    as lib;

import 'web_view.dart';

Future<void> _ignoreError(Future<void> future) => future.onError(
      (error, _) {
        // TODO: use logger to keep track of stack trace
        debugPrint('Ignored controller error: $error');
      },
    );

class WebViewState extends State<WebView> {
  final _timers = <Timer>[];
  late final lib.WebViewController _controller;

  late double _aspectRatio;
  String? _firstFinishedUrl;
  _Issue37? _issue37;

  @override
  void initState() {
    super.initState();
    _aspectRatio = widget.aspectRatio;

    _ignoreError(_initController());

    if (widget.unsupportedWorkaroundForIssue37) {
      _issue37 = _Issue37(this);
      WidgetsBinding.instance.addObserver(_issue37!);
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
    for (final timer in _timers) {
      timer.cancel();
    }

    if (_issue37 != null) {
      WidgetsBinding.instance.removeObserver(_issue37!);
    }

    super.dispose();
  }

  Future<String> eval(String js) async {
    try {
      final result = await _controller.runJavaScriptReturningResult(js);
      return '$result';
    } catch (evalError) {
      debugPrint('evalError: $evalError');
    }

    return '';
  }

  Future<void> _autoResize() async {
    if (!mounted) {
      return;
    }

    final evals = await Future.wait([
      eval('document.body.scrollWidth'),
      eval('document.body.scrollHeight'),
    ]);
    if (!mounted) {
      return;
    }

    final w = double.tryParse(evals[0]) ?? 0;
    final h = double.tryParse(evals[1]) ?? 0;

    final r = (h > 0 && w > 0) ? (w / h) : _aspectRatio;
    final changed = (r - _aspectRatio).abs() > 0.0001;
    if (changed && mounted) {
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

    if (widget.autoResize) {
      for (final interval in widget.autoResizeIntervals) {
        if (interval == Duration.zero) {
          // get dimensions immediately
          _autoResize();
        } else {
          // or wait for the specified duration
          _timers.add(Timer(interval, _autoResize));
        }
      }
    }
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
