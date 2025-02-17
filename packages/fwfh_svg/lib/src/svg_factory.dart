// TODO: remove ignore for file when our minimum core version >= 1.0
// ignore_for_file: deprecated_member_use

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import 'internal/platform_specific/fallback.dart'
    if (dart.library.io) 'internal/platform_specific/io.dart';

const kAttributeSvgHeight = 'height';
const kAttributeSvgWidth = 'width';
const kTagSvg = 'svg';

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
  void parse(BuildMetadata meta) {
    switch (meta.element.localName) {
      case kTagSvg:
        meta.register(
          _tagSvg ??= BuildOp(
            // TODO: set debugLabel when our minimum core version >= 1.0
            defaultStyles: (element) {
              // other tags that share the same logic:
              // - IFRAME
              // - IMG
              //
              // consider update them together if this changes
              final attrs = element.attributes;
              final height = attrs[kAttributeSvgHeight];
              final width = attrs[kAttributeSvgWidth];

              return {
                'height': 'auto',
                'min-width': '0px',
                'min-height': '0px',
                'width': 'auto',
                if (height != null) 'height': height,
                if (width != null) 'width': width,
              };
            },
            onWidgets: (meta, widgets) {
              final bytesLoader = SvgStringLoader(meta.element.outerHtml);
              const src = ImageSource('');
              final built = _buildSvgPicture(meta, src, bytesLoader);
              return [built];
            },
          ),
        );
    }

    return super.parse(meta);
  }

  Widget _buildSvgPicture(
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
