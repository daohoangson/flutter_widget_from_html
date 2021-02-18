import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core show WidgetFactory;

import 'external/url_launcher.dart';
import 'internal/ops.dart';
import 'data.dart';
import 'helpers.dart';
import 'html_widget.dart';

/// A factory to build widgets with [WebView], [VideoPlayer], etc.
class WidgetFactory extends core.WidgetFactory {
  final _anchors = <String, GlobalKey>{};

  State _state;
  TextStyleHtml Function(TextStyleHtml, Null) _tagA;
  BuildOp _tagIframe;
  BuildOp _tagSvg;

  bool get _isFlutterSvgSupported => !kIsWeb;

  HtmlWidget get _widget => _state.widget;

  /// Builds [Divider].
  @override
  Widget buildDivider(BuildMetadata meta) => const Divider(height: 1);

  /// Builds [InkWell].
  @override
  Widget buildGestureDetector(
          BuildMetadata meta, Widget child, GestureTapCallback onTap) =>
      InkWell(child: child, onTap: onTap);

  /// Builds [SvgPicture] or [Image].
  @override
  Widget buildImage(BuildMetadata meta, Object provider, ImageMetadata data) {
    var built = super.buildImage(meta, provider, data);

    if (_isFlutterSvgSupported &&
        built == null &&
        provider is PictureProvider) {
      built = SvgPicture(provider);

      if (_widget?.onTapImage != null) {
        built = GestureDetector(
          child: built,
          onTap: () => _widget?.onTapImage?.call(data),
        );
      }
    }

    if (data.title != null && built != null) {
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
          ? buildImage(
              meta,
              imageProvider(posterImgSrc),
              ImageMetadata(sources: [posterImgSrc]),
            )
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
  GestureTapCallback gestureTapCallback(String url) =>
      url != null ? () => onTapUrl(url) : null;

  @override
  Iterable<dynamic> getDependencies(BuildContext context) =>
      [...super.getDependencies(context), Theme.of(context)];

  /// Returns flutter_svg.[PictureProvider] or [ImageProvider].
  @override
  Object imageProvider(ImageSource imgSrc) {
    if (imgSrc == null) return super.imageProvider(imgSrc);
    final url = imgSrc.url;

    if (Uri.tryParse(url)?.path?.toLowerCase()?.endsWith('.svg') == true) {
      return _imageSvgPictureProvider(url);
    }

    if (url.startsWith('data:image/svg+xml')) {
      return _imageSvgMemoryPicture(url);
    }

    if (url.startsWith('http')) {
      return _imageFromUrl(url);
    }

    return super.imageProvider(imgSrc);
  }

  Object _imageFromUrl(String url) =>
      url?.isNotEmpty == true ? CachedNetworkImageProvider(url) : null;

  Object _imageSvgMemoryPicture(String dataUri) {
    final bytes = bytesFromDataUri(dataUri);
    return bytes != null
        ? MemoryPicture(SvgPicture.svgByteDecoder, bytes)
        : null;
  }

  Object _imageSvgPictureProvider(String url) {
    if (url.startsWith('asset:')) {
      final uri = Uri.tryParse(url);
      final assetName = uri.path;
      if (assetName?.isNotEmpty != true) return null;

      final package = uri.queryParameters?.containsKey('package') == true
          ? uri.queryParameters['package']
          : null;

      return ExactAssetPicture(
        SvgPicture.svgStringDecoder,
        assetName,
        package: package,
      );
    }

    if (url.startsWith('file:')) {
      final uri = Uri.tryParse(url);
      final filePath = uri?.toFilePath();
      if (filePath?.isNotEmpty != true) return null;

      return FilePicture(SvgPicture.svgByteDecoder, File(uri.toFilePath()));
    }

    return NetworkPicture(SvgPicture.svgByteDecoder, url);
  }

  /// Handles user tapping a link.
  void onTapUrl(String url) {
    if (url == null) return;

    final callback = _widget?.onTapUrl;
    if (callback != null) return callback(url);

    if (url.startsWith('#')) {
      final id = url.substring(1);
      return onTapAnchor(id, _anchors[id]?.currentContext);
    }

    launchUrl(url);
  }

  /// Ensures anchor is visible.
  void onTapAnchor(String id, BuildContext anchorContext) {
    final renderObject = anchorContext?.findRenderObject();
    if (renderObject == null) return;

    final offsetToReveal = RenderAbstractViewport.of(renderObject)
        ?.getOffsetToReveal(renderObject, 0.0)
        ?.offset;
    final position = Scrollable.of(anchorContext)?.position;
    if (offsetToReveal == null || position == null) return;

    final alignment = (position.pixels > offsetToReveal)
        ? 0.0
        : (position.pixels < offsetToReveal ? 1.0 : null);
    if (alignment == null) return;

    position.ensureVisible(
      renderObject,
      alignment: alignment,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeIn,
    );
  }

  @override
  void parse(BuildMetadata meta) {
    final attrs = meta.element.attributes;

    switch (meta.element.localName) {
      case 'a':
        _tagA ??= (tsh, Null _) => tsh.copyWith(
            style: tsh.style
                .copyWith(color: tsh.getDependency<ThemeData>().accentColor));
        meta.enqueueTsb(_tagA, null);

        if (attrs.containsKey('name')) {
          meta.register(_anchorOp(attrs['name']));
        }
        break;
      case kTagIframe:
        _tagIframe ??= BuildOp(onWidgets: (meta, _) {
          final attrs = meta.element.attributes;
          final src = urlFull(attrs[kAttributeIframeSrc]);
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
      case 'svg':
        if (_isFlutterSvgSupported) {
          _tagSvg ??= BuildOp(
            onWidgets: (meta, _) => [SvgPicture.string(meta.element.outerHtml)],
          );
          meta.register(_tagSvg);
        }
        break;
      case kTagVideo:
        meta.register(TagVideo(this, meta).op);
        break;
    }

    if (attrs.containsKey('id')) {
      meta.register(_anchorOp(attrs['id']));
    }

    return super.parse(meta);
  }

  @override
  void reset(State state) {
    _anchors.clear();

    final widget = state.widget;
    if (widget is HtmlWidget) {
      _state = state;
    }

    super.reset(state);
  }

  BuildOp _anchorOp(String id) => BuildOp(onTree: (meta, tree) {
        final anchor = GlobalKey();
        _anchors[id] = anchor;
        tree.add(WidgetBit.inline(
          tree,
          WidgetPlaceholder('#$id').wrapWith(
            (context, _) => SizedBox(
              height: meta.tsb.build(context).style.fontSize,
              key: anchor,
            ),
          ),
        ));
      });
}
