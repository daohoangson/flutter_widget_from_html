import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core;

import 'config.dart';
import 'data_classes.dart';
import 'widget_factory.dart' as extended;

class HtmlWidget extends core.HtmlWidget implements Config {
  final bool webView;
  final bool webViewJs;

  const HtmlWidget(
    String html, {
    core.WidgetFactory wf,
    Key key,
    Uri baseUrl,
    EdgeInsets bodyPadding,
    NodeMetadataCollector builderCallback,
    Color hyperlinkColor,
    core.OnTapUrl onTapUrl,
    EdgeInsets tableCellPadding,
    EdgeInsets tablePadding,
    EdgeInsets textPadding,
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
          tablePadding: tablePadding,
          textPadding: textPadding,
          textStyle: textStyle,
          wrapSpacing: wrapSpacing,
        );

  core.WidgetFactory initFactory() =>
      (wf ?? extended.WidgetFactory())..config = this;
}
