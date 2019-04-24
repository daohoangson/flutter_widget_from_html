import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;

import 'data_classes.dart';
import 'parser.dart' as parser;

part 'ops/style_margin.dart';
part 'ops/style_text_align.dart';
part 'ops/tag_code.dart';
part 'ops/tag_hr.dart';
part 'ops/tag_img.dart';
part 'ops/tag_table.dart';

const kFontSizeXxLarge = 2.0;
const kFontSizeXLarge = 1.5;
const kFontSizeLarge = 1.125;
const kFontSizeMedium = 1;
const kFontSizeSmall = .8125;
const kFontSizeXSmall = .625;
const kFontSizeXxSmall = .5625;
const kFontSizeLarger = 1.2;
const kFontSizeSmaller = 15 / 18;

final _dataUriRegExp = RegExp(r'^data:image/\w+;base64,');
final _spacingRegExp = RegExp(r'\s+');

class WidgetFactory {
  final BuildContext context;

  BuildOp _styleMargin;
  BuildOp _styleTextAlign;
  BuildOp _tagCode;
  BuildOp _tagHr;
  BuildOp _tagImg;
  BuildOp _tagTable;

  WidgetFactory(this.context);

  double get defaultFontSize => DefaultTextStyle.of(context).style.fontSize;

  Widget buildAlign(Widget child, Alignment alignment) {
    if (alignment == null) return child;
    return child != null ? Align(alignment: alignment, child: child) : null;
  }

