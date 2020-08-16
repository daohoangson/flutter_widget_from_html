import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

import 'internal/builder.dart';
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
    Key key,
    this.onTapUrl,
    this.textStyle = const TextStyle(),
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
  NodeMetadata _rootMeta;
  _RootTsb _rootTsb;
  WidgetFactory _wf;

  _HtmlWidgetState({this.buildAsync = false});

  @override
  void initState() {
    super.initState();

    _rootTsb = _RootTsb(this);
    _rootMeta = HtmlBuilder.rootMeta(_rootTsb);
    _wf = widget.factoryBuilder();

    if (buildAsync) {
      _future = _buildAsync();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _rootTsb.reset();
  }

  @override
  void didUpdateWidget(HtmlWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    var needsRebuild = false;

    if (widget.baseUrl != oldWidget.baseUrl ||
        widget.buildAsync != oldWidget.buildAsync ||
        widget.html != oldWidget.html ||
        widget.enableCaching != oldWidget.enableCaching ||
        widget.hyperlinkColor != oldWidget.hyperlinkColor) {
      needsRebuild = true;
    }

    if (widget.textStyle != oldWidget.textStyle) {
      _rootTsb.reset();
      needsRebuild = true;
    }

    if (needsRebuild) {
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
    final built = _buildBody(this, domNodes);
    Timeline.finishSync();

    return built;
  }

  Widget _buildSync() {
    Timeline.startSync('Build $widget (sync)');

    final domNodes = _parseHtml(widget.html);
    final built = _buildBody(this, domNodes);

    Timeline.finishSync();

    return built;
  }
}

class _RootTsb extends TextStyleBuilder {
  final _HtmlWidgetState hws;

  TextStyleHtml _output;

  _RootTsb(this.hws);

  @override
  TextStyleHtml build() {
    if (_output != null) return _output;

    final deps = HtmlWidgetDependencies(hws._wf.getDependencies(hws.context));

    var textStyle = deps.getValue<TextStyle>();
    final widgetTextStyle = hws.widget.textStyle;
    if (widgetTextStyle != null) {
      textStyle = widgetTextStyle.inherit
          ? textStyle.merge(widgetTextStyle)
          : widgetTextStyle;
    }

    var mqd = deps.getValue<MediaQueryData>();
    final tsf = mqd.textScaleFactor;
    if (tsf != 1) {
      textStyle = textStyle.copyWith(fontSize: textStyle.fontSize * tsf);
    }

    _output = TextStyleHtml(
      deps: deps,
      style: textStyle,
      textDirection: deps.getValue<TextDirection>(),
    );
    return _output;
  }

  void reset() {
    _output = null;
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

Widget _buildBody(_HtmlWidgetState state, dom.NodeList domNodes) {
  final rootMeta = state._rootMeta;
  final wf = state._wf;
  wf.reset(state);

  final builder = HtmlBuilder(
    customStylesBuilder: state.widget.customStylesBuilder,
    customWidgetBuilder: state.widget.customWidgetBuilder,
    domNodes: domNodes,
    parentMeta: rootMeta,
    wf: wf,
  );
  return wf.buildBody(rootMeta, builder.build()) ?? widget0;
}

dom.NodeList _parseHtml(String html) => parser.parse(html).body.nodes;
