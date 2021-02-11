import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'web_view/fallback.dart' if (dart.library.io) 'web_view/io.dart';

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
  /// Flutter Web: No.
  final bool autoResize;

  /// The auto resize intevals.
  ///
  /// By default, resizing will be attempted three times
  /// - On page load
  /// - After 1s
  /// - After another 2s
  final List<Duration> autoResizeIntervals;

  /// Controls whether WebView debugging is enabled.
  ///
  /// Default: `false`.
  final bool debuggingEnabled;

  /// The callback to handle navigation request.
  ///
  /// This callback will be triggered on generated navigation within the web view.
  /// Returning `true` will stop web view from navigating.
  /// Flutter Web: No.
  final bool Function(String) interceptNavigationRequest;

  /// Controls whether to enable JavaScript.
  ///
  /// Default: `true`.
  /// Flutter Web: JavaScript is always enabled (cannot turn off).
  final bool js;

  /// Controls whether to always allow media playback.
  ///
  /// Default: `false`.
  final bool mediaPlaybackAlwaysAllow;

  /// {@template web_view.unsupportedWorkaroundForIssue37}
  /// Controls whether or not to apply workaround for
  /// [video continue playing after locking the phone or navigate to another screen](https://github.com/daohoangson/flutter_widget_from_html/issues/37)
  /// issue.
  ///
  /// Default: `false`.
  /// {@endtemplate}
  final bool unsupportedWorkaroundForIssue37;

  /// {@template web_view.unsupportedWorkaroundForIssue375}
  /// Controls whether or not to apply workaround for
  /// [crash on Android device](https://github.com/daohoangson/flutter_widget_from_html/issues/375)
  /// issue.
  ///
  /// If your app targets Android 10, it's better to switch to the new webview
  /// implemention: [hybrid composition](https://pub.dev/packages/webview_flutter#using-hybrid-composition).
  ///
  /// Default: `false`.
  /// {@endtemplate}
  final bool unsupportedWorkaroundForIssue375;

  /// The value used for the HTTP User-Agent: request header.
  final String userAgent;

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
    this.debuggingEnabled = false,
    this.interceptNavigationRequest,
    this.js = true,
    this.mediaPlaybackAlwaysAllow = false,
    this.unsupportedWorkaroundForIssue37 = false,
    this.unsupportedWorkaroundForIssue375 = false,
    this.userAgent,
    Key key,
  })  : assert(url != null),
        assert(aspectRatio != null),
        autoResize = !js ? false : autoResize ?? js,
        super(key: key);

  @override
  State<WebView> createState() =>
      (!kIsWeb && Platform.environment.containsKey('FLUTTER_TEST'))
          ? _WebViewPlaceholder()
          : WebViewState();
}

class _WebViewPlaceholder extends State<WebView> {
  @override
  Widget build(BuildContext _) => AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: Container(
        child: Center(child: Text('WebView')),
        color: Color.fromRGBO(0, 0, 0, .5),
      ));
}
