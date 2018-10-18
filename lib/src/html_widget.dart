import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/core.dart' as core;

import 'config.dart';
import 'widget_factory.dart';

class HtmlWidget extends core.HtmlWidget {
  final Config config;

  HtmlWidget(
    String html, {
    this.config = const Config(),
    Key key,
  }) : super(html, key: key);

  @override
  core.WidgetFactory newWidgetFactory(BuildContext context) =>
      WidgetFactory(context, config);
}
