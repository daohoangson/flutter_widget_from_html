import 'dart:convert';
import 'dart:ui' as ui show ParagraphBuilder;
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import 'core_helpers.dart';
import 'core_html_widget.dart';
import 'data_classes.dart';

part 'ops/style_bg_color.dart';
part 'ops/style_margin.dart';
part 'ops/style_text_align.dart';
part 'ops/tag_a.dart';
part 'ops/tag_code.dart';
part 'ops/tag_font.dart';
part 'ops/tag_img.dart';
part 'ops/tag_li.dart';
part 'ops/tag_q.dart';
part 'ops/tag_table.dart';
part 'ops/text.dart';

final _dataUriRegExp = RegExp(r'^data:image/\w+;base64,');

class WidgetFactory {
  final HtmlWidgetConfig _config;

  BuildOp _styleBgColor;
  BuildOp _styleMargin;
  BuildOp _styleTextAlign;
  BuildOp _tagA;
  BuildOp _tagBr;
  BuildOp _tagCode;
  BuildOp _tagFont;
  BuildOp _tagHr;
  BuildOp _tagImg;
  BuildOp _tagLi;
  BuildOp _tagQ;
  BuildOp _tagTable;

  WidgetFactory(this._config);

  Color get hyperlinkColor => _config.hyperlinkColor;

  Iterable<Widget> buildAligns(
          BuilderContext bc, Iterable<Widget> widgets, Alignment alignment) =>
      widgets.map((widget) {
        if (bc.origin is WidgetPlaceholder<TextBlock>) return widget;
        if (widget is WidgetPlaceholder<TextBlock>) return widget;
        return Align(alignment: alignment, child: widget);
      });

  Widget buildBody(Iterable<Widget> children) =>
      buildPadding(buildColumn(children), _config.bodyPadding);

  Widget buildColumn(Iterable<Widget> children) => children?.isNotEmpty == true
      ? WidgetPlaceholder(
          builder: _buildColumn,
          children: children,
        )
      : null;

