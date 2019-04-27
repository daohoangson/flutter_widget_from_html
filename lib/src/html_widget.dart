import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core;

import 'config.dart';
import 'widget_factory.dart' as extended;

class HtmlWidget extends core.HtmlWidget implements Config {
  final bool webView;
  final bool webViewJs;

  const HtmlWidget(
    String html, {
    core.WidgetFactoryBuilder wf,
    Key key,
    Uri baseUrl,
    EdgeInsets bodyPadding,
    EdgeInsets tableCellPadding,
    EdgeInsets tablePadding,
    EdgeInsets textPadding,
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
          tableCellPadding: tableCellPadding,
          tablePadding: tablePadding,
          textPadding: textPadding,
        );

  core.WidgetFactory initFactory(BuildContext context) =>
      (wf != null ? wf(context) : extended.WidgetFactory(context))
        ..config = this;
}
