import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core;
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    show BuildOp, BuiltPiece, BuiltPieceSimple, NodeMetadata, TextBlock, lazySet;
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'config.dart';

part 'ops/tag_a.dart';
part 'ops/tag_iframe.dart';
part 'ops/tag_li.dart';

final _baseUriTrimmingRegExp = RegExp(r'/+$');
final _isFullUrlRegExp = RegExp(r'^(https?://|mailto:|tel:)');

class WidgetFactory extends core.WidgetFactory {
  final Config config;

  BuildOp _tagA;
  BuildOp _tagIframe;
  BuildOp _tagLi;

  WidgetFactory(
    BuildContext context, {
    this.config = const Config(),
  }) : super(context);

  @override
  Widget buildDivider() => Divider(height: 1);

  GestureTapCallback buildGestureTapCallbackForUrl(String fullUrl) =>
      () => canLaunch(fullUrl).then((ok) => ok ? launch(fullUrl) : null);

  @override
  Widget buildImage(String src, {int height, String text, int width}) =>
      buildPadding(
        super.buildImage(src, height: height, text: text, width: width),
        config.imagePadding,
      );

  @override
  Widget buildImageFromUrl(String url) {
    final imageUrl = constructFullUrl(url);
    if (imageUrl?.isEmpty != false) return null;

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget buildText({
    TextBlock block,
    String text,
    TextAlign textAlign,
  }) =>
      buildPadding(
        super.buildText(
          block: block,
          text: text,
          textAlign: textAlign,
        ),
        config.textPadding,
      );

  Widget buildWebView(
    String initialUrl, {
    double height,
    double width,
  }) =>
      buildPadding(
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
        child: buildText(text: fullUrl),
        onTap: buildGestureTapCallbackForUrl(fullUrl),
      );

  String constructFullUrl(String url) {
    if (url?.isNotEmpty != true) return null;
    if (url.startsWith(_isFullUrlRegExp)) return url;

    final b = config.baseUrl;
    if (b == null) return null;

    if (url.startsWith('//')) return "${b.scheme}:$url";

    if (url.startsWith('/')) {
      final port = b.hasPort ? ":${b.port}" : '';
      return "${b.scheme}://${b.host}$port$url";
    }

    return "${b.toString().replaceAll(_baseUriTrimmingRegExp, '')}/$url";
  }

  @override
  NodeMetadata parseElement(NodeMetadata meta, dom.Element e) {
    switch (e.localName) {
      case 'a':
        meta = lazySet(meta, buildOp: tagA());
        break;

      case 'iframe':
        // return asap to avoid being disabled by core
        return lazySet(meta, buildOp: tagIframe());

      case kTagListItem:
      case kTagOrderedList:
      case kTagUnorderedList:
        meta = lazySet(meta, buildOp: tagLi());
        break;
    }

    return super.parseElement(meta, e);
  }

  BuildOp tagA() {
    _tagA ??= TagA(this).buildOp;
    return _tagA;
  }

  BuildOp tagIframe() {
    _tagIframe ??= TagIframe(this).buildOp;
    return _tagIframe;
  }

  BuildOp tagLi() {
    _tagLi ??= TagLi(this).buildOp;
    return _tagLi;
  }
}
