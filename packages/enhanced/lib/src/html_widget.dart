import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core show HtmlWidget, RebuildTriggers;

import 'data.dart';
import 'helpers.dart';
import 'widget_factory.dart';

/// A widget that builds Flutter widget tree from HTML
/// with support for IFRAME, VIDEO and many other tags.
class HtmlWidget extends core.HtmlWidget {
  /// {@macro web_view.unsupportedWorkaroundForIssue37}
  final bool unsupportedWebViewWorkaroundForIssue37;

  /// {@macro web_view.unsupportedWorkaroundForIssue375}
  final bool unsupportedWebViewWorkaroundForIssue375;

  /// Controls whether or not IFRAME is rendered as [WebView].
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
    this.unsupportedWebViewWorkaroundForIssue37 = false,
    this.unsupportedWebViewWorkaroundForIssue375 = false,
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
          onTapImage: onTapImage,
          onTapUrl: onTapUrl,
          rebuildTriggers: core.RebuildTriggers([
            unsupportedWebViewWorkaroundForIssue37,
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
