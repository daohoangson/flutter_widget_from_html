import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

/// A mixin that can render IMG with `cached_network_image` plugin.
mixin CachedNetworkImageFactory on WidgetFactory {
  @override
  Widget? buildImageWidget(BuildMetadata meta, ImageSource src) {
    final url = src.url;
    if (!url.startsWith(RegExp('https?://'))) {
      return super.buildImageWidget(meta, src);
    }

    return CachedNetworkImage(
      errorWidget: (context, _, error) =>
          imageErrorBuilder(context, error, null, src),
      fit: BoxFit.fill,
      imageUrl: url,
      progressIndicatorBuilder: (context, _, progress) => imageLoadingBuilder(
          context,
          const SizedBox.shrink(),
          ImageChunkEvent(
            cumulativeBytesLoaded: progress.downloaded,
            expectedTotalBytes: progress.totalSize,
          ),
          src,
        ),
    );
  }
}
