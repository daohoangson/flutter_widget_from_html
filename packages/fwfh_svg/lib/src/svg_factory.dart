import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import 'internal/platform_specific/fallback.dart'
    if (dart.library.io) 'internal/platform_specific/io.dart';

/// A mixin that can render SVG with `flutter_svg` plugin.
mixin SvgFactory on WidgetFactory {
  BuildOp? _tagSvg;

  /// If true, will allow the SVG to be drawn outside of the clip boundary of its viewBox.
  ///
  /// See [SvgPicture.allowDrawingOutsideViewBox]
  bool get svgAllowDrawingOutsideViewBox => false;

  @override
  Widget? buildImageWidget(BuildMetadata meta, ImageSource src) {
    final url = src.url;

    PictureProvider? provider;
    if (url.startsWith('data:image/svg+xml')) {
      provider = imageSvgFromDataUri(url);
    } else if (Uri.tryParse(url)?.path.toLowerCase().endsWith('.svg') == true) {
      if (url.startsWith('asset:')) {
        provider = imageSvgFromAsset(url);
      } else if (url.startsWith('file:')) {
        provider = imageSvgFromFileUri(url);
      } else {
        provider = imageSvgFromNetwork(url);
      }
    }

    if (provider == null) {
      return super.buildImageWidget(meta, src);
    }

    return _buildSvgPicture(meta, src, provider);
  }

  /// Returns an [ExactAssetPicture].
  PictureProvider? imageSvgFromAsset(String url) {
    final uri = Uri.parse(url);
    final assetName = uri.path;
    if (assetName.isEmpty) {
      return null;
    }

    return assetPictureProvider(
      this,
      assetName,
      uri.queryParameters['package'],
    );
  }

  /// Returns a [MemoryPicture].
  PictureProvider? imageSvgFromDataUri(String dataUri) {
    final bytes = bytesFromDataUri(dataUri);
    if (bytes == null) {
      return null;
    }

    return memoryPictureProvider(this, bytes);
  }

  /// Returns a [FilePicture].
  PictureProvider? imageSvgFromFileUri(String url) {
    final filePath = Uri.parse(url).toFilePath();
    if (filePath.isEmpty) {
      return null;
    }

    return filePictureProvider(this, filePath);
  }

  /// Returns a [NetworkPicture].
  PictureProvider? imageSvgFromNetwork(String url) =>
      url.isNotEmpty ? networkPictureProvider(this, url) : null;

  @override
  void parse(BuildMetadata meta) {
    switch (meta.element.localName) {
      case 'svg':
        _tagSvg ??= BuildOp(
          onWidgets: (meta, widgets) {
            final provider = stringPicture(this, meta.element.outerHtml);
            if (provider == null) {
              return widgets;
            }
            return [_buildSvgPicture(meta, const ImageSource(''), provider)];
          },
        );
        meta.register(_tagSvg!);
        break;
    }

    return super.parse(meta);
  }

  Widget _buildSvgPicture(
    BuildMetadata meta,
    ImageSource src,
    PictureProvider provider,
  ) {
    final image = src.image;
    final semanticLabel = image?.alt ?? image?.title;

    return SvgPicture(
      provider,
      allowDrawingOutsideViewBox: svgAllowDrawingOutsideViewBox,
      excludeFromSemantics: semanticLabel == null,
      fit: BoxFit.fill,
      height: src.height,
      placeholderBuilder: (context) {
        final loading = onLoadingBuilder(context, meta, null, src);
        if (loading != null) {
          return loading;
        }

        if (src.width != null && src.height != null) {
          return SizedBox(width: src.width, height: src.height);
        }

        return SvgPicture.defaultPlaceholderBuilder(context);
      },
      semanticsLabel: semanticLabel,
      width: src.width,
    );
  }
}
