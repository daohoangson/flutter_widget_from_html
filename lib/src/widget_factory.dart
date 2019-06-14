import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core;
import 'package:url_launcher/url_launcher.dart';

import 'data_classes.dart';
import 'html_widget.dart';
import 'web_view.dart';

part 'ops/tag_iframe.dart';

class WidgetFactory extends core.WidgetFactory {
  final HtmlWidget _htmlWidget;
  final Color _hyperlinkColor;

  BuildOp _tagIframe;

  WidgetFactory(BuildContext context, this._htmlWidget)
      : _hyperlinkColor = Theme.of(context).accentColor,
        super(_htmlWidget);

  Color get hyperlinkColor => _htmlWidget.hyperlinkColor ?? _hyperlinkColor;

  @override
  Widget buildDivider() => Divider(height: 1);

  @override
  Widget buildGestureDetector(Widget child, GestureTapCallback onTap) =>
      InkWell(child: child, onTap: onTap);

  @override
  GestureTapCallback buildGestureTapCallbackForUrl(String url) =>
      () => _htmlWidget.onTapUrl != null
          ? _htmlWidget.onTapUrl(url)
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
    if (_htmlWidget.webView != true) return buildWebViewLinkOnly(url);

    final dimensOk = height != null && height > 0 && width != null && width > 0;
    return WebView(
      url,
      aspectRatio: dimensOk ? width / height : 16 / 9,
      getDimensions: !dimensOk && _htmlWidget.webViewJs == true,
      interceptNavigationRequest: (newUrl) {
        if (newUrl == url) return false;

        buildGestureTapCallbackForUrl(newUrl)();
        return true;
      },
      js: _htmlWidget.webViewJs == true,
      unsupportedWorkaroundForIssue37:
          _htmlWidget?.unsupportedWebViewWorkaroundForIssue37 == true,
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
    _tagIframe ??= _TagIframe(this).buildOp;
    return _tagIframe;
  }
}
