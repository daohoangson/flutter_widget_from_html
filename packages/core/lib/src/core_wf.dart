import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import 'ops/style_margin.dart';
import 'ops/style_text_align.dart';
import 'ops/tag_img.dart';
import 'metadata.dart';
import 'parser.dart' as parser;

final _dataUriRegExp = RegExp(r'^data:image/\w+;base64,');
final _spacingRegExp = RegExp(r'\s+');

class WidgetFactory {
  final BuildContext context;

  BuildOp _styleMargin;
  BuildOp _styleTextAlign;
  BuildOp _tagCode;
  BuildOp _tagImg;

  WidgetFactory(this.context);

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
    if (match == null) {
      return null;
    }

    final prefix = match[0];
    final bytes = base64.decode(dataUri.substring(prefix.length));
    if (bytes.length == 0) {
      return null;
    }

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

  TextDecoration buildTextDecoration(NodeMetadata meta, TextStyle parent) {
    if (meta.hasDecoration != true) return null;

    final pd = parent.decoration;
    final pdLineThough = pd?.contains(TextDecoration.lineThrough) == true;
    final pdOverline = pd?.contains(TextDecoration.overline) == true;
    final pdUnderline = pd?.contains(TextDecoration.underline) == true;

    final List<TextDecoration> list = List();
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

    TextSpan span;
    if (text.isEmpty && children?.length == 1) {
      span = children.first;
    } else {
      span = TextSpan(
        children: children,
        style: style,
        text: text,
      );
    }

    return span;
  }

  TextStyle buildTextStyle(NodeMetadata meta, TextStyle parent) {
    if (meta?.hasStyling != true) return null;

    var textStyle = parent;

    if (meta.style != null) {
      textStyle = buildTextStyleForStyle(meta.style, textStyle);
    }

    textStyle = textStyle.copyWith(
      color: meta.color,
      decoration: buildTextDecoration(meta, parent),
      fontFamily: meta.fontFamily,
      fontSize: meta.fontSize,
      fontStyle: buildFontSize(meta),
      fontWeight: meta.fontWeight,
    );

    return textStyle;
  }

  TextStyle buildTextStyleForStyle(StyleType style, TextStyle textStyle) {
    switch (style) {
      case StyleType.Heading1:
        return textStyle.copyWith(fontSize: textStyle.fontSize * 2);
      case StyleType.Heading2:
        return textStyle.copyWith(fontSize: textStyle.fontSize * 1.5);
      case StyleType.Heading3:
        return textStyle.copyWith(fontSize: textStyle.fontSize * 1.17);
      case StyleType.Heading4:
        return textStyle.copyWith(fontSize: textStyle.fontSize * 1.12);
      case StyleType.Heading5:
        return textStyle.copyWith(fontSize: textStyle.fontSize * .83);
      case StyleType.Heading6:
        return textStyle.copyWith(fontSize: textStyle.fontSize * .75);
    }

    return textStyle;
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
      case 'code':
        meta = lazySet(
          meta,
          buildOp: tagCode(),
          fontFamily: 'monospace',
        );
        break;
      case 'pre':
        meta = lazySet(
          meta,
          buildOp: tagCode(),
          fontFamily: 'monospace',
          textSpaceCollapse: false,
        );
        break;

      case 'img':
        meta = lazySet(meta, buildOp: tagImg());
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
    _tagCode ??= BuildOp(onWidgets: (_, widgets) => buildScrollView(widgets));
    return _tagCode;
  }

  BuildOp tagImg() {
    _tagImg ??= TagImg(this).buildOp;
    return _tagImg;
  }
}
