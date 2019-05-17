import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html/parser.dart' as parser;

import 'builder.dart' as core;
import 'core_widget_factory.dart';
import 'data_classes.dart';

/// A widget that builds Flutter widget tree from html.
class HtmlWidget extends StatelessWidget {
  /// The input string.
  ///
  /// It should contains at least HTML and BODY elements (something like
  /// `<html><body>Contents</body></html>`) to avoid parsing quirks.
  final String html;

  /// The custom [WidgetFactory] builder.
  final FactoryBuilder factoryBuilder;

  /// The base url to resolve links and image urls.
  final Uri baseUrl;

  /// The amount of space by which to inset the built widget tree.
  final EdgeInsets bodyPadding;

  /// The callback to render custom elements.
  ///
  /// See also:
  ///
  ///  * [core.Builder]
  final NodeMetadataCollector builderCallback;

  /// The text color for link elements.
  final Color hyperlinkColor;

  /// The callback when user taps a link.
  final OnTapUrl onTapUrl;

  /// The amount of space by which to inset the table cell's contents.
  final EdgeInsets tableCellPadding;

  /// The default styling for text elements.
  final TextStyle textStyle;

  /// The amount of space between [Wrap] children.
  final double wrapSpacing;

  /// Creates a widget that builds Flutter widget tree from html.
  ///
  /// The [html] argument must not be null.
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
