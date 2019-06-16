import 'dart:convert';
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
part 'ops/tag_img.dart';
part 'ops/tag_li.dart';
part 'ops/tag_q.dart';
part 'ops/tag_table.dart';
part 'ops/text.dart';

final _baseUriTrimmingRegExp = RegExp(r'/+$');
final _dataUriRegExp = RegExp(r'^data:image/\w+;base64,');
final _isFullUrlRegExp = RegExp(r'^(https?://|mailto:|tel:)');

class WidgetFactory {
  final HtmlWidget _htmlWidget;

  BuildOp _styleBgColor;
  BuildOp _styleMargin;
  BuildOp _styleTextAlign;
  BuildOp _tagA;
  BuildOp _tagBr;
  BuildOp _tagCode;
  BuildOp _tagHr;
  BuildOp _tagImg;
  BuildOp _tagLi;
  BuildOp _tagQ;
  BuildOp _tagTable;

  WidgetFactory(this._htmlWidget);

  Color get hyperlinkColor => _htmlWidget.hyperlinkColor;

  Widget buildAlign(Widget child, Alignment alignment) {
    if (child == null) return null;
    if (alignment == null) return child;

    if (child is Padding)
      return buildPadding(buildAlign(child.child, alignment), child.padding);

    return Align(alignment: alignment, child: child);
  }

  Widget buildBody(Iterable<Widget> children) =>
      buildPadding(buildColumn(children), _htmlWidget.bodyPadding);

  Widget buildColumn(Iterable<Widget> children) {
    children = fixOverlappingPaddings(children);
    if (children?.isNotEmpty != true) return null;

    return children.length > 1
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          )
        : children.first;
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
          : null;

