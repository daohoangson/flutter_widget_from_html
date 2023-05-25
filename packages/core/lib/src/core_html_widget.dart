import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:logging/logging.dart';

import 'core_data.dart';
import 'core_helpers.dart';
import 'core_widget_factory.dart';
import 'internal/builder.dart' as builder;
import 'internal/html_style_widget.dart';

final _logger = Logger('fwfh.HtmlWidget');

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
  /// - [renderMode]
  /// - [textStyle]
  List<dynamic> get rebuildTriggers => [
        baseUrl,
        buildAsync,
        enableCaching,
        html,
        renderMode,
        textStyle,
        ..._rebuildTriggers ?? const [],
      ];
  final List<dynamic>? _rebuildTriggers;

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
    List<dynamic>? rebuildTriggers,
    this.renderMode = RenderMode.column,
    this.textStyle,
  })  : _rebuildTriggers = rebuildTriggers,
        super(key: key);

  @override
  State<HtmlWidget> createState() => HtmlWidgetState();
}

/// State for a [HtmlWidget].
class HtmlWidgetState extends State<HtmlWidget> {
  late final _RootStyleBuilder _rootStyleBuilder;
  late final WidgetFactory _wf;

  Widget? _cache;
  Future<Widget>? _future;
  HtmlStyle? _rootStyle;

  bool get buildAsync =>
      widget.buildAsync ?? widget.html.length > kShouldBuildAsync;

  bool get enableCaching => widget.enableCaching ?? !buildAsync;

  builder.Builder get _rootBuilder => builder.Builder(
        customStylesBuilder: widget.customStylesBuilder,
        customWidgetBuilder: widget.customWidgetBuilder,
        element: _rootElement,
        styleBuilder: _rootStyleBuilder,
        wf: _wf,
      );

  @override
  void initState() {
    super.initState();

    _rootStyleBuilder = _RootStyleBuilder(this);
    _wf = widget.factoryBuilder?.call() ?? WidgetFactory();

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
    _rootStyle = null;
  }

  @override
  void didUpdateWidget(HtmlWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    var needsRebuild = false;

    if (!listEquals(widget.rebuildTriggers, oldWidget.rebuildTriggers)) {
      needsRebuild = true;
    }

    if (widget.textStyle != oldWidget.textStyle) {
      _rootStyle = null;
    }

    if (needsRebuild) {
      _cache = null;
      _future = buildAsync ? _buildAsync() : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final future = _future;
    if (future != null) {
      return FutureBuilder<Widget>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.requireData;
          } else if (snapshot.hasError) {
            return _sliverToBoxAdapterIfNeeded(
              _wf.onErrorBuilder(
                    context,
                    _rootBuilder,
                    snapshot.error,
                    snapshot.stackTrace,
                  ) ??
                  widget0,
            );
          } else {
            return _sliverToBoxAdapterIfNeeded(
              _wf.onLoadingBuilder(context, _rootBuilder) ?? widget0,
            );
          }
        },
        future: future.then(_wrapper),
      );
    }

    if (!enableCaching || _cache == null) {
      _cache = _buildSync();
    }

    return _wrapper(_cache!);
  }

  /// Scrolls to make sure the requested anchor is as visible as possible.
  Future<bool> scrollToAnchor(String id) => _wf.onTapUrl('#$id');

  Future<Widget> _buildAsync() async {
    final domNodes = await compute(_parseHtml, widget.html);
    if (!mounted) {
      return widget0;
    }

    Timeline.startSync('Build $widget (async)');
    final built = _buildBody(this, domNodes);
    Timeline.finishSync();

    return built;
  }

  Widget _buildSync() {
    Timeline.startSync('Build $widget (sync)');

    Widget built;
    try {
      final domNodes = _parseHtml(widget.html);
      built = _buildBody(this, domNodes);
    } catch (error, stackTrace) {
      built = _wf.onErrorBuilder(context, _rootBuilder, error, stackTrace) ??
          widget0;
    }

    Timeline.finishSync();

    return built;
  }

  Widget _sliverToBoxAdapterIfNeeded(Widget child) =>
      widget.renderMode == RenderMode.sliverList
          ? SliverToBoxAdapter(child: child)
          : child;

  Widget _wrapper(Widget child) =>
      HtmlStyleWidget(style: _rootStyle, child: child);
}

final _rootElement = dom.Element.tag('root');

class _RootStyleBuilder extends HtmlStyleBuilder {
  final HtmlWidgetState state;

  _RootStyleBuilder(this.state);

  @override
  HtmlStyle build(BuildContext context) {
    context.dependOnInheritedWidgetOfExactType<HtmlStyleWidget>();

    final built = state._rootStyle;
    if (built != null) {
      return built;
    }

    return state._rootStyle = HtmlStyle.root(
      state._wf.getDependencies(state.context),
      state.widget.textStyle,
    );
  }
}

Widget _buildBody(HtmlWidgetState state, dom.NodeList domNodes) {
  _logger.fine('Building body...');
  final wf = state._wf;
  wf.reset(state);

  final rootBuilder = state._rootBuilder;
  rootBuilder.addBitsFromNodes(domNodes);

  final built = rootBuilder.build()?.wrapWith(wf.buildBodyWidget) ?? widget0;
  _logger.fine('Built body successfuly.');

  return built;
}

dom.NodeList _parseHtml(String html) =>
    parser.HtmlParser(html, parseMeta: false).parseFragment().nodes;
