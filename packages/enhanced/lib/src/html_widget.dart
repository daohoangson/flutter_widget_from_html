import 'package:flutter/material.dart';
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
  /// Default: `false`.
  final bool webView;

  /// Controls whether debugging is enabled in WebViews.
  ///
  /// Default: `false`.
  final bool webViewDebuggingEnabled;

  /// Controls whether to enable JavaScript in WebViews.
  ///
  /// Default: `true`.
  final bool webViewJs;

  /// Controls whether to always allow media playback in WebViews.
  ///
  /// Default: `false`.
  final bool webViewMediaPlaybackAlwaysAllow;

  /// The value used for the HTTP `User-Agent` request header in WebViews.
  final String webViewUserAgent;

  /// Creates a widget that builds Flutter widget tree from html.
  ///
  /// The [html] argument must not be null.
  HtmlWidget(
    String html, {
    bool buildAsync,
    AsyncWidgetBuilder<Widget> buildAsyncBuilder,
    bool enableCaching = true,
    WidgetFactory Function() factoryBuilder,
    Key key,
    Uri baseUrl,
    CustomStylesBuilder customStylesBuilder,
    CustomWidgetBuilder customWidgetBuilder,
    Color hyperlinkColor,
    void Function(ImageMetadata) onTapImage,
    void Function(String) onTapUrl,
    core.RebuildTriggers rebuildTriggers,
    TextStyle textStyle = const TextStyle(),
    this.webView = false,
    this.webViewDebuggingEnabled = false,
    this.webViewJs = true,
    this.webViewMediaPlaybackAlwaysAllow = false,
    this.webViewUserAgent,
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
          onTapImage: onTapImage,
          onTapUrl: onTapUrl,
          rebuildTriggers: core.RebuildTriggers([
            webView,
            webViewJs,
            if (rebuildTriggers != null) rebuildTriggers,
          ]),
          textStyle: textStyle,
          key: key,
        );

  static WidgetFactory _getEnhancedWf() => WidgetFactory();
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
