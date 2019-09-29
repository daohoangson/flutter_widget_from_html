import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core;

import 'data_classes.dart';
import 'widget_factory.dart' as extended;

/// A widget that builds Flutter widget tree from html.
class HtmlWidget extends core.HtmlWidget {
  /// Creates a widget that builds Flutter widget tree from html.
  ///
  /// The [html] argument must not be null.
  HtmlWidget(
    String html, {
    core.FactoryBuilder factoryBuilder,
    Key key,
    HtmlWidgetConfig config,
    Uri baseUrl,
    EdgeInsets bodyPadding = const EdgeInsets.all(10),
    NodeMetadataCollector builderCallback,
    Color hyperlinkColor,
    core.OnTapUrl onTapUrl,
    EdgeInsets tableCellPadding = const EdgeInsets.all(5),
    TextStyle textStyle = const TextStyle(),
    bool unsupportedWebViewWorkaroundForIssue37 = false,
    bool webView = false,
    bool webViewJs = true,
  })  : assert(html != null),
        super(
          html,
          factoryBuilder:
              factoryBuilder ?? (config) => extended.WidgetFactory(config),
          config: config ??
              HtmlWidgetConfig(
                baseUrl: baseUrl,
                bodyPadding: bodyPadding,
                builderCallback: builderCallback,
                hyperlinkColor: hyperlinkColor,
                onTapUrl: onTapUrl,
                tableCellPadding: tableCellPadding,
                textStyle: textStyle,
                unsupportedWebViewWorkaroundForIssue37:
                    unsupportedWebViewWorkaroundForIssue37,
                webView: webView,
                webViewJs: webViewJs,
              ),
          key: key,
        );
}

class HtmlWidgetConfig extends core.HtmlWidgetConfig {
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

  HtmlWidgetConfig({
    Uri baseUrl,
    EdgeInsets bodyPadding,
    NodeMetadataCollector builderCallback,
    Color hyperlinkColor,
    core.OnTapUrl onTapUrl,
    EdgeInsets tableCellPadding,
    TextStyle textStyle,
    this.unsupportedWebViewWorkaroundForIssue37,
    this.webView,
    this.webViewJs,
  }) : super(
          baseUrl: baseUrl,
          bodyPadding: bodyPadding,
          builderCallback: builderCallback,
          hyperlinkColor: hyperlinkColor,
          onTapUrl: onTapUrl,
          tableCellPadding: tableCellPadding,
          textStyle: textStyle,
        );
}
