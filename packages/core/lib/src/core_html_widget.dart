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
  final TextStyle textStyle;
  final double wrapSpacing;

  HtmlWidget(
    this.html, {
    this.wf,
    Key key,
    this.baseUrl,
    EdgeInsets bodyPadding,
    this.builderCallback,
    Color hyperlinkColor,
    this.onTapUrl,
    EdgeInsets tableCellPadding,
    this.textStyle,
    double wrapSpacing,
  })  : assert(html != null),
        this.bodyPadding =
            bodyPadding ?? const EdgeInsets.all(10),
        this.hyperlinkColor =
            hyperlinkColor ?? const Color.fromRGBO(0, 0, 255, 1),
        this.tableCellPadding = tableCellPadding ?? const EdgeInsets.all(5),
        this.wrapSpacing = wrapSpacing ?? 5,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final domNodes = parser.parse(html).body.nodes;
    final wf = initFactory(context);
    final widgets = core.Builder(
      context: context,
      domNodes: domNodes,
      parentTextStyle: textStyle,
      wf: wf,
    ).build();

    return wf.buildBody(widgets) ?? Text(html);
  }

  WidgetFactory initFactory(BuildContext context) =>
      (wf ?? WidgetFactory())..config = this;
}
