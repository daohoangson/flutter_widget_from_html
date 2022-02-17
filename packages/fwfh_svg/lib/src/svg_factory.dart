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
  Widget? buildImageWidget(BuildTree tree, ImageSource src) {
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
      return super.buildImageWidget(tree, src);
    }

    return _buildSvgPicture(tree, src, provider);
  }

  /// Returns an [ExactAssetPicture].
  PictureProvider? imageSvgFromAsset(String url) {
    final uri = Uri.parse(url);
    final assetName = uri.path;
    if (assetName.isEmpty) {
      return null;
    }

    return ExactAssetPicture(
      svgAllowDrawingOutsideViewBox
          ? SvgPicture.svgStringDecoderOutsideViewBoxBuilder
          : SvgPicture.svgStringDecoderBuilder,
      assetName,
      package: uri.queryParameters['package'],
    );
  }

  /// Returns a [MemoryPicture].
  PictureProvider? imageSvgFromDataUri(String dataUri) {
    final bytes = bytesFromDataUri(dataUri);
    if (bytes == null) {
      return null;
    }

    return MemoryPicture(
      svgAllowDrawingOutsideViewBox
          ? SvgPicture.svgByteDecoderOutsideViewBoxBuilder
          : SvgPicture.svgByteDecoderBuilder,
      bytes,
    );
  }

  /// Returns a [FilePicture].
  PictureProvider? imageSvgFromFileUri(String url) {
    final filePath = Uri.parse(url).toFilePath();
    if (filePath.isEmpty) {
      return null;
    }

    return filePicture(
      svgAllowDrawingOutsideViewBox
          ? SvgPicture.svgByteDecoderOutsideViewBoxBuilder
          : SvgPicture.svgByteDecoderBuilder,
      filePath,
    );
  }

  /// Returns a [NetworkPicture].
  PictureProvider? imageSvgFromNetwork(String url) {
    if (url.isEmpty) {
      return null;
    }

    return NetworkPicture(
      svgAllowDrawingOutsideViewBox
          ? SvgPicture.svgByteDecoderOutsideViewBoxBuilder
          : SvgPicture.svgByteDecoderBuilder,
      url,
    );
  }

  @override
  void parse(BuildTree tree) {
    switch (tree.element.localName) {
      case 'svg':
        tree.register(
          _tagSvg ??= BuildOp(
            onWidgets: (tree, widgets) {
              final provider = StringPicture(
                svgAllowDrawingOutsideViewBox
                    ? SvgPicture.svgStringDecoderOutsideViewBoxBuilder
                    : SvgPicture.svgStringDecoderBuilder,
                tree.element.outerHtml,
              );
              return [_buildSvgPicture(tree, const ImageSource(''), provider)];
            },
          ),
        );
        break;
    }

    return super.parse(tree);
  }

  Widget _buildSvgPicture(
    BuildTree tree,
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
        final loading = onLoadingBuilder(context, tree, null, src);
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
