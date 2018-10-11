import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;

import 'src/builder.dart' as builder;
import 'widget_factory.dart';

class HtmlWidget extends StatelessWidget {
  final String html;
  final WidgetFactory widgetFactory;

  HtmlWidget(
      {@required this.html,
      this.widgetFactory = const WidgetFactory(),
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final domNodes = parser.parse(html).body.nodes;

    final widgets = builder.Builder(
      context: context,
      domNodes: domNodes,
      widgetFactory: widgetFactory,
    ).build();

    return widgetFactory.buildColumn(children: widgets);
  }
}
