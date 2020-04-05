import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core;

import 'config.dart';
import 'data_classes.dart';
import 'widget_factory.dart' as extended;

/// A widget that builds Flutter widget tree from html.
class HtmlWidget extends core.HtmlWidget {
  /// Creates a widget that builds Flutter widget tree from html.
  ///
  /// The [html] argument must not be null.
  HtmlWidget(
    String html, {
    bool enableCaching = true,
    core.FactoryBuilder factoryBuilder,
    Key key,
    core.HtmlConfig config,
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
          enableCaching: enableCaching,
          factoryBuilder:
              factoryBuilder ?? (config) => extended.WidgetFactory(config),
          config: config ??
              HtmlExtendedConfig(
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
