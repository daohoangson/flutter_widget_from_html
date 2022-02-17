import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

/// A mixin that can render IMG with `cached_network_image` plugin.
mixin CachedNetworkImageFactory on WidgetFactory {
  /// Uses a custom cache manager.
  BaseCacheManager? get cacheManager => null;

  @override
  Widget? buildImageWidget(BuildTree tree, ImageSource src) {
    final url = src.url;
    if (!url.startsWith(RegExp('https?://'))) {
      return super.buildImageWidget(tree, src);
    }

    return CachedNetworkImage(
      cacheManager: cacheManager,
      errorWidget: (context, _, error) =>
          onErrorBuilder(context, tree, error, src) ?? widget0,
      fit: BoxFit.fill,
      imageUrl: url,
      progressIndicatorBuilder: (context, _, progress) =>
          onLoadingBuilder(
            context,
            tree,
            progress.totalSize != null && progress.totalSize! > 0
                ? progress.downloaded / progress.totalSize!
                : null,
            src,
          ) ??
          widget0,
    );
  }
}
