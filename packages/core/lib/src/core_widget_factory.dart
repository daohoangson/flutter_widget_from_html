import 'package:csslib/visitor.dart' as css;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'core_data.dart';
import 'core_helpers.dart';
import 'core_html_widget.dart';
import 'internal/core_ops.dart';
import 'internal/core_parser.dart';
import 'internal/margin_vertical.dart';
import 'internal/platform_specific/fallback.dart'
    if (dart.library.io) 'internal/platform_specific/io.dart';

/// A factory to build widgets.
class WidgetFactory {
  /// Setting this property to true replaces the default with a static [Text].
  /// This property is most useful for testing purposes.
  ///
  /// Defaults to `false`, resulting in a [CircularProgressIndicator].
  static bool debugDeterministicLoadingWidget = false;

  final _recognizersNeedDisposing = <GestureRecognizer>[];

  late AnchorRegistry _anchorRegistry;

  BuildOp? _styleBgColor;
  StyleBorder? _styleBorder;
  BuildOp? _styleDisplayInlineBlock;
  BuildOp? _styleDisplayNone;
  BuildOp? _styleMargin;
  BuildOp? _stylePadding;
  BuildOp? _styleTextDecoration;
  StyleVerticalAlign? _styleVerticalAlign;
  BuildOp? _tagA;
  BuildOp? _tagBr;
  BuildOp? _tagDetails;
  BuildOp? _tagFont;
  BuildOp? _tagHr;
  BuildOp? _tagImg;
  BuildOp? _tagPre;
  BuildOp? _tagQ;
  BuildOp? _tagRuby;
  HtmlStyle Function(HtmlStyle, css.Expression)? _styleBuilderLineHeight;
  HtmlWidget? _widget;

