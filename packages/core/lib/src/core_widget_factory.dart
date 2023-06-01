import 'package:csslib/visitor.dart' as css;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart'
    show
        // we want to limit Material usages to be as generic as possible
        CircularProgressIndicator,
        Divider,
        Theme,
        ThemeData,
        Tooltip;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

import 'core_data.dart';
import 'core_helpers.dart';
import 'core_html_widget.dart';
import 'internal/core_ops.dart';
import 'internal/core_parser.dart';
import 'internal/margin_vertical.dart';
import 'internal/platform_specific/fallback.dart'
    if (dart.library.io) 'internal/platform_specific/io.dart';

final _logger = Logger('fwfh.WidgetFactory');

/// A factory to build widgets.
class WidgetFactory extends WidgetFactoryResetter with AnchorWidgetFactory {
  /// Setting this property to true replaces the default with a static [Text].
  /// This property is most useful for testing purposes.
  ///
  /// Defaults to `false`, resulting in a [CircularProgressIndicator].
  static bool debugDeterministicLoadingWidget = false;

  final _recognizersNeedDisposing = <GestureRecognizer>[];

  BuildOp? _styleBackground;
  BuildOp? _styleBorder;
  BuildOp? _styleMargin;
  BuildOp? _stylePadding;
  BuildOp? _styleVerticalAlign;
  BuildOp? _tagA;
  BuildOp? _tagDetails;
  BuildOp? _tagHr;
  BuildOp? _tagImg;
  BuildOp? _tagLi;
  BuildOp? _tagPre;
  TagTable? _tagTable;
  HtmlStyle Function(HtmlStyle, css.Expression)? _styleBuilderLineHeight;
  HtmlWidget? _widget;

  /// Builds [Align].
  Widget? buildAlign(
    BuildTree tree,
    Widget child,
    AlignmentGeometry alignment, {
    double? heightFactor,
    double? widthFactor,
  }) =>
      Align(
        alignment: alignment,
        heightFactor: heightFactor,
        widthFactor: widthFactor,
        child: child,
      );

  /// Builds [AspectRatio].
  Widget? buildAspectRatio(
    BuildTree tree,
    Widget child,
    double aspectRatio,
  ) =>
      AspectRatio(aspectRatio: aspectRatio, child: child);

  /// Builds body widget.
  Widget buildBodyWidget(BuildContext context, Widget child) {
    var children = child is Column ? child.children : [child];
    final renderMode = _widget?.renderMode ?? RenderMode.column;

    if (children.isNotEmpty && children.first is HeightPlaceholder) {
      children.removeAt(0);
    }
    if (children.isNotEmpty && children.last is HeightPlaceholder) {
      children.removeLast();
    }

    while (children.length == 1) {
      final child = children.first;
      if (child is Column) {
        children = child.children;
        continue;
      }

      if (renderMode != RenderMode.column && child is CssBlock) {
        final grandChild = child.child;
        if (grandChild is Column) {
          children = grandChild.children;
          continue;
        }
      }

      break;
    }

    return renderMode.buildBodyWidget(this, context, children);
  }

  /// Builds column placeholder.
  WidgetPlaceholder? buildColumnPlaceholder(
    BuildTree tree,
    Iterable<WidgetPlaceholder> children,
  ) {
    if (children.isEmpty) {
      return null;
    }
    if (children.length == 1) {
      return children.first;
    }

    return ColumnPlaceholder(
      children: children,
      tree: tree,
      wf: this,
    );
  }

  /// Builds [Column].
  Widget buildColumnWidget(
    BuildContext context,
    List<Widget> children, {
    CrossAxisAlignment? crossAxisAlignment,
    TextDirection? dir,
  }) {
    if (children.length == 1) {
      return children.first;
    }

    return Column(
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      textDirection: dir,
      children: children,
    );
  }

  /// Builds [Decoration].
  Widget? buildDecoration(
    BuildTree tree,
    Widget child, {
    BoxBorder? border,
    BorderRadius? borderRadius,
    Color? color,
  }) {
    if (border == null && borderRadius == null && color == null) {
      return child;
    }

    final container = child is Container ? child : null;
    final grandChild = container?.child;
    final prevDeco = container?.decoration;
    final baseDeco =
        prevDeco is BoxDecoration ? prevDeco : const BoxDecoration();
    var decoration = baseDeco.copyWith(border: border, color: color);

    var clipBehavior = Clip.none;
    if (borderRadius != null) {
      final borderIsUniform = decoration.border?.isUniform ?? true;
      if (borderIsUniform) {
        // TODO: require uniform color & style when our minimum Flutter version >= 3.10
        // support for non-uniform border has been improved since this commit
        // https://github.com/flutter/flutter/commit/5054b6e514a7af91db9859b4eb55d71177d19cfa
        decoration = decoration.copyWith(borderRadius: borderRadius);
        clipBehavior = Clip.hardEdge;
      }
    }

    return Container(
      decoration: decoration,
      clipBehavior: clipBehavior,
      child: grandChild ?? child,
    );
  }

