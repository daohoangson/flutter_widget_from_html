import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core;
import 'package:url_launcher/url_launcher.dart';

import 'data_classes.dart';
import 'html_widget.dart';
import 'video_player.dart';
import 'web_view.dart';

part 'ops/tag_a_extended.dart';
part 'ops/tag_iframe.dart';
part 'ops/tag_video.dart';

class WidgetFactory extends core.WidgetFactory {
  final HtmlWidgetConfig _config;

  BuildOp _tagAExtended;
  BuildOp _tagIframe;
  BuildOp _tagVideo;

  WidgetFactory(this._config) : super(_config);

  @override
  Widget buildDivider() => Divider(height: 1);

  @override
  Widget buildGestureDetector(Widget child, GestureTapCallback onTap) =>
      InkWell(child: child, onTap: onTap);

  @override
  GestureTapCallback buildGestureTapCallbackForUrl(String url) => url != null
      ? () => _config.onTapUrl != null
          ? _config.onTapUrl(url)
          : canLaunch(url).then((ok) => ok ? launch(url) : null)
      : null;

  @override
  Widget buildImageFromUrl(String url) => url?.isNotEmpty == true
      ? CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
        )
      : null;

  Widget buildVideoPlayer(
    String url, {
    bool autoplay,
    bool controls,
    double height,
    bool loop,
    double width,
  }) {
    final dimensOk = height != null && height > 0 && width != null && width > 0;
    return VideoPlayer(
      url,
      aspectRatio: dimensOk ? width / height : 16 / 9,
      autoResize: !dimensOk,
      autoplay: autoplay,
      controls: controls,
      loop: loop,
    );
  }

  Widget buildWebView(
    String url, {
    double height,
    double width,
  }) {
    if (_config.webView != true) return buildWebViewLinkOnly(url);

    final dimensOk = height != null && height > 0 && width != null && width > 0;
    return WebView(
      url,
      aspectRatio: dimensOk ? width / height : 16 / 9,
      getDimensions: !dimensOk && _config.webViewJs == true,
      interceptNavigationRequest: (newUrl) {
        if (newUrl == url) return false;

        buildGestureTapCallbackForUrl(newUrl)();
        return true;
      },
      js: _config.webViewJs == true,
      unsupportedWorkaroundForIssue37:
          _config.unsupportedWebViewWorkaroundForIssue37 == true,
    );
  }

  Widget buildWebViewLinkOnly(String url) => GestureDetector(
        child: Text(url),
        onTap: buildGestureTapCallbackForUrl(url),
      );

  @override
  NodeMetadata parseLocalName(NodeMetadata meta, String localName) {
    switch (localName) {
      case 'a':
        meta = lazySet(meta, buildOp: tagAExtended());
        break;
      case 'iframe':
        // return asap to avoid being disabled by core
        return lazySet(meta, buildOp: tagIframe());
      case 'video':
        meta = lazySet(meta, buildOp: tagVideo());
        break;
    }

    return super.parseLocalName(meta, localName);
  }

  BuildOp tagAExtended() {
    _tagAExtended ??= _TagAExtended().buildOp;
    return _tagAExtended;
  }

  BuildOp tagIframe() {
    _tagIframe ??= _TagIframe(this).buildOp;
    return _tagIframe;
  }

  BuildOp tagVideo() {
    _tagVideo ??= _TagVideo(this).buildOp;
    return _tagVideo;
  }
}
