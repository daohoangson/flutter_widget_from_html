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
    Key key,
    core.WidgetFactoryBuilder wf,
    this.webView = false,
    this.webViewJs = true,
  }) : super(
          html,
          key: key,
          wf: wf,
        );

  core.WidgetFactory initFactory(BuildContext context) =>
      (wf != null ? wf(context) : extended.WidgetFactory(context))
        ..config = this;
}
