import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

import 'core_builder.dart';
import 'core_data.dart';
import 'core_widget_factory.dart';

/// A widget that builds Flutter widget tree from HTML
/// (supports most popular tags and stylings).
class HtmlWidget extends StatefulWidget {
  /// The base url to resolve links and image urls.
  final Uri baseUrl;

  /// Controls whether the widget tree is built asynchronously.
  /// If not set, async build will be automatically enabled if the
  /// input HTML is longer than [kShouldBuildAsync].
  final bool buildAsync;

  /// The callback to handle async build snapshot.
  /// By default, a [CircularProgressIndicator] will be shown until
  /// the widget tree is ready without error handling.
  final AsyncWidgetBuilder<Widget> buildAsyncBuilder;

  /// The callback to specify custom stylings.
  final CustomStylesBuilder customStylesBuilder;

  /// The callback to specify custom stylings.
  final CustomWidgetBuilder customWidgetBuilder;

  /// Controls whether the built widget tree is cached between rebuild.
  final bool enableCaching;

  /// The input string.
  ///
  /// It should contains at least HTML and BODY elements (something like
  /// `<html><body>Contents</body></html>`) to avoid parsing quirks.
  final String html;

  /// The text color for link elements.
  final Color hyperlinkColor;

  /// The custom [WidgetFactory] builder.
  final WidgetFactory Function() factoryBuilder;

  /// The callback when user taps a link.
  final void Function(String) onTapUrl;

  /// The default styling for text elements.
  final TextStyle textStyle;

  /// Controls whether to use [WidgetSpan] for IMG, SUB, SUP, etc. tags.
  /// Flutter Web (beta) doesn't support this so this flag
  /// should be disabled in web builds or you will receive errors like
  /// > Field '_placeholderCount' has not been initialized.
  ///
  /// Default value: ![kIsWeb]
  ///
  /// Issues: https://github.com/flutter/flutter/issues/42086
  /// PRs: https://github.com/flutter/engine/pull/20276
  final bool useWidgetSpan;

  /// Creates a widget that builds Flutter widget tree from html.
  ///
  /// The [html] argument must not be null.
  HtmlWidget(
    this.html, {
    this.baseUrl,
    this.buildAsync,
    this.buildAsyncBuilder,
    this.customStylesBuilder,
    this.customWidgetBuilder,
    this.enableCaching = true,
    this.factoryBuilder = _singleton,
    this.hyperlinkColor = const Color.fromRGBO(0, 0, 255, 1),
    this.onTapUrl,
    this.textStyle = const TextStyle(),
    this.useWidgetSpan = !kIsWeb,
    Key key,
  })  : assert(html != null),
        assert(factoryBuilder != null),
        super(key: key);

  @override
  State<HtmlWidget> createState() => _HtmlWidgetState(
        buildAsync: buildAsync ?? html.length > kShouldBuildAsync,
      );

  static WidgetFactory _wf;

  static WidgetFactory _singleton() {
    _wf ??= WidgetFactory();
    return _wf;
  }
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

    _wf = widget.factoryBuilder();

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

  @override
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
    final built = _buildBody(_wf, widget, domNodes);
    Timeline.finishSync();

    return built;
  }

  Widget _buildSync() {
    Timeline.startSync('Build $widget (sync)');

    final domNodes = _parseHtml(widget.html);
    final built = _buildBody(_wf, widget, domNodes);

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

Widget _buildBody(WidgetFactory wf, HtmlWidget widget, dom.NodeList domNodes) {
  wf.reset(widget);
  final tsb = TextStyleBuilder(_tsb, input: widget.textStyle);
  final built = HtmlBuilder(domNodes: domNodes, parentTsb: tsb, wf: wf).build();
  return wf.buildBody(built) ?? widget0;
}

dom.NodeList _parseHtml(String html) => parser.parse(html).body.nodes;

TextStyleHtml _tsb(BuildContext _, TextStyleHtml p, TextStyle style) =>
    style == null
        ? p
        : TextStyleHtml.style(style.inherit ? p.style.merge(style) : style);
