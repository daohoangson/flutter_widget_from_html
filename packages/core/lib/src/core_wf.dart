import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import 'ops/style_text_align.dart';
import 'ops/tag_img.dart';
import 'metadata.dart';
import 'parser.dart' as parser;

final _dataUriRegExp = RegExp(r'^data:image/\w+;base64,');
final _spacingRegExp = RegExp(r'\s+');

class WidgetFactory {
  final BuildContext context;

  const WidgetFactory(this.context);

  TextStyle get defaultTextStyle => DefaultTextStyle.of(context).style;

  Widget buildColumn(List<Widget> children) => children?.isNotEmpty == true
      ? children?.length == 1
          ? children.first
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
              key: UniqueKey(),
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

    final prefix = match.group(0);
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

  Widget buildScrollView(List<Widget> widgets) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: widgets.length == 1 ? widgets.first : buildColumn(widgets),
      );

  TextDecoration buildTextDecoration(NodeMetadata meta, TextStyle parent) {
    if (meta?.hasDecoration != true) return null;

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
        style: style ?? defaultTextStyle,
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

  NodeMetadata parseElement(dom.Element e) {
    NodeMetadata meta = parser.parseElement(e);

    switch (e.localName) {
      case 'a':
        meta = lazySet(meta, decorationUnderline: true);
        break;

      case 'code':
        meta = lazySet(
          meta,
          buildOp: BuildOp(
            onWidgets: (widgets) => <Widget>[buildScrollView(widgets)],
          ),
          fontFamily: 'monospace',
        );
        break;
      case 'pre':
        meta = lazySet(
          meta,
          buildOp: BuildOp(
            onWidgets: (widgets) => <Widget>[buildScrollView(widgets)],
          ),
          fontFamily: 'monospace',
          textSpaceCollapse: false,
        );
        break;

      case 'img':
        meta = lazySet(meta, buildOp: tagImg(e));
        break;
    }

    return meta;
  }

  NodeMetadata parseElementStyle(NodeMetadata meta, String key, String value) {
    meta = parser.parseElementStyle(meta, key, value);

    switch (key) {
      case 'text-align':
        final sta = StyleTextAlign.fromString(value, this);
        if (sta != null) {
          meta = lazySet(meta, buildOp: BuildOp(onPieces: sta.onPieces));
        }
        break;
    }

    return meta;
  }

  BuildOp tagImg(dom.Element e) =>
      BuildOp(onProcess: TagImg(e, this).onProcess);
}
