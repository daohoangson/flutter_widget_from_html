import 'package:csslib/visitor.dart' as css;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart'
    show
        // we want to limit Material usages to be as generic as possible
        CircularProgressIndicator,
        Tooltip;
import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;
import 'package:logging/logging.dart';

import 'core_data.dart';
import 'core_helpers.dart';
import 'core_html_widget.dart';
import 'internal/core_ops.dart';
import 'internal/core_parser.dart';
import 'internal/margin_vertical.dart';
import 'internal/platform_specific/fallback.dart'
    if (dart.library.io) 'internal/platform_specific/io.dart';
import 'internal/text_ops.dart' as text_ops;
import 'utils/roman_numerals_converter.dart';

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
  BuildOp? _styleDisplayFlex;
  BuildOp? _styleMargin;
  BuildOp? _stylePadding;
  BuildOp? _styleVerticalAlign;
  BuildOp? _tagA;
  BuildOp? _tagDetails;
  BuildOp? _tagImg;
  BuildOp? _tagLi;
  BuildOp? _tagPre;
  TagTable? _tagTable;
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
    DecorationImage? image,
  }) {
    if (border == null &&
        borderRadius == null &&
        color == null &&
        image == null) {
      return child;
    }

    final container = child is Container ? child : null;
    final grandChild = container?.child;
    final prevDeco = container?.decoration;
    final baseDeco =
        prevDeco is BoxDecoration ? prevDeco : const BoxDecoration();
    var decoration = baseDeco.copyWith(
      border: border,
      color: color,
      image: image,
    );

    var clipBehavior = Clip.none;
    if (borderRadius != null) {
      final borderIsUniform = decoration.border?.isUniform ?? true;
      if (borderIsUniform) {
        // TODO: add support for non-uniform border
        // https://github.com/flutter/flutter/commit/5054b6e
        // https://pub.dev/packages/non_uniform_border
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

  /// Builds decoration image from [url]
  DecorationImage? buildDecorationImage(
    BuildTree tree,
    String? url, {
    AlignmentGeometry alignment = Alignment.topLeft,
    BoxFit fit = BoxFit.scaleDown,
    ImageRepeat repeat = ImageRepeat.noRepeat,
  }) {
    if (url == null) {
      return null;
    }

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

    return DecorationImage(
      alignment: alignment,
      fit: fit,
      image: provider,
      repeat: repeat,
    );
  }

  /// Builds [Flex].
  Widget? buildFlex(
    BuildTree tree,
    List<Widget> children, {
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    required Axis direction,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    double spacing = 0.0,
    TextBaseline textBaseline = TextBaseline.alphabetic,
    TextDirection textDirection = TextDirection.ltr,
  }) {
    return LayoutBuilder(
      builder: (_, bc) {
        Widget built = HtmlFlex(
          crossAxisAlignment: crossAxisAlignment,
          direction: direction,
          mainAxisAlignment: mainAxisAlignment,
          spacing: spacing,
          textBaseline: textBaseline,
          textDirection: textDirection,
          children: children,
        );
        switch (direction) {
          case Axis.horizontal:
            built = CssSizingHint(maxWidth: bc.maxWidth, child: built);
          case Axis.vertical:
            built = CssSizingHint(maxHeight: bc.maxHeight, child: built);
        }
        return built;
      },
    );
  }

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
        child: Semantics(
          button: true,
          child: GestureDetector(onTap: recognizer.onTap, child: child),
        ),
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
    InheritedProperties resolved,
    String listStyleType,
    int index,
  ) {
    final text = getListMarkerText(listStyleType, index);
    final textStyle = resolved.prepareTextStyle();
    if (text.isNotEmpty) {
      return buildText(tree, resolved, TextSpan(style: textStyle, text: text));
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
  Widget? buildText(
    BuildTree tree,
    InheritedProperties resolved,
    InlineSpan text,
  ) {
    // pre-compute as many parameters as possible
    final maxLines = tree.maxLines > 0 ? tree.maxLines : null;
    final softWrap = resolved.get<CssWhitespace>() != CssWhitespace.nowrap;
    final textAlign = resolved.get<TextAlign>() ?? TextAlign.start;
    final textDirection = resolved.get<TextDirection>();

    return Builder(
      builder: (context) {
        // TODO: remove Builder when ListView stops providing its own registrar
        final selectionRegistrar = SelectionContainer.maybeOf(context);
        final selectionColor = selectionRegistrar != null
            ? DefaultSelectionStyle.of(context).selectionColor ??
                DefaultSelectionStyle.defaultColor
            : null;

        Widget built = RichText(
          maxLines: maxLines,
          overflow: tree.overflow,
          selectionColor: selectionColor,
          selectionRegistrar: selectionRegistrar,
          softWrap: softWrap,
          text: text,
          textAlign: textAlign,
          textDirection: textDirection,
        );

        if (selectionRegistrar != null) {
          built = MouseRegion(cursor: SystemMouseCursors.text, child: built);
        }

        return built;
      },
    );
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

  StylesMap? customStylesBuilder(dom.Element element) =>
      _widget?.customStylesBuilder?.call(element);

  Widget? customWidgetBuilder(dom.Element element) =>
      _widget?.customWidgetBuilder?.call(element);

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

  /// Returns [context]-based dependencies.
  ///
  /// It's recommended to use [InheritedProperties.get] instead of
  /// obtaining dependencies from [BuildContext] for performance reason.
  ///
  /// ```dart
  /// // avoid doing this:
  /// final direction = Directionality.of(context);
  ///
  /// // do this:
  /// final direction = resolved.get<TextDirection>();
  /// ```
  Iterable<dynamic> getDependencies(BuildContext context) {
    return [
      CssWhitespace.normal,
      Directionality.maybeOf(context) ?? TextDirection.ltr,
      DefaultTextStyle.of(context).style,

      // performance critical
      // avoid adding broad dependencies like MediaQuery.of(context)
      // because it may invalidate our root properties too often
      // TODO: remove lint ignore when our minimum Flutter version >= 3.16
      // ignore: deprecated_member_use
      TextScaleFactor(MediaQuery.textScaleFactorOf(context)),
    ];
  }

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
        final roman = intToRomanNumerals(i)?.toLowerCase();
        return roman != null ? '$roman.' : '';
      case kCssListStyleTypeRomanUpper:
        final roman = intToRomanNumerals(i);
        return roman != null ? '$roman.' : '';
      case kCssListStyleTypeNone:
      default:
        return '';
    }
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
            ..inherit<BuildContext?>(TagA.defaultColor)
            ..register(_tagA ??= TagA(this).buildOp);
        }

        final name = attrs[kAttributeAName];
        if (name != null) {
          tree.register(Anchor(this, name).buildOp);
        }

      case 'abbr':
      case kTagAcronym:
        tree.register(
          const BuildOp.v2(
            debugLabel: kTagAcronym,
            defaultStyles: _tagAcronym,
            priority: Early.tagAcronym,
          ),
        );

      case kTagAddress:
        tree.register(
          const BuildOp.v2(
            debugLabel: kTagAddress,
            defaultStyles: _tagAddress,
            priority: Early.tagAddress,
          ),
        );
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
          const BuildOp.v2(
            debugLabel: kTagDiv,
            defaultStyles: _cssDisplayBlock,
            priority: Early.tagDiv,
          ),
        );

      case 'blockquote':
      case kTagFigure:
        tree.register(
          const BuildOp.v2(
            debugLabel: kTagFigure,
            defaultStyles: _tagFigure,
            priority: Early.tagFigure,
          ),
        );

      case 'b':
      case 'strong':
        tree.inherit(text_ops.fontWeight, FontWeight.bold);

      case 'big':
        tree.inherit(text_ops.fontSizeTerm, kCssFontSizeLarger);
      case 'small':
        tree.inherit(text_ops.fontSizeTerm, kCssFontSizeSmaller);

      case kTagBr:
        tree.register(tagBr);

      case kTagCenter:
        tree.register(
          const BuildOp.v2(
            debugLabel: kTagCenter,
            defaultStyles: _tagCenter,
            priority: Early.tagCenter,
          ),
        );

      case 'cite':
      case 'dfn':
      case 'em':
      case 'i':
      case 'var':
        tree.inherit(text_ops.fontStyle, FontStyle.italic);

      case kTagCode:
      case kTagKbd:
      case kTagSamp:
      case kTagTt:
        tree.inherit(
          text_ops.fontFamily,
          const [kTagCodeFont1, kTagCodeFont2],
        );
      case kTagPre:
        tree.register(_tagPre ??= TagPre(this).buildOp);

      case kTagDetails:
        tree.register(_tagDetails ??= TagDetails(this).buildOp);

      case kTagDd:
        tree.register(
          const BuildOp.v2(
            debugLabel: kTagDd,
            defaultStyles: _tagDd,
            priority: Early.tagDd,
          ),
        );
      case kTagDt:
        tree.register(
          const BuildOp.v2(
            debugLabel: kTagDt,
            defaultStyles: _tagDt,
            priority: Early.tagDt,
          ),
        );

      case 'del':
      case 's':
      case kTagStrike:
        tree.register(
          const BuildOp.v2(
            debugLabel: kTagStrike,
            defaultStyles: _cssTextDecorationLineThrough,
            priority: Early.tagStrike,
          ),
        );

      case kTagFont:
        tree.register(tagFont);

      case kTagH1:
        tree.register(
          const BuildOp.v2(
            debugLabel: kTagH1,
            defaultStyles: _tagH1,
            priority: Early.tagH1,
          ),
        );
      case kTagH2:
        tree.register(
          const BuildOp.v2(
            debugLabel: kTagH2,
            defaultStyles: _tagH2,
            priority: Early.tagH2,
          ),
        );
      case kTagH3:
        tree.register(
          const BuildOp.v2(
            debugLabel: kTagH3,
            defaultStyles: _tagH3,
            priority: Early.tagH3,
          ),
        );
      case kTagH4:
        tree.register(
          const BuildOp.v2(
            debugLabel: kTagH4,
            defaultStyles: _tagH4,
            priority: Early.tagH4,
          ),
        );
      case kTagH5:
        tree.register(
          const BuildOp.v2(
            debugLabel: kTagH5,
            defaultStyles: _tagH5,
            priority: Early.tagH5,
          ),
        );
      case kTagH6:
        tree.register(
          const BuildOp.v2(
            debugLabel: kTagH6,
            defaultStyles: _tagH6,
            priority: Early.tagH6,
          ),
        );

      case kTagHr:
        tree.register(
          const BuildOp.v2(
            debugLabel: kTagHr,
            defaultStyles: _tagHrDefaultStyles,
            onRenderBlock: _tagHrOnRenderBlock,
            priority: Priority.tagHr,
          ),
        );

      case kTagImg:
        tree.register(_tagImg ??= TagImg(this).buildOp);

      case kTagOrderedList:
      case kTagUnorderedList:
        tree.register(_tagLi ??= TagLi(this).buildOp);

      case kTagMark:
        tree.register(
          const BuildOp.v2(
            debugLabel: kTagMark,
            defaultStyles: _tagMark,
            priority: Early.tagMark,
          ),
        );

      case kTagP:
        tree.register(
          const BuildOp.v2(
            debugLabel: kTagP,
            defaultStyles: _tagP,
            priority: Early.tagP,
          ),
        );

      case kTagQ:
        tree.register(tagQ);

      case kTagRuby:
        tree.register(tagRuby);

      case 'style':
      case kTagScript:
        tree.register(
          const BuildOp.v2(
            debugLabel: kTagScript,
            defaultStyles: _cssDisplayNone,
            priority: Early.tagScript,
          ),
        );

      case kTagSub:
        tree.register(
          const BuildOp.v2(
            debugLabel: kTagSub,
            defaultStyles: _tagSub,
            priority: Early.tagSub,
          ),
        );
      case kTagSup:
        tree.register(
          const BuildOp.v2(
            debugLabel: kTagSup,
            defaultStyles: _tagSup,
            priority: Early.tagSup,
          ),
        );

      case kTagTable:
        final tagTable = _tagTable ??= TagTable(this);
        tree
          ..register(
            const BuildOp.v2(
              debugLabel: kTagTable,
              defaultStyles: _cssDisplayTable,
              priority: Early.tagTableDisplayTable,
            ),
          )
          ..register(tagTable.borderOp)
          ..register(tagTable.cellPaddingOp);
      case kTagTableCell:
        tree.register(
          const BuildOp.v2(
            debugLabel: kTagTableCell,
            defaultStyles: _cssVerticalAlignMiddle,
            priority: Early.tagTableCellValignDefault,
          ),
        );
      case kTagTableHeaderCell:
        tree.register(
          const BuildOp.v2(
            debugLabel: kTagTableHeaderCell,
            defaultStyles: _tagTableHeaderCell,
            priority: Early.tagTableHeaderCellDefaultStyles,
          ),
        );
      case kTagTableCaption:
        tree.register(
          const BuildOp.v2(
            debugLabel: kTagTableCaption,
            defaultStyles: _cssTextAlignCenter,
            priority: Early.tagTableCaptionTextAlignCenter,
          ),
        );

      case 'u':
      case kTagIns:
        tree.register(
          const BuildOp.v2(
            debugLabel: kTagIns,
            defaultStyles: _cssTextDecorationUnderline,
            priority: Early.tagIns,
          ),
        );
    }

    for (final attribute in attrs.entries) {
      switch (attribute.key) {
        case kAttributeAlign:
          tree.register(
            const BuildOp.v2(
              debugLabel: kAttributeAlign,
              defaultStyles: _cssTextAlignFromAttribute,
              priority: Early.attributeAlign,
            ),
          );
        case kAttributeDir:
          tree.register(
            const BuildOp.v2(
              debugLabel: kAttributeDir,
              defaultStyles: _cssDirectionFromAttribute,
              priority: Early.attributeDir,
            ),
          );
        case kAttributeId:
          tree.register(Anchor(this, attribute.value).buildOp);
      }
    }
  }

  /// Parses inline style [css.Declaration] one by one.
  /// This also handles styling from [BuildOp]s and [HtmlWidget.customStylesBuilder].
  void parseStyle(BuildTree tree, css.Declaration style) {
    final key = style.property;
    switch (key) {
      case kCssColor:
        final color = tryParseColor(style.value)?.rawValue;
        if (color != null) {
          tree.inherit(text_ops.color, color);
        }

      case kCssDirection:
        final term = style.term;
        if (term != null) {
          tree.inherit(text_ops.textDirection, term);
        }

      case kCssFontFamily:
        final list = text_ops.fontFamilyTryParse(style.values);
        tree.inherit(text_ops.fontFamily, list);

      case kCssFontSize:
        final value = style.value;
        if (value != null) {
          tree.inherit(text_ops.fontSize, value);
        }

      case kCssFontStyle:
        final term = style.term;
        final fontStyle =
            term != null ? text_ops.fontStyleTryParse(term) : null;
        if (fontStyle != null) {
          tree.inherit(text_ops.fontStyle, fontStyle);
        }

      case kCssFontWeight:
        final value = style.value;
        final fontWeight =
            value != null ? text_ops.fontWeightTryParse(value) : null;
        if (fontWeight != null) {
          tree.inherit(text_ops.fontWeight, fontWeight);
        }

      case kCssHeight:
      case kCssMaxHeight:
      case kCssMaxWidth:
      case kCssMinHeight:
      case kCssMinWidth:
      case kCssWidth:
        StyleSizing.registerSizingOp(this, tree);

      case kCssLineHeight:
        final value = style.value;
        if (value != null) {
          tree.inherit(text_ops.lineHeight, value);
        }

      case kCssMaxLines:
      case kCssMaxLinesWebkitLineClamp:
        final maxLines = tryParseMaxLines(style.value);
        if (maxLines != null) {
          tree.maxLines = maxLines;
        }

      case kCssTextAlign:
        tree.register(styleTextAlign);

      case kCssTextDecoration:
      case kCssTextDecorationColor:
      case kCssTextDecorationLine:
      case kCssTextDecorationStyle:
      case kCssTextDecorationThickness:
      case kCssTextDecorationWidth:
        textDecorationApply(tree, style);

      case kCssTextOverflow:
        final textOverflow = tryParseTextOverflow(style.value);
        if (textOverflow != null) {
          tree.overflow = textOverflow;
        }

      case kCssVerticalAlign:
        tree.register(_styleVerticalAlign ??= StyleVerticalAlign(this).buildOp);

      case kCssWhitespace:
        final term = style.term;
        final whitespace =
            term != null ? text_ops.whitespaceTryParse(term) : null;
        if (whitespace != null) {
          tree.inherit(text_ops.whitespace, whitespace);
        }

      case kCssTextShadow:
        textShadowApply(tree, style);
    }

    if (key.startsWith(kCssBackground)) {
      tree.register(_styleBackground ??= StyleBackground(this).buildOp);
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
      case kCssDisplayFlex:
        tree.register(_styleDisplayFlex ??= StyleDisplayFlex(this).buildOp);
      case kCssDisplayBlock:
        StyleSizing.registerBlockOp(this, tree);
      case kCssDisplayInlineBlock:
        tree.register(displayInlineBlock);
      case kCssDisplayNone:
        tree.register(displayNone);
      case kCssDisplayTable:
        final tagTable = _tagTable ??= TagTable(this);
        tree.register(tagTable.tableOp);
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
      if (uri.hasAuthority) {
        // special handling for protocol relative URL without base: assume HTTPS
        return Uri(scheme: 'https').resolveUri(uri).toString();
      }

      return null;
    }

    return baseUrl.resolveUri(uri).toString();
  }

  // TODO: switch to use constant function literal when available
  // https://github.com/dart-lang/language/issues/1048
  static StylesMap _cssDirectionFromAttribute(dom.Element element) {
    final value = element.attributes[kAttributeDir];
    return value != null ? {kCssDirection: value} : const {};
  }

  static StylesMap _cssDisplayBlock(dom.Element _) =>
      {kCssDisplay: kCssDisplayBlock};

  static StylesMap _cssDisplayNone(dom.Element _) =>
      {kCssDisplay: kCssDisplayNone};

  static StylesMap _cssDisplayTable(dom.Element _) =>
      {kCssDisplay: kCssDisplayTable};

  static StylesMap _cssTextAlignCenter(dom.Element _) =>
      {kCssTextAlign: kCssTextAlignCenter};

  static StylesMap _cssTextAlignFromAttribute(dom.Element element) {
    final value = element.attributes[kAttributeAlign];

    if (value == kCssTextAlignCenter) {
      // `align=center` works more like `CENTER` tag, not `text-align: center`
      return _tagCenter(element);
    }

    return value != null ? {kCssTextAlign: value} : const {};
  }

  static StylesMap _cssTextDecorationLineThrough(dom.Element _) =>
      {kCssTextDecorationLine: kCssTextDecorationLineThrough};

  static StylesMap _cssTextDecorationUnderline(dom.Element _) =>
      {kCssTextDecorationLine: kCssTextDecorationUnderline};

  static StylesMap _cssVerticalAlignMiddle(dom.Element _) =>
      {kCssVerticalAlign: kCssVerticalAlignMiddle};

  static StylesMap _tagAcronym(dom.Element _) => {
        kCssTextDecorationLine: kCssTextDecorationUnderline,
        kCssTextDecorationStyle: kCssTextDecorationStyleDotted,
      };

  static StylesMap _tagAddress(dom.Element _) => {
        kCssDisplay: kCssDisplayBlock,
        kCssFontStyle: kCssFontStyleItalic,
      };

  static StylesMap _tagCenter(dom.Element _) => {
        kCssDisplay: kCssDisplayBlock,
        kCssTextAlign: kCssTextAlignWebkitCenter,
        kCssWidth: '100%',
      };

  static StylesMap _tagDd(dom.Element _) => {
        kCssDisplay: kCssDisplayBlock,
        kCssMargin: '0 0 1em 40px',
      };

  static StylesMap _tagDt(dom.Element _) => {
        kCssDisplay: kCssDisplayBlock,
        kCssFontWeight: kCssFontWeightBold,
      };

  static StylesMap _tagFigure(dom.Element _) => {
        kCssDisplay: kCssDisplayBlock,
        kCssMargin: '1em 40px',
      };

  static StylesMap _tagH1(dom.Element _) => {
        kCssDisplay: kCssDisplayBlock,
        kCssFontSize: '2em',
        kCssFontWeight: kCssFontWeightBold,
        kCssMargin: '0.67em 0',
      };

  static StylesMap _tagH2(dom.Element _) => {
        kCssDisplay: kCssDisplayBlock,
        kCssFontSize: '1.5em',
        kCssFontWeight: kCssFontWeightBold,
        kCssMargin: '0.83em 0',
      };

  static StylesMap _tagH3(dom.Element _) => {
        kCssDisplay: kCssDisplayBlock,
        kCssFontSize: '1.17em',
        kCssFontWeight: kCssFontWeightBold,
        kCssMargin: '1em 0',
      };

  static StylesMap _tagH4(dom.Element _) => {
        kCssDisplay: kCssDisplayBlock,
        kCssFontWeight: kCssFontWeightBold,
        kCssMargin: '1.33em 0',
      };

  static StylesMap _tagH5(dom.Element _) => {
        kCssDisplay: kCssDisplayBlock,
        kCssFontSize: '0.83em',
        kCssFontWeight: kCssFontWeightBold,
        kCssMargin: '1.67em 0',
      };

  static StylesMap _tagH6(dom.Element _) => {
        kCssDisplay: kCssDisplayBlock,
        kCssFontSize: '0.67em',
        kCssFontWeight: kCssFontWeightBold,
        kCssMargin: '2.33em 0',
      };

  static StylesMap _tagHrDefaultStyles(dom.Element _) => {
        kCssDisplay: kCssDisplayBlock,
        kCssMargin: '0.5em 0',
        kCssBorder + kSuffixTop: '1px solid',
      };

  static WidgetPlaceholder _tagHrOnRenderBlock(
    BuildTree _,
    WidgetPlaceholder placeholder,
  ) =>
      placeholder.wrapWith((_, __) => Container());

  static StylesMap _tagMark(dom.Element _) => {
        kCssBackgroundColor: '#ff0',
        kCssColor: '#000',
      };

  static StylesMap _tagP(dom.Element _) => {
        kCssDisplay: kCssDisplayBlock,
        kCssMargin: '1em 0',
      };

  static StylesMap _tagSub(dom.Element _) => {
        kCssVerticalAlign: kCssVerticalAlignSub,
        kCssFontSize: kCssFontSizeSmaller,
      };

  static StylesMap _tagSup(dom.Element _) => {
        kCssVerticalAlign: kCssVerticalAlignSuper,
        kCssFontSize: kCssFontSizeSmaller,
      };

  static StylesMap _tagTableHeaderCell(dom.Element _) => {
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
