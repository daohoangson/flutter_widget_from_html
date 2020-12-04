import 'dart:io';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart' as lib;

import '../web_view.dart';

class WebViewState extends State<WebView> {
  double _aspectRatio;
  _Issue37 _issue37;
  lib.WebViewController _wvc;

  String _firstFinishedUrl;

  @override
  void initState() {
    super.initState();
    _aspectRatio = widget.aspectRatio;

    if (widget.unsupportedWorkaroundForIssue37 == true) {
      _issue37 = _Issue37(this);
      WidgetsBinding.instance.addObserver(_issue37);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.unsupportedWorkaroundForIssue375 == true) {
      final size = MediaQuery.of(context).size;
      final width = size.width;
      final height = width / _aspectRatio;
      return SizedBox(
        child: _buildWebView(),
        height: Platform.isAndroid ? min(height, size.height) : height,
        width: width,
      );
    }

    return AspectRatio(
      aspectRatio: _aspectRatio,
      child: _buildWebView(),
    );
  }

  @override
  void deactivate() {
    super.deactivate();

    if (widget.unsupportedWorkaroundForIssue37 == true) {
      _wvc?.reload();
    }
  }

  @override
  void dispose() {
    if (_issue37 != null) {
      WidgetsBinding.instance.removeObserver(_issue37);
    }

    super.dispose();
  }

  Future<String> eval(String js) =>
      _wvc?.evaluateJavascript(js)?.catchError((_) => '');

  void _autoResize() async {
    // TODO: enable codecov when `flutter drive --coverage` is available
    // https://github.com/flutter/flutter/issues/7474
    if (!mounted) return;

    final evals = await Future.wait([
      eval('document.body.scrollWidth'),
      eval('document.body.scrollHeight'),
    ]);
    final w = double.tryParse(evals[0] ?? '') ?? 0;
    final h = double.tryParse(evals[1] ?? '') ?? 0;

    final r = (h > 0 && w > 0) ? (w / h) : _aspectRatio;
    final changed = (r - _aspectRatio).abs() > 0.0001;
    if (changed && mounted) setState(() => _aspectRatio = r);
  }

  Widget _buildWebView() => lib.WebView(
        initialUrl: widget.url,
        javascriptMode: widget.js == true
            ? lib.JavascriptMode.unrestricted
            : lib.JavascriptMode.disabled,
        key: Key(widget.url),
        navigationDelegate: widget.interceptNavigationRequest != null
            ? (req) => _interceptNavigationRequest(req)
            : null,
        onPageFinished: _onPageFinished,
        onWebViewCreated: (c) => _wvc = c,
      );

  lib.NavigationDecision _interceptNavigationRequest(
      lib.NavigationRequest req) {
    var intercepted = false;

    if (widget.interceptNavigationRequest != null &&
        _firstFinishedUrl != null &&
        req.isForMainFrame &&
        req.url != widget.url &&
        req.url != _firstFinishedUrl) {
      intercepted = widget.interceptNavigationRequest(req.url);
    }

    return intercepted
        ? lib.NavigationDecision.prevent
        : lib.NavigationDecision.navigate;
  }

  void _onPageFinished(String url) {
    _firstFinishedUrl ??= url;

    if (widget.autoResize == true) {
      widget.autoResizeIntervals.forEach((t) => t == null
          // get dimensions immediately
          ? _autoResize()
          // or wait for the specified duration
          : Future.delayed(t).then((_) => _autoResize()));
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
