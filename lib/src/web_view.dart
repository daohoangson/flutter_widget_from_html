import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart' as lib;

typedef void GetDimensionsDone(
  double aspectRatio,
  bool changed,
  double height,
  double width,
);

class WebView extends StatefulWidget {
  final String url;

  final double aspectRatio;
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;
  final bool getDimensions;
  final GetDimensionsDone getDimensionsDone;
  final List<Duration> getDimensionsDurations;
  final bool js;

  WebView(
    this.url, {
    this.aspectRatio,
    this.gestureRecognizers,
    this.getDimensions = false,
    this.getDimensionsDone,
    this.getDimensionsDurations = const [
      null,
      Duration(seconds: 1),
      Duration(seconds: 2),
    ],
    this.js = true,
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
  lib.WebViewController _wvc;
  double _aspectRatio;

  @override
  initState() {
    super.initState();
    _aspectRatio = widget.aspectRatio;
  }

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: _aspectRatio,
        child: _buildWebView(),
      );

  Future<String> eval(String js) =>
      _wvc?.evaluateJavascript(js)?.catchError((_) => '');

  Widget _buildWebView() => lib.WebView(
        gestureRecognizers: widget.gestureRecognizers,
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
    final evals = await Future.wait([
      eval("document.body.scrollWidth"),
      eval("document.body.scrollHeight"),
    ]);
    final w = double.tryParse(evals[0] ?? '') ?? 0;
    final h = double.tryParse(evals[1] ?? '') ?? 0;

    final r = (h > 0 && w > 0) ? (w / h) : _aspectRatio;
    final changed = (r - _aspectRatio).abs() > 0.0001;
    if (changed) setState(() => _aspectRatio = r);

    final f = widget.getDimensionsDone;
    if (f != null) f(r, changed, h, w);
  }
}
