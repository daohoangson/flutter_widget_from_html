import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart' as lib;

class WebView extends StatefulWidget {
  final String url;
  final List<Duration> getDimensionsDurations;
  final double height;
  final bool js;
  final double width;

  WebView(
    this.url, {
    this.getDimensionsDurations = const [
      Duration(milliseconds: 500),
      Duration(seconds: 1),
      Duration(seconds: 2),
      Duration(seconds: 4),
    ],
    this.height,
    this.js,
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
  double _width;
  double _height;
  lib.WebViewController _controller;

  bool get hasDimensions => (_height != null && _width != null);

  @override
  initState() {
    super.initState();

    if (widget.height != null &&
        widget.height > 0 &&
        widget.width != null &&
        widget.width > 0) {
      _width = widget.width;
      _height = widget.height;
    }
  }

  @override
  Widget build(BuildContext context) => _buildAspectRatio(_buildWebView());

  Widget _buildAspectRatio(Widget child) => AspectRatio(
        aspectRatio: hasDimensions ? (_width / _height) : (16 / 9),
        child: child,
      );

  Widget _buildWebView() {
    if (!hasDimensions && widget.js) {
      return lib.WebView(
        initialUrl: widget.url,
        javascriptMode: lib.JavascriptMode.unrestricted,
        onPageFinished: (url) {
          if (url != widget.url) return;

          _getDimensions();

          widget.getDimensionsDurations
              .forEach((t) => Future.delayed(t).then((_) => _getDimensions()));
        },
        onWebViewCreated: (c) => _controller = c,
      );
    }

    return lib.WebView(
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
              setState(() {
                _height = height;
                _width = width;
              });
            }
          }))
      ?.catchError((_) {/*ignore error */});
}
