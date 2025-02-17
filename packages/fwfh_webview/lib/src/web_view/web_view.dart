import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import 'fallback.dart'
    if (dart.library.io) 'io.dart'
    if (dart.library.js_interop) 'js_interop.dart';

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

  /// A legacy field that is no longer used.
  @Deprecated('No longer used.')
  final List<Duration> autoResizeIntervals;

  /// {@template web_view.debuggingEnabled}
  /// Controls whether debugging is enabled.
  ///
  /// Default: `false`.
  ///
  /// Flutter Web is not supported.
  /// {@endtemplate}
  final bool debuggingEnabled;

  /// {@template web_view.gestureRecognizers}
  /// Specifies which gestures should be consumed by the web view.
  /// {@endtemplate}
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;

  /// The callback to handle navigation request.
  ///
  /// This will be triggered on generated navigation within the web view.
  /// Returning `true` will stop web view from navigating.
  ///
  /// Flutter Web is not supported.
  final bool Function(String value)? interceptNavigationRequest;

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

  /// {@template web_view.onAndroidHideCustomWidget}
  /// Sets the callback that is invoked when the host application wants to
  /// hide a custom widget.
  ///
  /// Default: pop the most recent route from the nearest navigator.
  /// {@endtemplate}
  final void Function()? onAndroidHideCustomWidget;

  /// {@template web_view.onAndroidShowCustomWidget}
  /// Sets the callback that is invoked when the host application wants to
  /// show a custom widget. The most common use case this method is invoked
  /// a video element wants to be displayed in fullscreen.
  ///
  /// Default: push a page route with the webview in fullscreen.
  /// {@endtemplate}
  final void Function(Widget child)? onAndroidShowCustomWidget;

  /// {@template web_view.unsupportedWorkaroundForIssue37}
  /// Controls whether or not to apply workaround for
  /// [video continue playing after locking the phone or navigate to another screen](https://github.com/daohoangson/flutter_widget_from_html/issues/37)
  /// issue.
  ///
  /// Default: `true`.
  /// {@endtemplate}
  final bool unsupportedWorkaroundForIssue37;

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
    @Deprecated('No longer used.') this.autoResizeIntervals = const [],
    bool? autoResize,
    this.debuggingEnabled = false,
    this.gestureRecognizers = const <Factory<OneSequenceGestureRecognizer>>{},
    this.interceptNavigationRequest,
    this.js = true,
    this.mediaPlaybackAlwaysAllow = false,
    this.onAndroidHideCustomWidget,
    this.onAndroidShowCustomWidget,
    this.unsupportedWorkaroundForIssue37 = true,
    this.userAgent,
    super.key,
  }) : autoResize = js && (autoResize ?? js);

  @override
  State<WebView> createState() => WebViewState();
}
