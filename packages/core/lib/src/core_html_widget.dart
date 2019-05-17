import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html/parser.dart' as parser;

import 'builder.dart' as core;
import 'core_widget_factory.dart';
import 'data_classes.dart';

class HtmlWidget extends StatelessWidget {
  final String html;
  final FactoryBuilder factoryBuilder;

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
    this.factoryBuilder,
    Key key,
    this.baseUrl,
    this.bodyPadding = const EdgeInsets.all(10),
    this.builderCallback,
    this.hyperlinkColor = const Color.fromRGBO(0, 0, 255, 1),
    this.onTapUrl,
    this.tableCellPadding = const EdgeInsets.all(5),
    this.textStyle,
    this.wrapSpacing = 5,
  })  : assert(html != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final domNodes = parser.parse(html).body.nodes;
    final wf = buildFactory(context);
    final widgets = core.Builder(
      context: context,
      domNodes: domNodes,
      parentTextStyle: textStyle,
      wf: wf,
    ).build();

    return wf.buildBody(widgets) ?? Text(html);
  }

  WidgetFactory buildFactory(BuildContext context) => factoryBuilder != null
      ? factoryBuilder(context, this)
      : WidgetFactory(this);
}

typedef void OnTapUrl(String url);
typedef WidgetFactory FactoryBuilder(BuildContext context, HtmlWidget widget);
