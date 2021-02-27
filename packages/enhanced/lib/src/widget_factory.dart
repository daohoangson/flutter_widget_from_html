import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core show WidgetFactory;
import 'package:fwfh_svg/fwfh_svg.dart';
import 'package:fwfh_url_launcher/fwfh_url_launcher.dart';

import 'internal/ops.dart';
import 'data.dart';
import 'helpers.dart';
import 'html_widget.dart';

/// A factory to build widgets with [WebView], [VideoPlayer], etc.
class WidgetFactory extends core.WidgetFactory
    with SvgFactory, UrlLauncherFactory {
  TextStyleHtml Function(TextStyleHtml, dynamic) _tagA;
  BuildOp _tagIframe;
  HtmlWidget _widget;

  /// Builds [Divider].
  @override
  Widget buildDivider(BuildMetadata meta) => const Divider(height: 1);

  /// Builds [InkWell].
  @override
  Widget buildGestureDetector(
          BuildMetadata meta, Widget child, GestureTapCallback onTap) =>
      InkWell(child: child, onTap: onTap);

  @override
  Widget buildImage(BuildMetadata meta, ImageMetadata data) {
    var built = super.buildImage(meta, data);

    if (built != null && data.title != null) {
      built = Tooltip(child: built, message: data.title);
    }

    return built;
  }

  /// Builds [VideoPlayer].
  Widget buildVideoPlayer(
    BuildMetadata meta,
    String url, {
    bool autoplay,
    bool controls,
    double height,
    bool loop,
    String posterUrl,
    double width,
  }) {
    final dimensOk = height != null && height > 0 && width != null && width > 0;
    final posterImgSrc = posterUrl != null ? ImageSource(posterUrl) : null;
    return VideoPlayer(
      url,
      aspectRatio: dimensOk ? width / height : 16 / 9,
      autoResize: !dimensOk,
      autoplay: autoplay,
      controls: controls,
      loop: loop,
      poster: posterImgSrc != null
          ? buildImage(meta, ImageMetadata(sources: [posterImgSrc]))
          : null,
    );
  }

  /// Builds [WebView].
  ///
  /// JavaScript is only enabled if [HtmlWidget.webViewJs] is turned on
  /// AND sandbox restrictions are unset (no `sandbox` attribute)
  /// or `allow-scripts` is explicitly allowed.
  Widget buildWebView(
    BuildMetadata meta,
    String url, {
    double height,
    List<String> sandbox,
    double width,
  }) {
    if (_widget?.webView != true) return buildWebViewLinkOnly(meta, url);

    final dimensOk = height != null && height > 0 && width != null && width > 0;
    final js = _widget.webViewJs == true &&
        (sandbox == null ||
            sandbox.contains(kAttributeIframeSandboxAllowScripts));
    return WebView(
      url,
      aspectRatio: dimensOk ? width / height : 16 / 9,
      autoResize: !dimensOk && js,
      debuggingEnabled: _widget.webViewDebuggingEnabled == true,
      interceptNavigationRequest: (newUrl) {
        if (newUrl == url) return false;

        gestureTapCallback(newUrl)();
        return true;
      },
      js: js,
      mediaPlaybackAlwaysAllow: _widget.webViewMediaPlaybackAlwaysAllow == true,
      unsupportedWorkaroundForIssue37:
          _widget.unsupportedWebViewWorkaroundForIssue37 == true,
      unsupportedWorkaroundForIssue375:
          _widget.unsupportedWebViewWorkaroundForIssue375 == true,
      userAgent: _widget.webViewUserAgent,
    );
  }

  /// Builds fallback link when [HtmlWidget.webView] is disabled.
  Widget buildWebViewLinkOnly(BuildMetadata meta, String url) =>
      GestureDetector(
        child: Text(url),
        onTap: gestureTapCallback(url),
      );

  @override
  Iterable<dynamic> getDependencies(BuildContext context) =>
      [...super.getDependencies(context), Theme.of(context)];

  @override
  ImageProvider imageProviderFromNetwork(String url) =>
      url?.isNotEmpty == true ? CachedNetworkImageProvider(url) : null;

  @override
  void parse(BuildMetadata meta) {
    switch (meta.element.localName) {
      case 'a':
        _tagA ??= (tsh, _) => tsh.copyWith(
            style: tsh.style
                .copyWith(color: tsh.getDependency<ThemeData>().accentColor));
        meta.tsb.enqueue(_tagA);
        break;
      case kTagIframe:
        _tagIframe ??= BuildOp(onWidgets: (meta, _) {
          final attrs = meta.element.attributes;
          final src = urlFull(attrs[kAttributeIframeSrc] ?? '');
          if (src == null) return null;

          return listOrNull(buildWebView(
            meta,
            src,
            height: tryParseDoubleFromMap(attrs, kAttributeIframeHeight),
            sandbox: attrs[kAttributeIframeSandbox]?.split(RegExp(r'\s+')),
            width: tryParseDoubleFromMap(attrs, kAttributeIframeWidth),
          ));
        });
        meta.register(_tagIframe);
        break;
      case kTagVideo:
        meta.register(TagVideo(this, meta).op);
        break;
    }

    return super.parse(meta);
  }

  @override
  void reset(State state) {
    final widget = state.widget;
    _widget = widget is HtmlWidget ? widget : null;

    super.reset(state);
  }
}
