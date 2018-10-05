import 'package:flutter/material.dart';

import 'html_parser.dart';
import 'widget_factory.dart';

class HtmlWidget extends StatelessWidget {
  final String html;
  final WidgetFactory widgetFactory;

  HtmlWidget({
    @required this.html,
    this.widgetFactory = const WidgetFactory(),
    Key key
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    final p = HtmlParser(
      context: context,
      widgetFactory: widgetFactory,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: p.parse(html),
    );
  }
}
