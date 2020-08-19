import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core show HtmlWidget;

import 'helpers.dart';
import 'widget_factory.dart';

/// A widget that builds Flutter widget tree from HTML
/// with support for IFRAME, VIDEO and many other tags.
class HtmlWidget extends core.HtmlWidget {
  /// Controls whether or not to apply workaround for
  /// [issue 37](https://github.com/daohoangson/flutter_widget_from_html/issues/37)
  ///
  /// Default: `false`.
  final bool unsupportedWebViewWorkaroundForIssue37;

  /// Controls whether or not IFRAME is rendered as [WebView].
  ///
  /// You must perform additional configuration for this to work.
  /// ### iOS
  /// Add this at the end of `ios/Runner/Info.plist` to enable
  /// Flutter's experimental platform view.
  /// See more info [here](https://pub.dev/packages/webview_flutter#ios).
  /// ```plist
  /// <key>io.flutter.embedded_views_preview</key>
  /// <string>YES</string>
  /// ```
  /// ### Android
  /// Add this into `android/app/src/main/AndroidManifest.xml`
  /// to enable internet access. Without this, you will most likely
  /// see a `net:ERR_CACHE_MISS` error for each iframe being rendered.
  /// ```xml
  /// <uses-permission android:name="android.permission.INTERNET" />
  /// ```
  ///
  /// Default: `false`.
  final bool webView;

  /// Controls whether to enable JavaScript in [WebView].
  ///
  /// Default: `true`.
  final bool webViewJs;

  /// Creates a widget that builds Flutter widget tree from html.
  ///
  /// The [html] argument must not be null.
  HtmlWidget(
    String html, {
    Uri baseUrl,
    bool buildAsync,
    AsyncWidgetBuilder<Widget> buildAsyncBuilder,
    CustomStylesBuilder customStylesBuilder,
    CustomWidgetBuilder customWidgetBuilder,
    bool enableCaching = true,
    WidgetFactory Function() factoryBuilder,
    Color hyperlinkColor,
    Key key,
    void Function(String) onTapUrl,
    TextStyle textStyle = const TextStyle(),
    this.unsupportedWebViewWorkaroundForIssue37 = false,
    bool useWidgetSpan = !kIsWeb,
    this.webView = false,
    this.webViewJs = true,
  })  : assert(html != null),
        super(
          html,
          baseUrl: baseUrl,
          buildAsync: buildAsync,
          buildAsyncBuilder: buildAsyncBuilder ?? _buildAsyncBuilder,
          customStylesBuilder: customStylesBuilder,
          customWidgetBuilder: customWidgetBuilder,
          enableCaching: enableCaching,
          factoryBuilder: factoryBuilder ?? _getEnhancedWf,
          hyperlinkColor: hyperlinkColor,
          onTapUrl: onTapUrl,
          textStyle: textStyle,
          useWidgetSpan: useWidgetSpan,
          key: key,
        );

  static WidgetFactory _enhancedWf;
  static WidgetFactory _getEnhancedWf() {
    _enhancedWf ??= WidgetFactory();
    return _enhancedWf;
  }
}

Widget _buildAsyncBuilder(BuildContext _, AsyncSnapshot<Widget> snapshot) =>
    snapshot.hasData
        ? snapshot.data
        : const Center(
            child: Padding(
              child: CircularProgressIndicator(),
              padding: EdgeInsets.all(8),
            ),
          );
