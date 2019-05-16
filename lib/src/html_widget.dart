import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core;

import 'config.dart';
import 'data_classes.dart';
import 'widget_factory.dart' as extended;

class HtmlWidget extends core.HtmlWidget implements Config {

  /// Flag to render WebView for IFRAME tag.
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

  final bool webViewJs;

  Color _hyperlinkColor;

  Color get hyperlinkColor => _hyperlinkColor ?? super.hyperlinkColor;

  HtmlWidget(
    String html, {
    core.WidgetFactory wf,
    Key key,
    Uri baseUrl,
    EdgeInsets bodyPadding,
    NodeMetadataCollector builderCallback,
    Color hyperlinkColor,
    core.OnTapUrl onTapUrl,
    EdgeInsets tableCellPadding,
    TextStyle textStyle,
    double wrapSpacing,
    bool webView,
    bool webViewJs,
  })  : this.webView = webView ?? false,
        this.webViewJs = webViewJs ?? true,
        super(
          html,
          wf: wf,
          key: key,
          baseUrl: baseUrl,
          bodyPadding: bodyPadding,
          builderCallback: builderCallback,
          hyperlinkColor: hyperlinkColor,
          onTapUrl: onTapUrl,
          tableCellPadding: tableCellPadding,
          textStyle: textStyle,
          wrapSpacing: wrapSpacing,
        );

  @override
  core.WidgetFactory initFactory(BuildContext context) {
    _hyperlinkColor = Theme.of(context).accentColor;
    return (wf ?? extended.WidgetFactory())..config = this;
  }
}
