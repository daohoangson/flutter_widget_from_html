import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html_core/src/core_html_widget.dart'
    as core;
import 'package:flutter_widget_from_html_core/src/core_widget_factory.dart'
    as core;
import 'package:url_launcher/url_launcher.dart';

import 'builder.dart';
import 'data.dart';
import 'helpers.dart';
import 'html_widget.dart';

part 'ops/tag_a_extended.dart';
part 'ops/tag_iframe.dart';
part 'ops/tag_svg.dart';
part 'ops/tag_video.dart';

/// A factory to build widget for HTML elements
/// with support for [WebView] and [VideoPlayer] etc.
class WidgetFactory extends core.WidgetFactory {
  final HtmlConfig _config;

  BuildOp _tagAExtended;
  BuildOp _tagIframe;
  BuildOp _tagSvg;
  BuildOp _tagVideo;

  WidgetFactory(core.HtmlConfig config)
      : _config = config is HtmlConfig ? config : null,
        super(config);

  @override
  Widget buildDivider() => const Divider(height: 1);

  @override
  Iterable<Widget> buildGestureDetectors(
    BuildContext _,
    Iterable<Widget> widgets,
    GestureTapCallback onTap,
  ) =>
      widgets.map((widget) => InkWell(child: widget, onTap: onTap));

  @override
  GestureTapCallback buildGestureTapCallbackForUrl(String url) {
    if (url == null) return null;
    if (_config?.onTapUrl == null) {
      return () => canLaunch(url).then((ok) => ok ? launch(url) : null);
    }
    return () => _config.onTapUrl(url);
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
    if (_config?.webView != true) return buildWebViewLinkOnly(url);

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
  NodeMetadata parseTag(
    NodeMetadata meta,
    String tag,
    Map<dynamic, String> attributes,
  ) {
    switch (tag) {
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

    return super.parseTag(meta, tag, attributes);
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
