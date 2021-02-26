import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core show WidgetFactory;
import 'package:fwfh_url_launcher/fwfh_url_launcher.dart';
import 'package:fwfh_webview/fwfh_webview.dart';

import 'internal/ops.dart';
import 'internal/platform_specific/fallback.dart'
    if (dart.library.io) 'internal/platform_specific/io.dart';
import 'data.dart';
import 'helpers.dart';
import 'html_widget.dart';

/// A factory to build widgets with [WebView], [VideoPlayer], etc.
class WidgetFactory extends core.WidgetFactory
    with UrlLauncherFactory, WebViewFactory {
  TextStyleHtml Function(TextStyleHtml, dynamic) _tagA;
  BuildOp _tagSvg;
  HtmlWidget _widget;

  @override
  bool get webView => _widget?.webView == true;

  @override
  bool get webViewDebuggingEnabled => _widget?.webViewDebuggingEnabled == true;

  @override
  bool get webViewJs => _widget?.webViewJs == true;

  @override
  bool get webViewMediaPlaybackAlwaysAllow =>
      _widget?.webViewMediaPlaybackAlwaysAllow == true;

  @override
  String get webViewUserAgent => _widget?.webViewUserAgent;

  bool get _isFlutterSvgSupported => !kIsWeb;

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

  @override
  Widget buildImageWidget(
    BuildMetadata meta, {
    String semanticLabel,
    @required String url,
  }) {
    PictureProvider provider;
    if (_isFlutterSvgSupported) {
      if (url.startsWith('data:image/svg+xml')) {
        provider = imageSvgFromDataUri(url);
      } else if (Uri.tryParse(url)?.path?.toLowerCase()?.endsWith('.svg') ==
          true) {
        if (url.startsWith('asset:')) {
          provider = imageSvgFromAsset(url);
        } else if (url.startsWith('file:')) {
          provider = imageSvgFromFileUri(url);
        } else {
          provider = imageSvgFromNetwork(url);
        }
      }
    }

    if (provider == null) {
      return super.buildImageWidget(
        meta,
        semanticLabel: semanticLabel,
        url: url,
      );
    }

    return SvgPicture(
      provider,
      excludeFromSemantics: semanticLabel == null,
      semanticsLabel: semanticLabel,
    );
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

  @override
  Iterable<dynamic> getDependencies(BuildContext context) =>
      [...super.getDependencies(context), Theme.of(context)];

  @override
  ImageProvider imageProviderFromNetwork(String url) =>
      url?.isNotEmpty == true ? CachedNetworkImageProvider(url) : null;

  /// Returns an [ExactAssetPicture].
  PictureProvider imageSvgFromAsset(String url) {
    final uri = Uri.parse(url);
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

  /// Returns a [MemoryPicture].
  PictureProvider imageSvgFromDataUri(String dataUri) {
    final bytes = bytesFromDataUri(dataUri);
    if (bytes == null) return null;

    return MemoryPicture(SvgPicture.svgByteDecoder, bytes);
  }

  /// Returns a [FilePicture].
  PictureProvider imageSvgFromFileUri(String url) {
    final filePath = Uri.parse(url).toFilePath();
    if (filePath.isEmpty) return null;

    return filePictureProvider(filePath);
  }

  /// Returns a [NetworkPicture].
  PictureProvider imageSvgFromNetwork(String url) =>
      url.isNotEmpty ? NetworkPicture(SvgPicture.svgByteDecoder, url) : null;

  @override
  void parse(BuildMetadata meta) {
    switch (meta.element.localName) {
      case 'a':
        _tagA ??= (tsh, _) => tsh.copyWith(
            style: tsh.style
                .copyWith(color: tsh.getDependency<ThemeData>().accentColor));
        meta.tsb.enqueue(_tagA);
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

    return super.parse(meta);
  }

  @override
  void reset(State state) {
    final widget = state.widget;
    _widget = widget is HtmlWidget ? widget : null;

    super.reset(state);
  }
}