  Widget buildDivider() => DecoratedBox(
        decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 1)),
        child: SizedBox(height: 1),
      );

  FontStyle buildFontStyle(NodeMetadata meta) => meta?.fontStyleItalic != null
      ? (meta.fontStyleItalic == true ? FontStyle.italic : FontStyle.normal)
      : null;

  Widget buildGestureDetector(Widget child, GestureTapCallback onTap) =>
      GestureDetector(child: child, onTap: onTap);

  Iterable<Widget> buildGestureDetectors(
    Iterable<Widget> widgets,
    GestureTapCallback onTap,
  ) {
    if (widgets?.isNotEmpty != true || onTap == null) return widgets;

    return widgets.map((widget) {
      if (widget is Padding) {
        final p = widget;
        return buildPadding(buildGestureDetector(p.child, onTap), p.padding);
      }

      return buildGestureDetector(widget, onTap);
    });
  }

  GestureTapCallback buildGestureTapCallbackForUrl(String url) =>
      () => _htmlWidget.onTapUrl != null
          ? _htmlWidget.onTapUrl(url)
          : debugPrint(url);

  Widget buildImage(String src, {double height, String text, double width}) {
    final imageWidget = src?.startsWith('data:image') == true
        ? buildImageFromDataUri(src)
        : buildImageFromUrl(src);
    if (imageWidget == null) return Text(text ?? '');

    height ??= 0;
    width ??= 0;
    if (height <= 0 || width <= 0) return imageWidget;

    return CustomSingleChildLayout(
      child: imageWidget,
      delegate: ImageLayoutDelegate(
        height: height,
        width: width,
      ),
    );
  }

  List buildImageBytes(String dataUri) {
    final match = _dataUriRegExp.matchAsPrefix(dataUri);
    if (match == null) return null;

    final prefix = match[0];
    final bytes = base64.decode(dataUri.substring(prefix.length));
    if (bytes.length == 0) return null;

    return bytes;
  }

  Widget buildImageFromDataUri(String dataUri) {
    final bytes = buildImageBytes(dataUri);
    if (bytes == null) return null;

    return Image.memory(bytes, fit: BoxFit.cover);
  }

  Widget buildImageFromUrl(String url) =>
      url?.isNotEmpty == true ? Image.network(url, fit: BoxFit.cover) : null;

  Widget buildPadding(Widget child, EdgeInsets padding) {
    if (child == null) return null;
    if (padding == null || padding == const EdgeInsets.all(0)) return child;

    if (child is Padding) {
      final p = child as Padding;
      final pp = p.padding as EdgeInsets;
      child = p.child;
      padding = EdgeInsets.fromLTRB(
        pp.left + padding.left,
        pp.top > padding.top ? pp.top : padding.top,
        pp.right + padding.right,
        pp.bottom > padding.bottom ? pp.bottom : padding.bottom,
      );
    }

    return Padding(child: child, padding: padding);
  }

  Widget buildScrollView(Widget child) => child != null
      ? SingleChildScrollView(
          child: child,
          scrollDirection: Axis.horizontal,
        )
      : null;

  Widget buildTable(List<TableRow> rows, {TableBorder border}) =>
      Table(border: border, children: rows);

  Widget buildTableCell(Widget child) =>
      TableCell(child: buildPadding(child, _htmlWidget.tableCellPadding));

  Widget buildText(TextBlock block, {TextAlign textAlign}) {
    final _textAlign = textAlign ?? TextAlign.start;

    final span = _compileToTextSpan(block);
    if (span != null) return RichText(text: span, textAlign: _textAlign);

    return null;
  }

  TextDecoration buildTextDecoration(NodeMetadata meta, TextStyle parent) {
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

  double buildTextFontSize(NodeMetadata meta, TextStyle parent) {
    final value = meta?.fontSize;
    if (value == null) return null;

    final parsed = parseCssLength(value);
    if (parsed != null) return parsed.getValue(parent);

    switch (value) {
      case kCssFontSizeXxLarge:
        return DefaultTextStyle.of(meta.context).style.fontSize * 2.0;
      case kCssFontSizeXLarge:
        return DefaultTextStyle.of(meta.context).style.fontSize * 1.5;
      case kCssFontSizeLarge:
        return DefaultTextStyle.of(meta.context).style.fontSize * 1.125;
      case kCssFontSizeMedium:
        return DefaultTextStyle.of(meta.context).style.fontSize;
      case kCssFontSizeSmall:
        return DefaultTextStyle.of(meta.context).style.fontSize * .8125;
      case kCssFontSizeXSmall:
        return DefaultTextStyle.of(meta.context).style.fontSize * .625;
      case kCssFontSizeXxSmall:
        return DefaultTextStyle.of(meta.context).style.fontSize * .5625;

      case kCssFontSizeLarger:
        return parent.fontSize * 1.2;
      case kCssFontSizeSmaller:
        return parent.fontSize * (15 / 18);
    }

    return null;
  }

  TextStyle buildTextStyle(NodeMetadata meta, TextStyle parent) {
    if (meta == null) return parent;

    final decoration = buildTextDecoration(meta, parent);
    final fontSize = buildTextFontSize(meta, parent);
    final fontStyle = buildFontStyle(meta);
    if (meta.color == null &&
        decoration == null &&
        meta.decorationStyle == null &&
        meta.fontFamily == null &&
        fontSize == null &&
        fontStyle == null &&
        meta.fontWeight == null) {
      return parent;
    }

    return parent.copyWith(
      color: meta.color,
      decoration: decoration,
      decorationStyle: meta.decorationStyle,
      fontFamily: meta.fontFamily,
      fontSize: fontSize,
      fontStyle: fontStyle,
      fontWeight: meta.fontWeight,
    );
  }

  String constructFullUrl(String url) {
    if (url?.isNotEmpty != true) return null;
    if (url.startsWith(_isFullUrlRegExp)) return url;

    final b = _htmlWidget.baseUrl;
    if (b == null) return null;

    if (url.startsWith('//')) return "${b.scheme}:$url";

    if (url.startsWith('/')) {
      final port = b.hasPort ? ":${b.port}" : '';
      return "${b.scheme}://${b.host}$port$url";
    }

    return "${b.toString().replaceAll(_baseUriTrimmingRegExp, '')}/$url";
  }

  List<Widget> fixOverlappingPaddings(List<Widget> widgets) {
    if (widgets?.isNotEmpty != true) return null;
    final fixed = <Widget>[];
    final skipWidget0 = (Widget w) => w == widget0 ? null : fixed.add(w);

    var iMin = 0;
    var iMax = widgets.length - 1;
    while (iMin < iMax) {
      final wMin = widgets[iMin];
      if (wMin is Padding && wMin.child == widget0) {
        iMin++;
      } else {
        break;
      }
    }
    while (iMax > iMin) {
      final wMax = widgets[iMax];
      if (wMax is Padding && wMax.child == widget0) {
        iMax--;
      } else {
        break;
      }
    }

    EdgeInsets prev;
    for (var i = iMin; i <= iMax; i++) {
      final widget = widgets[i];
      if (!(widget is Padding)) {
        fixed.add(widget);
        prev = null;
        continue;
      }

      final p = widget as Padding;
      final pp = p.padding as EdgeInsets;
      var v = pp;

      if (i == iMin && v.top > 0) {
        // remove padding at the top
        v = v.copyWith(top: 0);
      }

      if (i == iMax && v.bottom > 0) {
        // remove padding at the bottom
        v = v.copyWith(bottom: 0);
      }

      if (prev != null && prev.bottom > 0 && v.top > 0) {
        v = v.copyWith(top: v.top > prev.bottom ? v.top - prev.bottom : 0);
      }

      skipWidget0(v != pp
          ? v == const EdgeInsets.all(0)
              ? p.child
              : Padding(child: p.child, padding: v)
          : widget);
      prev = v;
    }

    return fixed;
  }

  String getListStyleMarker(String type, int i) {
    switch (type) {
      case kCssListStyleTypeCircle:
        return '-';
      case kCssListStyleTypeDecimal:
        return "$i.";
      case kCssListStyleTypeDisc:
        return '•';
      case kCssListStyleTypeSquare:
        return '+';
    }

    return '';
  }

  NodeMetadata parseElement(NodeMetadata meta, dom.Element element) {
    if (_htmlWidget.builderCallback != null) {
      meta = _htmlWidget.builderCallback(meta, element);
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
      defaultStyles: (_, __) => const [kCssMargin, '0.5em 0'],
      onWidgets: (_, __) => [widget0],
    );
    return _tagBr;
  }

  BuildOp tagCode() {
    _tagCode ??= _TagCode(this).buildOp;
    return _tagCode;
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
