import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart' as lib;

/// An embedded web view.
class WebView extends StatefulWidget {
  /// The website URL.
  final String url;

  /// The initial aspect ratio.
  final double aspectRatio;

  /// Controls whether to resize automatically.
  ///
  /// JavaScript must be enabled for this to work.
  /// Default: `true` if [js] is enabled, `false` otherwise.
  final bool autoResize;

  /// The auto resize intevals.
  ///
  /// By default, resizing will be attempted three times
  /// - On page load
  /// - After 1s
  /// - After another 2s
  final List<Duration> autoResizeIntervals;

  /// The callback to handle navigation request.
  ///
  /// This callback will be triggered on generated navigation within the web view.
  /// Returning `true` will stop web view from navigating.
  final bool Function(String) interceptNavigationRequest;

  /// Controls whether to enable JavaScript.
  ///
  /// Default: `true`.
  final bool js;

  /// Controls whether or not to apply workaround for
  /// [issue 37](https://github.com/daohoangson/flutter_widget_from_html/issues/37)
  ///
  /// Default: `false`.
  final bool unsupportedWorkaroundForIssue37;

  /// Creates a web view.
  WebView(
    this.url, {
    @required this.aspectRatio,
    bool autoResize,
    this.autoResizeIntervals = const [
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
        autoResize = !js ? false : autoResize ?? js,
        super(key: key);

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
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
  final _WebViewState wvs;

  _Issue37(this.wvs);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      wvs._wvc?.reload();
    }
  }
}
