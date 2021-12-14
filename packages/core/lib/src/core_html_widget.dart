import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

import 'core_data.dart';
import 'core_helpers.dart';
import 'core_widget_factory.dart';
import 'internal/builder.dart' as builder;
import 'internal/tsh_widget.dart';

/// A widget that builds Flutter widget tree from HTML
/// (supports most popular tags and stylings).
class HtmlWidget extends StatefulWidget {
  /// The base url to resolve links and image urls.
  final Uri? baseUrl;

  /// Controls whether the widget tree is built asynchronously.
  ///
  /// If not set, async build will be enabled automatically if the
  /// [html] has at least [kShouldBuildAsync] characters.
  final bool? buildAsync;

  /// The callback to specify custom stylings.
  final CustomStylesBuilder? customStylesBuilder;

  /// The callback to render a custom widget.
  final CustomWidgetBuilder? customWidgetBuilder;

  /// Controls whether the built widget tree is cached between rebuilds.
  ///
  /// Default: `true` if [buildAsync] is off, `false` otherwise.
  final bool? enableCaching;

  /// The input string.
  final String html;

  /// The custom [WidgetFactory] builder.
  final WidgetFactory Function()? factoryBuilder;

  /// The custom error builder.
  final OnErrorBuilder? onErrorBuilder;

  /// The custom loading builder.
  final OnLoadingBuilder? onLoadingBuilder;

  /// The callback when user taps an image.
  final void Function(ImageMetadata)? onTapImage;

  /// The callback when user taps a link.
  ///
  /// Returns `true` if the url has been handled,
  /// the default handler will be skipped.
  final FutureOr<bool> Function(String)? onTapUrl;

  /// The values that should trigger rebuild.
  ///
  /// By default, these fields' changes will invalidate cached widget tree:
  ///
  /// - [baseUrl]
  /// - [buildAsync]
  /// - [enableCaching]
  /// - [html]
  ///
  /// In `flutter_widget_from_html` package, these are also included:
  ///
  /// - `unsupportedWebViewWorkaroundForIssue37`
  /// - `webView`
  /// - `webViewJs`
  RebuildTriggers get rebuildTriggers => RebuildTriggers([
        html,
        baseUrl,
        buildAsync,
        enableCaching,
        if (_rebuildTriggers != null) _rebuildTriggers,
      ]);
  final RebuildTriggers? _rebuildTriggers;

  /// The render mode.
  ///
  /// - [RenderMode.column] is the default mode, suitable for small / medium document.
  /// - [RenderMode.listView] has better performance as it renders lazily.
  /// - [RenderMode.sliverList] has similar performance as `ListView`
  /// and can be put inside a `CustomScrollView`.
  final RenderMode renderMode;

  /// The default styling for text elements.
  final TextStyle? textStyle;

  /// Creates a widget that builds Flutter widget tree from html.
  ///
  /// The [html] argument must not be null.
  const HtmlWidget(
    this.html, {
    this.baseUrl,
    this.buildAsync,
    this.customStylesBuilder,
    this.customWidgetBuilder,
    this.enableCaching,
    this.factoryBuilder,
    Key? key,
    this.onErrorBuilder,
    this.onLoadingBuilder,
    this.onTapImage,
    this.onTapUrl,
    RebuildTriggers? rebuildTriggers,
    this.renderMode = RenderMode.column,
    this.textStyle,
  })  : _rebuildTriggers = rebuildTriggers,
        super(key: key);

  @override
  State<HtmlWidget> createState() => HtmlWidgetState();
}

/// State for a [HtmlWidget].
class HtmlWidgetState extends State<HtmlWidget> {
  late final BuildMetadata _rootMeta;
  late final _RootTsb _rootTsb;
  late final WidgetFactory _wf;

  Widget? _cache;
  Future<Widget>? _future;

  bool get buildAsync =>
      widget.buildAsync ?? widget.html.length > kShouldBuildAsync;

  bool get enableCaching => widget.enableCaching ?? !buildAsync;

  @override
  void initState() {
    super.initState();

    _rootTsb = _RootTsb(this);
    _rootMeta = builder.BuildMetadata(dom.Element.tag('root'), _rootTsb);
    _wf = widget.factoryBuilder?.call() ?? WidgetFactory();

    _wf.onRoot(_rootTsb);
    _wf.reset(this);

    if (buildAsync) {
      _future = _buildAsync();
    }
  }

  @override
  void dispose() {
    _wf.dispose();
    super.dispose();
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

    if (widget.rebuildTriggers != oldWidget.rebuildTriggers) {
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
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          } else if (snapshot.hasError) {
            return _sliverToBoxAdapterIfNeeded(
              _wf.onErrorBuilder(context, _rootMeta, snapshot.error) ?? widget0,
            );
          } else {
            return _sliverToBoxAdapterIfNeeded(
              _wf.onLoadingBuilder(context, _rootMeta) ?? widget0,
            );
          }
        },
        future: _future!.then(_tshWidget),
      );
    }

    if (!enableCaching || _cache == null) {
      _cache = _buildSync();
    }

    return _tshWidget(_cache!);
  }

  /// Scrolls to make sure the requested anchor is as visible as possible.
  Future<bool> scrollToAnchor(String id) => _wf.onTapUrl('#$id');

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

  Widget _sliverToBoxAdapterIfNeeded(Widget child) =>
      widget.renderMode == RenderMode.sliverList
          ? SliverToBoxAdapter(child: child)
          : child;

  Widget _tshWidget(Widget child) =>
      TshWidget(tsh: _rootTsb._output, child: child);
}

class _RootTsb extends TextStyleBuilder {
  TextStyleHtml? _output;

  _RootTsb(HtmlWidgetState state) {
    enqueue(builder, state);
  }

  @override
  TextStyleHtml build(BuildContext context) {
    context.dependOnInheritedWidgetOfExactType<TshWidget>();
    return super.build(context);
  }

  TextStyleHtml builder(TextStyleHtml? _, HtmlWidgetState state) {
    if (_output != null) {
      return _output!;
    }

    return _output = TextStyleHtml.root(
      state._wf.getDependencies(state.context),
      state.widget.textStyle,
    );
  }

  void reset() => _output = null;
}

Widget _buildBody(HtmlWidgetState state, dom.NodeList domNodes) {
  final rootMeta = state._rootMeta;
  final wf = state._wf;
  wf.reset(state);

  final tree = builder.BuildTree(
    customStylesBuilder: state.widget.customStylesBuilder,
    customWidgetBuilder: state.widget.customWidgetBuilder,
    parentMeta: rootMeta,
    tsb: rootMeta.tsb,
    wf: wf,
  )..addBitsFromNodes(domNodes);

  return wf
          .buildColumnPlaceholder(rootMeta, tree.build())
          ?.wrapWith(wf.buildBodyWidget) ??
      widget0;
}

dom.NodeList _parseHtml(String html) =>
    parser.HtmlParser(html, parseMeta: false).parseFragment().nodes;
