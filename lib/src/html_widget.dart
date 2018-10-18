import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart' as core;

import 'config.dart';
import 'widget_factory.dart';

class HtmlWidget extends core.HtmlWidget {
  final Config config;

  HtmlWidget(
    String html, {
    this.config = const Config(),
    Key key,
    core.WidgetFactoryBuilder wfBuilder,
  }) : super(
          html,
          key: key,
          wfBuilder: wfBuilder ?? (context) => WidgetFactory(context, config),
        );
}
