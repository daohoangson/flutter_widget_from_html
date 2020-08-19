import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

import 'internal/builder.dart';
import 'core_data.dart';
import 'core_widget_factory.dart';
import 'internal/tsh_widget.dart';

/// A widget that builds Flutter widget tree from HTML
/// (supports most popular tags and stylings).
class HtmlWidget extends StatefulWidget {
  /// The base url to resolve links and image urls.
  final Uri baseUrl;

  /// Controls whether the widget tree is built asynchronously.
  ///
  /// If not set, async build will be enabled automatically if the
  /// [html] has at least [kShouldBuildAsync] characters.
  final bool buildAsync;

  /// The callback to handle async build snapshot.
  ///
  /// By default, a [CircularProgressIndicator] will be shown until
  /// the widget tree is ready.
  /// This default builder doesn't do any error handling
  /// (it will just ignore any errors).
  final AsyncWidgetBuilder<Widget> buildAsyncBuilder;

  /// The callback to specify custom stylings.
  final CustomStylesBuilder customStylesBuilder;

  /// The callback to render a custom widget.
  final CustomWidgetBuilder customWidgetBuilder;

  /// Controls whether the built widget tree is cached between rebuilds.
  ///
  /// Default: `true` if [buildAsync] is off, `false` otherwise.
  final bool enableCaching;

  /// The input string.
  ///
  /// It should contains at least HTML and BODY elements (something like
  /// `<html><body>Contents</body></html>`) to avoid parsing quirks.
  final String html;

  /// The text color for link elements.
  ///
  /// Default: blue (#0000FF).
  final Color hyperlinkColor;

  /// The custom [WidgetFactory] builder.
  ///
  /// By default, a singleton instance of [WidgetFactory] will be used.
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
    this.enableCaching,
    this.factoryBuilder,
    this.hyperlinkColor = const Color.fromRGBO(0, 0, 255, 1),
    Key key,
    this.onTapUrl,
    this.textStyle = const TextStyle(),
    this.useWidgetSpan = !kIsWeb,
  })  : assert(html != null),
        super(key: key);

  @override
  State<HtmlWidget> createState() => _HtmlWidgetState();
}

class _HtmlWidgetState extends State<HtmlWidget> {
  Widget _cache;
  Future<Widget> _future;
  NodeMetadata _rootMeta;
  _RootTsb _rootTsb;
  WidgetFactory _wf;

  bool get buildAsync =>
      widget.buildAsync ?? widget.html.length > kShouldBuildAsync;

  bool get enableCaching => widget.enableCaching ?? !buildAsync;

  @override
  void initState() {
    super.initState();

    _rootTsb = _RootTsb(this);
    _rootMeta = HtmlBuilder.rootMeta(_rootTsb);
    _wf = (widget.factoryBuilder ?? _getCoreWf).call();

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
        future: _future.then(_tshWidget),
      );
    }

    if (!enableCaching || _cache == null) _cache = _buildSync();

    return _tshWidget(_cache);
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

  Widget _tshWidget(Widget child) =>
      TshWidget(child: child, tsh: _rootTsb._output);

  static WidgetFactory _coreWf;
  static WidgetFactory _getCoreWf() {
    _coreWf ??= WidgetFactory();
    return _coreWf;
  }
}

class _RootTsb extends TextStyleBuilder {
  final _HtmlWidgetState state;

  TextStyleHtml _output;

  _RootTsb(this.state);

  @override
  TextStyleHtml build(BuildContext childContext) {
    childContext.dependOnInheritedWidgetOfExactType<TshWidget>();

    if (_output != null) return _output;
    return _output = TextStyleHtml.root(
      state._wf.getDependencies(state.context),
      state.widget.textStyle,
    );
  }

  void reset() => _output = null;
}

Widget _buildAsyncBuilder(BuildContext _, AsyncSnapshot<Widget> snapshot) =>
    snapshot.hasData
        ? snapshot.data
        : const Center(
            child: Padding(
              child: Text('Loading...'),
              padding: EdgeInsets.all(8),
            ),
          );

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
