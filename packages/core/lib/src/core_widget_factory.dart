import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui show ParagraphBuilder;
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import 'core_builder.dart';
import 'core_data.dart';
import 'core_helpers.dart';
import 'core_html_widget.dart';

part 'ops/style_bg_color.dart';
part 'ops/style_direction.dart';
part 'ops/style_margin.dart';
part 'ops/style_padding.dart';
part 'ops/style_sizing.dart';
part 'ops/style_text_align.dart';
part 'ops/style_vertical_align.dart';
part 'ops/tag_a.dart';
part 'ops/tag_code.dart';
part 'ops/tag_font.dart';
part 'ops/tag_img.dart';
part 'ops/tag_li.dart';
part 'ops/tag_q.dart';
part 'ops/tag_ruby.dart';
part 'ops/tag_table.dart';
part 'ops/text.dart';
part 'ops/text_style.dart';
part 'parser/border.dart';
part 'parser/color.dart';
part 'parser/css.dart';
part 'parser/length.dart';

final _dataUriRegExp = RegExp(r'^data:image/[^;]+;(base64|utf8),');

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
  BuildOp _tagLi;
  BuildOp _tagQ;
  BuildOp _tagTable;
  HtmlWidget _widget;

  HtmlWidget get widget => _widget;

  Widget buildBody(Iterable<Widget> children) => buildColumn(children);

  WidgetPlaceholder buildColumn(Iterable<Widget> children) =>
      children?.isNotEmpty == true
          ? (children.length == 1 && children.first is WidgetPlaceholder
              ? (children.first as WidgetPlaceholder).wrapWith(_buildColumn)
              : WidgetPlaceholder(
                  builder: _buildColumn,
                  children: children,
                ))
          : null;

  static Iterable<Widget> _buildColumn(BuildContext c, Iterable<Widget> ws, _) {
    if (ws == null) return null;

    final output = <Widget>[];
    final iter = ws.iterator;
    while (iter.moveNext()) {
      if (!(iter.current is _MarginVerticalPlaceholder)) break;
    }

    if (iter.current == null) return null;

    Widget prev;
    while (output.isEmpty || iter.moveNext()) {
      var widget = iter.current;

      if (widget is _MarginVerticalPlaceholder &&
          prev is _MarginVerticalPlaceholder) {
        prev.mergeWith(widget);
        continue;
      }

      if (widget is WidgetPlaceholder<TextBits>) {
        widget = (widget as WidgetPlaceholder).build(c);
      }

      if (widget is Column) {
        final Column column = widget;
        output.addAll(column.children);
        widget = column.children.last;
      } else {
        output.add(widget);
      }

      prev = widget;
    }

    while (output.isNotEmpty) {
      if (output.last is _MarginVerticalPlaceholder) {
        output.removeLast();
        continue;
      }

      break;
    }

    return output;
  }

  Widget buildDecoratedBox(
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

  Widget buildDivider() => const DecoratedBox(
        decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 1)),
        child: SizedBox(height: 1),
      );

  Iterable<Widget> buildGestureDetectors(
    BuildContext _,
    Iterable<Widget> widgets,
    GestureTapCallback onTap,
  ) =>
      widgets?.map((widget) => GestureDetector(child: widget, onTap: onTap));

  GestureTapCallback buildGestureTapCallbackForUrl(String url) => url != null
      ? () => widget.onTapUrl != null
          ? widget.onTapUrl(url)
          : print('[flutter_widget_from_html] Tapped url $url')
      : null;

  InlineSpan buildGestureTapCallbackSpan(
    String text,
    GestureTapCallback onTap,
    TextStyle style,
  ) =>
      TextSpan(
        text: text,
        recognizer: TapGestureRecognizer()..onTap = onTap,
        style: style,
      );

  Widget buildImage(Object provider, ImgMetadata img) =>
      provider != null && provider is ImageProvider && img != null
          ? Image(
              errorBuilder: buildImageErrorWidgetBuilder(img),
              image: provider,
              semanticLabel: img.alt ?? img.title,
            )
          : null;

  ImageErrorWidgetBuilder buildImageErrorWidgetBuilder(ImgMetadata img) =>
      (_, error, __) {
        print('${img.url} error: $error');
        final text = img.alt ?? img.title ?? '❌';
        return Text(text);
      };

  Object buildImageProvider(String url) {
    if (url?.startsWith('asset:') == true) {
      return buildImageFromAsset(url);
    }

    if (url?.startsWith('data:') == true) {
      return buildImageFromDataUri(url);
    }

    return buildImageFromUrl(url);
  }

  Uint8List buildImageBytes(String dataUri) {
    final match = _dataUriRegExp.matchAsPrefix(dataUri);
    if (match == null) return null;

    final prefix = match[0];
    final encoding = match[1];
    final data = dataUri.substring(prefix.length);

    final bytes = encoding == 'base64'
        ? base64.decode(data)
        : encoding == 'utf8' ? Uint8List.fromList(data.codeUnits) : null;
    if (bytes.isEmpty) return null;

    return bytes;
  }

  ImageProvider buildImageFromAsset(String url) {
    final uri = url?.isNotEmpty == true ? Uri.tryParse(url) : null;
    if (uri?.scheme != 'asset') return null;

    final assetName = uri.path;
    if (assetName?.isNotEmpty != true) return null;

    final package = uri.queryParameters?.containsKey('package') == true
        ? uri.queryParameters['package']
        : null;

    return AssetImage(assetName, package: package);
  }

  ImageProvider buildImageFromDataUri(String dataUri) {
    final bytes = buildImageBytes(dataUri);
    if (bytes == null) return null;

    return MemoryImage(bytes);
  }

  ImageProvider buildImageFromUrl(String url) =>
      url?.isNotEmpty == true ? NetworkImage(url) : null;

  Widget buildPadding(Widget child, EdgeInsets padding) =>
      child != null && padding != null && padding != const EdgeInsets.all(0)
          ? Padding(child: child, padding: padding)
          : child;

  Widget buildTable(TableData table) {
    final rows = <TableRow>[];
    final slotIndices = <int>[];
    final tableCols = table.cols;
    final tableRows = table.rows;

    for (var r = 0; r < tableRows; r++) {
      final cells = List<Widget>(tableCols);
      for (var c = 0; c < tableCols; c++) {
        final slot = table.getSlot(row: r, col: c);
        if (slot == null || slotIndices.contains(slot.index)) {
          cells[c] = widget0;
          continue;
        }

        slotIndices.add(slot.index);
        cells[c] = TableCell(
          child: buildColumn(slot.cell.children),
        );
      }

      rows.add(TableRow(children: cells));
    }

    final tableBorder = table.border != null
        // TODO: support different styling for border sides
        ? TableBorder.symmetric(inside: table.border, outside: table.border)
        : null;
    return Table(border: tableBorder, children: rows);
  }

  WidgetPlaceholder<TextBits> buildText(TextBits text) =>
      (text..trimRight()).isNotEmpty
          ? WidgetPlaceholder(
              builder: _buildText,
              input: text,
            )
          : null;

  static Iterable<Widget> _buildText(
    BuildContext context,
    Iterable<Widget> _,
    TextBits text,
  ) {
    final tsh = text.tsb?.build(context);
    final maxLines = tsh?.maxLines == -1 ? null : tsh?.maxLines;
    final overflow = tsh?.textOverflow ?? TextOverflow.clip;
    final textAlign = tsh?.align ?? TextAlign.start;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final widgets = <Widget>[];
    for (final compiled in _TextCompiler(text).compile(context)) {
      if (compiled is InlineSpan) {
        widgets.add(overflow == TextOverflow.ellipsis && maxLines == null
            ? LayoutBuilder(
                builder: (_, bc) => RichText(
                      text: compiled,
                      textAlign: textAlign,
                      textScaleFactor: textScaleFactor,
                      maxLines:
                          bc.biggest.height.isFinite && bc.biggest.height > 0
                              ? (bc.biggest.height / compiled.style.fontSize)
                                  .floor()
                              : null,
                      overflow: overflow,
                    ))
            : RichText(
                text: compiled,
                textAlign: textAlign,
                textScaleFactor: textScaleFactor,
                maxLines: maxLines,
                overflow: overflow,
              ));
      } else if (compiled is Widget) {
        widgets.add(compiled);
      }
    }

    return widgets;
  }

  String constructFullUrl(String url) {
    if (url?.isNotEmpty != true) return null;
    if (url.startsWith('data:')) return url;

    final p = Uri.tryParse(url);
    if (p == null) return null;
    if (p.hasScheme) return p.toString();

    final b = widget.baseUrl;
    if (b == null) return null;

    return b.resolveUri(p).toString();
  }

  void customStyleBuilder(NodeMetadata meta, dom.Element element) {
    if (widget.customStylesBuilder == null) return;

    final map = widget.customStylesBuilder(element);
    if (map == null) return;

    final list = List<String>(map.length * 2);
    var i = 0;
    for (final pair in map.entries) {
      list[i++] = pair.key;
      list[i++] = pair.value;
    }

    meta.styles = list;
  }

  void customWidgetBuilder(NodeMetadata meta, dom.Element element) {
    if (widget.customWidgetBuilder == null) return;

    final built = widget.customWidgetBuilder(element);
    if (built == null) return;

    meta.op = BuildOp(onWidgets: (_, __) => [built]);
  }

  String getListStyleMarker(String type, int i) {
    switch (type) {
      case _kCssListStyleTypeAlphaLower:
      case _kCssListStyleTypeAlphaLatinLower:
        if (i >= 1 && i <= 26) {
          // the specs said it's unspecified after the 26th item
          // TODO: generate something like aa, ab, etc. when needed
          return '${String.fromCharCode(96 + i)}.';
        }
        return '';
      case _kCssListStyleTypeAlphaUpper:
      case _kCssListStyleTypeAlphaLatinUpper:
        if (i >= 1 && i <= 26) {
          // the specs said it's unspecified after the 26th item
          // TODO: generate something like AA, AB, etc. when needed
          return '${String.fromCharCode(64 + i)}.';
        }
        return '';
      case _kCssListStyleTypeCircle:
        return '-';
      case _kCssListStyleTypeDecimal:
        return '$i.';
      case _kCssListStyleTypeDisc:
        return '•';
      case _kCssListStyleTypeRomanLower:
        final roman = getListStyleMarkerRoman(i)?.toLowerCase();
        return roman != null ? '$roman.' : '';
      case _kCssListStyleTypeRomanUpper:
        final roman = getListStyleMarkerRoman(i);
        return roman != null ? '$roman.' : '';
      case _kCssListStyleTypeSquare:
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

  Color parseColor(String value) => _parseColor(value);

  CssBorderSide parseCssBorderSide(String value) =>
      _parseCssBorderSide(this, value);

  TextDecorationStyle parseCssBorderStyle(String value) =>
      _parseCssBorderStyle(value);

  CssLength parseCssLength(String value) => _parseCssLength(value);

  CssLengthBox parseCssLengthBox(NodeMetadata meta, String key) =>
      _parseCssLengthBox(meta, key);

  CssLengthBox parseCssMargin(NodeMetadata meta) =>
      parseCssLengthBox(meta, _kCssMargin);

  CssLengthBox parseCssPadding(NodeMetadata meta) =>
      parseCssLengthBox(meta, _kCssPadding);

  void parseStyle(NodeMetadata meta, String key, String value) {
    switch (key) {
      case _kCssBackgroundColor:
        meta.op = styleBgColor();
        break;

      case _kCssBorderBottom:
        final borderBottom = parseCssBorderSide(value);
        if (borderBottom != null) {
          meta.tsb(
              _TextStyle.textDeco,
              _TextDeco(
                color: borderBottom.color,
                under: true,
                style: borderBottom.style,
                thickness: borderBottom.width,
              ));
        } else {
          meta.tsb(_TextStyle.textDeco, _TextDeco(under: false));
        }
        break;
      case _kCssBorderTop:
        final borderTop = parseCssBorderSide(value);
        if (borderTop != null) {
          meta.tsb(
              _TextStyle.textDeco,
              _TextDeco(
                color: borderTop.color,
                over: true,
                style: borderTop.style,
                thickness: borderTop.width,
              ));
        } else {
          meta.tsb(_TextStyle.textDeco, _TextDeco(over: false));
        }
        break;

      case _kCssColor:
        final color = parseColor(value);
        if (color != null) meta.tsb(_TextStyle.color, color);
        break;

      case _kCssDirection:
        meta.op = styleDirection(value);
        break;

      case _kCssDisplay:
        switch (value) {
          case _kCssDisplayBlock:
            meta.isBlockElement = true;
            break;
          case _kCssDisplayInline:
          case _kCssDisplayInlineBlock:
            meta.isBlockElement = false;
            break;
          case _kCssDisplayNone:
            meta.isNotRenderable = true;
            break;
          case _kCssDisplayTable:
          case _kCssDisplayTableRow:
          case _kCssDisplayTableHeaderGroup:
          case _kCssDisplayTableRowGroup:
          case _kCssDisplayTableFooterGroup:
          case _kCssDisplayTableCell:
          case _kCssDisplayTableCaption:
            meta.op = tagTable();
            break;
        }
        break;

      case _kCssFontFamily:
        final list = _TextStyle._fontFamilyTryParse(value);
        if (list != null) meta.tsb(_TextStyle.fontFamily, list);
        break;

      case _kCssFontSize:
        meta.tsb(_TextStyle.fontSize, value);
        break;

      case _kCssFontStyle:
        final fontStyle = _TextStyle._fontStyleTryParse(value);
        if (fontStyle != null) meta.tsb(_TextStyle.fontStyle, fontStyle);
        break;

      case _kCssFontWeight:
        final fontWeight = _TextStyle._fontWeightTryParse(value);
        if (fontWeight != null) meta.tsb(_TextStyle.fontWeight, fontWeight);
        break;

      case _kCssHeight:
      case _kCssMaxHeight:
      case _kCssMaxWidth:
      case _kCssMinHeight:
      case _kCssMinWidth:
      case _kCssWidth:
        meta.op = styleSizing();
        break;

      case _kCssLineHeight:
        meta.tsb(_TextStyle.lineHeight, value);
        break;

      case _kCssMaxLines:
      case _kCssMaxLinesWebkitLineClamp:
        final maxLines = value == _kCssMaxLinesNone ? -1 : int.tryParse(value);
        if (maxLines != null) meta.tsb(_styleMaxLines, maxLines);
        break;

      case _kCssTextAlign:
        final textAlign = _StyleTextAlign.tryParse(value);
        if (textAlign != null) {
          meta
            ..isBlockElement = true
            ..tsb(_StyleTextAlign._tsb, textAlign);
        }
        break;

      case _kCssTextDecoration:
        final textDeco = _TextDeco.tryParse(value);
        if (textDeco != null) meta.tsb(_TextStyle.textDeco, textDeco);
        break;

      case _kCssTextOverflow:
        switch (value) {
          case _kCssTextOverflowClip:
            meta.tsb(_styleTextOverflow, TextOverflow.clip);
            break;
          case _kCssTextOverflowEllipsis:
            meta.tsb(_styleTextOverflow, TextOverflow.ellipsis);
            break;
        }
        break;

      case _kCssVerticalAlign:
        meta.op = styleVerticalAlign();
        break;
    }

    if (key.startsWith(_kCssMargin)) {
      meta.op = styleMargin();
    }

    if (key.startsWith(_kCssPadding)) {
      meta.op = stylePadding();
    }
  }

  void parseTag(NodeMetadata meta, String tag, Map<dynamic, String> attrs) {
    switch (tag) {
      case 'a':
        meta.op = tagA();
        break;

      case 'abbr':
      case 'acronym':
        meta.tsb(
          _TextStyle.textDeco,
          _TextDeco(style: TextDecorationStyle.dotted, under: true),
        );
        break;

      case 'address':
        meta
          ..isBlockElement = true
          ..tsb(_TextStyle.fontStyle, FontStyle.italic);
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
          ..styles = [_kCssMargin, '1em 40px'];
        break;

      case 'b':
      case 'strong':
        meta.tsb(_TextStyle.fontWeight, FontWeight.bold);
        break;

      case 'big':
        meta.tsb(_TextStyle.fontSize, _kCssFontSizeLarger);
        break;

      case 'br':
        meta.op = tagBr();
        break;

      case 'center':
        meta.styles = [_kCssTextAlign, _kCssTextAlignCenter];
        break;

      case 'cite':
      case 'dfn':
      case 'em':
      case 'i':
      case 'var':
        meta.tsb(_TextStyle.fontStyle, FontStyle.italic);
        break;

      case _kTagCode:
      case _kTagPre:
      case _kTagTt:
        meta.op = tagCode();
        break;

      case 'dd':
        meta
          ..isBlockElement = true
          ..styles = [_kCssMargin, '0 0 1em 40px'];
        break;
      case 'dl':
        meta.isBlockElement = true;
        break;
      case 'dt':
        meta
          ..isBlockElement = true
          ..tsb(_TextStyle.fontWeight, FontWeight.bold);
        break;

      case 'del':
      case 's':
      case 'strike':
        meta.tsb(_TextStyle.textDeco, _TextDeco(strike: true));
        break;

      case 'font':
        meta.op = tagFont();
        break;

      case 'hr':
        meta.op = tagHr();
        break;

      case 'h1':
        meta
          ..isBlockElement = true
          ..styles = [_kCssMargin, '0.67em 0']
          ..tsb(_TextStyle.fontSize, '2em')
          ..tsb(_TextStyle.fontWeight, FontWeight.bold);
        break;
      case 'h2':
        meta
          ..isBlockElement = true
          ..styles = [_kCssMargin, '0.83em 0']
          ..tsb(_TextStyle.fontSize, '1.5em')
          ..tsb(_TextStyle.fontWeight, FontWeight.bold);
        break;
      case 'h3':
        meta
          ..isBlockElement = true
          ..styles = [_kCssMargin, '1em 0']
          ..tsb(_TextStyle.fontSize, '1.17em')
          ..tsb(_TextStyle.fontWeight, FontWeight.bold);
        break;
      case 'h4':
        meta
          ..isBlockElement = true
          ..styles = [_kCssMargin, '1.33em 0']
          ..tsb(_TextStyle.fontWeight, FontWeight.bold);
        break;
      case 'h5':
        meta
          ..isBlockElement = true
          ..styles = [_kCssMargin, '1.67em 0']
          ..tsb(_TextStyle.fontSize, '0.83em')
          ..tsb(_TextStyle.fontWeight, FontWeight.bold);
        break;
      case 'h6':
        meta
          ..isBlockElement = true
          ..styles = [_kCssMargin, '2.33em 0']
          ..tsb(_TextStyle.fontSize, '0.67em')
          ..tsb(_TextStyle.fontWeight, FontWeight.bold);
        break;

      case 'iframe':
      case 'script':
      case 'style':
      case 'svg':
        // actually `script` and `style` are not required here
        // our parser will put those elements into document.head anyway
        meta.isNotRenderable = true;
        break;

      case 'img':
        meta.op = tagImg();
        if (attrs.containsKey('height')) {
          meta.styles = ['height', "${attrs['height']}px"];
        }
        if (attrs.containsKey('width')) {
          meta.styles = ['width', "${attrs['width']}px"];
        }
        break;

      case 'ins':
      case 'u':
        meta.tsb(_TextStyle.textDeco, _TextDeco(under: true));
        break;

      case 'kbd':
      case 'samp':
        meta.tsb(_TextStyle.fontFamily, [_kTagCodeFont1, _kTagCodeFont2]);
        break;

      case _kTagOrderedList:
      case _kTagUnorderedList:
        meta.op = tagLi();
        break;

      case 'mark':
        meta
          ..styles = [_kCssBackgroundColor, '#ff0']
          ..tsb(_TextStyle.color, Color.fromARGB(255, 0, 0, 0));
        break;

      case 'p':
        meta
          ..isBlockElement = true
          ..styles = [_kCssMargin, '1em 0'];
        break;

      case 'q':
        meta.op = tagQ();
        break;

      case _kTagRuby:
        meta.op = tagRuby();
        break;

      case 'small':
        meta.tsb(_TextStyle.fontSize, _kCssFontSizeSmaller);
        break;

      case 'sub':
        meta
          ..styles = [_kCssVerticalAlign, _kCssVerticalAlignSub]
          ..tsb(_TextStyle.fontSize, _kCssFontSizeSmaller);
        break;
      case 'sup':
        meta
          ..styles = [_kCssVerticalAlign, _kCssVerticalAlignSuper]
          ..tsb(_TextStyle.fontSize, _kCssFontSizeSmaller);
        break;

      case 'table':
        meta
          ..styles = [_kCssDisplay, _kCssDisplayTable]
          ..op = _TagTable.cellPaddingOp(
              (attrs.containsKey(_kAttributeCellPadding)
                      ? double.tryParse(attrs[_kAttributeCellPadding])
                      : null) ??
                  1);
        break;
      case 'tr':
        meta.styles = [_kCssDisplay, _kCssDisplayTableRow];
        break;
      case 'thead':
        meta.styles = [_kCssDisplay, _kCssDisplayTableHeaderGroup];
        break;
      case 'tbody':
        meta.styles = [_kCssDisplay, _kCssDisplayTableRowGroup];
        break;
      case 'tfoot':
        meta.styles = [_kCssDisplay, _kCssDisplayTableFooterGroup];
        break;
      case 'td':
        meta.styles = [_kCssDisplay, _kCssDisplayTableCell];
        break;
      case 'th':
        meta
          ..styles = [_kCssDisplay, _kCssDisplayTableCell]
          ..tsb(_TextStyle.fontWeight, FontWeight.bold);
        break;
      case 'caption':
        meta.styles = [
          _kCssDisplay,
          _kCssDisplayTableCaption,
          _kCssTextAlign,
          _kCssTextAlignCenter,
        ];
        break;
    }

    for (final attribute in attrs.entries) {
      switch (attribute.key) {
        case _kAttributeAlign:
          meta.styles = [_kCssTextAlign, attribute.value];
          break;
        case _kAttributeDir:
          meta.styles = [_kCssDirection, attribute.value];
          break;
      }
    }
  }

  @mustCallSuper
  void reset(HtmlWidget widget) => _widget = widget;

  BuildOp styleBgColor() {
    _styleBgColor ??= _StyleBgColor(this).buildOp;
    return _styleBgColor;
  }

  BuildOp styleDirection(String dir) => _styleDirection(this, dir);

  BuildOp styleDisplayBlock() {
    _styleDisplayBlock ??= BuildOp(
      onWidgets: (_, widgets) {
        for (final widget in widgets) {
          widget.wrapWith(_cssBlock);
        }
        return widgets;
      },
      priority: 9223372036854775807,
    );
    return _styleDisplayBlock;
  }

  static Iterable<Widget> _cssBlock(BuildContext _, Iterable<Widget> ws, __) =>
      ws?.map((w) => w is CssBlock ? w : CssBlock(child: w));

  BuildOp styleMargin() {
    _styleMargin ??= _StyleMargin(this).buildOp;
    return _styleMargin;
  }

  BuildOp stylePadding() {
    _stylePadding ??= _StylePadding(this).buildOp;
    return _stylePadding;
  }

  BuildOp styleSizing() {
    _styleSizing ??= _StyleSizing(this).buildOp;
    return _styleSizing;
  }

  BuildOp styleVerticalAlign() {
    _styleVerticalAlign ??= _StyleVerticalAlign(this).buildOp;
    return _styleVerticalAlign;
  }

  BuildOp tagA() {
    _tagA ??= _TagA(this).buildOp;
    return _tagA;
  }

  BuildOp tagBr() {
    _tagBr ??= BuildOp(
      onPieces: (_, pieces) =>
          pieces..last.text.addWhitespace(TextWhitespaceType.newLine),
    );
    return _tagBr;
  }

  BuildOp tagCode() {
    _tagCode ??= _TagCode(this).buildOp;
    return _tagCode;
  }

  BuildOp tagFont() {
    _tagFont ??= _TagFont(this).buildOp;
    return _tagFont;
  }

  BuildOp tagHr() {
    _tagHr ??= BuildOp(
      defaultStyles: (_, __) => const {'margin-bottom': '1em'},
      onWidgets: (_, __) => [buildDivider()],
    );
    return _tagHr;
  }

  BuildOp tagImg() {
    _tagImg ??= _TagImg(this).buildOp;
    return _tagImg;
  }

  BuildOp tagLi() {
    _tagLi ??= _TagLi(this).buildOp;
    return _tagLi;
  }

  BuildOp tagQ() {
    _tagQ ??= _TagQ(this).buildOp;
    return _tagQ;
  }

  BuildOp tagRuby() => _TagRuby(this).buildOp;

  BuildOp tagTable() {
    _tagTable ??= _TagTable(this).buildOp;
    return _tagTable;
  }
}

Iterable<Widget> _listOrNull(Widget x) => x == null ? null : [x];

TextStyleHtml _styleMaxLines(BuildContext _, TextStyleHtml p, int v) =>
    p.copyWith(maxLines: v);

TextStyleHtml _styleTextOverflow(
        BuildContext _, TextStyleHtml p, TextOverflow v) =>
    p.copyWith(textOverflow: v);
