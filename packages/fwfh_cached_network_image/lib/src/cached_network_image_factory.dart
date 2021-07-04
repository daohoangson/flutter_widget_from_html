import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

/// A mixin that can render IMG with `cached_network_image` plugin.
mixin CachedNetworkImageFactory on WidgetFactory {
  @override
  Widget? buildImageWidget(BuildMetadata meta, ImageSource src) {
    final url = src.url;

    if (url.isEmpty) return null;

    // Use default image loading for assets, data images and files
    if (url.startsWith('asset:') ||
        url.startsWith('data:image/') ||
        url.startsWith('file:')) {
      return super.buildImageWidget(meta, src);
    }

    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.fill,
      placeholder: (context, url) => imageLoadingBuilder(
        context,
        Container(),
        ImageChunkEvent(cumulativeBytesLoaded: 1, expectedTotalBytes: 1),
        src,
      ),
      errorWidget: (_1, _2, _3) => imageErrorBuilder(_1, _3, null, src),
    );
  }
}
