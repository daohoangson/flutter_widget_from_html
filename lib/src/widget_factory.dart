import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core;
import 'package:url_launcher/url_launcher.dart';

import 'config.dart';
import 'data_classes.dart';
import 'video_player.dart';
import 'web_view.dart';

part 'ops/tag_iframe.dart';
part 'ops/tag_video.dart';

class WidgetFactory extends core.WidgetFactory {
  Config _config;

  BuildOp _tagIframe;
  BuildOp _tagVideo;

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
  Widget buildGestureDetector(Widget child, GestureTapCallback onTap) =>
      InkWell(child: child, onTap: onTap);

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
    if (!_config.webView) return buildWebViewLinkOnly(url);

    final dimensOk = height != null && height > 0 && width != null && width > 0;
    return WebView(
      url,
      aspectRatio: dimensOk ? width / height : 16 / 9,
      getDimensions: !dimensOk && _config?.webViewJs == true,
      js: _config?.webViewJs == true,
      unsupportedWorkaroundForIssue37:
          _config?.unsupportedWebViewWorkaroundForIssue37 == true,
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
      case 'video':
        meta = lazySet(meta, buildOp: tagVideo());
        break;
    }

    return super.parseLocalName(meta, localName);
  }

  BuildOp tagIframe() {
    _tagIframe ??= TagIframe(this).buildOp;
    return _tagIframe;
  }

  BuildOp tagVideo() {
    _tagVideo ??= TagVideo(this).buildOp;
    return _tagVideo;
  }
}
