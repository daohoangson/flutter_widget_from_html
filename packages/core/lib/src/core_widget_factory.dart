import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'internal/core_ops.dart';
import 'internal/core_parser.dart';
import 'core_data.dart';
import 'core_helpers.dart';
import 'core_html_widget.dart';
import 'internal/css_block.dart';

/// A factory to build widget for HTML elements.
class WidgetFactory {
  BuildOp _styleBgColor;
  BuildOp _styleDisplayBlock;
  BuildOp _styleMargin;
  BuildOp _stylePadding;
  BuildOp _styleSizing;
  BuildOp _styleVerticalAlign;
  BuildOp _tagA;
  BuildOp _tagBr;
  BuildOp _tagCode;
  BuildOp _tagFont;
  BuildOp _tagHr;
  BuildOp _tagImg;
  BuildOp _tagQ;
  TextStyleHtml Function(TextStyleHtml, String) __tsbFontSize;
  TextStyleHtml Function(TextStyleHtml, String) _tsbLineHeight;
  State<HtmlWidget> _state;

  HtmlWidget get _widget => _state.widget;

  WidgetPlaceholder buildBody(NodeMetadata meta, Iterable<Widget> children) =>
      buildColumnPlaceholder(meta, children, trimMarginVertical: true);

  WidgetPlaceholder buildColumnPlaceholder(
    NodeMetadata meta,
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

  Widget buildColumnWidget(NodeMetadata meta, List<Widget> children) {
    if (children?.isNotEmpty != true) return null;
    if (children.length == 1) return children.first;

    return Column(
      children: children,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      textDirection: meta.tsb().build().textDirection,
    );
  }

  Widget buildDecoratedBox(
    NodeMetadata meta,
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

  Widget buildDivider(NodeMetadata meta) => const DecoratedBox(
        decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 1)),
        child: SizedBox(height: 1),
      );

  Widget buildGestureDetector(
          NodeMetadata meta, Widget child, GestureTapCallback onTap) =>
      GestureDetector(child: child, onTap: onTap);

  TextSpan buildGestureTapCallbackSpan(
    String text,
    GestureTapCallback onTap,
    TextStyle style,
  ) =>
      TextSpan(
        text: text,
        recognizer: TapGestureRecognizer()..onTap = onTap,
        style: style,
      );

  Widget buildHorizontalScrollView(NodeMetadata meta, Widget child) =>
      SingleChildScrollView(child: child, scrollDirection: Axis.horizontal);

  Widget buildImage(NodeMetadata node, Object provider, ImageMetadata image) =>
      provider != null && provider is ImageProvider && image != null
          ? Image(
              errorBuilder: buildImageErrorWidgetBuilder(node, provider, image),
              image: provider,
              semanticLabel: image.alt ?? image.title,
            )
          : null;

  ImageErrorWidgetBuilder buildImageErrorWidgetBuilder(
          NodeMetadata meta, Object provider, ImageMetadata image) =>
      (_, error, __) {
        print('$provider error: $error');
        final text = image.alt ?? image.title ?? '❌';
        return Text(text);
      };

  Widget buildPadding(NodeMetadata meta, Widget child, EdgeInsets padding) =>
      child != null && padding != null && padding != const EdgeInsets.all(0)
          ? Padding(child: child, padding: padding)
          : child;

  Widget buildStack(NodeMetadata meta, List<Widget> children) => Stack(
        children: children,
        overflow: Overflow.visible,
        textDirection: meta.tsb().build().textDirection,
      );

  Widget buildTable(NodeMetadata node, TableMetadata table) {
    final rows = <TableRow>[];
    final slotIndices = <int>[];
    final tableCols = table.cols;
    final tableRows = table.rows;

    for (var r = 0; r < tableRows; r++) {
      final cells = List<Widget>(tableCols);
      for (var c = 0; c < tableCols; c++) {
        final index = table.getIndexAt(row: r, column: c);
        if (index == -1 || slotIndices.contains(index)) {
          cells[c] = widget0;
          continue;
        }
        slotIndices.add(index);

        cells[c] = TableCell(child: table.getWidgetAt(index));
      }

      if (cells.isEmpty) continue;
      rows.add(TableRow(children: cells));
    }

    if (rows.isEmpty) return null;

    final tableBorder = table.border != null
        // TODO: support different styling for border sides
        ? TableBorder.symmetric(inside: table.border, outside: table.border)
        : null;
    return Table(border: tableBorder, children: rows);
  }

  WidgetPlaceholder buildText(NodeMetadata meta, TextBits text) {
    text.trimRight();
    if (text.isEmpty) return null;

    final tsh = text.tsb?.build();
    final maxLines = tsh?.maxLines == -1 ? null : tsh?.maxLines;
    final overflow = tsh?.textOverflow ?? TextOverflow.clip;
    final textAlign = tsh?.textAlign ?? TextAlign.start;
    final textDirection = tsh?.textDirection ?? TextDirection.ltr;

    final widgets = <WidgetPlaceholder>[];
    for (final compiled in TextCompiler(text).compile()) {
      if (compiled.widget != null) {
        widgets.add(compiled.widget);
        continue;
      }

      if (compiled.span == null) continue;
      widgets.add(
        WidgetPlaceholder<TextBits>(
          child: RichText(
            overflow: overflow,
            text: compiled.span,
            textAlign: textAlign,
            textDirection: textDirection,

            // TODO: calculate max lines automatically for ellipsis if needed
            // currently it only renders 1 line with ellipsis
            maxLines: maxLines,
          ),
          generator: text,
        ),
      );
    }

    return buildColumnPlaceholder(meta, widgets);
  }

