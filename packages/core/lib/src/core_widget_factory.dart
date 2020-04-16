import 'dart:convert';
import 'dart:ui' as ui show ParagraphBuilder;
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import 'builder.dart';
import 'core_data.dart';
import 'core_helpers.dart';
import 'core_html_widget.dart';

part 'ops/style_bg_color.dart';
part 'ops/style_direction.dart';
part 'ops/style_margin.dart';
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
part 'parser/border.dart';
part 'parser/color.dart';
part 'parser/css.dart';

final _dataUriRegExp = RegExp(r'^data:image/\w+;base64,');

/// A factory to build widget for HTML elements.
class WidgetFactory {
  final HtmlConfig _config;

  BuildOp _styleBgColor;
  BuildOp _styleMargin;
  BuildOp _styleTextAlign;
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

  WidgetFactory(this._config);

  Color get hyperlinkColor => _config.hyperlinkColor;

  Iterable<Widget> buildAligns(
    BuildContext _,
    Iterable<Widget> widgets,
    Alignment alignment,
  ) =>
      widgets.map((widget) {
        final x = _childOf(widget);
        if (x is RichText || x is WidgetPlaceholder<TextBits>) return widget;
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

  static Iterable<Widget> _buildColumn(BuildContext c, Iterable<Widget> ws, _) {
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

  FontStyle buildFontStyle(NodeMetadata meta) => meta?.fontStyleItalic != null
      ? (meta.fontStyleItalic == true ? FontStyle.italic : FontStyle.normal)
      : null;

  Iterable<Widget> buildGestureDetectors(
    BuildContext _,
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

  Widget buildTable(List<TableRow> rows, {TableBorder border}) =>
      rows?.isNotEmpty == true ? Table(border: border, children: rows) : null;

  TableCell buildTableCell(Widget child) => TableCell(
      child: buildPadding(child, _config.tableCellPadding) ?? widget0);

  Widget buildText(TextBits text) => (text..trimRight()).isNotEmpty
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
    final tsb = text.tsb;
    tsb?.build(context);

    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final widgets = <Widget>[];
    for (final compiled in _TextCompiler(text).compile(context)) {
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
    if (parsed != null) return parsed.getValue(tsb.context, m.tsb);

    final c = tsb.context;
    switch (value) {
      case _kCssFontSizeXxLarge:
        return DefaultTextStyle.of(c).style.fontSize * 2.0;
      case _kCssFontSizeXLarge:
        return DefaultTextStyle.of(c).style.fontSize * 1.5;
      case _kCssFontSizeLarge:
        return DefaultTextStyle.of(c).style.fontSize * 1.125;
      case _kCssFontSizeMedium:
        return DefaultTextStyle.of(c).style.fontSize;
      case _kCssFontSizeSmall:
        return DefaultTextStyle.of(c).style.fontSize * .8125;
      case _kCssFontSizeXSmall:
        return DefaultTextStyle.of(c).style.fontSize * .625;
      case _kCssFontSizeXxSmall:
        return DefaultTextStyle.of(c).style.fontSize * .5625;

      case _kCssFontSizeLarger:
        return p.fontSize * 1.2;
      case _kCssFontSizeSmaller:
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
      case _kCssListStyleTypeAlphaLower:
      case _kCssListStyleTypeAlphaLatinLower:
        if (i >= 1 && i <= 26) {
          // the specs said it's unspecified after the 26th item
          // TODO: generate something like aa, ab, etc. when needed
          return "${String.fromCharCode(96 + i)}.";
        }
        return '';
      case _kCssListStyleTypeAlphaUpper:
      case _kCssListStyleTypeAlphaLatinUpper:
        if (i >= 1 && i <= 26) {
          // the specs said it's unspecified after the 26th item
          // TODO: generate something like AA, AB, etc. when needed
          return "${String.fromCharCode(64 + i)}.";
        }
        return '';
      case _kCssListStyleTypeCircle:
        return '-';
      case _kCssListStyleTypeDecimal:
        return "$i.";
      case _kCssListStyleTypeDisc:
        return '•';
      case _kCssListStyleTypeRomanLower:
        final roman = getListStyleMarkerRoman(i)?.toLowerCase();
        return roman != null ? "$roman." : '';
      case _kCssListStyleTypeRomanUpper:
        final roman = getListStyleMarkerRoman(i);
        return roman != null ? "$roman." : '';
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

  NodeMetadata parseElement(NodeMetadata meta, dom.Element element) {
    if (_config.builderCallback != null) {
      meta = _config.builderCallback(meta, element);
    }

    return meta;
  }

  Color parseColor(String value) => _parseColor(value);

  CssBorderSide parseCssBorderSide(String value) =>
      _parseCssBorderSide(this, value);

  TextDecorationStyle parseCssBorderStyle(String value) =>
      _parseCssBorderStyle(value);

  CssLength parseCssLength(String value) => _parseCssLength(value);

  CssMargin parseCssMargin(NodeMetadata meta) => _parseCssMargin(this, meta);

  CssMargin parseCssMarginAll(String value) => _parseCssMarginAll(this, value);

  CssMargin parseCssMarginOne(CssMargin existing, String key, String value) =>
      _parseCssMarginOne(this, existing, key, value);

  NodeMetadata parseStyle(NodeMetadata meta, String key, String value) {
    switch (key) {
      case _kCssBackgroundColor:
        meta = lazySet(meta, buildOp: styleBgColor());
        break;

      case _kCssBorderBottom:
        final borderBottom = parseCssBorderSide(value);
        if (borderBottom != null) {
          meta = lazySet(
            meta,
            decoUnder: true,
            decorationStyle: borderBottom.style,
          );
        } else {
          meta = lazySet(meta, decoUnder: false);
        }
        break;
      case _kCssBorderTop:
        final borderTop = parseCssBorderSide(value);
        if (borderTop != null) {
          meta = lazySet(
            meta,
            decoOver: true,
            decorationStyle: borderTop.style,
          );
        } else {
          meta = lazySet(meta, decoOver: false);
        }
        break;

      case _kCssColor:
        final color = parseColor(value);
        if (color != null) meta = lazySet(meta, color: color);
        break;

      case _kCssDirection:
        meta = lazySet(meta, buildOp: styleDirection(value));
        break;

      case _kCssDisplay:
        switch (value) {
          case _kCssDisplayBlock:
            meta = lazySet(meta, isBlockElement: true);
            break;
          case _kCssDisplayInline:
          case _kCssDisplayInlineBlock:
            meta = lazySet(meta, isBlockElement: false);
            break;
          case _kCssDisplayNone:
            meta = lazySet(meta, isNotRenderable: true);
            break;
        }
        break;

      case _kCssFontFamily:
        meta = lazySet(meta, fontFamily: value);
        break;

      case _kCssFontSize:
        meta = lazySet(meta, fontSize: value);
        break;

      case _kCssFontStyle:
        switch (value) {
          case _kCssFontStyleItalic:
            meta = lazySet(meta, fontStyleItalic: true);
            break;
          case _kCssFontStyleNormal:
            meta = lazySet(meta, fontStyleItalic: false);
            break;
        }
        break;

      case _kCssFontWeight:
        switch (value) {
          case _kCssFontWeightBold:
            meta = lazySet(meta, fontWeight: FontWeight.bold);
            break;
          case _kCssFontWeight100:
            meta = lazySet(meta, fontWeight: FontWeight.w100);
            break;
          case _kCssFontWeight200:
            meta = lazySet(meta, fontWeight: FontWeight.w200);
            break;
          case _kCssFontWeight300:
            meta = lazySet(meta, fontWeight: FontWeight.w300);
            break;
          case _kCssFontWeight400:
            meta = lazySet(meta, fontWeight: FontWeight.w400);
            break;
          case _kCssFontWeight500:
            meta = lazySet(meta, fontWeight: FontWeight.w500);
            break;
          case _kCssFontWeight600:
            meta = lazySet(meta, fontWeight: FontWeight.w600);
            break;
          case _kCssFontWeight700:
            meta = lazySet(meta, fontWeight: FontWeight.w700);
            break;
          case _kCssFontWeight800:
            meta = lazySet(meta, fontWeight: FontWeight.w800);
            break;
          case _kCssFontWeight900:
            meta = lazySet(meta, fontWeight: FontWeight.w900);
            break;
        }
        break;

      case _kCssMargin:
      case _kCssMarginBottom:
      case _kCssMarginEnd:
      case _kCssMarginLeft:
      case _kCssMarginRight:
      case _kCssMarginStart:
      case _kCssMarginTop:
        meta = lazySet(meta, buildOp: styleMargin());
        break;

      case _kCssTextAlign:
        meta = lazySet(meta, buildOp: styleTextAlign());
        break;

      case _kCssTextDecoration:
        for (final v in _splitCss(value)) {
          switch (v) {
            case _kCssTextDecorationLineThrough:
              meta = lazySet(meta, decoStrike: true);
              break;
            case _kCssTextDecorationNone:
              meta = lazySet(
                meta,
                decoStrike: false,
                decoOver: false,
                decoUnder: false,
              );
              break;
            case _kCssTextDecorationOverline:
              meta = lazySet(meta, decoOver: true);
              break;
            case _kCssTextDecorationUnderline:
              meta = lazySet(meta, decoUnder: true);
              break;
          }
        }
        break;

      case _kCssVerticalAlign:
        meta = lazySet(meta, buildOp: styleVerticalAlign());
        break;
    }

    return meta;
  }

  NodeMetadata parseTag(
    NodeMetadata meta,
    String tag,
    Map<dynamic, String> attributes,
  ) {
    switch (tag) {
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
        meta = lazySet(meta, styles: [_kCssMargin, '1em 40px']);
        break;

      case 'b':
      case 'strong':
        meta = lazySet(meta, fontWeight: FontWeight.bold);
        break;

      case 'big':
        meta = lazySet(meta, fontSize: _kCssFontSizeLarger);
        break;

      case 'br':
        meta = lazySet(meta, buildOp: tagBr());
        break;

      case 'center':
        meta = lazySet(meta, styles: [_kCssTextAlign, _kCssTextAlignCenter]);
        break;

      case 'cite':
      case 'dfn':
      case 'em':
      case 'i':
      case 'var':
        meta = lazySet(meta, fontStyleItalic: true);
        break;

      case _kTagCode:
      case _kTagPre:
      case _kTagTt:
        meta = lazySet(meta, buildOp: tagCode());
        break;

      case 'dd':
        meta = lazySet(meta, styles: [_kCssMargin, '0 0 1em 40px']);
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
          styles: [_kCssMargin, '0.67em 0'],
        );
        break;
      case 'h2':
        meta = lazySet(
          meta,
          fontSize: '1.5em',
          fontWeight: FontWeight.bold,
          styles: [_kCssMargin, '0.83em 0'],
        );
        break;
      case 'h3':
        meta = lazySet(
          meta,
          fontSize: '1.17em',
          fontWeight: FontWeight.bold,
          styles: [_kCssMargin, '1em 0'],
        );
        break;
      case 'h4':
        meta = lazySet(
          meta,
          fontWeight: FontWeight.bold,
          styles: [_kCssMargin, '1.33em 0'],
        );
        break;
      case 'h5':
        meta = lazySet(
          meta,
          fontSize: '0.83em',
          fontWeight: FontWeight.bold,
          styles: [_kCssMargin, '1.67em 0'],
        );
        break;
      case 'h6':
        meta = lazySet(
          meta,
          fontSize: '0.67em',
          fontWeight: FontWeight.bold,
          styles: [_kCssMargin, '2.33em 0'],
        );
        break;

      case 'iframe':
      case 'script':
      case 'style':
      case 'svg':
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

      case _kTagOrderedList:
      case _kTagUnorderedList:
        meta = lazySet(meta, buildOp: tagLi());
        break;

      case 'mark':
        meta = lazySet(
          meta,
          styles: [_kCssBackgroundColor, '#ff0', _kCssColor, '#000'],
        );
        break;

      case 'p':
        meta = lazySet(meta, styles: [_kCssMargin, '1em 0']);
        break;

      case 'q':
        meta = lazySet(meta, buildOp: tagQ());
        break;

      case _kTagRuby:
        meta = lazySet(meta, buildOp: tagRuby());
        break;

      case 'small':
        meta = lazySet(meta, fontSize: _kCssFontSizeSmaller);
        break;

      case 'sub':
        meta = lazySet(meta, styles: [
          _kCssFontSize,
          _kCssFontSizeSmaller,
          _kCssVerticalAlign,
          _kCssVerticalAlignSub,
        ]);
        break;
      case 'sup':
        meta = lazySet(meta, styles: [
          _kCssFontSize,
          _kCssFontSizeSmaller,
          _kCssVerticalAlign,
          _kCssVerticalAlignSuper,
        ]);
        break;

      case _kTagTable:
        meta = lazySet(meta, buildOp: tagTable());
        break;
    }

    for (final attribute in attributes.entries) {
      switch (attribute.key) {
        case _kAttributeAlign:
          meta = lazySet(meta, styles: [_kCssTextAlign, attribute.value]);
          break;
        case _kAttributeDir:
          meta = lazySet(meta, styles: [_kCssDirection, attribute.value]);
          break;
      }
    }

    return meta;
  }

  BuildOp styleBgColor() {
    _styleBgColor ??= _StyleBgColor(this).buildOp;
    return _styleBgColor;
  }

  BuildOp styleDirection(final String dir) => _styleDirection(this, dir);

  BuildOp styleMargin() {
    _styleMargin ??= _StyleMargin(this).buildOp;
    return _styleMargin;
  }

  BuildOp styleTextAlign() {
    _styleTextAlign ??= _StyleTextAlign(this).buildOp;
    return _styleTextAlign;
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
      defaultStyles: (_, __) => const [_kCssMarginBottom, '1em'],
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
