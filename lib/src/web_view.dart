import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart' as lib;

class WebView extends StatefulWidget {
  final String url;

  final double aspectRatio;
  final bool getDimensions;
  final _GetDimensionsDone getDimensionsDone;
  final List<Duration> getDimensionsDurations;
  final bool js;

  // https://github.com/daohoangson/flutter_widget_from_html/issues/37
  final bool unsupportedWorkaroundForIssue37;

  WebView(
    this.url, {
    this.aspectRatio,
    this.getDimensions = false,
    this.getDimensionsDone,
    this.getDimensionsDurations = const [
      null,
      Duration(seconds: 1),
      Duration(seconds: 2),
    ],
    this.js = true,
    this.unsupportedWorkaroundForIssue37 = false,
    Key key,
  })  : assert(url != null),
        assert(aspectRatio != null),
        // `js` must be true for `getDimensions` to work
        assert(getDimensions == false || js == true),
        super(key: key);

  @override
  _WebViewState createState() => _WebViewState();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) =>
      "[WebView:url=$url,aspectRatio=${aspectRatio.toStringAsFixed(2)}," +
      "getDimensions=$getDimensions,js=$js]";
}

class _WebViewState extends State<WebView> {
  double _aspectRatio;
  _Issue37 _issue37;
  lib.WebViewController _wvc;

  @override
  initState() {
    super.initState();
    _aspectRatio = widget.aspectRatio;

    if (widget.unsupportedWorkaroundForIssue37) {
      _issue37 = _Issue37(this);
      WidgetsBinding.instance.addObserver(_issue37);
    }
  }

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: _aspectRatio,
        child: _buildWebView(),
      );

  @override
  void deactivate() {
    super.deactivate();

    if (widget.unsupportedWorkaroundForIssue37) {
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

  Widget _buildWebView() => lib.WebView(
        initialUrl: widget.url,
        javascriptMode: widget.js
            ? lib.JavascriptMode.unrestricted
            : lib.JavascriptMode.disabled,
        key: Key(widget.url),
        onPageFinished: widget.getDimensions
            ? (_) => widget.getDimensionsDurations.forEach((t) => t == null
                // get dimensions immediately
                ? _getDimensions()
                // or wait for the specified duration
                : Future.delayed(t).then((_) => _getDimensions()))
            : null,
        onWebViewCreated: (c) => _wvc = c,
      );

  void _getDimensions() async {
    // TODO: enable codecov when `flutter drive --coverage` is available
    // https://github.com/flutter/flutter/issues/7474
    if (!mounted) return;

    final evals = await Future.wait([
      eval("document.body.scrollWidth"),
      eval("document.body.scrollHeight"),
    ]);
    final w = double.tryParse(evals[0] ?? '') ?? 0;
    final h = double.tryParse(evals[1] ?? '') ?? 0;

    final r = (h > 0 && w > 0) ? (w / h) : _aspectRatio;
    final changed = (r - _aspectRatio).abs() > 0.0001;
    if (changed && mounted) setState(() => _aspectRatio = r);

    final f = widget.getDimensionsDone;
    if (f != null) f(r, changed, h, w);
  }
}

typedef void _GetDimensionsDone(
  double aspectRatio,
  bool changed,
  double height,
  double width,
);

class _Issue37 with WidgetsBindingObserver {
  final _WebViewState wvs;

  _Issue37(this.wvs);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      wvs._wvc.reload();
    }
  }
}
