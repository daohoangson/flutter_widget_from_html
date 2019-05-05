import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core;
import 'package:url_launcher/url_launcher.dart';

import 'config.dart';
import 'data_classes.dart';
import 'web_view.dart';

part 'ops/tag_iframe.dart';

class WidgetFactory extends core.WidgetFactory {
  Config _config;

  BuildOp _tagIframe;

  @override
  set config(core.Config config) {
    super.config = config;
    if (config is Config) _config = config;
  }

  @override
  Config get config => _config;

  @override
  Widget buildDivider() => Divider(height: 1);

  @override
  GestureTapCallback buildGestureTapCallbackForUrl(String url) =>
      () => _config.onTapUrl != null
          ? _config.onTapUrl(url)
          : canLaunch(url).then((ok) => ok ? launch(url) : null);

  @override
  Widget buildImageFromUrl(String url) => CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
      );

  Widget buildWebView(
    String url, {
    double height,
    double width,
  }) {
    if (!_config.webView) return buildWebViewLinkOnly(url);

    final dimensOk = height != null && height > 0 && width != null && width > 0;
    return WebView(
      url,
      aspectRatio: dimensOk ? width / height : 16 / 9,
      getDimensions: !dimensOk && _config?.webViewJs == true,
      js: _config?.webViewJs == true,
    );
  }

  Widget buildWebViewLinkOnly(String url) => GestureDetector(
        child: Text(url),
        onTap: buildGestureTapCallbackForUrl(url),
      );

  @override
  NodeMetadata parseLocalName(NodeMetadata meta, String localName) {
    switch (localName) {
      case 'iframe':
        // return asap to avoid being disabled by core
        return lazySet(meta, buildOp: tagIframe());
    }

    return super.parseLocalName(meta, localName);
  }

  BuildOp tagIframe() {
    _tagIframe ??= TagIframe(this).buildOp;
    return _tagIframe;
  }
}
