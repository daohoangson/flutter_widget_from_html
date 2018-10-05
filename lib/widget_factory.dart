import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'config.dart';

class WidgetFactory {

  final Config config;
  
  static final _baseUriTrimmingRegExp = RegExp(r'/+$');
  static final _dataUriRegExp = RegExp(r'^data:image/\w+;base64,');
  static final _httpSchemeRegExp = RegExp(r'^https?://');

  const WidgetFactory({this.config = const Config()});

  String buildFullUrl(String url) {
    var imageUrl = url;

    if (!url.startsWith(_httpSchemeRegExp)) {
      final baseUrl = config.baseUrl;
      if (baseUrl == null) {
        return null;
      }

      if (url.startsWith('/')) {
        imageUrl = baseUrl.scheme + '://' + baseUrl.host + (baseUrl.hasPort ? ":${baseUrl.port}" : '') + url;
      } else {
        final baseUrlTrimmed = baseUrl.toString().replaceAll(_baseUriTrimmingRegExp, '');
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

  Widget buildImageWidgetFromDataUri(String dataUri) {
    final bytes = buildImageBytes(dataUri);
    if (bytes == null) {
      return null;
    }

    return Image.memory(bytes, fit: BoxFit.cover);
  }

  Widget buildImageWidgetFromUrl(String url) {
    final imageUrl = buildFullUrl(url);
    if (imageUrl == null) {
      return null;
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
    );
  }

  TextSpan buildTextSpan({List<TextSpan> children, TextStyle style, String text, String url}) {
    TapGestureRecognizer recognizer;
    if (url != null && url.isNotEmpty) {
      recognizer = buildRecognizerToLaunchUrl(buildFullUrl(url));
    }

    return TextSpan(
      children: children,
      style: style,
      recognizer: recognizer,
      text: text,
    );
  }

  Widget buildTextWidget(TextSpan textSpan) {
    return RichText(
      softWrap: true,
      text: textSpan,
    );
  }

  TapGestureRecognizer buildRecognizerToLaunchUrl(String url) {
    return TapGestureRecognizer()
      ..onTap = () async {
        if (await canLaunch(url)) {
          await launch(url);
        }
      };
  }
}
