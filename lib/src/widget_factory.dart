import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/core.dart' as core;
import 'package:url_launcher/url_launcher.dart';

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

Widget wrapPadding(Widget widget, EdgeInsetsGeometry padding) =>
    (widget != null && padding != null)
        ? Padding(padding: padding, child: widget)
        : widget;

class WidgetFactory extends core.WidgetFactory {
  final Config config;

  WidgetFactory(BuildContext context, this.config) : super(context);

  Widget buildColumnForList(List<Widget> children) => wrapPadding(
        super.buildColumnForList(children),
        config.listPadding,
      );

  @override
  Widget buildImageWidget(core.NodeImage image) => wrapPadding(
        super.buildImageWidget(image),
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
  TextStyle buildTextStyleForHref(String href, TextStyle textStyle) =>
      textStyle.copyWith(color: Theme.of(context).accentColor);

  @override
  Widget buildTextWidget(text, {TextAlign textAlign}) => wrapPadding(
        super.buildTextWidget(text, textAlign: textAlign),
        config.textPadding,
      );

  @override
  GestureTapCallback prepareGestureTapCallbackToLaunchUrl(String url) =>
      () async {
        final fullUrl = buildFullUrl(url, config.baseUrl);

        if (await canLaunch(fullUrl)) {
          await launch(fullUrl);
        }
      };
}
