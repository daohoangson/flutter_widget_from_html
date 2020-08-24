import 'package:flutter/widgets.dart';

import 'web_view/fallback.dart'
    if (dart.library.html) 'web_view/html.dart'
    if (dart.library.io) 'web_view/io.dart';

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
  State<WebView> createState() => WebViewState();
}
