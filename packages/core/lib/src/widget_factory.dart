import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import 'metadata.dart';

final _dataUriRegExp = RegExp(r'^data:image/\w+;base64,');
final _spacingRegExp = RegExp(r'\s+');
final _textIsUselessRegExp = RegExp(r'^\s*$');

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

  Widget buildColumnForList(List<Widget> children, ListType type) =>
      buildColumn(children);

  FontStyle buildFontSize(NodeMetadata meta) => meta?.hasFontStyle == true
      ? (meta.fontStyleItalic == true ? FontStyle.italic : FontStyle.normal)
      : null;

  Widget buildGestureDetectorToLaunchUrl(Widget child, String url) =>
      (child != null && url?.isNotEmpty == true)
          ? GestureDetector(
              onTap: prepareGestureTapCallbackToLaunchUrl(url),
              child: child,
            )
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

  Widget buildImageWidget(NodeImage image) {
    final src = image?.src;
    if (src?.isNotEmpty != true) return null;

    final imageWidget = src.startsWith('data:image')
        ? buildImageWidgetFromDataUri(src)
        : buildImageWidgetFromUrl(src);
    if (imageWidget == null) return null;

    final height = image.height ?? 0;
    final width = image.width ?? 0;
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
    String url,
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

    if (url?.isNotEmpty == true) {
      final onTap = prepareGestureTapCallbackToLaunchUrl(url);
      final recognizer = TapGestureRecognizer()..onTap = onTap;
      span = _rebuildTextSpanWithRecognizer(span, recognizer);
    }

    return span;
  }

  TextStyle buildTextStyle(NodeMetadata meta, TextStyle parent) {
    if (meta?.hasStyling != true) return null;

    var textStyle = parent;

    if (meta.href != null) {
      textStyle = buildTextStyleForHref(meta.href, textStyle);
    }

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

  TextStyle buildTextStyleForHref(String href, TextStyle textStyle) =>
      textStyle;

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
      return _checkTextIsUseless(text)
          ? null
          : Text(text.trim(), textAlign: _textAlign);
    }

    if (text is TextSpan) {
      return _checkTextSpanIsUseless(text)
          ? null
          : RichText(text: text, textAlign: _textAlign);
    }

    return null;
  }

  NodeMetadata collectMetadata(dom.Element e) => parseElement(e);

  GestureTapCallback prepareGestureTapCallbackToLaunchUrl(String url) =>
      () => null;

  bool _checkTextIsUseless(String text) =>
      _textIsUselessRegExp.firstMatch(text) != null;

  bool _checkTextSpanIsUseless(TextSpan span) {
    if (span == null) return true;
    if (span.children?.isNotEmpty == true) return false;

    return _checkTextIsUseless(span.text);
  }

  TextSpan _rebuildTextSpanWithRecognizer(TextSpan span, GestureRecognizer r) {
    // this is required because recognizer does not trigger for children
    // https://github.com/flutter/flutter/issues/10623
    final children = span.children == null
        ? null
        : span.children
            .map((TextSpan subSpan) =>
                _rebuildTextSpanWithRecognizer(subSpan, r))
            .toList();

    return TextSpan(
      children: children,
      style: span.style,
      recognizer: r,
      text: span.text,
    );
  }
}
