part of '../helpers.dart';

class WebView extends StatefulWidget {
  final String url;

  final double aspectRatio;
  final bool getDimensions;
  final List<Duration> getDimensionsDurations;
  final bool Function(String) interceptNavigationRequest;
  final bool js;

  // https://github.com/daohoangson/flutter_widget_from_html/issues/37
  final bool unsupportedWorkaroundForIssue37;

  WebView(
    this.url, {
    this.aspectRatio,
    this.getDimensions = false,
    this.getDimensionsDurations = const [
      null,
      Duration(seconds: 1),
      Duration(seconds: 2),
    ],
    this.interceptNavigationRequest,
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
      "[WebView:url=$url,"
      "aspectRatio=${aspectRatio.toStringAsFixed(2)},"
      "getDimensions=${getDimensions ? 1 : 0},"
      "js=${js ? 1 : 0}"
      "${unsupportedWorkaroundForIssue37 == true ? ',issue37' : ''}"
      ']';
}

class _WebViewState extends State<WebView> {
  double _aspectRatio;
  _Issue37 _issue37;
  lib.WebViewController _wvc;

  String _firstFinishedUrl;

  @override
  initState() {
    super.initState();
    _aspectRatio = widget.aspectRatio;

    if (widget.unsupportedWorkaroundForIssue37 == true) {
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
  }

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
    if (_firstFinishedUrl == null) _firstFinishedUrl = url;

    if (widget.getDimensions == true) {
      widget.getDimensionsDurations.forEach((t) => t == null
          // get dimensions immediately
          ? _getDimensions()
          // or wait for the specified duration
          : Future.delayed(t).then((_) => _getDimensions()));
    }
  }
}

class _Issue37 with WidgetsBindingObserver {
  final _WebViewState wvs;

  _Issue37(this.wvs);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      wvs._wvc?.reload();
    }
  }
}
