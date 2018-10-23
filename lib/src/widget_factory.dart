import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core;
import 'package:html/dom.dart' as dom;

import 'ops/tag_a.dart';
import 'ops/tag_li.dart';
import 'config.dart';

final _baseUriTrimmingRegExp = RegExp(r'/+$');
final _isFullUrlRegExp = RegExp(r'^(https?://|mailto:|tel:)');

String buildFullUrl(String url, Uri baseUrl) {
  if (url?.isNotEmpty != true) return null;
  if (url.startsWith(_isFullUrlRegExp)) return url;
  if (baseUrl == null) return null;

  if (url.startsWith('//')) {
    return "${baseUrl.scheme}:$url";
  }

  if (url.startsWith('/')) {
    return baseUrl.scheme +
        '://' +
        baseUrl.host +
        (baseUrl.hasPort ? ":${baseUrl.port}" : '') +
        url;
  }

  return "${baseUrl.toString().replaceAll(_baseUriTrimmingRegExp, '')}/$url";
}

Widget wrapPadding(Widget widget, EdgeInsets padding) => (widget != null &&
        padding != null &&
        padding.top + padding.right + padding.bottom + padding.left > 0)
    ? Padding(padding: padding, child: widget)
    : widget;

class WidgetFactory extends core.WidgetFactory {
  final Config config;

  WidgetFactory(BuildContext context, this.config) : super(context);

  @override
  Widget buildImageWidget(String src, {int height, int width}) => wrapPadding(
        super.buildImageWidget(src, height: height, width: width),
        config.imagePadding,
      );

  @override
  Widget buildImageWidgetFromUrl(String url) {
    final imageUrl = buildFullUrl(url, config.baseUrl);
    if (imageUrl?.isEmpty != false) return null;

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget buildTextWidget(text, {TextAlign textAlign}) => wrapPadding(
        super.buildTextWidget(text, textAlign: textAlign),
        config.textPadding,
      );

  @override
  core.NodeMetadata parseElement(dom.Element e) {
    var meta = super.parseElement(e);

    switch (e.localName) {
      case 'a':
        meta = core.lazySet(meta, color: Theme.of(context).accentColor);

        if (e.attributes.containsKey('href')) {
          final href = e.attributes['href'];
          final fullUrl = buildFullUrl(href, config.baseUrl);
          if (fullUrl?.isNotEmpty == true) {
            meta = core.lazySet(meta, buildOp: tagA(fullUrl));
          }
        }
        break;

      case 'li':
      case 'ol':
      case 'ul':
        meta = core.lazySet(null, buildOp: tagLi(e.localName));
        break;
    }

    return meta;
  }

  core.BuildOp tagA(String fullUrl) => core.BuildOp(
        onPieces: TagA(fullUrl, this).onPieces,
      );

  core.BuildOp tagLi(String tag) => core.BuildOp(
        onWidgets: (widgets) => <Widget>[TagLi(this).build(widgets, tag)],
      );
}