  static Iterable<Widget> _buildColumn(
      BuilderContext bc, Iterable<Widget> ws, _) {
    final output = <Widget>[];
    final iter = ws.iterator;
    while (iter.moveNext()) {
      if (!(iter.current is SpacingPlaceholder)) break;
    }

    if (iter.current == null) return null;

    Widget prev;
    while (output.isEmpty || iter.moveNext()) {
      var widget = iter.current;

      if (widget is SpacingPlaceholder && prev is SpacingPlaceholder) {
        prev.mergeWith(widget);
        continue;
      }

      if (widget is WidgetPlaceholder<TextBlock>) {
        final WidgetPlaceholder<TextBlock> textPlaceholder = widget;
        widget = textPlaceholder.build(bc.context);
      }

      if (widget is SimpleColumn) {
        final SimpleColumn column = widget;
        output.addAll(column.children);
        widget = column.children.last;
      } else {
        output.add(widget);
      }

      prev = widget;
    }

    while (output.isNotEmpty) {
      if (output.last is SpacingPlaceholder) {
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

  FontStyle buildFontStyle(NodeMetadata meta) => meta?.fontStyleItalic != null
      ? (meta.fontStyleItalic == true ? FontStyle.italic : FontStyle.normal)
      : null;

  Iterable<Widget> buildGestureDetectors(
    BuilderContext bc,
    Iterable<Widget> widgets,
    GestureTapCallback onTap,
  ) =>
      widgets.map((widget) => GestureDetector(child: widget, onTap: onTap));

  GestureTapCallback buildGestureTapCallbackForUrl(String url) => url != null
      ? () => _config.onTapUrl != null
          ? _config.onTapUrl(url)
          : print("[flutter_widget_from_html] Tapped url $url")
      : null;

  Widget buildImage(String url, {double height, String text, double width}) {
    ImageProvider image;
    if (url != null) {
      if (url.startsWith('asset:')) {
        image = buildImageFromAsset(url);
      } else if (url.startsWith('data:')) {
        image = buildImageFromDataUri(url);
      } else {
        image = buildImageFromUrl(url);
      }
    }

    return image != null
        ? ImageLayout(image, height: height, text: text, width: width)
        : text != null ? Text(text) : null;
  }

  List buildImageBytes(String dataUri) {
    final match = _dataUriRegExp.matchAsPrefix(dataUri);
    if (match == null) return null;

    final prefix = match[0];
    final bytes = base64.decode(dataUri.substring(prefix.length));
    if (bytes.length == 0) return null;

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

  Widget buildTable(List<TableRow> rows, {TableBorder border}) =>
      rows?.isNotEmpty == true ? Table(border: border, children: rows) : null;

  TableCell buildTableCell(Widget child) => TableCell(
      child: buildPadding(child, _config.tableCellPadding) ?? widget0);

  Iterable<Widget> buildText(
    BuilderContext bc,
    Iterable<Widget> _,
    TextBlock block,
  ) {
    final tsb = block.tsb;
    tsb?.build(bc);

    final textScaleFactor = MediaQuery.of(bc.context).textScaleFactor;
    final widgets = <Widget>[];
    for (final compiled in _TextBlockCompiler(block).compile(bc)) {
      if (compiled is InlineSpan) {
        widgets.add(RichText(
          text: compiled,
          textAlign: tsb?.textAlign ?? TextAlign.start,
          textScaleFactor: textScaleFactor,
        ));
      } else if (compiled is Widget) {
        widgets.add(compiled);
      }
    }

    return widgets;
  }

  TextDecoration buildTextDecoration(TextStyle parent, NodeMetadata meta) {
    if (meta?.decoOver == null &&
        meta?.decoStrike == null &&
        meta?.decoUnder == null) {
      return null;
    }

    final pd = parent.decoration;
    final lineThough = pd?.contains(TextDecoration.lineThrough) == true;
    final overline = pd?.contains(TextDecoration.overline) == true;
    final underline = pd?.contains(TextDecoration.underline) == true;

    final List<TextDecoration> list = [];
    if (meta.decoOver == true || (overline && meta.decoOver != false)) {
      list.add(TextDecoration.overline);
    }
    if (meta.decoStrike == true || (lineThough && meta.decoStrike != false)) {
      list.add(TextDecoration.lineThrough);
    }
    if (meta.decoUnder == true || (underline && meta.decoUnder != false)) {
      list.add(TextDecoration.underline);
    }

    return TextDecoration.combine(list);
  }

  double buildTextFontSize(TextStyleBuilders tsb, TextStyle p, NodeMetadata m) {
    final value = m.fontSize;
    if (value == null) return null;

    final parsed = parseCssLength(value);
    if (parsed != null) return parsed.getValue(tsb.bc, m.tsb);

    final c = tsb.bc.context;
    switch (value) {
      case kCssFontSizeXxLarge:
        return DefaultTextStyle.of(c).style.fontSize * 2.0;
      case kCssFontSizeXLarge:
        return DefaultTextStyle.of(c).style.fontSize * 1.5;
      case kCssFontSizeLarge:
        return DefaultTextStyle.of(c).style.fontSize * 1.125;
      case kCssFontSizeMedium:
        return DefaultTextStyle.of(c).style.fontSize;
      case kCssFontSizeSmall:
        return DefaultTextStyle.of(c).style.fontSize * .8125;
      case kCssFontSizeXSmall:
        return DefaultTextStyle.of(c).style.fontSize * .625;
      case kCssFontSizeXxSmall:
        return DefaultTextStyle.of(c).style.fontSize * .5625;

      case kCssFontSizeLarger:
        return p.fontSize * 1.2;
      case kCssFontSizeSmaller:
        return p.fontSize * (15 / 18);
    }

    return null;
  }

  TextStyle buildTextStyle(TextStyleBuilders tsb, TextStyle p, NodeMetadata m) {
    if (m == null) return p;

    final decoration = buildTextDecoration(p, m);
    final fontSize = buildTextFontSize(tsb, p, m);
    final fontStyle = buildFontStyle(m);
    if (m.color == null &&
        decoration == null &&
        m.decorationStyle == null &&
        m.fontFamily == null &&
        fontSize == null &&
        fontStyle == null &&
        m.fontWeight == null) {
      return p;
    }

    return p.copyWith(
      color: m.color,
      decoration: decoration,
      decorationStyle: m.decorationStyle,
      fontFamily: m.fontFamily,
      fontSize: fontSize,
      fontStyle: fontStyle,
      fontWeight: m.fontWeight,
    );
  }

  String constructFullUrl(String url) {
    if (url?.isNotEmpty != true) return null;
    final p = Uri.tryParse(url);
    if (p == null) return null;
    if (p.hasScheme) return p.toString();

    final b = _config.baseUrl;
    if (b == null) return null;

    return b.resolveUri(p).toString();
  }

  String getListStyleMarker(String type, int i) {
    switch (type) {
      case kCssListStyleTypeAlphaLower:
      case kCssListStyleTypeAlphaLatinLower:
        if (i >= 1 && i <= 26) {
          // the specs said it's unspecified after the 26th item
          // TODO: generate something like aa, ab, etc. when needed
          return "${String.fromCharCode(96 + i)}.";
        }
        return '';
      case kCssListStyleTypeAlphaUpper:
      case kCssListStyleTypeAlphaLatinUpper:
        if (i >= 1 && i <= 26) {
          // the specs said it's unspecified after the 26th item
          // TODO: generate something like AA, AB, etc. when needed
          return "${String.fromCharCode(64 + i)}.";
        }
        return '';
      case kCssListStyleTypeCircle:
        return '-';
      case kCssListStyleTypeDecimal:
        return "$i.";
      case kCssListStyleTypeDisc:
        return '•';
      case kCssListStyleTypeRomanLower:
        final roman = getListStyleMarkerRoman(i)?.toLowerCase();
        return roman != null ? "$roman." : '';
      case kCssListStyleTypeRomanUpper:
        final roman = getListStyleMarkerRoman(i);
        return roman != null ? "$roman." : '';
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

  NodeMetadata parseElement(NodeMetadata meta, dom.Element element) {
    if (_config.builderCallback != null) {
      meta = _config.builderCallback(meta, element);
    }

    return meta;
  }

  NodeMetadata parseLocalName(NodeMetadata meta, String localName) {
    switch (localName) {
      case 'a':
        meta = lazySet(meta, buildOp: tagA());
        break;

      case 'abbr':
      case 'acronym':
        meta = lazySet(
          meta,
          decorationStyle: TextDecorationStyle.dotted,
          decoUnder: true,
        );
        break;

      case 'address':
        meta = lazySet(meta, isBlockElement: true, fontStyleItalic: true);
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
        meta = lazySet(meta, isBlockElement: true);
        break;

      case 'blockquote':
      case 'figure':
        meta = lazySet(meta, styles: [kCssMargin, '1em 40px']);
        break;

      case 'b':
      case 'strong':
        meta = lazySet(meta, fontWeight: FontWeight.bold);
        break;

      case 'big':
        meta = lazySet(meta, fontSize: kCssFontSizeLarger);
        break;

      case 'br':
        meta = lazySet(meta, buildOp: tagBr());
        break;

      case 'center':
        meta = lazySet(meta, styles: [kCssTextAlign, kCssTextAlignCenter]);
        break;

      case 'cite':
      case 'dfn':
      case 'em':
      case 'i':
      case 'var':
        meta = lazySet(meta, fontStyleItalic: true);
        break;

      case kTagCode:
      case kTagPre:
      case kTagTt:
        meta = lazySet(meta, buildOp: tagCode());
        break;

      case 'dd':
        meta = lazySet(meta, styles: [kCssMargin, '0 0 1em 40px']);
        break;
      case 'dl':
        meta = lazySet(meta, isBlockElement: true);
        break;
      case 'dt':
        meta = lazySet(meta, isBlockElement: true, fontWeight: FontWeight.bold);
        break;

      case 'del':
      case 's':
      case 'strike':
        meta = lazySet(meta, decoStrike: true);
        break;

      case 'font':
        meta = lazySet(meta, buildOp: tagFont());
        break;

      case 'hr':
        meta = lazySet(meta, buildOp: tagHr());
        break;

      case 'h1':
        meta = lazySet(
          meta,
          fontSize: '2em',
          fontWeight: FontWeight.bold,
          styles: [kCssMargin, '0.67em 0'],
        );
        break;
      case 'h2':
        meta = lazySet(
          meta,
          fontSize: '1.5em',
          fontWeight: FontWeight.bold,
          styles: [kCssMargin, '0.83em 0'],
        );
        break;
      case 'h3':
        meta = lazySet(
          meta,
          fontSize: '1.17em',
          fontWeight: FontWeight.bold,
          styles: [kCssMargin, '1em 0'],
        );
        break;
      case 'h4':
        meta = lazySet(
          meta,
          fontWeight: FontWeight.bold,
          styles: [kCssMargin, '1.33em 0'],
        );
        break;
      case 'h5':
        meta = lazySet(
          meta,
          fontSize: '0.83em',
          fontWeight: FontWeight.bold,
          styles: [kCssMargin, '1.67em 0'],
        );
        break;
      case 'h6':
        meta = lazySet(
          meta,
          fontSize: '0.67em',
          fontWeight: FontWeight.bold,
          styles: [kCssMargin, '2.33em 0'],
        );
        break;

      case 'iframe':
      case 'script':
      case 'style':
        // actually `script` and `style` are not required here
        // our parser will put those elements into document.head anyway
        meta = lazySet(meta, isNotRenderable: true);
        break;

      case 'img':
        meta = lazySet(meta, buildOp: tagImg());
        break;

      case 'ins':
      case 'u':
        meta = lazySet(meta, decoUnder: true);
        break;

      case 'kbd':
      case 'samp':
        meta = lazySet(meta, fontFamily: 'monospace');
        break;

      case kTagOrderedList:
      case kTagUnorderedList:
        meta = lazySet(meta, buildOp: tagLi());
        break;

      case 'mark':
        meta = lazySet(
          meta,
          styles: [kCssBackgroundColor, '#ff0', kCssColor, '#000'],
        );
        break;

      case 'p':
        meta = lazySet(meta, styles: [kCssMargin, '1em 0']);
        break;

      case kTagQ:
        meta = lazySet(meta, buildOp: tagQ());
        break;

      case 'small':
        meta = lazySet(meta, fontSize: kCssFontSizeSmaller);
        break;

      case kTagTable:
        meta = lazySet(meta, buildOp: tagTable());
        break;
    }

    return meta;
  }

  NodeMetadata parseStyle(NodeMetadata meta, String key, String value) {
    switch (key) {
      case kCssBackgroundColor:
        meta = lazySet(meta, buildOp: styleBgColor());
        break;

      case kCssBorderBottom:
        final borderBottom = parseCssBorderSide(value);
        if (borderBottom != null) {
          meta = lazySet(
            meta,
            decoUnder: true,
            decorationStyleFromCssBorderStyle: borderBottom.style,
          );
        } else {
          meta = lazySet(meta, decoUnder: false);
        }
        break;
      case kCssBorderTop:
        final borderTop = parseCssBorderSide(value);
        if (borderTop != null) {
          meta = lazySet(
            meta,
            decoOver: true,
            decorationStyleFromCssBorderStyle: borderTop.style,
          );
        } else {
          meta = lazySet(meta, decoOver: false);
        }
        break;

      case kCssColor:
        final color = parseColor(value);
        if (color != null) meta = lazySet(meta, color: color);
        break;

      case kCssDisplay:
        switch (value) {
          case kCssDisplayBlock:
            meta = lazySet(meta, isBlockElement: true);
            break;
          case kCssDisplayInline:
          case kCssDisplayInlineBlock:
            meta = lazySet(meta, isBlockElement: false);
            break;
          case kCssDisplayNone:
            meta = lazySet(meta, isNotRenderable: true);
            break;
        }
        break;

      case kCssFontFamily:
        meta = lazySet(meta, fontFamily: value);
        break;

      case kCssFontSize:
        meta = lazySet(meta, fontSize: value);
        break;

      case kCssFontStyle:
        switch (value) {
          case kCssFontStyleItalic:
            meta = lazySet(meta, fontStyleItalic: true);
            break;
          case kCssFontStyleNormal:
            meta = lazySet(meta, fontStyleItalic: false);
            break;
        }
        break;

      case kCssFontWeight:
        switch (value) {
          case kCssFontWeightBold:
            meta = lazySet(meta, fontWeight: FontWeight.bold);
            break;
          case kCssFontWeight100:
            meta = lazySet(meta, fontWeight: FontWeight.w100);
            break;
          case kCssFontWeight200:
            meta = lazySet(meta, fontWeight: FontWeight.w200);
            break;
          case kCssFontWeight300:
            meta = lazySet(meta, fontWeight: FontWeight.w300);
            break;
          case kCssFontWeight400:
            meta = lazySet(meta, fontWeight: FontWeight.w400);
            break;
          case kCssFontWeight500:
            meta = lazySet(meta, fontWeight: FontWeight.w500);
            break;
          case kCssFontWeight600:
            meta = lazySet(meta, fontWeight: FontWeight.w600);
            break;
          case kCssFontWeight700:
            meta = lazySet(meta, fontWeight: FontWeight.w700);
            break;
          case kCssFontWeight800:
            meta = lazySet(meta, fontWeight: FontWeight.w800);
            break;
          case kCssFontWeight900:
            meta = lazySet(meta, fontWeight: FontWeight.w900);
            break;
        }
        break;

      case kCssMargin:
      case kCssMarginBottom:
      case kCssMarginLeft:
      case kCssMarginRight:
      case kCssMarginTop:
        meta = lazySet(meta, buildOp: styleMargin());
        break;

      case kCssTextAlign:
        meta = lazySet(meta, buildOp: styleTextAlign());
        break;

      case kCssTextDecoration:
        for (final v in splitCss(value)) {
          switch (v) {
            case kCssTextDecorationLineThrough:
              meta = lazySet(meta, decoStrike: true);
              break;
            case kCssTextDecorationNone:
              meta = lazySet(
                meta,
                decoStrike: false,
                decoOver: false,
                decoUnder: false,
              );
              break;
            case kCssTextDecorationOverline:
              meta = lazySet(meta, decoOver: true);
              break;
            case kCssTextDecorationUnderline:
              meta = lazySet(meta, decoUnder: true);
              break;
          }
        }
        break;
    }

    return meta;
  }

  BuildOp styleBgColor() {
    _styleBgColor ??= _StyleBgColor(this).buildOp;
    return _styleBgColor;
  }

  BuildOp styleMargin() {
    _styleMargin ??= _StyleMargin(this).buildOp;
    return _styleMargin;
  }

  BuildOp styleTextAlign() {
    _styleTextAlign ??= _StyleTextAlign(this).buildOp;
    return _styleTextAlign;
  }

  BuildOp tagA() {
    _tagA ??= _TagA(this).buildOp;
    return _tagA;
  }

  BuildOp tagBr() {
    _tagBr ??= BuildOp(
      onPieces: (_, pieces) => pieces..last.block.addSpace('\n'),
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
      defaultStyles: (_, __) => const [kCssMarginBottom, '1em'],
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

  BuildOp tagTable() {
    _tagTable ??= _TagTable(this).buildOp;
    return _tagTable;
  }
}
