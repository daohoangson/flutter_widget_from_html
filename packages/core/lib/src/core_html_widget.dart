import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html/parser.dart' as parser;

import 'builder.dart' as core;
import 'core_config.dart';
import 'core_widget_factory.dart';
import 'data_classes.dart';

class HtmlWidget extends StatelessWidget implements Config {
  final String html;
  final WidgetFactory wf;

  final Uri baseUrl;
  final EdgeInsets bodyPadding;
  final NodeMetadataCollector builderCallback;
  final Color hyperlinkColor;
  final OnTapUrl onTapUrl;
  final EdgeInsets tableCellPadding;
  final EdgeInsets tablePadding;
  final EdgeInsets textPadding;
  final TextStyle textStyle;

  const HtmlWidget(
    this.html, {
    this.wf,
    Key key,
    this.baseUrl,
    EdgeInsets bodyPadding,
    this.builderCallback,
    Color hyperlinkColor,
    this.onTapUrl,
    EdgeInsets tableCellPadding,
    EdgeInsets tablePadding,
    EdgeInsets textPadding,
    this.textStyle,
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
    final widgets = core.Builder(
      context: context,
      domNodes: domNodes,
      metadataCallback: builderCallback,
      parentTextStyle: textStyle,
      wf: wf,
    ).build();

    return wf.buildBody(widgets) ?? Text(html);
  }

  WidgetFactory initFactory() => (wf ?? WidgetFactory())..config = this;
}
