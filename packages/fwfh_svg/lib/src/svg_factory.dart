import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import 'internal/platform_specific/fallback.dart'
    if (dart.library.io) 'internal/platform_specific/io.dart';

/// A mixin that can render SVG with `flutter_svg` plugin.
mixin SvgFactory on WidgetFactory {
  BuildOp? _tagSvg;

  /// Controls whether the SVG can be drawn outside
  /// of the clip boundary of its view box.
  /// See [SvgPicture.allowDrawingOutsideViewBox] for more information.
  ///
  /// Default: `false`.
  bool get svgAllowDrawingOutsideViewBox => false;

  @override
  // ignore: deprecated_member_use
  Widget? buildImageWidget(BuildMetadata meta, ImageSource src) {
    final url = src.url;

    BytesLoader? bytesLoader;
    if (url.startsWith('data:image/svg+xml')) {
      bytesLoader = imageSvgFromDataUri(url);
    } else if (Uri.tryParse(url)?.path.toLowerCase().endsWith('.svg') == true) {
      if (url.startsWith('asset:')) {
        bytesLoader = imageSvgFromAsset(url);
      } else if (url.startsWith('file:')) {
        bytesLoader = imageSvgFromFileUri(url);
      } else {
        bytesLoader = imageSvgFromNetwork(url);
      }
    }

    if (bytesLoader == null) {
      return super.buildImageWidget(meta, src);
    }

    return _buildSvgPicture(meta, src, bytesLoader);
  }

  /// Returns an [SvgAssetLoader].
  BytesLoader? imageSvgFromAsset(String url) {
    final uri = Uri.parse(url);
    final assetName = uri.path;
    if (assetName.isEmpty) {
      return null;
    }

    return SvgAssetLoader(
      assetName,
      packageName: uri.queryParameters['package'],
    );
  }

  /// Returns a [SvgBytesLoader].
  BytesLoader? imageSvgFromDataUri(String dataUri) {
    final bytes = bytesFromDataUri(dataUri);
    if (bytes == null) {
      return null;
    }

    return SvgBytesLoader(bytes);
  }

  /// Returns a [SvgFileLoader].
  BytesLoader? imageSvgFromFileUri(String url) {
    final filePath = Uri.parse(url).toFilePath();
    if (filePath.isEmpty) {
      return null;
    }

    return fileLoader(filePath);
  }

  /// Returns a [SvgNetworkLoader].
  BytesLoader? imageSvgFromNetwork(String url) {
    if (url.isEmpty) {
      return null;
    }

    return SvgNetworkLoader(url);
  }

  @override
  // ignore: deprecated_member_use
  void parse(BuildMetadata meta) {
    final localName = meta.element.localName;

    switch (localName) {
      case 'svg':
        meta.register(
          // ignore: deprecated_member_use
          _tagSvg ??= BuildOp(
            onWidgets: (meta, widgets) {
              final bytesLoader = SvgStringLoader(meta.element.outerHtml);
              return [
                _buildSvgPicture(meta, const ImageSource(''), bytesLoader)
              ];
            },
          ),
        );
        break;
    }

    return super.parse(meta);
  }

  Widget _buildSvgPicture(
    // ignore: deprecated_member_use
    BuildMetadata meta,
    ImageSource src,
    BytesLoader bytesLoader,
  ) {
    final image = src.image;
    final semanticLabel = image?.alt ?? image?.title;

    return SvgPicture(
      bytesLoader,
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
