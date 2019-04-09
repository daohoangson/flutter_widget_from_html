import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart' as lib;

class WebView extends StatefulWidget {
  final String url;

  final double defaultAspectRatio;
  final List<Duration> getDimensionsDurations;
  final double height;
  final bool js;
  final double width;

  WebView(
    this.url, {
    this.defaultAspectRatio = 16 / 9,
    this.getDimensionsDurations = const [
      Duration(milliseconds: 500),
      Duration(seconds: 1),
      Duration(seconds: 2),
      Duration(seconds: 4),
    ],
    this.height,
    this.js = true,
    Key key,
    this.width,
  }) : super(key: key);

  @override
  _WebViewState createState() => _WebViewState();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) =>
      "[WebView:url=$url,height=$height,js=$js,width=$width]";
}

class _WebViewState extends State<WebView> {
  lib.WebViewController _controller;
  double _aspectRatio;
  double _aspectRatioInitial;
  bool _widgetHasDimensions = false;

  @override
  initState() {
    super.initState();

    if (widget.height != null &&
        widget.height > 0 &&
        widget.width != null &&
        widget.width > 0) {
      _aspectRatio = widget.width / widget.height;
      _widgetHasDimensions = true;
    } else {
      _aspectRatio = widget.defaultAspectRatio;
    }

    _aspectRatioInitial = _aspectRatio;
  }

  @override
  Widget build(BuildContext context) => _buildAspectRatio(_buildWebView());

  Widget _buildAspectRatio(Widget child) => AspectRatio(
        aspectRatio: _aspectRatio,
        child: child,
      );

  Widget _buildWebView() {
    final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers =
        !_widgetHasDimensions && _aspectRatio == _aspectRatioInitial
            ? (Set()
              ..add(Factory<VerticalDragGestureRecognizer>(
                () => VerticalDragGestureRecognizer(),
              )))
            : null;

    if (!_widgetHasDimensions && widget.js) {
      return lib.WebView(
        gestureRecognizers: gestureRecognizers,
        initialUrl: widget.url,
        javascriptMode: lib.JavascriptMode.unrestricted,
        onPageFinished: (u) => (u == widget.url) ? _getDimensionsAll() : null,
        onWebViewCreated: (c) => _controller = c,
      );
    }

    return lib.WebView(
      gestureRecognizers: gestureRecognizers,
      initialUrl: widget.url,
      javascriptMode: widget.js
          ? lib.JavascriptMode.unrestricted
          : lib.JavascriptMode.disabled,
    );
  }

  void _getDimensions() => _controller
      ?.evaluateJavascript("document.body.scrollWidth")
      ?.then((scrollWidth) => _controller
              .evaluateJavascript("document.body.scrollHeight")
              .then((scrollHeight) {
            final width = double.tryParse(scrollWidth);
            final height = double.tryParse(scrollHeight);
            if (height != null && height > 0 && width != null && width > 0) {
              final aspectRatio = width / height;
              if ((aspectRatio - _aspectRatio).abs() > 0.01) {
                setState(() => _aspectRatio = aspectRatio);
              }
            }
          }))
      ?.catchError((_) {/*ignore error */});

  void _getDimensionsAll() {
    _getDimensions();

    widget.getDimensionsDurations
        .forEach((t) => Future.delayed(t).then((_) => _getDimensions()));
  }
}
