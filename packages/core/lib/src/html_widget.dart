import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;

import 'builder.dart' as builder;
import 'core_wf.dart';

class HtmlWidget extends StatelessWidget {
  final String html;
  final WidgetFactoryBuilder wfBuilder;
  final TextStyle style;

  HtmlWidget(this.html, {Key key, this.wfBuilder, this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final domNodes = parser.parse(html).body.nodes;
    final wf = wfBuilder != null ? wfBuilder(context) : WidgetFactory(context);
    final widgets = builder.Builder(
      domNodes: domNodes,
      widgetFactory: wf,
    ).build();

    return DefaultTextStyle(
      style: style,
      child: wf.buildColumn(widgets) ?? Text(html),
    );
  }
}

typedef WidgetFactory WidgetFactoryBuilder(BuildContext context);