  GestureTapCallback gestureTapCallback(String url) => url != null
      ? () => _widget.onTapUrl != null
          ? _widget.onTapUrl(url)
          : print('[flutter_widget_from_html] Tapped url $url')
      : null;

  List<HtmlWidgetDependency> getDependencies(BuildContext context) => [
        HtmlWidgetDependency<MediaQueryData>(MediaQuery.of(context)),
        HtmlWidgetDependency<TextDirection>(Directionality.of(context)),
        HtmlWidgetDependency<TextStyle>(DefaultTextStyle.of(context).style),
      ];

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
      case kCssListStyleTypeCircle:
        return '-';
      case kCssListStyleTypeDecimal:
        return '$i.';
      case kCssListStyleTypeDisc:
        return '•';
      case kCssListStyleTypeRomanLower:
        final roman = getListStyleMarkerRoman(i)?.toLowerCase();
        return roman != null ? '$roman.' : '';
      case kCssListStyleTypeRomanUpper:
        final roman = getListStyleMarkerRoman(i);
        return roman != null ? '$roman.' : '';
      case kCssListStyleTypeSquare:
        return '+';
    }

    return '';
  }

  String getListStyleMarkerRoman(int i) {
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

    return map.containsKey(i) ? map[i] : null;
  }

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

  void parseStyle(NodeMetadata meta, String key, String value) {
    switch (key) {
      case kCssBackground:
      case kCssBackgroundColor:
        _styleBgColor ??= StyleBgColor(this).buildOp;
        meta.register(_styleBgColor);
        break;

      case kCssBorderBottom:
        final borderBottom = tryParseCssBorderSide(value);
        if (borderBottom != null) {
          meta.register(TextStyleOps.textDecoOp(TextDeco(
            color: borderBottom.color,
            under: true,
            style: borderBottom.style,
            thickness: borderBottom.width,
          )));
        } else {
          meta.register(TextStyleOps.textDecoOp(TextDeco(under: false)));
        }
        break;
      case kCssBorderTop:
        final borderTop = tryParseCssBorderSide(value);
        if (borderTop != null) {
          meta.register(TextStyleOps.textDecoOp(TextDeco(
            color: borderTop.color,
            over: true,
            style: borderTop.style,
            thickness: borderTop.width,
          )));
        } else {
          meta.register(TextStyleOps.textDecoOp(TextDeco(over: false)));
        }
        break;

      case kCssColor:
        final color = tryParseColor(value);
        if (color != null) meta.tsb(TextStyleOps.color, color);
        break;

      case kCssDirection:
        meta.tsb(TextStyleOps.textDirection, value);
        break;

      case kCssDisplay:
        switch (value) {
          case kCssDisplayBlock:
            meta.isBlockElement = true;
            break;
          case kCssDisplayInline:
          case kCssDisplayInlineBlock:
            meta.isBlockElement = false;
            break;
          case kCssDisplayNone:
            meta.isNotRenderable = true;
            break;
          case kCssDisplayTable:
            meta.register(TagTable(this, meta).op);
            break;
        }
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
        final textAlign = tryParseTextAlign(value);
        if (textAlign != null) {
          meta
            ..isBlockElement = true
            ..tsb(TextStyleOps.textAlign, textAlign);
        }
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

    if (key.startsWith(kCssMargin)) {
      _styleMargin ??= StyleMargin(this).buildOp;
      meta.register(_styleMargin);
    }

    if (key.startsWith(kCssPadding)) {
      _stylePadding ??= StylePadding(this).buildOp;
      meta.register(_stylePadding);
    }
  }

  void parseTag(NodeMetadata meta, String tag, Map<dynamic, String> attrs) {
    switch (tag) {
      case kTagA:
        _tagA ??= TagA(this, () => _widget.hyperlinkColor).buildOp;
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
          ..isBlockElement = true
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
        meta.isBlockElement = true;
        break;

      case 'blockquote':
      case 'figure':
        meta
          ..isBlockElement = true
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
        _tagBr ??= BuildOp(onPieces: (_, p) => p..last.text.addNewLine());
        meta.register(_tagBr);
        break;

      case 'center':
        meta[kCssTextAlign] = kCssTextAlignCenter;
        break;

      case 'cite':
      case 'dfn':
      case 'em':
      case 'i':
      case 'var':
        meta.tsb(TextStyleOps.fontStyle, FontStyle.italic);
        break;

      case kTagCode:
      case kTagPre:
      case kTagTt:
        _tagCode ??= TagCode(this).buildOp;
        meta.register(_tagCode);
        break;

      case 'dd':
        meta
          ..isBlockElement = true
          ..[kCssMargin] = '0 0 1em 40px';
        break;
      case 'dl':
        meta.isBlockElement = true;
        break;
      case 'dt':
        meta
          ..isBlockElement = true
          ..tsb(TextStyleOps.fontWeight, FontWeight.bold);
        break;

      case 'del':
      case 's':
      case 'strike':
        meta.tsb(TextStyleOps.textDeco, TextDeco(strike: true));
        break;

      case kTagFont:
        _tagFont ??= TagFont(this).buildOp;
        meta.register(_tagFont);
        break;

      case 'hr':
        _tagHr ??= BuildOp(
          defaultStyles: (_) => const {'margin-bottom': '1em'},
          onWidgets: (meta, _) => [buildDivider(meta)],
        );
        meta.register(_tagHr);
        break;

      case 'h1':
        meta
          ..isBlockElement = true
          ..[kCssMargin] = '0.67em 0'
          ..tsb(_tsbFontSize, '2em')
          ..tsb(TextStyleOps.fontWeight, FontWeight.bold);
        break;
      case 'h2':
        meta
          ..isBlockElement = true
          ..[kCssMargin] = '0.83em 0'
          ..tsb(_tsbFontSize, '1.5em')
          ..tsb(TextStyleOps.fontWeight, FontWeight.bold);
        break;
      case 'h3':
        meta
          ..isBlockElement = true
          ..[kCssMargin] = '1em 0'
          ..tsb(_tsbFontSize, '1.17em')
          ..tsb(TextStyleOps.fontWeight, FontWeight.bold);
        break;
      case 'h4':
        meta
          ..isBlockElement = true
          ..[kCssMargin] = '1.33em 0'
          ..tsb(TextStyleOps.fontWeight, FontWeight.bold);
        break;
      case 'h5':
        meta
          ..isBlockElement = true
          ..[kCssMargin] = '1.67em 0'
          ..tsb(_tsbFontSize, '0.83em')
          ..tsb(TextStyleOps.fontWeight, FontWeight.bold);
        break;
      case 'h6':
        meta
          ..isBlockElement = true
          ..[kCssMargin] = '2.33em 0'
          ..tsb(_tsbFontSize, '0.67em')
          ..tsb(TextStyleOps.fontWeight, FontWeight.bold);
        break;

      case 'iframe':
      case 'script':
      case 'style':
      case 'svg':
        // actually `script` and `style` are not required here
        // our parser will put those elements into document.head anyway
        meta.isNotRenderable = true;
        break;

      case kTagImg:
        _tagImg ??= TagImg(this).buildOp;
        meta.register(_tagImg);

        if (attrs.containsKey(kAttributeImgHeight)) {
          meta[kCssHeight] = '${attrs[kAttributeImgHeight]}px';
        }
        if (attrs.containsKey(kAttributeImgWidth)) {
          meta[kCssWidth] = '${attrs[kAttributeImgWidth]}px';
        }
        break;

      case 'ins':
      case 'u':
        meta.tsb(TextStyleOps.textDeco, TextDeco(under: true));
        break;

      case 'kbd':
      case 'samp':
        meta.tsb(TextStyleOps.fontFamily, [kTagCodeFont1, kTagCodeFont2]);
        break;

      case kTagOrderedList:
      case kTagUnorderedList:
        meta.register(TagLi(this, meta).op);
        break;

      case 'mark':
        meta
          ..[kCssBackgroundColor] = '#ff0'
          ..tsb(TextStyleOps.color, Color.fromARGB(255, 0, 0, 0));
        break;

      case 'p':
        meta
          ..isBlockElement = true
          ..[kCssMargin] = '1em 0';
        break;

      case kTagQ:
        _tagQ ??= TagQ(this).buildOp;
        meta.register(_tagQ);
        break;

      case kTagRuby:
        meta.register(TagRuby(this, meta).op);
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
          ..register(TagTable.cellPaddingOp(
              tryParseDoubleFromMap(attrs, kAttributeCellPadding) ?? 1));
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

  @mustCallSuper
  void reset(State<HtmlWidget> state) => _state = state;

  BuildOp styleDisplayBlock() {
    _styleDisplayBlock ??= BuildOp(
      onWidgets: (meta, widgets) => listOrNull(
          buildColumnPlaceholder(meta, widgets)?.wrapWith(_cssBlock)),
      priority: 10000,
    );
    return _styleDisplayBlock;
  }

  String urlFull(String url) {
    if (url?.isNotEmpty != true) return null;
    if (url.startsWith('data:')) return url;

    final p = Uri.tryParse(url);
    if (p == null) return null;
    if (p.hasScheme) return p.toString();

    final b = _widget.baseUrl;
    if (b == null) return null;

    return b.resolveUri(p).toString();
  }

  TextStyleHtml Function(TextStyleHtml, String) get _tsbFontSize {
    __tsbFontSize ??= TextStyleOps.fontSize(this);
    return __tsbFontSize;
  }
}

Widget _cssBlock(Widget child) =>
    child == widget0 || child is CssBlock ? child : CssBlock(child: child);
