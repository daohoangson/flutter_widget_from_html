import 'package:flutter/widgets.dart';
import 'package:html/parser.dart' as parser;

import 'builder.dart' as builder;
import 'core_config.dart';
import 'core_wf.dart';

class HtmlWidget extends StatelessWidget implements Config {
  final Uri baseUrl;
  final String html;
  final WidgetFactoryBuilder wf;

  const HtmlWidget(
    this.html, {
    this.baseUrl,
    Key key,
    this.wf,
  })  : assert(html != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final domNodes = parser.parse(html).body.nodes;
    final wf = initFactory(context);
    final widgets = builder.Builder(domNodes, wf).build();

    return wf.buildBody(widgets) ?? Text(html);
  }

  WidgetFactory initFactory(BuildContext context) =>
      (wf != null ? wf(context) : WidgetFactory(context))..config = this;
}

typedef WidgetFactory WidgetFactoryBuilder(BuildContext context);
