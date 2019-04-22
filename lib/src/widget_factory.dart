import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core;
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'ops/tag_a.dart';
import 'ops/tag_iframe.dart';
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

  core.BuildOp _tagA;
  core.BuildOp _tagIframe;
  core.BuildOp _tagLi;

  WidgetFactory(
    BuildContext context, {
    this.config = const Config(),
  }) : super(context);

  GestureTapCallback buildGestureTapCallbackForUrl(String fullUrl) =>
      () => canLaunch(fullUrl).then((ok) => ok ? launch(fullUrl) : null);

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

  Widget buildWebView(
    String initialUrl, {
    double height,
    double width,
  }) =>
      wrapPadding(
        AspectRatio(
          aspectRatio:
              (height != null && height > 0 && width != null && width > 0)
                  ? (width / height)
                  : (16 / 9),
          child: WebView(
              initialUrl: initialUrl,
              javascriptMode: config.webViewJs
                  ? JavascriptMode.unrestricted
                  : JavascriptMode.disabled),
        ),
        config.webViewPadding,
      );

  Widget buildWebViewLinkOnly(String fullUrl) => GestureDetector(
        child: buildTextWidget(fullUrl),
        onTap: buildGestureTapCallbackForUrl(fullUrl),
      );

  @override
  core.NodeMetadata parseElement(core.NodeMetadata meta, dom.Element e) {
    switch (e.localName) {
      case 'a':
        meta = core.lazySet(
          meta,
          buildOp: tagA(),
          color: Theme.of(context).accentColor,
        );
        break;

      case 'iframe':
        return core.lazySet(
          meta,
          buildOp: tagIframe(),
          isNotRenderable: false,
        );

      case kTagListItem:
      case kTagOrderedList:
      case kTagUnorderedList:
        meta = core.lazySet(meta, buildOp: tagLi());
        break;
    }

    return super.parseElement(meta, e);
  }

  core.BuildOp tagA() {
    _tagA ??= TagA(this).buildOp;
    return _tagA;
  }

  core.BuildOp tagIframe() {
    _tagIframe ??= TagIframe(this).buildOp;
    return _tagIframe;
  }

  core.BuildOp tagLi() {
    _tagLi ??= TagLi(this).buildOp;
    return _tagLi;
  }
}
