import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

/// A mixin that can render IMG with `cached_network_image` plugin.
mixin CachedNetworkImageFactory on WidgetFactory {
  @override
  ImageProvider? imageProviderFromNetwork(String url) =>
      url.isNotEmpty ? CachedNetworkImageProvider(url) : null;
}
