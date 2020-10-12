import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'internal/core_ops.dart';
import 'internal/core_parser.dart';
import 'core_data.dart';
import 'core_helpers.dart';
import 'core_html_widget.dart';

/// A factory to build widgets.
class WidgetFactory {
  BuildOp _styleBgColor;
  BuildOp _styleBlock;
  BuildOp _styleBorder;
  BuildOp _styleDisplayNone;
  BuildOp _styleMargin;
  BuildOp _stylePadding;
  BuildOp _styleSizing;
  BuildOp _styleVerticalAlign;
  BuildOp _tagA;
  BuildOp _tagBr;
  BuildOp _tagFont;
  BuildOp _tagHr;
  BuildOp _tagImg;
  BuildOp _tagPre;
  BuildOp _tagQ;
  TextStyleHtml Function(TextStyleHtml, String) __tsbFontSize;
  TextStyleHtml Function(TextStyleHtml, String) _tsbLineHeight;
  State _state;

  HtmlWidget get _widget => _state?.widget;

  /// Builds [AspectRatio].
  Widget buildAspectRatio(
          BuildMetadata meta, Widget child, double aspectRatio) =>
      child != null && aspectRatio != null
          ? AspectRatio(aspectRatio: aspectRatio, child: child)
          : null;

  /// Builds primary column (body).
  WidgetPlaceholder buildBody(BuildMetadata meta, Iterable<Widget> children) =>
      buildColumnPlaceholder(meta, children, trimMarginVertical: true);

  /// Builds column placeholder.
  WidgetPlaceholder buildColumnPlaceholder(
    BuildMetadata meta,
    Iterable<Widget> children, {
    bool trimMarginVertical = false,
  }) {
    if (children?.isNotEmpty != true) return null;

    if (children.length == 1) {
      final first = children.first;
      if (first is WidgetPlaceholder) {
        if (first is! ColumnPlaceholder) return first;

        final existingPlaceholder = first as ColumnPlaceholder;
        if (existingPlaceholder.trimMarginVertical == trimMarginVertical) {
          return first;
        }
      }
    }

    return ColumnPlaceholder(
      children,
      meta: meta,
      trimMarginVertical: trimMarginVertical,
      wf: this,
    );
  }

  /// Builds [Column].
  Widget buildColumnWidget(
      BuildMetadata meta, TextStyleHtml tsh, List<Widget> children) {
    if (children?.isNotEmpty != true) return null;
    if (children.length == 1) return children.first;

    return Column(
      children: children,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      textDirection: tsh.textDirection,
    );
  }

  /// Builds [DecoratedBox].
  Widget buildDecoratedBox(
    BuildMetadata meta,
    Widget child, {
    Color color,
  }) =>
      child != null
          ? DecoratedBox(
              child: child,
              decoration: BoxDecoration(
                color: color,
              ),
            )
          : child;

