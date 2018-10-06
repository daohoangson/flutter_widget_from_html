import 'package:flutter/material.dart';

import 'src/builder.dart' as builder;
import 'src/parsed_node.dart';
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
    final domNodes = parseDomNodes(html);
    final config = widgetFactory.config;
    final parsedNodes = ParsedNodeProcessor(config: config).parse(domNodes);

    final children = builder.Builder(
      context: context,
      parsedNodes: parsedNodes,
      widgetFactory: widgetFactory,
    ).buildAll();

    return widgetFactory.buildColumn(children: children);
  }
}
