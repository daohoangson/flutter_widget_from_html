import 'package:flutter/widgets.dart';
import 'package:html/parser.dart' as parser;

import 'builder.dart' as builder;
import 'core_config.dart';
import 'core_widget_factory.dart';

class HtmlWidget extends StatelessWidget implements Config {
  final String html;
  final WidgetFactoryBuilder wf;

  final Uri baseUrl;
  final EdgeInsets bodyPadding;
  final EdgeInsets tableCellPadding;
  final EdgeInsets tablePadding;
  final EdgeInsets textPadding;

  const HtmlWidget(
    this.html, {
    this.wf,
    Key key,
    this.baseUrl,
    EdgeInsets bodyPadding,
    EdgeInsets tableCellPadding,
    EdgeInsets tablePadding,
    EdgeInsets textPadding,
  })  : assert(html != null),
        this.bodyPadding =
            bodyPadding ?? const EdgeInsets.symmetric(vertical: 10),
        this.tableCellPadding = tableCellPadding ?? const EdgeInsets.all(5),
        this.tablePadding =
            tablePadding ?? const EdgeInsets.symmetric(horizontal: 10),
        this.textPadding =
            textPadding ?? const EdgeInsets.symmetric(horizontal: 10),
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
