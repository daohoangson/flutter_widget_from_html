import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart' as lib;
import 'package:webview_flutter_android/webview_flutter_android.dart' as lib;
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart'
    as lib;

import 'web_view.dart';

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

    _initController();

    if (widget.unsupportedWorkaroundForIssue37) {
      _issue37 = _Issue37(this);
      WidgetsBinding.instance.addObserver(_issue37!);
    }
  }

  void _initController() {
    var params = const lib.PlatformWebViewControllerCreationParams();
    if (lib.WebViewPlatform.instance is lib.WebKitWebViewPlatform) {
      params = lib.WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: widget.mediaPlaybackAlwaysAllow
            ? {}
            : {...lib.PlaybackMediaTypes.values},
      );
    }

    _controller = lib.WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(
        widget.js
            ? lib.JavaScriptMode.unrestricted
            : lib.JavaScriptMode.disabled,
      )
      ..setNavigationDelegate(
        lib.NavigationDelegate(
          onPageFinished: _onPageFinished,
          onNavigationRequest: widget.interceptNavigationRequest != null
              ? (req) => _interceptNavigationRequest(req)
              : null,
        ),
      )
      ..setUserAgent(widget.userAgent)
      ..loadRequest(Uri.parse(widget.url));

    final platformController = _controller.platform;
    if (platformController is lib.AndroidWebViewController) {
      lib.AndroidWebViewController.enableDebugging(widget.debuggingEnabled);
      platformController.setMediaPlaybackRequiresUserGesture(
        !widget.mediaPlaybackAlwaysAllow,
      );
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
      if (result is String) {
        return result;
      }
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
