import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html/parser.dart' as parser;

import 'builder.dart' as core;
import 'core_widget_factory.dart';
import 'data_classes.dart';

TextStyle _rootTextStyleBuilder(
  TextStyleBuilders _,
  TextStyle parent,
  HtmlWidgetConfig config,
) {
  var style = config.textStyle;
  if (style == null) return parent;
  if (style.inherit) return parent.merge(style);
  return style;
}

/// A widget that builds Flutter widget tree from html.
class HtmlWidget extends StatefulWidget {
  /// The input string.
  ///
  /// It should contains at least HTML and BODY elements (something like
  /// `<html><body>Contents</body></html>`) to avoid parsing quirks.
  final String html;

  /// The custom [WidgetFactory] builder.
  final FactoryBuilder factoryBuilder;

  final HtmlWidgetConfig _config;

  /// Creates a widget that builds Flutter widget tree from html.
  ///
  /// The [html] argument must not be null.
  HtmlWidget(
    this.html, {
    this.factoryBuilder,
    Key key,
    HtmlWidgetConfig config,
    Uri baseUrl,
    EdgeInsets bodyPadding = const EdgeInsets.all(10),
    NodeMetadataCollector builderCallback,
    Color hyperlinkColor = const Color.fromRGBO(0, 0, 255, 1),
    OnTapUrl onTapUrl,
    EdgeInsets tableCellPadding = const EdgeInsets.all(5),
    TextStyle textStyle = const TextStyle(),
  })  : assert(html != null),
        _config = config ??
            HtmlWidgetConfig(
              baseUrl: baseUrl,
              bodyPadding: bodyPadding,
              builderCallback: builderCallback,
              hyperlinkColor: hyperlinkColor,
              onTapUrl: onTapUrl,
              tableCellPadding: tableCellPadding,
              textStyle: textStyle,
            ),
        super(key: key);

  @override
  State<HtmlWidget> createState() => HtmlWidgetState();
}

class HtmlWidgetConfig {
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

  HtmlWidgetConfig({
    this.baseUrl,
    this.bodyPadding,
    this.builderCallback,
    this.hyperlinkColor,
    this.onTapUrl,
    this.tableCellPadding,
    this.textStyle,
  });
}

class HtmlWidgetState extends State<HtmlWidget> {
  Widget _built;

  @override
  void initState() {
    super.initState();
    _built = _build();
  }

  Widget build(BuildContext context) => _built;

  Widget _build() {
    final domNodes = parser.parse(widget.html).body.nodes;
    final wf = widget.factoryBuilder != null
        ? widget.factoryBuilder(widget._config)
        : WidgetFactory(widget._config);

    final widgets = core.Builder(
      domNodes: domNodes,
      parentTsb: TextStyleBuilders()
        ..enqueue(_rootTextStyleBuilder, widget._config),
      wf: wf,
    ).build();

    return wf.buildBody(widgets) ?? Text(widget.html);
  }
}
