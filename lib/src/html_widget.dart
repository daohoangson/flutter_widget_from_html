import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core;

import 'config.dart';
import 'data_classes.dart';
import 'widget_factory.dart' as extended;

class HtmlWidget extends core.HtmlWidget implements Config {
  final bool unsupportedWebViewWorkaroundForIssue37;
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
    bool unsupportedWebViewWorkaroundForIssue37,
    double wrapSpacing,
    bool webView,
    bool webViewJs,
  })  : this.unsupportedWebViewWorkaroundForIssue37 =
            unsupportedWebViewWorkaroundForIssue37 ?? false,
        this.webView = webView ?? false,
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
