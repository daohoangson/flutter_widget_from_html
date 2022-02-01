import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart' as lib;

import 'web_view.dart';

class WebViewState extends State<WebView> {
  final _timers = <Timer>[];

  late double _aspectRatio;
  String? _firstFinishedUrl;
  _Issue37? _issue37;
  lib.WebViewController? _wvc;

  @override
  void initState() {
    super.initState();
    _aspectRatio = widget.aspectRatio;

    if (widget.unsupportedWorkaroundForIssue37) {
      _issue37 = _Issue37(this);
      WidgetsBinding.instance?.addObserver(_issue37!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final webView = _buildWebView();

    if (widget.unsupportedWorkaroundForIssue375 &&
        defaultTargetPlatform == TargetPlatform.android) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.hasBoundedWidth
              ? constraints.maxWidth
              : MediaQuery.of(context).size.width;
          final height = width / _aspectRatio;
          return SizedBox(
            height: min(
              height,
              constraints.hasBoundedHeight
                  ? constraints.maxHeight
                  : MediaQuery.of(context).size.height,
            ),
            width: width,
            child: webView,
          );
        },
      );
    }

    return AspectRatio(
      aspectRatio: _aspectRatio,
      child: webView,
    );
  }

  @override
  void deactivate() {
    super.deactivate();

    if (widget.unsupportedWorkaroundForIssue37) {
      _wvc?.reload();
    }
  }

  @override
  void dispose() {
    for (final timer in _timers) {
      timer.cancel();
    }

    if (_issue37 != null) {
      WidgetsBinding.instance?.removeObserver(_issue37!);
    }

    super.dispose();
  }

  Future<String> eval(String js) async {
    try {
      return await _wvc!.runJavascriptReturningResult(js);
    } catch (_) {
      return '';
    }
  }

  Future<void> _autoResize() async {
    if (!mounted) {
      return;
    }

    final evals = await Future.wait([
      eval('document.body.scrollWidth'),
      eval('document.body.scrollHeight'),
    ]);
    final w = double.tryParse(evals[0]) ?? 0;
    final h = double.tryParse(evals[1]) ?? 0;

    final r = (h > 0 && w > 0) ? (w / h) : _aspectRatio;
    final changed = (r - _aspectRatio).abs() > 0.0001;
    if (changed && mounted) {
      setState(() => _aspectRatio = r);
    }
  }

  Widget _buildWebView() => lib.WebView(
        debuggingEnabled: widget.debuggingEnabled,
        initialUrl: widget.url,
        initialMediaPlaybackPolicy: widget.mediaPlaybackAlwaysAllow
            ? lib.AutoMediaPlaybackPolicy.always_allow
            : lib.AutoMediaPlaybackPolicy
                .require_user_action_for_all_media_types,
        javascriptMode: widget.js
            ? lib.JavascriptMode.unrestricted
            : lib.JavascriptMode.disabled,
        key: Key(widget.url),
        navigationDelegate: widget.interceptNavigationRequest != null
            ? (req) => _interceptNavigationRequest(req)
            : null,
        onPageFinished: _onPageFinished,
        onWebViewCreated: (c) => _wvc = c,
        userAgent: widget.userAgent,
      );

  lib.NavigationDecision _interceptNavigationRequest(
    lib.NavigationRequest req,
  ) {
    var intercepted = false;

    if (widget.interceptNavigationRequest != null &&
        _firstFinishedUrl != null &&
        req.isForMainFrame &&
        req.url != widget.url &&
        req.url != _firstFinishedUrl) {
      intercepted = widget.interceptNavigationRequest!(req.url);
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
      wvs._wvc?.reload();
    }
  }
}
