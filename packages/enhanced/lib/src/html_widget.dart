import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core show HtmlWidget, RebuildTriggers;

import 'data.dart';
import 'helpers.dart';
import 'widget_factory.dart';

/// A widget that builds Flutter widget tree from HTML
/// with support for IFRAME, VIDEO and many other tags.
class HtmlWidget extends core.HtmlWidget {
  /// Controls whether IFRAME is rendered as [WebView].
  ///
  /// See [WidgetFactory.webView].
  final bool webView;

  /// Controls whether debugging is enabled in WebViews.
  ///
  /// See [WidgetFactory.webViewDebuggingEnabled].
  final bool webViewDebuggingEnabled;

  /// Controls whether to enable JavaScript in WebViews.
  ///
  /// See [WidgetFactory.webViewJs].
  final bool webViewJs;

  /// Controls whether to always allow media playback in WebViews.
  ///
  /// See [WidgetFactory.webViewMediaPlaybackAlwaysAllow].
  final bool webViewMediaPlaybackAlwaysAllow;

  /// The value used for the HTTP `User-Agent` request header in WebViews.
  ///
  /// See [WidgetFactory.webViewUserAgent].
  final String? webViewUserAgent;

  /// Creates a widget that builds Flutter widget tree from html.
  ///
  /// The [html] argument must not be null.
  HtmlWidget(
    String html, {
    bool? buildAsync,
    AsyncWidgetBuilder<Widget>? buildAsyncBuilder,
    bool enableCaching = true,
    WidgetFactory Function()? factoryBuilder,
    Key? key,
    Uri? baseUrl,
    CustomStylesBuilder? customStylesBuilder,
    CustomWidgetBuilder? customWidgetBuilder,
    Color? hyperlinkColor,
    void Function(ImageMetadata)? onTapImage,
    FutureOr<bool> Function(String)? onTapUrl,
    core.RebuildTriggers? rebuildTriggers,
    RenderMode renderMode = RenderMode.column,
    TextStyle textStyle = const TextStyle(),
    this.webView = false,
    this.webViewDebuggingEnabled = false,
    this.webViewJs = true,
    this.webViewMediaPlaybackAlwaysAllow = false,
    this.webViewUserAgent,
  }) : super(
          html,
          baseUrl: baseUrl,
          buildAsync: buildAsync,
          buildAsyncBuilder: buildAsyncBuilder,
          customStylesBuilder: customStylesBuilder,
          customWidgetBuilder: customWidgetBuilder,
          enableCaching: enableCaching,
          factoryBuilder: factoryBuilder ?? _getEnhancedWf,
          hyperlinkColor: hyperlinkColor,
          onTapImage: onTapImage,
          onTapUrl: onTapUrl,
          rebuildTriggers: core.RebuildTriggers([
            webView,
            webViewJs,
            if (rebuildTriggers != null) rebuildTriggers,
          ]),
          renderMode: renderMode,
          textStyle: textStyle,
          key: key,
        );

  static WidgetFactory _getEnhancedWf() => WidgetFactory();
}