  /// Builds [Divider].
  Widget? buildDivider(BuildTree tree) => const Divider();

  /// Builds [GestureDetector].
  ///
  /// Only [TapGestureRecognizer] is supported for now.
  Widget? buildGestureDetector(
    BuildTree tree,
    Widget child,
    GestureRecognizer recognizer,
  ) {
    var built = child;

    if (recognizer is TapGestureRecognizer) {
      built = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(onTap: recognizer.onTap, child: child),
      );
    }

    return built;
  }

  /// Builds [GestureRecognizer].
  ///
  /// Only [TapGestureRecognizer.onTap] is supported for now.
  GestureRecognizer? buildGestureRecognizer(
    BuildTree tree, {
    GestureTapCallback? onTap,
  }) {
    final recognizer =
        onTap != null ? (TapGestureRecognizer()..onTap = onTap) : null;
    if (recognizer != null) {
      _recognizersNeedDisposing.add(recognizer);
    }
    return recognizer;
  }

  /// Builds horizontal scroll view.
  Widget? buildHorizontalScrollView(BuildTree tree, Widget child) =>
      SingleChildScrollView(scrollDirection: Axis.horizontal, child: child);

  /// Builds image widget from an [ImageMetadata].
  Widget? buildImage(BuildTree tree, ImageMetadata data) {
    final src = data.sources.isNotEmpty ? data.sources.first : null;
    if (src == null) {
      return null;
    }

    var built = buildImageWidget(tree, src);

    final title = data.title;
    if (built != null && title != null) {
      built = buildTooltip(tree, built, title);
    }

    if (built != null) {
      final height = src.height;
      final width = src.width;
      if (height != null && height > 0 && width != null && width > 0) {
        built = buildAspectRatio(tree, built, width / height);
      }
    }

    final onTapImage = _widget?.onTapImage;
    if (onTapImage != null && built != null) {
      final recognizer = buildGestureRecognizer(
        tree,
        onTap: () => onTapImage(data),
      );
      if (recognizer != null) {
        built = buildGestureDetector(tree, built, recognizer);
      }
    }

    return built;
  }

  /// Builds [Image].
  Widget? buildImageWidget(BuildTree tree, ImageSource src) {
    final url = src.url;

    ImageProvider? provider;
    if (url.startsWith('asset:')) {
      provider = imageProviderFromAsset(url);
    } else if (url.startsWith('data:image/')) {
      provider = imageProviderFromDataUri(url);
    } else if (url.startsWith('file:')) {
      provider = imageProviderFromFileUri(url);
    } else {
      provider = imageProviderFromNetwork(url);
    }
    if (provider == null) {
      return null;
    }

    final image = src.image;
    final semanticLabel = image?.alt ?? image?.title;
    return Image(
      errorBuilder: (context, error, _) =>
          onErrorBuilder(context, tree, error, src) ?? widget0,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }

        final t = loadingProgress.expectedTotalBytes;
        final loaded = loadingProgress.cumulativeBytesLoaded;
        final v = t != null && t > 0 ? loaded / t : null;
        return onLoadingBuilder(context, tree, v, src) ?? child;
      },
      excludeFromSemantics: semanticLabel == null,
      fit: BoxFit.fill,
      image: provider,
      semanticLabel: semanticLabel,
    );
  }

  /// Builds marker widget for a list item.
  Widget? buildListMarker(
    BuildTree tree,
    HtmlStyle style,
    String listStyleType,
    int index,
  ) {
    final text = getListMarkerText(listStyleType, index);
    final textStyle = style.textStyle;
    if (text.isNotEmpty) {
      return buildText(tree, style, TextSpan(style: textStyle, text: text));
    }

    switch (listStyleType) {
      case kCssListStyleTypeCircle:
        return HtmlListMarker.circle(textStyle);
      case kCssListStyleTypeNone:
        return null;
      case kCssListStyleTypeSquare:
        return HtmlListMarker.square(textStyle);
      case kCssListStyleTypeDisc:
      default:
        return HtmlListMarker.disc(textStyle);
    }
  }

  /// Builds [Padding].
  Widget? buildPadding(
    BuildTree tree,
    Widget child,
    EdgeInsetsGeometry padding,
  ) =>
      padding == EdgeInsets.zero
          ? child
          : Padding(padding: padding, child: child);

  /// Builds [RichText].
  Widget? buildText(BuildTree tree, HtmlStyle style, InlineSpan text) {
    const selectionColorDefault = DefaultSelectionStyle.defaultColor;
    final selectionRegistrar = style.getDependency<SelectionRegistrar?>();
    final selectionStyle = style.getDependency<DefaultSelectionStyle>();

    Widget built = RichText(
      maxLines: tree.maxLines > 0 ? tree.maxLines : null,
      overflow: tree.overflow,
      selectionColor: selectionStyle.selectionColor ?? selectionColorDefault,
      selectionRegistrar: selectionRegistrar,
      softWrap: style.whitespace != CssWhitespace.nowrap,
      text: text,
      textAlign: style.textAlign ?? TextAlign.start,
      textDirection: style.textDirection,
    );

    if (selectionRegistrar != null) {
      built = MouseRegion(cursor: SystemMouseCursors.text, child: built);
    }

    return built;
  }

  /// Builds [TextSpan].
  InlineSpan? buildTextSpan({
    List<InlineSpan>? children,
    GestureRecognizer? recognizer,
    TextStyle? style,
    String? text,
  }) {
    if (text?.isEmpty == true) {
      if (children == null) {
        return null;
      }
      if (children.length == 1) {
        return children.first;
      }
    }

    return TextSpan(
      children: children,
      mouseCursor: recognizer != null ? SystemMouseCursors.click : null,
      recognizer: recognizer,
      style: style,
      text: text,
    );
  }

  /// Builds [Tooltip].
  Widget? buildTooltip(BuildTree tree, Widget child, String message) =>
      Tooltip(message: message, child: child);

  @override
  void dispose() {
    super.dispose();
    _dispose();
  }

  void _dispose() {
    for (final r in _recognizersNeedDisposing) {
      r.dispose();
    }
    _recognizersNeedDisposing.clear();
  }

  /// Prepares [GestureTapCallback].
  @Deprecated('Use .onTapUrl instead.')
  GestureTapCallback? gestureTapCallback(String url) => () => onTapUrl(url);

  /// Returns [context]-based dependencies.
  ///
  /// Includes these by default:
  ///
  /// - [TextDirection] via [Directionality.of]
  /// - [DefaultSelectionStyle] via [DefaultSelectionStyle.of]
  /// - [TextStyle] via [DefaultTextStyle.of]
  /// - [SelectionRegistrar] via [SelectionContainer.maybeOf]
  /// - [TextScaleFactor] via [MediaQuery.textScaleFactorOf]
  /// - [ThemeData] via [Theme.of]
  ///
  /// Use [HtmlStyle.getDependency] to get value by type.
  ///
  /// ```dart
  /// // in normal widget building:
  /// final scale = MediaQuery.of(context).textScaleFactor;
  /// final color = Theme.of(context).accentColor;
  ///
  /// // in build ops:
  /// final tsf = style.getDependency<TextScaleFactor>();
  /// final color = style.getDependency<ThemeData>().accentColor;
  /// ```
  ///
  /// It's recommended to use values from [HtmlStyle] instead of
  /// obtaining from [BuildContext] for performance reason.
  ///
  /// ```dart
  /// // avoid doing this:
  /// final widgetValue = Directionality.of(context);
  ///
  /// // do this:
  /// final buildOpValue = style.textDirection;
  /// ```
  Iterable<dynamic> getDependencies(BuildContext context) => [
        Directionality.maybeOf(context) ?? TextDirection.ltr,
        DefaultSelectionStyle.of(context),
        DefaultTextStyle.of(context).style,
        SelectionContainer.maybeOf(context),
        TextScaleFactor(MediaQuery.textScaleFactorOf(context)),
        Theme.of(context),
      ];

  /// Returns marker text for the specified list style [type] at index [i].
  String getListMarkerText(String type, int i) {
    switch (type) {
      case kCssListStyleTypeAlphaLower:
      case kCssListStyleTypeAlphaLatinLower:
        if (i >= 1 && i <= 26) {
          // the specs said it's unspecified after the 26th item
          // TODO: generate something like aa, ab, etc. when needed
          return '${String.fromCharCode(96 + i)}.';
        }
        return '';
      case kCssListStyleTypeAlphaUpper:
      case kCssListStyleTypeAlphaLatinUpper:
        if (i >= 1 && i <= 26) {
          // the specs said it's unspecified after the 26th item
          // TODO: generate something like AA, AB, etc. when needed
          return '${String.fromCharCode(64 + i)}.';
        }
        return '';
      case kCssListStyleTypeDecimal:
        return '$i.';
      case kCssListStyleTypeRomanLower:
        final roman = _getListMarkerRoman(i)?.toLowerCase();
        return roman != null ? '$roman.' : '';
      case kCssListStyleTypeRomanUpper:
        final roman = _getListMarkerRoman(i);
        return roman != null ? '$roman.' : '';
      case kCssListStyleTypeNone:
      default:
        return '';
    }
  }

  String? _getListMarkerRoman(int i) {
    // TODO: find some lib to generate programatically
    const map = <int, String>{
      1: 'I',
      2: 'II',
      3: 'III',
      4: 'IV',
      5: 'V',
      6: 'VI',
      7: 'VII',
      8: 'VIII',
      9: 'IX',
      10: 'X',
    };

    return map[i];
  }

  /// Returns an [AssetImage].
  ImageProvider? imageProviderFromAsset(String url) {
    final uri = Uri.parse(url);
    final assetName = uri.path;
    if (assetName.isEmpty) {
      return null;
    }

    final package = uri.queryParameters.containsKey('package') == true
        ? uri.queryParameters['package']
        : null;

    return AssetImage(assetName, package: package);
  }

  /// Returns a [MemoryImage].
  ImageProvider? imageProviderFromDataUri(String dataUri) {
    final bytes = bytesFromDataUri(dataUri);
    if (bytes == null) {
      return null;
    }

    return MemoryImage(bytes);
  }

  /// Returns a [FileImage].
  ImageProvider? imageProviderFromFileUri(String url) {
    final filePath = Uri.parse(url).toFilePath();
    if (filePath.isEmpty) {
      return null;
    }

    return fileImageProvider(filePath);
  }

  /// Returns a [NetworkImage].
  ImageProvider? imageProviderFromNetwork(String url) =>
      url.isNotEmpty ? NetworkImage(url) : null;

  /// Builder for error widget if a complicated element failed to render.
  ///
  /// See [OnErrorBuilder].
  Widget? onErrorBuilder(
    BuildContext context,
    BuildTree tree, [
    dynamic error,
    dynamic data,
  ]) {
    _logger.warning('Could not render data=$data', error);

    final callback = _widget?.onErrorBuilder;
    if (callback != null) {
      final result = callback(context, tree.element, error);
      if (result != null) {
        return result;
      }
    }

    final image = data is ImageSource ? data.image : null;
    final semanticLabel = image?.alt ?? image?.title;
    final text = semanticLabel ?? '❌';
    return Text(text);
  }

  /// Builder for loading widget while a complicated element is loading.
  ///
  /// See [OnLoadingBuilder].
  Widget? onLoadingBuilder(
    BuildContext context,
    BuildTree tree, [
    double? loadingProgress,
    dynamic data,
  ]) {
    final callback = _widget?.onLoadingBuilder;
    if (callback != null) {
      final result = callback(context, tree.element, loadingProgress);
      if (result != null) {
        return result;
      }
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: debugDeterministicLoadingWidget
            ? const Text('Loading...')
            : CircularProgressIndicator.adaptive(value: loadingProgress),
      ),
    );
  }

  /// Calls [HtmlWidget.onTapUrl] with [url].
  ///
  /// Returns `true` if there is a callback and it has handled the tap.
  Future<bool> onTapCallback(String url) async {
    final callback = _widget?.onTapUrl;
    return callback != null ? callback(url) : false;
  }

  /// Handles user tapping a link.
  Future<bool> onTapUrl(String url) async {
    final handledViaCallback = await onTapCallback(url);
    if (handledViaCallback) {
      return true;
    }

    final idPrefix = '${_widget?.baseUrl ?? ''}#';
    if (url.startsWith(idPrefix)) {
      final id = url.substring(idPrefix.length);
      final handledViaAnchor = await onTapAnchorWrapper(id);
      if (handledViaAnchor) {
        return true;
      }
    }

    return false;
  }

  /// Parses [tree] for build ops and text styles.
  void parse(BuildTree tree) {
    final attrs = tree.element.attributes;
    final localName = tree.element.localName;

    switch (localName) {
      case kTagA:
        if (attrs.containsKey(kAttributeAHref)) {
          tree
            ..apply(TagA.defaultColor, null)
            ..register(_tagA ??= TagA(this).buildOp);
        }

        final name = attrs[kAttributeAName];
        if (name != null) {
          tree.register(Anchor(this, name).buildOp);
        }
        break;

      case 'abbr':
      case kTagAcronym:
        tree.register(
          const BuildOp.v1(
            debugLabel: kTagAcronym,
            defaultStyles: _tagAcronym,
            priority: Early.tagAcronym,
          ),
        );
        break;

      case kTagAddress:
        tree.register(
          const BuildOp.v1(
            debugLabel: kTagAddress,
            defaultStyles: _tagAddress,
            priority: Early.tagAddress,
          ),
        );
        break;

      case 'article':
      case 'aside':
      case 'dl':
      case 'figcaption':
      case 'footer':
      case 'header':
      case 'main':
      case 'nav':
      case 'section':
      case kTagDiv:
        tree.register(
          const BuildOp.v1(
            debugLabel: kTagDiv,
            defaultStyles: _cssDisplayBlock,
            priority: Early.tagDiv,
          ),
        );
        break;

      case 'blockquote':
      case kTagFigure:
        tree.register(
          const BuildOp.v1(
            debugLabel: kTagFigure,
            defaultStyles: _tagFigure,
            priority: Early.tagFigure,
          ),
        );
        break;

      case 'b':
      case 'strong':
        tree.apply(TextStyleOps.fontWeight, FontWeight.bold);
        break;

      case 'big':
        tree.apply(TextStyleOps.fontSizeTerm, kCssFontSizeLarger);
        break;
      case 'small':
        tree.apply(TextStyleOps.fontSizeTerm, kCssFontSizeSmaller);
        break;

      case kTagBr:
        tree.register(tagBr);
        break;

      case kTagCenter:
        tree.register(
          const BuildOp.v1(
            debugLabel: kTagCenter,
            defaultStyles: _tagCenter,
            priority: Early.tagCenter,
          ),
        );
        break;

      case 'cite':
      case 'dfn':
      case 'em':
      case 'i':
      case 'var':
        tree.apply(TextStyleOps.fontStyle, FontStyle.italic);
        break;

      case kTagCode:
      case kTagKbd:
      case kTagSamp:
      case kTagTt:
        tree.apply(
          TextStyleOps.fontFamily,
          const [kTagCodeFont1, kTagCodeFont2],
        );
        break;
      case kTagPre:
        tree.register(_tagPre ??= TagPre(this).buildOp);
        break;

      case kTagDetails:
        tree.register(_tagDetails ??= TagDetails(this).buildOp);
        break;

      case kTagDd:
        tree.register(
          const BuildOp.v1(
            debugLabel: kTagDd,
            defaultStyles: _tagDd,
            priority: Early.tagDd,
          ),
        );
        break;
      case kTagDt:
        tree.register(
          const BuildOp.v1(
            debugLabel: kTagDt,
            defaultStyles: _tagDt,
            priority: Early.tagDt,
          ),
        );
        break;

      case 'del':
      case 's':
      case kTagStrike:
        tree.register(
          const BuildOp.v1(
            debugLabel: kTagStrike,
            defaultStyles: _cssTextDecorationLineThrough,
            priority: Early.tagStrike,
          ),
        );
        break;

      case kTagFont:
        tree.register(tagFont);
        break;

      case 'hr':
        tree.register(
          _tagHr ??= BuildOp.v1(
            debugLabel: localName,
            defaultStyles: (_) => {
              kCssDisplay: kCssDisplayBlock,
              kCssMargin + kSuffixBottom: '1em',
            },
            onRenderBlock: (tree, _) => buildDivider(tree) ?? _,
            priority: Priority.tagHr,
          ),
        );
        break;

      case kTagH1:
        tree.register(
          const BuildOp.v1(
            debugLabel: kTagH1,
            defaultStyles: _tagH1,
            priority: Early.tagH1,
          ),
        );
        break;
      case kTagH2:
        tree.register(
          const BuildOp.v1(
            debugLabel: kTagH2,
            defaultStyles: _tagH2,
            priority: Early.tagH2,
          ),
        );
        break;
      case kTagH3:
        tree.register(
          const BuildOp.v1(
            debugLabel: kTagH3,
            defaultStyles: _tagH3,
            priority: Early.tagH3,
          ),
        );
        break;
      case kTagH4:
        tree.register(
          const BuildOp.v1(
            debugLabel: kTagH4,
            defaultStyles: _tagH4,
            priority: Early.tagH4,
          ),
        );
        break;
      case kTagH5:
        tree.register(
          const BuildOp.v1(
            debugLabel: kTagH5,
            defaultStyles: _tagH5,
            priority: Early.tagH5,
          ),
        );
        break;
      case kTagH6:
        tree.register(
          const BuildOp.v1(
            debugLabel: kTagH6,
            defaultStyles: _tagH6,
            priority: Early.tagH6,
          ),
        );
        break;

      case kTagImg:
        tree.register(_tagImg ??= TagImg(this).buildOp);
        break;

      case kTagOrderedList:
      case kTagUnorderedList:
        tree.register(_tagLi ??= TagLi(this).buildOp);
        break;

      case kTagMark:
        tree.register(
          const BuildOp.v1(
            debugLabel: kTagMark,
            defaultStyles: _tagMark,
            priority: Early.tagMark,
          ),
        );
        break;

      case kTagP:
        tree.register(
          const BuildOp.v1(
            debugLabel: kTagP,
            defaultStyles: _tagP,
            priority: Early.tagP,
          ),
        );
        break;

      case kTagQ:
        tree.register(tagQ);
        break;

      case kTagRuby:
        tree.register(tagRuby);
        break;

      case 'style':
      case kTagScript:
        tree.register(
          const BuildOp.v1(
            debugLabel: kTagScript,
            defaultStyles: _cssDisplayNone,
            priority: Early.tagScript,
          ),
        );
        break;

      case kTagSub:
        tree.register(
          const BuildOp.v1(
            debugLabel: kTagSub,
            defaultStyles: _tagSub,
            priority: Early.tagSub,
          ),
        );
        break;
      case kTagSup:
        tree.register(
          const BuildOp.v1(
            debugLabel: kTagSup,
            defaultStyles: _tagSup,
            priority: Early.tagSup,
          ),
        );
        break;

      case kTagTable:
        final tagTable = _tagTable ??= TagTable(this);
        tree
          ..register(
            const BuildOp.v1(
              debugLabel: kTagTable,
              defaultStyles: _cssDisplayTable,
              priority: Early.tagTableDisplayTable,
            ),
          )
          ..register(tagTable.borderOp)
          ..register(tagTable.cellPaddingOp);
        break;
      case kTagTableCell:
        tree.register(
          const BuildOp.v1(
            debugLabel: kTagTableCell,
            defaultStyles: _cssVerticalAlignMiddle,
            priority: Early.tagTableCellDefaultStyles,
          ),
        );
        break;
      case kTagTableHeaderCell:
        tree.register(
          const BuildOp.v1(
            debugLabel: kTagTableHeaderCell,
            defaultStyles: _tagTableHeaderCell,
            priority: Early.tagTableHeaderCellDefaultStyles,
          ),
        );
        break;
      case kTagTableCaption:
        tree.register(
          const BuildOp.v1(
            debugLabel: kTagTableCaption,
            defaultStyles: _cssTextAlignCenter,
            priority: Early.tagTableCaptionTextAlignCenter,
          ),
        );
        break;

      case 'u':
      case kTagIns:
        tree.register(
          const BuildOp.v1(
            debugLabel: kTagIns,
            defaultStyles: _cssTextDecorationUnderline,
            priority: Early.tagIns,
          ),
        );
        break;
    }

    for (final attribute in attrs.entries) {
      switch (attribute.key) {
        case kAttributeAlign:
          tree.register(
            const BuildOp.v1(
              debugLabel: kAttributeAlign,
              defaultStyles: _cssTextAlignFromAttribute,
              priority: Early.attributeAlign,
            ),
          );
          break;
        case kAttributeDir:
          tree.register(
            const BuildOp.v1(
              debugLabel: kAttributeDir,
              defaultStyles: _cssDirectionFromAttribute,
              priority: Early.attributeDir,
            ),
          );
          break;
        case kAttributeId:
          tree.register(Anchor(this, attribute.value).buildOp);
          break;
      }
    }
  }

  /// Parses inline style [css.Declaration] one by one.
  /// This also handles styling from [BuildOp]s and [HtmlWidget.customStylesBuilder].
  void parseStyle(BuildTree tree, css.Declaration style) {
    final key = style.property;
    switch (key) {
      case kCssBackground:
      case kCssBackgroundColor:
        tree.register(_styleBackground ??= StyleBackground(this).buildOp);
        break;

      case kCssColor:
        final color = tryParseColor(style.value);
        if (color != null) {
          tree.apply(TextStyleOps.color, color);
        }
        break;

      case kCssDirection:
        final term = style.term;
        if (term != null) {
          tree.apply(TextStyleOps.textDirection, term);
        }
        break;

      case kCssFontFamily:
        final list = TextStyleOps.fontFamilyTryParse(style.values);
        tree.apply(TextStyleOps.fontFamily, list);
        break;

      case kCssFontSize:
        final value = style.value;
        if (value != null) {
          tree.apply(TextStyleOps.fontSize, value);
        }
        break;

      case kCssFontStyle:
        final term = style.term;
        final fontStyle =
            term != null ? TextStyleOps.fontStyleTryParse(term) : null;
        if (fontStyle != null) {
          tree.apply(TextStyleOps.fontStyle, fontStyle);
        }
        break;

      case kCssFontWeight:
        final value = style.value;
        final fontWeight =
            value != null ? TextStyleOps.fontWeightTryParse(value) : null;
        if (fontWeight != null) {
          tree.apply(TextStyleOps.fontWeight, fontWeight);
        }
        break;

      case kCssHeight:
      case kCssMaxHeight:
      case kCssMaxWidth:
      case kCssMinHeight:
      case kCssMinWidth:
      case kCssWidth:
        StyleSizing.registerSizingOp(this, tree);
        break;

      case kCssLineHeight:
        final value = style.value;
        if (value != null) {
          tree.apply(
            _styleBuilderLineHeight ??= TextStyleOps.lineHeight(this),
            value,
          );
        }
        break;

      case kCssMaxLines:
      case kCssMaxLinesWebkitLineClamp:
        final maxLines = tryParseMaxLines(style.value);
        if (maxLines != null) {
          tree.maxLines = maxLines;
        }
        break;

      case kCssTextAlign:
        tree.register(styleTextAlign);
        break;

      case kCssTextDecoration:
      case kCssTextDecorationColor:
      case kCssTextDecorationLine:
      case kCssTextDecorationStyle:
      case kCssTextDecorationThickness:
      case kCssTextDecorationWidth:
        textDecorationApply(tree, style);
        break;

      case kCssTextOverflow:
        final textOverflow = tryParseTextOverflow(style.value);
        if (textOverflow != null) {
          tree.overflow = textOverflow;
        }
        break;

      case kCssVerticalAlign:
        tree.register(_styleVerticalAlign ??= StyleVerticalAlign(this).buildOp);
        break;

      case kCssWhitespace:
        final term = style.term;
        final whitespace =
            term != null ? TextStyleOps.whitespaceTryParse(term) : null;
        if (whitespace != null) {
          tree.apply(TextStyleOps.whitespace, whitespace);
        }
        break;
    }

    if (key.startsWith(kCssBorder)) {
      tree.register(_styleBorder ??= StyleBorder(this).buildOp);
    }

    if (key.startsWith(kCssMargin)) {
      tree.register(_styleMargin ??= StyleMargin(this).buildOp);
    }

    if (key.startsWith(kCssPadding)) {
      tree.register(_stylePadding ??= StylePadding(this).buildOp);
    }
  }

  /// Parses display inline style.
  void parseStyleDisplay(BuildTree tree, String? value) {
    StyleSizing.maybeRegisterChildOp(this, tree);

    switch (value) {
      case kCssDisplayBlock:
        StyleSizing.registerBlockOp(this, tree);
        break;
      case kCssDisplayInlineBlock:
        tree.register(displayInlineBlock);
        break;
      case kCssDisplayNone:
        tree.register(displayNone);
        break;
      case kCssDisplayTable:
        final tagTable = _tagTable ??= TagTable(this);
        tree.register(tagTable.tableOp);
        break;
    }
  }

  @override
  void reset(State state) {
    super.reset(state);
    _dispose();

    final widget = state.widget;
    _widget = widget is HtmlWidget ? widget : null;
  }

  /// Resolves full URL with [HtmlWidget.baseUrl] if available.
  String? urlFull(String url) {
    if (url.isEmpty) {
      return null;
    }
    if (url.startsWith('data:')) {
      return url;
    }

    final uri = Uri.tryParse(url);
    if (uri == null) {
      return null;
    }
    if (uri.hasScheme) {
      return url;
    }

    final baseUrl = _widget?.baseUrl;
    if (baseUrl == null) {
      return null;
    }

    return baseUrl.resolveUri(uri).toString();
  }

  // TODO: switch to use constant function literal when available
  // https://github.com/dart-lang/language/issues/1048
  static StylesMap _cssDirectionFromAttribute(BuildTree tree) {
    final value = tree.element.attributes[kAttributeDir];
    return value != null ? {kCssDirection: value} : const {};
  }

  static StylesMap _cssDisplayBlock(BuildTree _) =>
      {kCssDisplay: kCssDisplayBlock};

  static StylesMap _cssDisplayNone(BuildTree _) =>
      {kCssDisplay: kCssDisplayNone};

  static StylesMap _cssDisplayTable(BuildTree _) =>
      {kCssDisplay: kCssDisplayTable};

  static StylesMap _cssTextAlignCenter(BuildTree _) =>
      {kCssTextAlign: kCssTextAlignCenter};

  static StylesMap _cssTextAlignFromAttribute(BuildTree tree) {
    final value = tree.element.attributes[kAttributeAlign];
    return value != null ? {kCssTextAlign: value} : const {};
  }

  static StylesMap _cssTextDecorationLineThrough(BuildTree _) =>
      {kCssTextDecorationLine: kCssTextDecorationLineThrough};

  static StylesMap _cssTextDecorationUnderline(BuildTree _) =>
      {kCssTextDecorationLine: kCssTextDecorationUnderline};

  static StylesMap _cssVerticalAlignMiddle(BuildTree _) =>
      {kCssVerticalAlign: kCssVerticalAlignMiddle};

  static StylesMap _tagAcronym(BuildTree _) => {
        kCssTextDecorationLine: kCssTextDecorationUnderline,
        kCssTextDecorationStyle: kCssTextDecorationStyleDotted,
      };

  static StylesMap _tagAddress(BuildTree _) => {
        kCssDisplay: kCssDisplayBlock,
        kCssFontStyle: kCssFontStyleItalic,
      };

  static StylesMap _tagCenter(BuildTree _) => {
        kCssDisplay: kCssDisplayBlock,
        kCssTextAlign: kCssTextAlignWebkitCenter,
      };

  static StylesMap _tagDd(BuildTree _) => {
        kCssDisplay: kCssDisplayBlock,
        kCssMargin: '0 0 1em 40px',
      };

  static StylesMap _tagDt(BuildTree _) => {
        kCssDisplay: kCssDisplayBlock,
        kCssFontWeight: kCssFontWeightBold,
      };

  static StylesMap _tagFigure(BuildTree _) => {
        kCssDisplay: kCssDisplayBlock,
        kCssMargin: '1em 40px',
      };

  static StylesMap _tagH1(BuildTree _) => {
        kCssDisplay: kCssDisplayBlock,
        kCssFontSize: '2em',
        kCssFontWeight: kCssFontWeightBold,
        kCssMargin: '0.67em 0',
      };

  static StylesMap _tagH2(BuildTree _) => {
        kCssDisplay: kCssDisplayBlock,
        kCssFontSize: '1.5em',
        kCssFontWeight: kCssFontWeightBold,
        kCssMargin: '0.83em 0',
      };

  static StylesMap _tagH3(BuildTree _) => {
        kCssDisplay: kCssDisplayBlock,
        kCssFontSize: '1.17em',
        kCssFontWeight: kCssFontWeightBold,
        kCssMargin: '1em 0',
      };

  static StylesMap _tagH4(BuildTree _) => {
        kCssDisplay: kCssDisplayBlock,
        kCssFontWeight: kCssFontWeightBold,
        kCssMargin: '1.33em 0',
      };

  static StylesMap _tagH5(BuildTree _) => {
        kCssDisplay: kCssDisplayBlock,
        kCssFontSize: '0.83em',
        kCssFontWeight: kCssFontWeightBold,
        kCssMargin: '1.67em 0',
      };

  static StylesMap _tagH6(BuildTree _) => {
        kCssDisplay: kCssDisplayBlock,
        kCssFontSize: '0.67em',
        kCssFontWeight: kCssFontWeightBold,
        kCssMargin: '2.33em 0',
      };

  static StylesMap _tagMark(BuildTree _) => {
        kCssBackgroundColor: '#ff0',
        kCssColor: '#000',
      };

  static StylesMap _tagP(BuildTree _) => {
        kCssDisplay: kCssDisplayBlock,
        kCssMargin: '1em 0',
      };

  static StylesMap _tagSub(BuildTree _) => {
        kCssVerticalAlign: kCssVerticalAlignSub,
        kCssFontSize: kCssFontSizeSmaller,
      };

  static StylesMap _tagSup(BuildTree _) => {
        kCssVerticalAlign: kCssVerticalAlignSuper,
        kCssFontSize: kCssFontSizeSmaller,
      };

  static StylesMap _tagTableHeaderCell(BuildTree _) => {
        kCssFontWeight: kCssFontWeightBold,
        kCssVerticalAlign: kCssVerticalAlignMiddle,
      };
}

/// A factory to build widgets.
class WidgetFactoryResetter {
  /// Called when the [HtmlWidget]'s state is disposed.
  @mustCallSuper
  void dispose() {}

  /// Resets for a new build.
  @mustCallSuper
  void reset(State state) {}
}
