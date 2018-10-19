import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core;
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
  final List<Key> listItemKeys = List();

  WidgetFactory(BuildContext context, this.config) : super(context);

  @override
  Widget buildColumnForList(List<Widget> children, core.ListType type) {
    if (type == core.ListType.Item) {
      final item = super.buildColumnForList(children, type);
      listItemKeys.add(item.key);
      return item;
    }

    final bullet = config.listBullet;
    final isOrdered = type == core.ListType.Ordered;
    final padding = config.listPaddingLeft;
    final tp = config.textPadding;
    if (bullet == null || padding == null) {
      return super.buildColumnForList(children, type);
    }

    final List<Stack> stacks = List(children.length);
    int i = 0;
    for (final widget in children) {
      final markerNumber = i + 1;
      final marker = LayoutBuilder(
        builder: (context, bc) => Text(
              isOrdered ? "$markerNumber." : bullet,
              maxLines: 1,
              overflow: TextOverflow.clip,
              style: DefaultTextStyle.of(context).style.copyWith(
                    color: Theme.of(context).disabledColor,
                  ),
              textAlign: TextAlign.right,
            ),
      );

      stacks[i] = Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: padding),
            child: widget,
          ),
          Positioned(
            left: 0.0,
            top: 0.0,
            width: padding,
            child: tp?.top != null
                ? Padding(
                    padding: EdgeInsets.only(top: tp.top),
                    child: marker,
                  )
                : marker,
          )
        ],
      );

      i++;
    }

    return buildColumn(stacks);
  }

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