  /// Builds 1-pixel-height divider.
  Widget buildDivider(BuildMetadata meta) => const DecoratedBox(
        decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 1)),
        child: SizedBox(height: 1),
      );

  /// Builds [GestureDetector].
  Widget buildGestureDetector(
          BuildMetadata meta, Widget child, GestureTapCallback onTap) =>
      GestureDetector(child: child, onTap: onTap);

  /// Builds horizontal scroll view.
  Widget buildHorizontalScrollView(BuildMetadata meta, Widget child) =>
      SingleChildScrollView(child: child, scrollDirection: Axis.horizontal);

  /// Builds [Image] from [provider].
  Widget buildImage(BuildMetadata meta, Object provider, ImageMetadata data) {
    if (provider == null) return null;
    if (provider is ImageProvider) {
      final semanticLabel = data?.alt ?? data?.title;
      return Image(
        errorBuilder: (_, error, __) {
          print('$provider error: $error');
          final text = semanticLabel ?? '❌';
          return Text(text);
        },
        excludeFromSemantics: semanticLabel == null,
        fit: BoxFit.fill,
        image: provider,
        semanticLabel: semanticLabel,
      );
    }

    return null;
  }

  /// Builds [Padding].
  Widget buildPadding(BuildMetadata meta, Widget child, EdgeInsets padding) =>
      child != null && padding != null && padding != const EdgeInsets.all(0)
          ? Padding(child: child, padding: padding)
          : child;

  /// Builds [Stack].
  Widget buildStack(
          BuildMetadata meta, TextStyleHtml tsh, List<Widget> children) =>
      Stack(
        children: children,
        clipBehavior: Clip.none,
        textDirection: tsh.textDirection,
      );

  /// Builds [RichText].
  Widget buildText(BuildMetadata meta, TextStyleHtml tsh, InlineSpan text) =>
      RichText(
        overflow: tsh?.textOverflow ?? TextOverflow.clip,
        text: text,
        textAlign: tsh?.textAlign ?? TextAlign.start,
        textDirection: tsh?.textDirection ?? TextDirection.ltr,

        // TODO: calculate max lines automatically for ellipsis if needed
        // currently it only renders 1 line with ellipsis
        maxLines: tsh?.maxLines == -1 ? null : tsh?.maxLines,
      );

  /// Prepares [GestureTapCallback].
  GestureTapCallback gestureTapCallback(String url) => url != null
      ? () => _widget.onTapUrl != null
          ? _widget.onTapUrl(url)
          : print('[HtmlWidget] onTapUrl($url)')
      : null;

  /// Returns [context]-based dependencies.
  ///
  /// Includes these by default:
  ///
  /// - [MediaQueryData] via [MediaQuery.of]
  /// - [TextDirection] via [Directionality.of]
  /// - [TextStyle] via [DefaultTextStyle.of]
  /// - [ThemeData] via [Theme.of] (enhanced package only)
  ///
  /// Use [TextStyleHtml.getDependency] to get value by type.
  ///
  /// ```dart
  /// // in normal widget building:
  /// final scale = MediaQuery.of(context).textScaleFactor;
  /// final color = Theme.of(context).accentColor;
  ///
  /// // in build ops:
  /// final scale = tsh.getDependency<MediaQueryData>().textScaleFactor;
  /// final color = tsh.getDependency<ThemeData>().accentColor;
  /// ```
  ///
  /// It's recommended to use values from [TextStyleHtml] instead of
  /// obtaining from [BuildContext] for performance reason.
  ///
  /// ```dart
  /// // avoid doing this:
  /// final widgetValue = Directionality.of(context);
  ///
  /// // do this:
  /// final buildOpValue = tsh.textDirection;
  /// ```
  Iterable<dynamic> getDependencies(BuildContext context) => [
        MediaQuery.of(context),
        Directionality.of(context),
        DefaultTextStyle.of(context).style,
      ];

  /// Returns marker for the specified [type] at index [i].
  ///
  /// Note: `circle`, `disc` and `square` type won't trigger this method
  String getListStyleMarker(String type, int i) {
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
        final roman = _getListStyleMarkerRoman(i)?.toLowerCase();
        return roman != null ? '$roman.' : '';
      case kCssListStyleTypeRomanUpper:
        final roman = _getListStyleMarkerRoman(i);
        return roman != null ? '$roman.' : '';
    }

    return '';
  }

  String _getListStyleMarkerRoman(int i) {
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

  /// Returns [ImageProvider].
  Object imageProvider(ImageSource imgSrc) {
    if (imgSrc == null) return null;
    final url = imgSrc.url;

    if (url.startsWith('asset:') == true) {
      return _imageFromAsset(url);
    }

    if (url.startsWith('data:') == true) {
      return _imageFromDataUri(url);
    }

    return _imageFromUrl(url);
  }

  Object _imageFromAsset(String url) {
    final uri = url?.isNotEmpty == true ? Uri.tryParse(url) : null;
    if (uri?.scheme != 'asset') return null;

    final assetName = uri.path;
    if (assetName?.isNotEmpty != true) return null;

    final package = uri.queryParameters?.containsKey('package') == true
        ? uri.queryParameters['package']
        : null;

    return AssetImage(assetName, package: package);
  }

  Object _imageFromDataUri(String dataUri) {
    final bytes = bytesFromDataUri(dataUri);
    if (bytes == null) return null;

    return MemoryImage(bytes);
  }

  Object _imageFromUrl(String url) =>
      url?.isNotEmpty == true ? NetworkImage(url) : null;

  /// Prepares the root [TextStyleBuilder].
  void onRoot(TextStyleBuilder rootTsb) {}

  /// Parses [meta] for build ops and text styles.
  void parse(BuildMetadata meta) {
    final attrs = meta.element.attributes;

    switch (meta.element.localName) {
      case kTagA:
        _tagA ??= TagA(this, () => _widget?.hyperlinkColor).buildOp;
        meta.register(_tagA);
        break;

      case 'abbr':
      case 'acronym':
        meta.tsb(
          TextStyleOps.textDeco,
          TextDeco(style: TextDecorationStyle.dotted, under: true),
        );
        break;

      case 'address':
        meta
          ..[kCssDisplay] = kCssDisplayBlock
          ..tsb(TextStyleOps.fontStyle, FontStyle.italic);
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
        meta[kCssDisplay] = kCssDisplayBlock;
        break;

      case 'blockquote':
      case 'figure':
        meta
          ..[kCssDisplay] = kCssDisplayBlock
          ..[kCssMargin] = '1em 40px';
        break;

      case 'b':
      case 'strong':
        meta.tsb(TextStyleOps.fontWeight, FontWeight.bold);
        break;

      case 'big':
        meta.tsb(_tsbFontSize, kCssFontSizeLarger);
        break;

      case 'br':
        _tagBr ??= BuildOp(onTree: (_, tree) => tree.addNewLine());
        meta.register(_tagBr);
        break;

      case kTagCenter:
        meta
          ..[kCssDisplay] = kCssDisplayBlock
          ..[kCssTextAlign] = kCssTextAlignWebkitCenter;
        break;

      case 'cite':
      case 'dfn':
      case 'em':
      case 'i':
      case 'var':
        meta.tsb(TextStyleOps.fontStyle, FontStyle.italic);
        break;

      case kTagCode:
      case kTagKbd:
      case kTagSamp:
      case kTagTt:
        meta.tsb(TextStyleOps.fontFamily, [kTagCodeFont1, kTagCodeFont2]);
        break;
      case kTagPre:
        _tagPre ??= BuildOp(
          defaultStyles: (_) =>
              const {kCssFontFamily: '$kTagCodeFont1, $kTagCodeFont2'},
          onTree: (meta, tree) =>
              tree.replaceWith(TextBit(tree, meta.element.text, tsb: tree.tsb)),
          onWidgets: (meta, widgets) => listOrNull(
              buildColumnPlaceholder(meta, widgets)
                  ?.wrapWith((_, w) => buildHorizontalScrollView(meta, w))),
        );
        meta
          ..[kCssDisplay] = kCssDisplayBlock
          ..register(_tagPre);
        break;

      case 'dd':
        meta
          ..[kCssDisplay] = kCssDisplayBlock
          ..[kCssMargin] = '0 0 1em 40px';
        break;
      case 'dl':
        meta[kCssDisplay] = kCssDisplayBlock;
        break;
      case 'dt':
        meta
          ..[kCssDisplay] = kCssDisplayBlock
          ..tsb(TextStyleOps.fontWeight, FontWeight.bold);
        break;

      case 'del':
      case 's':
      case 'strike':
        meta.tsb(TextStyleOps.textDeco, TextDeco(strike: true));
        break;

      case kTagFont:
        _tagFont ??= BuildOp(
          defaultStyles: (element) {
            final attrs = element.attributes;
            return {
              kCssColor: attrs[kAttributeFontColor],
              kCssFontFamily: attrs[kAttributeFontFace],
              kCssFontSize: kCssFontSizes[attrs[kAttributeFontSize]],
            };
          },
        );
        meta.register(_tagFont);
        break;

      case 'hr':
        _tagHr ??= BuildOp(
          defaultStyles: (_) => const {'margin-bottom': '1em'},
          onWidgets: (meta, _) => [buildDivider(meta)],
        );
        meta
          ..[kCssDisplay] = kCssDisplayBlock
          ..register(_tagHr);
        break;

      case 'h1':
        meta
          ..[kCssDisplay] = kCssDisplayBlock
          ..[kCssMargin] = '0.67em 0'
          ..tsb(_tsbFontSize, '2em')
          ..tsb(TextStyleOps.fontWeight, FontWeight.bold);
        break;
      case 'h2':
        meta
          ..[kCssDisplay] = kCssDisplayBlock
          ..[kCssMargin] = '0.83em 0'
          ..tsb(_tsbFontSize, '1.5em')
          ..tsb(TextStyleOps.fontWeight, FontWeight.bold);
        break;
      case 'h3':
        meta
          ..[kCssDisplay] = kCssDisplayBlock
          ..[kCssMargin] = '1em 0'
          ..tsb(_tsbFontSize, '1.17em')
          ..tsb(TextStyleOps.fontWeight, FontWeight.bold);
        break;
      case 'h4':
        meta
          ..[kCssDisplay] = kCssDisplayBlock
          ..[kCssMargin] = '1.33em 0'
          ..tsb(TextStyleOps.fontWeight, FontWeight.bold);
        break;
      case 'h5':
        meta
          ..[kCssDisplay] = kCssDisplayBlock
          ..[kCssMargin] = '1.67em 0'
          ..tsb(_tsbFontSize, '0.83em')
          ..tsb(TextStyleOps.fontWeight, FontWeight.bold);
        break;
      case 'h6':
        meta
          ..[kCssDisplay] = kCssDisplayBlock
          ..[kCssMargin] = '2.33em 0'
          ..tsb(_tsbFontSize, '0.67em')
          ..tsb(TextStyleOps.fontWeight, FontWeight.bold);
        break;

      case kTagImg:
        _tagImg ??= TagImg(this).buildOp;
        meta.register(_tagImg);
        break;

      case 'ins':
      case 'u':
        meta.tsb(TextStyleOps.textDeco, TextDeco(under: true));
        break;

      case kTagOrderedList:
      case kTagUnorderedList:
        meta
          ..[kCssDisplay] = kCssDisplayBlock
          ..register(TagLi(this, meta).op);
        break;

      case 'mark':
        meta
          ..[kCssBackgroundColor] = '#ff0'
          ..[kCssColor] = '#000';
        break;

      case 'p':
        meta
          ..[kCssDisplay] = kCssDisplayBlock
          ..[kCssMargin] = '1em 0';
        break;

      case kTagQ:
        _tagQ ??= TagQ(this).buildOp;
        meta.register(_tagQ);
        break;

      case kTagRuby:
        meta.register(TagRuby(this, meta).op);
        break;

      case 'script':
      case 'style':
        meta[kCssDisplay] = kCssDisplayNone;
        break;

      case 'small':
        meta.tsb(_tsbFontSize, kCssFontSizeSmaller);
        break;

      case 'sub':
        meta
          ..[kCssVerticalAlign] = kCssVerticalAlignSub
          ..tsb(_tsbFontSize, kCssFontSizeSmaller);
        break;
      case 'sup':
        meta
          ..[kCssVerticalAlign] = kCssVerticalAlignSuper
          ..tsb(_tsbFontSize, kCssFontSizeSmaller);
        break;

      case kTagTable:
        meta
          ..[kCssDisplay] = kCssDisplayTable
          ..register(TagTable.borderOp(
            tryParseDoubleFromMap(attrs, kAttributeBorder) ?? 1.0,
            tryParseDoubleFromMap(attrs, kAttributeCellSpacing) ?? 2.0,
          ))
          ..register(TagTable.cellPaddingOp(
              tryParseDoubleFromMap(attrs, kAttributeCellPadding) ?? 1.0));
        break;
      case kTagTableHeaderCell:
        meta.tsb(TextStyleOps.fontWeight, FontWeight.bold);
        break;
      case kTagTableCaption:
        meta[kCssTextAlign] = kCssTextAlignCenter;
        break;
    }

    for (final attribute in attrs.entries) {
      switch (attribute.key) {
        case kAttributeAlign:
          meta[kCssTextAlign] = attribute.value;
          break;
        case kAttributeDir:
          meta[kCssDirection] = attribute.value;
          break;
      }
    }
  }

  /// Parses inline style [key] and [value] pair.
  void parseStyle(BuildMetadata meta, String key, String value) {
    switch (key) {
      case kCssBackground:
      case kCssBackgroundColor:
        _styleBgColor ??= StyleBgColor(this).buildOp;
        meta.register(_styleBgColor);
        break;

      case kCssColor:
        final color = tryParseColor(value);
        if (color != null) meta.tsb(TextStyleOps.color, color);
        break;

      case kCssDirection:
        meta.tsb(TextStyleOps.textDirection, value);
        break;

      case kCssFontFamily:
        final list = TextStyleOps.fontFamilyTryParse(value);
        if (list != null) meta.tsb(TextStyleOps.fontFamily, list);
        break;

      case kCssFontSize:
        meta.tsb(_tsbFontSize, value);
        break;

      case kCssFontStyle:
        final fontStyle = TextStyleOps.fontStyleTryParse(value);
        if (fontStyle != null) meta.tsb(TextStyleOps.fontStyle, fontStyle);
        break;

      case kCssFontWeight:
        final fontWeight = TextStyleOps.fontWeightTryParse(value);
        if (fontWeight != null) meta.tsb(TextStyleOps.fontWeight, fontWeight);
        break;

      case kCssHeight:
      case kCssMaxHeight:
      case kCssMaxWidth:
      case kCssMinHeight:
      case kCssMinWidth:
      case kCssWidth:
        _styleSizing ??= StyleSizing(this).buildOp;
        meta.register(_styleSizing);
        break;

      case kCssLineHeight:
        _tsbLineHeight ??= TextStyleOps.lineHeight(this);
        meta.tsb(_tsbLineHeight, value);
        break;

      case kCssMaxLines:
      case kCssMaxLinesWebkitLineClamp:
        final maxLines = value == kCssMaxLinesNone ? -1 : int.tryParse(value);
        if (maxLines != null) meta.tsb(TextStyleOps.maxLines, maxLines);
        break;

      case kCssTextAlign:
        meta.register(StyleTextAlign(this, value).op);
        break;

      case kCssTextDecoration:
        final textDeco = TextDeco.tryParse(value);
        if (textDeco != null) meta.tsb(TextStyleOps.textDeco, textDeco);
        break;

      case kCssTextOverflow:
        switch (value) {
          case kCssTextOverflowClip:
            meta.tsb(TextStyleOps.textOverflow, TextOverflow.clip);
            break;
          case kCssTextOverflowEllipsis:
            meta.tsb(TextStyleOps.textOverflow, TextOverflow.ellipsis);
            break;
        }
        break;

      case kCssVerticalAlign:
        _styleVerticalAlign ??= StyleVerticalAlign(this).buildOp;
        meta.register(_styleVerticalAlign);
        break;
    }

    if (key.startsWith(kCssBorder)) {
      _styleBorder ??= StyleBorder(this).buildOp;
      meta.register(_styleBorder);
    }

    if (key.startsWith(kCssMargin)) {
      _styleMargin ??= StyleMargin(this).buildOp;
      meta.register(_styleMargin);
    }

    if (key.startsWith(kCssPadding)) {
      _stylePadding ??= StylePadding(this).buildOp;
      meta.register(_stylePadding);
    }
  }

  /// Parses display inline style.
  void parseStyleDisplay(BuildMetadata meta, String value) {
    switch (value) {
      case kCssDisplayBlock:
        _styleBlock ??= DisplayBlockOp(this);
        meta.register(_styleBlock);
        break;
      case kCssDisplayNone:
        _styleDisplayNone ??= BuildOp(
          onTree: (_, tree) {
            for (final bit in tree.bits.toList(growable: false)) {
              bit.detach();
            }
          },
          priority: 0,
        );
        meta.register(_styleDisplayNone);
        break;
      case kCssDisplayTable:
        meta.register(TagTable(this, meta).op);
        break;
    }
  }

  /// Resets for a new build.
  @mustCallSuper
  void reset(State state) {
    final widget = state?.widget;
    if (widget is HtmlWidget) {
      _state = state;
    }
  }

  /// Resolves full URL with [HtmlWidget.baseUrl] if available.
  String urlFull(String url) {
    if (url?.isNotEmpty != true) return null;
    if (url.startsWith('data:')) return url;

    final uri = Uri.tryParse(url);
    if (uri == null) return null;
    if (uri.hasScheme) return url;

    final baseUrl = _widget?.baseUrl;
    if (baseUrl == null) return null;

    return baseUrl.resolveUri(uri).toString();
  }

  TextStyleHtml Function(TextStyleHtml, String) get _tsbFontSize {
    __tsbFontSize ??= TextStyleOps.fontSize(this);
    return __tsbFontSize;
  }
}
