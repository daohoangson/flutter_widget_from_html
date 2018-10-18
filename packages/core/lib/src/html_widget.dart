import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;

import 'builder.dart' as builder;
import 'widget_factory.dart';

class HtmlWidget extends StatelessWidget {
  final String html;

  HtmlWidget(this.html, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final domNodes = parser.parse(html).body.nodes;
    final wf = newWidgetFactory(context);
    final widgets = builder.Builder(
      domNodes: domNodes,
      widgetFactory: wf,
    ).build();

    return wf.buildColumn(widgets);
  }

  WidgetFactory newWidgetFactory(BuildContext context) =>
      WidgetFactory(context);
}
