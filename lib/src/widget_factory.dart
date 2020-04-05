import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core;
import 'package:url_launcher/url_launcher.dart';

import 'config.dart';
import 'data_classes.dart';
import 'video_player.dart';
import 'web_view.dart';

part 'ops/tag_a_extended.dart';
part 'ops/tag_iframe.dart';
part 'ops/tag_svg.dart';
part 'ops/tag_video.dart';

class WidgetFactory extends core.WidgetFactory {
  final HtmlExtendedConfig _config;

  BuildOp _tagAExtended;
  BuildOp _tagIframe;
  BuildOp _tagSvg;
  BuildOp _tagVideo;

  WidgetFactory(core.HtmlConfig config)
      : _config = config is HtmlExtendedConfig ? config : null,
        super(config);

  @override
  Widget buildDivider() => const Divider(height: 1);

  @override
  Iterable<Widget> buildGestureDetectors(
    BuilderContext bc,
    Iterable<Widget> widgets,
    GestureTapCallback onTap,
  ) =>
      widgets.map((widget) => InkWell(child: widget, onTap: onTap));

  @override
  GestureTapCallback buildGestureTapCallbackForUrl(String url) {
    if (_config == null) return super.buildGestureTapCallbackForUrl(url);
    if (url == null) return null;
    if (_config.onTapUrl != null) return () => _config.onTapUrl(url);
    return () => canLaunch(url).then((ok) => ok ? launch(url) : null);
  }

  @override
  ImageProvider buildImageFromUrl(String url) =>
      url?.isNotEmpty == true ? CachedNetworkImageProvider(url) : null;

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
      case 'svg':
        // return asap to avoid being disabled by core
        return lazySet(meta, buildOp: tagSvg());
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

  BuildOp tagSvg() {
    _tagSvg ??= _TagSvg(this).buildOp;
    return _tagSvg;
  }

  BuildOp tagVideo() {
    _tagVideo ??= _TagVideo(this).buildOp;
    return _tagVideo;
  }
}
