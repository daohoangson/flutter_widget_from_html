import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'config.dart';

final _baseUriTrimmingRegExp = RegExp(r'/+$');
final _dataUriRegExp = RegExp(r'^data:image/\w+;base64,');
final _httpSchemeRegExp = RegExp(r'^https?://');
final _spacingRegExp = RegExp(r'\s+');
final _textIsUselessRegExp = RegExp(r'^\s*$');

class WidgetFactory {
  final Config config;

  const WidgetFactory({this.config = const Config()});

  Widget buildColumn({
    List<Widget> children,
    bool indent = false,
    String url,
  }) {
    if (children?.isNotEmpty != true) {
      return null;
    }

    Widget widget;
    if (children.length == 1) {
      widget = children.first;
    } else {
      widget = Column(
        children: children,
        crossAxisAlignment: CrossAxisAlignment.stretch,
      );
    }

    if (url?.isNotEmpty == true) {
      widget = GestureDetector(
        child: widget,
        onTap: prepareGestureTapCallbackToLaunchUrl(buildFullUrl(url)),
      );
    }

    if (indent) {
      widget = Padding(
        padding: config.indentPadding,
        child: widget,
      );
    }

    return widget;
  }

  String buildFullUrl(String url) {
    var imageUrl = url;

    if (!url.startsWith(_httpSchemeRegExp)) {
      final baseUrl = config.baseUrl;
      if (baseUrl == null) {
        return null;
      }

      if (url.startsWith('//')) {
        imageUrl = "${baseUrl.scheme}:$url";
      } else if (url.startsWith('/')) {
        imageUrl = baseUrl.scheme +
            '://' +
            baseUrl.host +
            (baseUrl.hasPort ? ":${baseUrl.port}" : '') +
            url;
      } else {
        final baseUrlTrimmed =
            baseUrl.toString().replaceAll(_baseUriTrimmingRegExp, '');
        imageUrl = "$baseUrlTrimmed/$url";
      }
    }

    return imageUrl;
  }

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

    Widget widget;
    if (src?.startsWith('data:image') == true) {
      widget = buildImageWidgetFromDataUri(src);
    } else {
      widget = buildImageWidgetFromUrl(
        height: image?.height,
        url: src,
        width: image?.width,
      );
    }

    if (config.widgetImagePadding != null) {
      widget = Padding(
        child: widget,
        padding: config.widgetImagePadding,
      );
    }

    return widget;
  }

  Widget buildImageWidgetFromDataUri(String dataUri) {
    final bytes = buildImageBytes(dataUri);
    if (bytes == null) {
      return null;
    }

    return Image.memory(bytes, fit: BoxFit.cover);
  }

  Widget buildImageWidgetFromUrl({int height, String url, int width}) {
    final imageUrl = buildFullUrl(url);
    if (imageUrl?.isEmpty != false) return null;

    Widget widget = CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
    );

    if (height != null && height > 0 && width != null && width > 0) {
      widget = AspectRatio(
        aspectRatio: width / height,
        child: widget,
      );
    }

    return widget;
  }

  TextSpan buildTextSpan({
    @required BuildContext context,
    List<TextSpan> children,
    TextStyle style,
    String text,
    String url,
  }) {
    if (children?.isEmpty != false && text?.isEmpty != false) {
      return null;
    }

    TextSpan span;
    text = text?.replaceAll(_spacingRegExp, ' ') ?? '';
    if (text.isEmpty && children?.isNotEmpty == true && children.length == 1) {
      span = children.first;
    } else {
      span = TextSpan(
        children: children,
        style: style ?? DefaultTextStyle.of(context).style,
        text: text,
      );
    }

    if (url?.isNotEmpty == true) {
      final onTap = prepareGestureTapCallbackToLaunchUrl(buildFullUrl(url));
      final recognizer = TapGestureRecognizer()..onTap = onTap;
      span = _rebuildTextSpanWithRecognizer(span, recognizer);
    }

    return span;
  }

  Widget buildTextWidgetSimple({
    @required String text,
    TextAlign textAlign,
  }) =>
      _checkTextIsUseless(text)
          ? null
          : Text(
              text.trim(),
              textAlign: textAlign ?? TextAlign.start,
            );

  Widget buildTextWidgetWithStyling({
    @required TextSpan text,
    TextAlign textAlign,
  }) =>
      _checkTextSpanIsUseless(text)
          ? null
          : RichText(
              text: text,
              textAlign: textAlign ?? TextAlign.start,
            );

  GestureTapCallback prepareGestureTapCallbackToLaunchUrl(String url) {
    return () async {
      if (await canLaunch(url)) {
        await launch(url);
      }
    };
  }

  Widget wrapTextWidget(Widget widget) =>
      (config.widgetTextPadding == null || widget == null)
          ? widget
          : Container(
              padding: config.widgetTextPadding,
              child: widget,
            );

  bool _checkTextIsUseless(String text) =>
      _textIsUselessRegExp.firstMatch(text) != null;

  bool _checkTextSpanIsUseless(TextSpan span) {
    if (span == null) return true;
    if (span.children?.isNotEmpty != false) return false;
    return _checkTextIsUseless(span.text);
  }

  TextSpan _rebuildTextSpanWithRecognizer(
      TextSpan span, GestureRecognizer recognizer) {
    // this is required because recognizer does not trigger for children
    // https://github.com/flutter/flutter/issues/10623
    final children = span.children == null
        ? null
        : span.children
            .map((TextSpan subSpan) =>
                _rebuildTextSpanWithRecognizer(subSpan, recognizer))
            .toList();

    return TextSpan(
      children: children,
      style: span.style,
      recognizer: recognizer,
      text: span.text,
    );
  }
}
