import 'package:flutter/widgets.dart'
    show BuildContext, Color, EdgeInsets, Key, StatelessWidget, Text, Widget;
import 'package:html/parser.dart' as parser;

import 'builder.dart';
import 'core_config.dart';
import 'core_widget_factory.dart';

class HtmlWidget extends StatelessWidget implements Config {
  final String html;
  final WidgetFactory wf;

  final Uri baseUrl;
  final EdgeInsets bodyPadding;
  final Color hyperlinkColor;
  final EdgeInsets tableCellPadding;
  final EdgeInsets tablePadding;
  final EdgeInsets textPadding;

  const HtmlWidget(
    this.html, {
    this.wf,
    Key key,
    this.baseUrl,
    EdgeInsets bodyPadding,
    Color hyperlinkColor,
    EdgeInsets tableCellPadding,
    EdgeInsets tablePadding,
    EdgeInsets textPadding,
  })  : assert(html != null),
        this.bodyPadding =
            bodyPadding ?? const EdgeInsets.symmetric(vertical: 10),
        this.hyperlinkColor =
            hyperlinkColor ?? const Color.fromRGBO(0, 0, 255, 1),
        this.tableCellPadding = tableCellPadding ?? const EdgeInsets.all(5),
        this.tablePadding =
            tablePadding ?? const EdgeInsets.symmetric(horizontal: 10),
        this.textPadding =
            textPadding ?? const EdgeInsets.symmetric(horizontal: 10),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final domNodes = parser.parse(html).body.nodes;
    final wf = initFactory();
    final widgets = Builder(
      context: context,
      domNodes: domNodes,
      wf: wf,
    ).build();

    return wf.buildBody(widgets) ?? Text(html);
  }

  WidgetFactory initFactory() =>
      (wf ?? WidgetFactory.getInstance())..config = this;
}