  Widget buildColumn(List<Widget> children) => children?.isNotEmpty == true
      ? children?.length == 1
          ? children.first
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            )
      : null;

  FontStyle buildFontSize(NodeMetadata meta) => meta?.hasFontStyle == true
      ? (meta.fontStyleItalic == true ? FontStyle.italic : FontStyle.normal)
      : null;

  List buildImageBytes(String dataUri) {
    final match = _dataUriRegExp.matchAsPrefix(dataUri);
    if (match == null) return null;

    final prefix = match[0];
    final bytes = base64.decode(dataUri.substring(prefix.length));
    if (bytes.length == 0) return null;

    return bytes;
  }

  Widget buildImageWidget(String src, {int height, int width}) {
    if (src?.isNotEmpty != true) return null;

    final imageWidget = src.startsWith('data:image')
        ? buildImageWidgetFromDataUri(src)
        : buildImageWidgetFromUrl(src);
    if (imageWidget == null) return null;

    height ??= 0;
    width ??= 0;
    if (height == 0 || width == 0) return imageWidget;

    return AspectRatio(
      aspectRatio: width / height,
      child: imageWidget,
    );
  }

  Widget buildImageWidgetFromDataUri(String dataUri) {
    final bytes = buildImageBytes(dataUri);
    if (bytes == null) return null;

    return Image.memory(bytes, fit: BoxFit.cover);
  }

  Widget buildImageWidgetFromUrl(String url) =>
      url?.isNotEmpty == true ? Image.network(url, fit: BoxFit.cover) : null;

  Widget buildPadding(Widget child, EdgeInsetsGeometry padding) {
    if (padding == null || padding == EdgeInsets.all(0)) return child;
    return child != null ? Padding(child: child, padding: padding) : null;
  }

  Widget buildScrollView(List<Widget> widgets) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: widgets.length == 1 ? widgets.first : buildColumn(widgets),
      );

  Widget buildTable(List<TableRow> rows, {TableBorder border}) => Table(
        border: border,
        children: rows,
      );

  Widget buildTableCell(Widget child) => TableCell(child: child);

  TextDecoration buildTextDecoration(NodeMetadata meta, TextStyle parent) {
    if (meta.hasDecoration != true) return null;

    final pd = parent.decoration;
    final pdLineThough = pd?.contains(TextDecoration.lineThrough) == true;
    final pdOverline = pd?.contains(TextDecoration.overline) == true;
    final pdUnderline = pd?.contains(TextDecoration.underline) == true;

    final List<TextDecoration> list = [];
    if (meta.decorationLineThrough == true ||
        (pdLineThough && meta.decorationLineThrough != false)) {
      list.add(TextDecoration.lineThrough);
    }
    if (meta.decorationOverline == true ||
        (pdOverline && meta.decorationOverline != false)) {
      list.add(TextDecoration.overline);
    }
    if (meta.decorationUnderline == true ||
        (pdUnderline && meta.decorationUnderline != false)) {
      list.add(TextDecoration.underline);
    }

    return TextDecoration.combine(list);
  }

  double buildTextFontSize(String value, TextStyle parent) {
    final parsed = parser.lengthParseValue(value);
    if (parsed != null) return parsed.getValue(parent);

    switch (value) {
      case 'xx-large':
        return defaultFontSize * kFontSizeXxLarge;
      case 'x-large':
        return defaultFontSize * kFontSizeXLarge;
      case 'large':
        return defaultFontSize * kFontSizeLarge;
      case 'medium':
        return defaultFontSize;
      case 'small':
        return defaultFontSize * kFontSizeSmall;
      case 'x-small':
        return defaultFontSize * kFontSizeXSmall;
      case 'xx-small':
        return defaultFontSize * kFontSizeXxSmall;

      case 'larger':
        return parent.fontSize * kFontSizeLarger;
      case 'smaller':
        return parent.fontSize * kFontSizeSmaller;
    }

    return null;
  }

  TextSpan buildTextSpan(
    String text, {
    List<TextSpan> children,
    TextStyle style,
    bool textSpaceCollapse,
  }) {
    final hasChildren = children?.isNotEmpty == true;
    final hasText = text?.isNotEmpty == true;
    if (!hasChildren && !hasText) return null;

    text = text ?? '';
    if (textSpaceCollapse != false) {
      text = text.replaceAll(_spacingRegExp, ' ');
    }

    return (text.isEmpty && children?.length == 1)
        ? children.first
        : TextSpan(children: children, style: style, text: text);
  }

  TextStyle buildTextStyle(NodeMetadata meta, TextStyle parent) {
    if (meta?.hasStyling != true) return null;

    return parent.copyWith(
      color: meta.color,
      decoration: buildTextDecoration(meta, parent),
      decorationStyle: meta.decorationStyle,
      fontFamily: meta.fontFamily,
      fontSize: buildTextFontSize(meta.fontSize, parent),
      fontStyle: buildFontSize(meta),
      fontWeight: meta.fontWeight,
    );
  }

  Widget buildTextWidget(text, {TextAlign textAlign}) {
    final _textAlign = textAlign ?? TextAlign.start;

    if (text is String) {
      return Text(text.trim(), textAlign: _textAlign);
    }

    if (text is TextSpan) {
      return RichText(text: text, textAlign: _textAlign);
    }

    return null;
  }

  NodeMetadata parseElement(NodeMetadata meta, dom.Element e) {
    switch (e.localName) {
      case kTagCode:
      case kTagPre:
        meta = lazySet(meta, buildOp: tagCode());
        break;

      case 'hr':
        meta = lazySet(meta, buildOp: tagHr());
        break;

      case 'img':
        meta = lazySet(meta, buildOp: tagImg());
        break;

      case kTagTable:
      case kTagTableCaption:
      case kTagTableCell:
      case kTagTableHeader:
      case kTagTableRow:
        meta = lazySet(meta, buildOp: tagTable());
        break;
    }

    return parser.parseElement(meta, e);
  }

  NodeMetadata parseElementStyle(NodeMetadata meta, String key, String value) {
    switch (key) {
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
    }

    return parser.parseElementStyle(meta, key, value);
  }

  BuildOp styleMargin() {
    _styleMargin ??= StyleMargin(this).buildOp;
    return _styleMargin;
  }

  BuildOp styleTextAlign() {
    _styleTextAlign ??= StyleTextAlign(this).buildOp;
    return _styleTextAlign;
  }

  BuildOp tagCode() {
    _tagCode ??= TagCode(this).buildOp;
    return _tagCode;
  }

  BuildOp tagHr() {
    _tagHr ??= TagHr(this).buildOp;
    return _tagHr;
  }

  BuildOp tagImg() {
    _tagImg ??= TagImg(this).buildOp;
    return _tagImg;
  }

  BuildOp tagTable() {
    _tagTable ??= TagTable(this).buildOp;
    return _tagTable;
  }
}
