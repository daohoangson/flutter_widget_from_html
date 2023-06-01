import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

/// A mixin that can render IMG with `cached_network_image` plugin.
mixin CachedNetworkImageFactory on WidgetFactory {
  /// Uses a custom cache manager.
  BaseCacheManager? get cacheManager => null;

  @override
  // ignore: deprecated_member_use
  Widget? buildImageWidget(BuildMetadata meta, ImageSource src) {
    final url = src.url;
    if (!url.startsWith(RegExp('https?://'))) {
      return super.buildImageWidget(meta, src);
    }

    return CachedNetworkImage(
      cacheManager: cacheManager,
      errorWidget: (context, _, error) =>
          onErrorBuilder(context, meta, error, src) ?? widget0,
      fit: BoxFit.fill,
      imageUrl: url,
      progressIndicatorBuilder: (context, _, progress) {
        final t = progress.totalSize;
        final v = t != null && t > 0 ? progress.downloaded / t : null;
        return onLoadingBuilder(context, meta, v, src) ?? widget0;
      },
    );
  }
}
