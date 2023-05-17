import 'package:flutter/widgets.dart';

import 'fallback.dart'
    if (dart.library.io) 'io.dart'
    if (dart.library.html) 'html.dart';

/// An embedded web view.
class WebView extends StatefulWidget {
  /// The website URL.
  final String url;

  /// The initial aspect ratio.
  final double aspectRatio;

  /// Controls whether to resize automatically.
  ///
  /// [js] must be enabled for this to work.
  /// Default: `true` if [js] is enabled, `false` otherwise.
  ///
  /// Flutter Web is not supported.
  final bool autoResize;

  /// The auto resize intevals.
  ///
  /// By default, resizing will be attempted three times
  /// - On page load
  /// - After 1s
  /// - After another 2s
  final List<Duration> autoResizeIntervals;

  /// {@template web_view.debuggingEnabled}
  /// Controls whether debugging is enabled.
  ///
  /// Default: `false`.
  ///
  /// Flutter Web is not supported.
  /// {@endtemplate}
  final bool debuggingEnabled;

  /// The callback to handle navigation request.
  ///
  /// This will be triggered on generated navigation within the web view.
  /// Returning `true` will stop web view from navigating.
  ///
  /// Flutter Web is not supported.
  final bool Function(String)? interceptNavigationRequest;

  /// {@template web_view.js}
  /// Controls whether to enable JavaScript.
  ///
  /// Default: `true`.
  ///
  /// Flutter Web: JavaScript is always enabled (no sandbox setter).
  /// {@endtemplate}
  final bool js;

  /// {@template web_view.mediaPlaybackAlwaysAllow}
  /// Controls whether to always allow media playback.
  ///
  /// Default: `false`.
  /// {@endtemplate}
  final bool mediaPlaybackAlwaysAllow;

  /// Controls whether or not to apply workaround for
  /// [video continue playing after locking the phone or navigate to another screen](https://github.com/daohoangson/flutter_widget_from_html/issues/37)
  /// issue.
  ///
  /// Default: `true`.
  final bool unsupportedWorkaroundForIssue37;

  /// Controls whether or not to apply workaround for
  /// [crash on Android device](https://github.com/daohoangson/flutter_widget_from_html/issues/375)
  /// issue.
  ///
  /// If your app targets Android 10, it's better to switch to the new webview
  /// implemention: [hybrid composition](https://pub.dev/packages/webview_flutter#using-hybrid-composition).
  ///
  /// Default: `true`.
  final bool unsupportedWorkaroundForIssue375;

  /// {@template web_view.userAgent}
  /// The value used for the HTTP `User-Agent` request header.
  ///
  /// Flutter Web is not supported.
  /// {@endtemplate}
  final String? userAgent;

  /// Creates a web view.
  const WebView(
    this.url, {
    required this.aspectRatio,
    bool? autoResize,
    this.autoResizeIntervals = const [
      Duration.zero,
      Duration(seconds: 1),
      Duration(seconds: 2),
    ],
    this.debuggingEnabled = false,
    this.interceptNavigationRequest,
    this.js = true,
    this.mediaPlaybackAlwaysAllow = false,
    this.unsupportedWorkaroundForIssue37 = true,
    this.unsupportedWorkaroundForIssue375 = true,
    this.userAgent,
    Key? key,
  })  :
        // ignore: avoid_bool_literals_in_conditional_expressions
        autoResize = js ? (autoResize ?? js) : false,
        super(key: key);

  @override
  State<WebView> createState() => WebViewState();
}
