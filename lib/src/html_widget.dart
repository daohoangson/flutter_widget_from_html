import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core;

import 'helpers.dart';
import 'widget_factory.dart';

/// A widget that builds Flutter widget tree from HTML
/// with support for IFRAME, VIDEO and many other tags.
class HtmlWidget extends core.HtmlWidget {
  /// Creates a widget that builds Flutter widget tree from html.
  ///
  /// The [html] argument must not be null.
  HtmlWidget(
    String html, {
    bool enableCaching = true,
    core.WidgetFactory Function(core.HtmlConfig) factoryBuilder,
    Key key,
    core.HtmlConfig config,
    Uri baseUrl,
    EdgeInsets bodyPadding = const EdgeInsets.all(10),
    CustomStylesBuilder customStylesBuilder,
    CustomWidgetBuilder customWidgetBuilder,
    Color hyperlinkColor,
    OnTapUrl onTapUrl,
    TextStyle textStyle = const TextStyle(),
    bool unsupportedWebViewWorkaroundForIssue37 = false,
    bool webView = false,
    bool webViewJs = true,
  })  : assert(html != null),
        super(
          html,
          enableCaching: enableCaching,
          factoryBuilder: factoryBuilder ?? (config) => WidgetFactory(config),
          config: config ??
              HtmlConfig(
                baseUrl: baseUrl,
                bodyPadding: bodyPadding,
                customStylesBuilder: customStylesBuilder,
                customWidgetBuilder: customWidgetBuilder,
                hyperlinkColor: hyperlinkColor,
                onTapUrl: onTapUrl,
                textStyle: textStyle,
                unsupportedWebViewWorkaroundForIssue37:
                    unsupportedWebViewWorkaroundForIssue37,
                webView: webView,
                webViewJs: webViewJs,
              ),
          key: key,
        );
}

/// A set of configurable options to build widget.
class HtmlConfig extends core.HtmlConfig {
  /// The flag to control whether or not to apply workaround for
  /// [issue 37](https://github.com/daohoangson/flutter_widget_from_html/issues/37)
  final bool unsupportedWebViewWorkaroundForIssue37;

  /// The flag to control whether or not IFRAME is rendered as WebView.
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
  final bool webView;

  /// The flag to control whether or not WebView has JavaScript enabled.
  final bool webViewJs;

  /// Creates a configuration
  HtmlConfig({
    Uri baseUrl,
    EdgeInsets bodyPadding,
    CustomStylesBuilder customStylesBuilder,
    CustomWidgetBuilder customWidgetBuilder,
    Color hyperlinkColor,
    OnTapUrl onTapUrl,
    TextStyle textStyle,
    this.unsupportedWebViewWorkaroundForIssue37,
    this.webView,
    this.webViewJs,
  }) : super(
          baseUrl: baseUrl,
          bodyPadding: bodyPadding,
          customStylesBuilder: customStylesBuilder,
          customWidgetBuilder: customWidgetBuilder,
          hyperlinkColor: hyperlinkColor,
          onTapUrl: onTapUrl,
          textStyle: textStyle,
        );
}
