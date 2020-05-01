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

/// A widget that builds Flutter widget tree from HTML
/// (supports most popular tags and stylings).
class HtmlWidget extends HtmlConfig {
  @override
  final Uri baseUrl;

  /// Controls whether the widget tree is built asynchronously.
  /// If not set, async build will be automatically enabled if the
  /// input HTML is longer than [kShouldBuildAsync].
  final bool buildAsync;

  /// The callback to handle async build snapshot.
  /// By default, a [CircularProgressIndicator] will be shown until
  /// the widget tree is ready without error handling.
  final AsyncWidgetBuilder<Widget> buildAsyncBuilder;

  @override
  final EdgeInsets bodyPadding;

  @override
  final CustomStylesBuilder customStylesBuilder;

  @override
  final CustomWidgetBuilder customWidgetBuilder;

  /// Controls whether the built widget tree is cached between rebuild.
  final bool enableCaching;

  /// The input string.
  ///
  /// It should contains at least HTML and BODY elements (something like
  /// `<html><body>Contents</body></html>`) to avoid parsing quirks.
  final String html;

  @override
  final Color hyperlinkColor;

  /// The custom [WidgetFactory] builder.
  final WidgetFactory Function(HtmlWidget) factoryBuilder;

  @override
  final void Function(String) onTapUrl;

  @override
  final EdgeInsets tableCellPadding;

  @override
  final TextStyle textStyle;

  /// Creates a widget that builds Flutter widget tree from html.
  ///
  /// The [html] argument must not be null.
  HtmlWidget(
    this.html, {
    this.baseUrl,
    this.buildAsync,
    this.buildAsyncBuilder,
    this.bodyPadding = const EdgeInsets.all(10),
    this.customStylesBuilder,
    this.customWidgetBuilder,
    this.enableCaching = true,
    this.factoryBuilder,
    this.hyperlinkColor = const Color.fromRGBO(0, 0, 255, 1),
    Key key,
    this.onTapUrl,
    this.tableCellPadding = const EdgeInsets.all(5),
    this.textStyle = const TextStyle(),
  })  : assert(html != null),
        super(key: key);

  @override
  State<HtmlWidget> createState() => _HtmlWidgetState(
        buildAsync: buildAsync ?? html.length > kShouldBuildAsync,
      );
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
        ? widget.factoryBuilder(widget)
        : WidgetFactory(widget);

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
    final built = _buildBody(_wf, widget.textStyle, domNodes);
    Timeline.finishSync();

    return built;
  }

  Widget _buildSync() {
    Timeline.startSync('Build $widget (sync)');

    final domNodes = _parseHtml(widget.html);
    final built = _buildBody(_wf, widget.textStyle, domNodes);

    Timeline.finishSync();

    return built;
  }
}

Widget _buildAsyncBuilder(BuildContext _, AsyncSnapshot<Widget> snapshot) =>
    snapshot.hasData
        ? snapshot.data
        : const Center(
            child: Padding(
            padding: EdgeInsets.all(8),
            child: CircularProgressIndicator(),
          ));

Widget _buildBody(WidgetFactory wf, TextStyle style, dom.NodeList domNodes) =>
    wf.buildBody(HtmlBuilder(
      domNodes: domNodes,
      parentTsb: TextStyleBuilders()..enqueue(_tsb, style),
      wf: wf,
    ).build()) ??
    widget0;

dom.NodeList _parseHtml(String html) => parser.parse(html).body.nodes;

TextStyle _tsb(TextStyleBuilders _, TextStyle parent, TextStyle style) =>
    style == null ? parent : style.inherit ? parent.merge(style) : style;
