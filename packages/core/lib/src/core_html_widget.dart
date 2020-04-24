import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html/parser.dart' as parser;

import 'builder.dart';
import 'core_data.dart';
import 'core_widget_factory.dart';

TextStyle _rootTextStyleBuilder(
  TextStyleBuilders _,
  TextStyle parent,
  HtmlConfig config,
) {
  var style = config.textStyle;
  if (style == null) return parent;
  if (style.inherit) return parent.merge(style);
  return style;
}

/// A widget that builds Flutter widget tree from HTML
/// (supports most popular tags and stylings).
class HtmlWidget extends StatefulWidget {
  /// Controls whether the built widget tree is cached between rebuild.
  final bool enableCaching;

  /// The input string.
  ///
  /// It should contains at least HTML and BODY elements (something like
  /// `<html><body>Contents</body></html>`) to avoid parsing quirks.
  final String html;

  /// The custom [WidgetFactory] builder.
  final WidgetFactory Function(HtmlConfig) factoryBuilder;

  final HtmlConfig _config;

  /// Creates a widget that builds Flutter widget tree from html.
  ///
  /// The [html] argument must not be null.
  HtmlWidget(
    this.html, {
    this.enableCaching = true,
    this.factoryBuilder,
    Key key,
    HtmlConfig config,
    Uri baseUrl,
    EdgeInsets bodyPadding = const EdgeInsets.all(10),
    CustomStylesBuilder customStylesBuilder,
    CustomWidgetBuilder customWidgetBuilder,
    Color hyperlinkColor = const Color.fromRGBO(0, 0, 255, 1),
    OnTapUrl onTapUrl,
    TextStyle textStyle = const TextStyle(),
  })  : assert(html != null),
        _config = config ??
            HtmlConfig(
              baseUrl: baseUrl,
              bodyPadding: bodyPadding,
              customStylesBuilder: customStylesBuilder,
              customWidgetBuilder: customWidgetBuilder,
              hyperlinkColor: hyperlinkColor,
              onTapUrl: onTapUrl,
              textStyle: textStyle,
            ),
        super(key: key);

  @override
  State<HtmlWidget> createState() => _HtmlWidgetState();
}

/// A set of configurable options to build widget.
class HtmlConfig {
  /// The base url to resolve links and image urls.
  final Uri baseUrl;

  /// The amount of space by which to inset the built widget tree.
  final EdgeInsets bodyPadding;

  /// The callback to specify custom stylings.
  final CustomStylesBuilder customStylesBuilder;

  /// The callback to render custom widget.
  final CustomWidgetBuilder customWidgetBuilder;

  /// The text color for link elements.
  final Color hyperlinkColor;

  /// The callback when user taps a link.
  final OnTapUrl onTapUrl;

  /// The default styling for text elements.
  final TextStyle textStyle;

  /// Creates a configuration
  HtmlConfig({
    this.baseUrl,
    this.bodyPadding,
    this.customStylesBuilder,
    this.customWidgetBuilder,
    this.hyperlinkColor,
    this.onTapUrl,
    this.textStyle,
  });
}

class _HtmlWidgetState extends State<HtmlWidget> {
  Widget _built;

  @override
  void initState() {
    super.initState();

    if (widget.enableCaching) _built = _build();
  }

  @override
  void didUpdateWidget(HtmlWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.html != oldWidget.html) _built = null;
  }

  Widget build(BuildContext context) {
    if (!widget.enableCaching) return _build();

    _built ??= _build();
    return _built;
  }

  Widget _build() {
    final domNodes = parser.parse(widget.html).body.nodes;
    final wf = widget.factoryBuilder != null
        ? widget.factoryBuilder(widget._config)
        : WidgetFactory(widget._config);

    final widgets = HtmlBuilder(
      domNodes: domNodes,
      parentTsb: TextStyleBuilders()
        ..enqueue(_rootTextStyleBuilder, widget._config),
      wf: wf,
    ).build();

    return wf.buildBody(widgets) ?? Text(widget.html);
  }
}
