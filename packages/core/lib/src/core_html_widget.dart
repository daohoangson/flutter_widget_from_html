import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html/dom.dart' as dom;
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

Widget _buildAsyncBuilder(BuildContext _, AsyncSnapshot<Widget> snapshot) =>
    snapshot.hasData
        ? snapshot.data
        : const Center(
            child: Padding(
            padding: EdgeInsets.all(8),
            child: CircularProgressIndicator(),
          ));

/// A widget that builds Flutter widget tree from HTML
/// (supports most popular tags and stylings).
class HtmlWidget extends StatefulWidget {
  /// Controls whether the widget tree is built asynchronously.
  /// If not set, async build will be automatically enabled if the
  /// input HTML is longer than [kShouldBuildAsync].
  final bool buildAsync;

  /// The callback to handle async build snapshot.
  /// By default, a [CircularProgressIndicator] will be shown until
  /// the widget tree is ready without error handling.
  final AsyncWidgetBuilder<Widget> buildAsyncBuilder;

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
    this.buildAsync,
    this.buildAsyncBuilder,
    this.enableCaching = true,
    this.factoryBuilder,
    Key key,
    HtmlConfig config,
    Uri baseUrl,
    EdgeInsets bodyPadding = const EdgeInsets.all(10),
    NodeMetadataCollector builderCallback,
    Color hyperlinkColor = const Color.fromRGBO(0, 0, 255, 1),
    OnTapUrl onTapUrl,
    EdgeInsets tableCellPadding = const EdgeInsets.all(5),
    TextStyle textStyle = const TextStyle(),
  })  : assert(html != null),
        _config = config ??
            HtmlConfig(
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
  State<HtmlWidget> createState() => _HtmlWidgetState(
        buildAsync: buildAsync ?? html.length > kShouldBuildAsync,
      );
}

/// A set of configurable options to build widget.
class HtmlConfig {
  /// The base url to resolve links and image urls.
  final Uri baseUrl;

  /// The amount of space by which to inset the built widget tree.
  final EdgeInsets bodyPadding;

  /// The callback to render custom elements.
  ///
  /// See also:
  ///
  ///  * [HtmlBuilder]
  final NodeMetadataCollector builderCallback;

  /// The text color for link elements.
  final Color hyperlinkColor;

  /// The callback when user taps a link.
  final OnTapUrl onTapUrl;

  /// The amount of space by which to inset the table cell's contents.
  final EdgeInsets tableCellPadding;

  /// The default styling for text elements.
  final TextStyle textStyle;

  /// Creates a configuration
  HtmlConfig({
    this.baseUrl,
    this.bodyPadding,
    this.builderCallback,
    this.hyperlinkColor,
    this.onTapUrl,
    this.tableCellPadding,
    this.textStyle,
  });
}

class _HtmlWidgetState extends State<HtmlWidget> {
  final bool buildAsync;

  Widget _cache;
  Future<Widget> _future;
  WidgetFactory _wf;

  _HtmlWidgetState({this.buildAsync = false});

  @override
  void initState() {
    super.initState();

    _wf = widget.factoryBuilder != null
        ? widget.factoryBuilder(widget._config)
        : WidgetFactory(widget._config);

    if (buildAsync) {
      _future = _buildAsync();
    } else if (widget.enableCaching) {
      _cache = _buildSync();
    }
  }

  @override
  void didUpdateWidget(HtmlWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.html != oldWidget.html) {
      _cache = null;
      _future = buildAsync ? _buildAsync() : null;
    }
  }

  Widget build(BuildContext context) {
    if (_future != null) {
      return FutureBuilder<Widget>(
        builder: widget.buildAsyncBuilder ?? _buildAsyncBuilder,
        future: _future,
      );
    }

    if (!widget.enableCaching) return _buildSync();

    _cache ??= _buildSync();
    return _cache;
  }

  Future<Widget> _buildAsync() async {
    final domNodes = await compute(_parseHtml, widget.html);

    Timeline.startSync('Build $widget (async)');
    final built = _buildBody(_wf, widget._config, domNodes);
    Timeline.finishSync();

    return built;
  }

  Widget _buildSync() {
    Timeline.startSync('Build $widget (sync)');

    final domNodes = _parseHtml(widget.html);
    final built = _buildBody(_wf, widget._config, domNodes);

    Timeline.finishSync();

    return built;
  }

  static dom.NodeList _parseHtml(String html) => parser.parse(html).body.nodes;

  static Widget _buildBody(
    WidgetFactory wf,
    HtmlConfig config,
    dom.NodeList domNodes,
  ) =>
      wf.buildBody(HtmlBuilder(
        domNodes: domNodes,
        parentTsb: TextStyleBuilders()..enqueue(_rootTextStyleBuilder, config),
        wf: wf,
      ).build()) ??
      widget0;
}
