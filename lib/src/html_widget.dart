import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core;

import 'data_classes.dart';
import 'widget_factory.dart' as extended;

class HtmlWidget extends core.HtmlWidget {
  final core.FactoryBuilder factoryBuilder;

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

  HtmlWidget(
    String html, {
    this.factoryBuilder,
    Key key,
    Uri baseUrl,
    EdgeInsets bodyPadding = const EdgeInsets.all(10),
    NodeMetadataCollector builderCallback,
    Color hyperlinkColor,
    core.OnTapUrl onTapUrl,
    EdgeInsets tableCellPadding = const EdgeInsets.all(5),
    TextStyle textStyle,
    double wrapSpacing = 5,
    this.webView = false,
    this.webViewJs = true,
  }) : super(
          html,
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
  core.WidgetFactory buildFactory(BuildContext context) =>
      factoryBuilder != null
          ? factoryBuilder(context, this)
          : extended.WidgetFactory(context, this);
}
