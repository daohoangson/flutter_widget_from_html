import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart' as lib;

import 'web_view.dart';

class WebViewState extends State<WebView> {
  late double _aspectRatio;
  String? _firstFinishedUrl;
  _Issue37? _issue37;
  lib.WebViewController? _wvc;

  @override
  void initState() {
    print('${widget.hashCode} $hashCode initState');

    super.initState();
    _aspectRatio = widget.aspectRatio;

    if (widget.unsupportedWorkaroundForIssue37) {
      _issue37 = _Issue37(this);
      WidgetsBinding.instance?.addObserver(_issue37!);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('${widget.hashCode} $hashCode build');

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
    print('${widget.hashCode} $hashCode deactivate');

    super.deactivate();

    if (widget.unsupportedWorkaroundForIssue37) {
      _wvc?.reload();
    }
  }

  @override
  void dispose() {
    print('${widget.hashCode} $hashCode dispose');

    if (_issue37 != null) {
      WidgetsBinding.instance?.removeObserver(_issue37!);
    }

    super.dispose();
  }

  Future<String> eval(String js) =>
      _wvc?.runJavascriptReturningResult(js).catchError((_) => '') ??
      Future.value('');

  Future<void> _autoResize(Duration interval) async {
    // TODO: enable codecov when `flutter drive --coverage` is available
    // https://github.com/flutter/flutter/issues/7474
    if (!mounted) {
      print('${widget.hashCode} $hashCode $interval !mounted');
      return;
    }

    final evals = await Future.wait([
      eval('document.body.scrollWidth'),
      eval('document.body.scrollHeight'),
    ]);
    final w = double.tryParse(evals[0]) ?? 0;
    final h = double.tryParse(evals[1]) ?? 0;
    print('${widget.hashCode} $hashCode $interval width=$w height=$h');

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
        javascriptChannels: {
          lib.JavascriptChannel(
            name: 'Print',
            onMessageReceived: (message) {
              print(
                '${widget.hashCode} $hashCode '
                'onMessageReceived: ${message.message}',
              );
            },
          )
        },
        javascriptMode: widget.js
            ? lib.JavascriptMode.unrestricted
            : lib.JavascriptMode.disabled,
        key: Key(widget.url),
        navigationDelegate: widget.interceptNavigationRequest != null
            ? (req) => _interceptNavigationRequest(req)
            : null,
        onPageFinished: _onPageFinished,
        onWebViewCreated: (c) {
          _wvc = c;
          print('${widget.hashCode} $hashCode onWebViewCreated ${c.hashCode}');
        },
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
    print('${widget.hashCode} $hashCode _onPageFinished $url');

    _firstFinishedUrl ??= url;

    if (widget.autoResize) {
      for (final interval in widget.autoResizeIntervals) {
        if (interval == Duration.zero) {
          // get dimensions immediately
          _autoResize(interval);
        } else {
          // or wait for the specified duration
          Future.delayed(interval).then((_) => _autoResize(interval));
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