  /// Gets the current anchor registry.
  ///
  /// This is an impl detail and may be changed without a major version bump.
  @protected
  AnchorRegistry get anchorRegistry => _anchorRegistry;

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
    TextDirection? dir,
  }) {
    if (children.length == 1) {
      return children.first;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      textDirection: dir,
      children: children,
    );
  }

  /// Builds [Decoration].
  ///
  /// See https://developer.mozilla.org/en-US/docs/Web/CSS/box-sizing
  /// for more information regarding `content-box` (the default)
  /// and `border-box` (set [isBorderBox] to use).
  Widget? buildDecoration(
    BuildTree tree,
    Widget child, {
    BoxBorder? border,
    BorderRadius? borderRadius,
    Color? color,
    bool isBorderBox = true,
  }) {
    if (border == null && borderRadius == null && color == null) {
      return child;
    }

    final container = child is Container ? child : null;
    final decoratedBox = child is DecoratedBox ? child : null;
    final grandChild = container?.child ?? decoratedBox?.child;
    final prevDeco = container?.decoration ?? decoratedBox?.decoration;
    final baseDeco =
        prevDeco is BoxDecoration ? prevDeco : const BoxDecoration();
    final decoration = baseDeco.copyWith(
      border: border,
      borderRadius: borderRadius,
      color: color,
    );

    if (!isBorderBox || container != null) {
      // we are using Container intentionally because it handles border differently
      // ignore: use_decorated_box
      return Container(
        decoration: decoration,
        child: grandChild ?? child,
      );
    } else {
      return DecoratedBox(
        decoration: decoration,
        child: decoratedBox?.child ?? child,
      );
    }
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

    if (built != null &&
        src.height?.isNegative == false &&
        src.width?.isNegative == false &&
        src.height != 0) {
      built = buildAspectRatio(tree, built, src.width! / src.height!);
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
      loadingBuilder: (context, child, loadingProgress) =>
          loadingProgress == null
              ? child
              : onLoadingBuilder(
                    context,
                    tree,
                    loadingProgress.expectedTotalBytes != null &&
                            loadingProgress.expectedTotalBytes! > 0
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                    src,
                  ) ??
                  child,
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
      return RichText(
        maxLines: 1,
        softWrap: false,
        text: TextSpan(style: textStyle, text: text),
        textDirection: style.textDirection,
      );
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
  Widget? buildText(BuildTree tree, HtmlStyle style, InlineSpan text) =>
      RichText(
        maxLines: tree.maxLines > 0 ? tree.maxLines : null,
        overflow: tree.overflow,
        selectionRegistrar: style.getDependency(),
        selectionColor:
            style.getDependency<DefaultSelectionStyle>().selectionColor,
        text: text,
        textAlign: style.textAlign ?? TextAlign.start,
        textDirection: style.textDirection,
      );

  /// Builds [TextSpan].
  InlineSpan? buildTextSpan({
    List<InlineSpan>? children,
    GestureRecognizer? recognizer,
    TextStyle? style,
    String? text,
  }) {
    if (text?.isEmpty == true) {
      if (children?.isEmpty == true) {
        return null;
      }
      if (children?.length == 1) {
        return children!.first;
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

  /// Called when the [HtmlWidget]'s state is disposed.
  @mustCallSuper
  void dispose() {
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
  /// Includes these by default:
  ///
  /// - [MediaQueryData] via [MediaQuery.of]
  /// - [TextDirection] via [Directionality.of]
  /// - [TextStyle] via [DefaultTextStyle.of]
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
  /// final scale = style.getDependency<MediaQueryData>().textScaleFactor;
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
        MediaQuery.of(context),
        Directionality.of(context),
        DefaultSelectionStyle.of(context),
        DefaultTextStyle.of(context).style,
        SelectionContainer.maybeOf(context),
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

  /// Ensures anchor is visible.
  ///
  /// Returns `true` if anchor has been found and
  /// [ScrollPosition.ensureVisible] completes successfully.
  Future<bool> onTapAnchor(String id, EnsureVisible scrollTo) => scrollTo(id);

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

    if (url.startsWith('#')) {
      final id = url.substring(1);
      final handledViaAnchor =
          await onTapAnchor(id, _anchorRegistry.ensureVisible);
      if (handledViaAnchor) {
        return true;
      }
    }

    return false;
  }

  /// Parses [tree] for build ops and text styles.
  void parse(BuildTree tree) {
    final attrs = tree.element.attributes;

    switch (tree.element.localName) {
      case kTagA:
        if (attrs.containsKey(kAttributeAHref)) {
          tree
            ..apply(TagA.defaultColor, null)
            ..register(_tagA ??= TagA(this).buildOp);
        }

        final name = attrs[kAttributeAName];
        if (name != null) {
          tree.register(_anchorOp(name));
        }
        break;

      case 'abbr':
      case 'acronym':
        tree[kCssTextDecorationLine] = kCssTextDecorationUnderline;
        tree[kCssTextDecorationStyle] = kCssTextDecorationStyleDotted;
        break;

      case 'address':
        tree
          ..[kCssDisplay] = kCssDisplayBlock
          ..apply(TextStyleOps.fontStyle, FontStyle.italic);
        break;

      case 'article':
      case 'aside':
      case 'div':
      case 'figcaption':
      case 'footer':
      case 'header':
      case 'main':
      case 'nav':
      case 'section':
        tree[kCssDisplay] = kCssDisplayBlock;
        break;

      case 'blockquote':
      case 'figure':
        tree
          ..[kCssDisplay] = kCssDisplayBlock
          ..[kCssMargin] = '1em 40px';
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

      case 'br':
        tree.register(_tagBr ??= TagBr(this).buildOp);
        break;

      case kTagCenter:
        tree
          ..[kCssDisplay] = kCssDisplayBlock
          ..[kCssTextAlign] = kCssTextAlignWebkitCenter;
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

      case 'dd':
        tree
          ..[kCssDisplay] = kCssDisplayBlock
          ..[kCssMargin] = '0 0 1em 40px';
        break;
      case 'dl':
        tree[kCssDisplay] = kCssDisplayBlock;
        break;
      case 'dt':
        tree
          ..[kCssDisplay] = kCssDisplayBlock
          ..apply(TextStyleOps.fontWeight, FontWeight.bold);
        break;

      case 'del':
      case 's':
      case 'strike':
        tree[kCssTextDecorationLine] = kCssTextDecorationLineThrough;
        break;

      case kTagFont:
        tree.register(_tagFont ??= TagFont(this).buildOp);
        break;

      case 'hr':
        tree
          ..[kCssDisplay] = kCssDisplayBlock
          ..[kCssMargin + kSuffixBottom] = '1em'
          ..register(
            _tagHr ??=
                BuildOp(onWidgets: (tree, _) => listOrNull(buildDivider(tree))),
          );
        break;

      case 'h1':
        tree
          ..[kCssDisplay] = kCssDisplayBlock
          ..[kCssMargin] = '0.67em 0'
          ..apply(TextStyleOps.fontSizeEm, 2.0)
          ..apply(TextStyleOps.fontWeight, FontWeight.bold);
        break;
      case 'h2':
        tree
          ..[kCssDisplay] = kCssDisplayBlock
          ..[kCssMargin] = '0.83em 0'
          ..apply(TextStyleOps.fontSizeEm, 1.5)
          ..apply(TextStyleOps.fontWeight, FontWeight.bold);
        break;
      case 'h3':
        tree
          ..[kCssDisplay] = kCssDisplayBlock
          ..[kCssMargin] = '1em 0'
          ..apply(TextStyleOps.fontSizeEm, 1.17)
          ..apply(TextStyleOps.fontWeight, FontWeight.bold);
        break;
      case 'h4':
        tree
          ..[kCssDisplay] = kCssDisplayBlock
          ..[kCssMargin] = '1.33em 0'
          ..apply(TextStyleOps.fontWeight, FontWeight.bold);
        break;
      case 'h5':
        tree
          ..[kCssDisplay] = kCssDisplayBlock
          ..[kCssMargin] = '1.67em 0'
          ..apply(TextStyleOps.fontSizeEm, .83)
          ..apply(TextStyleOps.fontWeight, FontWeight.bold);
        break;
      case 'h6':
        tree
          ..[kCssDisplay] = kCssDisplayBlock
          ..[kCssMargin] = '2.33em 0'
          ..apply(TextStyleOps.fontSizeEm, .67)
          ..apply(TextStyleOps.fontWeight, FontWeight.bold);
        break;

      case kTagImg:
        tree.register(_tagImg ??= TagImg(this).buildOp);
        break;

      case 'ins':
      case 'u':
        tree[kCssTextDecorationLine] = kCssTextDecorationUnderline;
        break;

      case kTagOrderedList:
      case kTagUnorderedList:
        tree
          ..[kCssDisplay] = kCssDisplayBlock
          ..register(TagLi(this, tree).buildOp);
        break;

      case 'mark':
        tree
          ..[kCssBackgroundColor] = '#ff0'
          ..[kCssColor] = '#000';
        break;

      case 'p':
        tree
          ..[kCssDisplay] = kCssDisplayBlock
          ..[kCssMargin] = '1em 0';
        break;

      case 'q':
        tree.register(_tagQ ??= TagQ(this).buildOp);
        break;

      case kTagRuby:
        tree.register(_tagRuby ??= TagRuby(this).buildOp);
        break;

      case 'script':
      case 'style':
        tree[kCssDisplay] = kCssDisplayNone;
        break;

      case 'sub':
        tree
          ..[kCssVerticalAlign] = kCssVerticalAlignSub
          ..apply(TextStyleOps.fontSizeTerm, kCssFontSizeSmaller);
        break;
      case 'sup':
        tree
          ..[kCssVerticalAlign] = kCssVerticalAlignSuper
          ..apply(TextStyleOps.fontSizeTerm, kCssFontSizeSmaller);
        break;

      case kTagTable:
        tree
          ..[kCssDisplay] = kCssDisplayTable
          ..register(
            TagTable.borderOp(
              tryParseDoubleFromMap(attrs, kAttributeBorder) ?? 0.0,
              tryParseDoubleFromMap(attrs, kAttributeCellSpacing) ?? 2.0,
            ),
          )
          ..register(
            TagTable.cellPaddingOp(
              tryParseDoubleFromMap(attrs, kAttributeCellPadding) ?? 1.0,
            ),
          );
        break;
      case kTagTableCell:
        tree[kCssVerticalAlign] = kCssVerticalAlignMiddle;
        break;
      case kTagTableHeaderCell:
        tree
          ..[kCssVerticalAlign] = kCssVerticalAlignMiddle
          ..apply(TextStyleOps.fontWeight, FontWeight.bold);
        break;
      case kTagTableCaption:
        tree[kCssTextAlign] = kCssTextAlignCenter;
        break;
    }

    for (final attribute in attrs.entries) {
      switch (attribute.key) {
        case kAttributeAlign:
          tree[kCssTextAlign] = attribute.value;
          break;
        case kAttributeDir:
          tree[kCssDirection] = attribute.value;
          break;
        case kAttributeId:
          tree.register(_anchorOp(attribute.value));
          break;
      }
    }
  }

  /// Parses inline style [key] and [value] pair.
  void parseStyle(BuildTree tree, css.Declaration style) {
    final key = style.property;
    switch (key) {
      case kCssBackground:
      case kCssBackgroundColor:
        tree.register(_styleBgColor ??= StyleBgColor(this).buildOp);
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
        StyleSizing.registerSizing(this, tree);
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
        final term = style.term;
        if (term != null) {
          tree.register(StyleTextAlign(this, term).buildOp);
        }
        break;

      case kCssTextDecoration:
      case kCssTextDecorationColor:
      case kCssTextDecorationLine:
      case kCssTextDecorationStyle:
      case kCssTextDecorationThickness:
      case kCssTextDecorationWidth:
        tree.register(
          _styleTextDecoration ??= StyleTextDecoration(this).buildOp,
        );
        break;

      case kCssTextOverflow:
        final textOverflow = tryParseTextOverflow(style.value);
        if (textOverflow != null) {
          tree.overflow = textOverflow;
        }
        break;

      case kCssVerticalAlign:
        final styleVerticalAlign =
            _styleVerticalAlign ??= StyleVerticalAlign(this);
        tree
          ..register(styleVerticalAlign.inlineOp)
          ..register(styleVerticalAlign.blockOp);
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
      final styleBorder = _styleBorder ??= StyleBorder(this);
      tree
        ..register(styleBorder.inlineOp)
        ..register(styleBorder.blockOp);
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
    switch (value) {
      case kCssDisplayBlock:
        StyleSizing.registerBlock(this, tree);
        break;
      case kCssDisplayInlineBlock:
        final displayInlineBlock = _styleDisplayInlineBlock ??= BuildOp(
          onTree: (tree) {
            final built = tree.build();
            if (built != null) {
              const align = PlaceholderAlignment.baseline;
              tree.replaceWith(WidgetBit.inline(tree, built, alignment: align));
            }
          },
          priority: BuildOp.kPriorityMax,
        );
        tree.register(displayInlineBlock);
        break;
      case kCssDisplayNone:
        final displayNone = _styleDisplayNone ??= BuildOp(
          onTree: (tree) => tree.replaceWith(null),
          priority: BuildOp.kPriorityMax,
        );
        tree.register(displayNone);
        break;
      case kCssDisplayTable:
        tree.register(TagTable(this).buildOp);
        break;
    }
  }

  /// Resets for a new build.
  @mustCallSuper
  void reset(State state) {
    _dispose();

    _anchorRegistry = AnchorRegistry(state.context);

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

  BuildOp _anchorOp(String id) {
    final anchor = GlobalKey(debugLabel: id);

    return BuildOp(
      onTree: (tree) {
        _anchorRegistry.register(id, anchor);
        tree.registerAnchor(anchor);
      },
      onTreeFlattening: (tree) {
        final widget = WidgetPlaceholder(
          builder: (context, _) => SizedBox(
            height: tree.styleBuilder.build(context).textStyle.fontSize,
            key: anchor,
          ),
          localName: 'anchor',
        );

        const baseline = PlaceholderAlignment.baseline;
        tree.prepend(WidgetBit.inline(tree, widget, alignment: baseline));
      },
      onWidgets: (tree, widgets) {
        return listOrNull(
              buildColumnPlaceholder(tree, widgets)?.wrapWith(
                (context, child) => SizedBox(key: anchor, child: child),
              ),
            ) ??
            widgets;
      },
      onWidgetsIsOptional: true,
      priority: BuildOp.kPriorityMax,
    );
  }
}
