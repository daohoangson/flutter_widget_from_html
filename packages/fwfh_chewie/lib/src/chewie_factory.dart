import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import 'internal/tag_video.dart';
import 'video_player/video_player.dart';

/// A mixin that can build player for VIDEO.
mixin ChewieFactory on WidgetFactory {
  BuildOp? _tagVideo;

  /// Builds [VideoPlayer].
  Widget? buildVideoPlayer(
    BuildTree tree,
    String url, {
    required bool autoplay,
    required bool controls,
    double? height,
    required bool loop,
    String? posterUrl,
    double? width,
  }) {
    final dimensOk = height != null && height > 0 && width != null && width > 0;
    final poster = posterUrl != null
        ? buildImage(tree, ImageMetadata(sources: [ImageSource(posterUrl)]))
        : null;
    return VideoPlayer(
      url,
      aspectRatio: dimensOk ? width / height : 16 / 9,
      autoResize: !dimensOk,
      autoplay: autoplay,
      controls: controls,
      errorBuilder: (context, _, error) =>
          onErrorBuilder(context, tree, error, url) ?? widget0,
      loadingBuilder: (context, _, child) =>
          onLoadingBuilder(context, tree, null, url) ?? widget0,
      loop: loop,
      poster: poster,
    );
  }

  @override
  void parse(BuildTree tree) {
    switch (tree.element.localName) {
      case kTagVideo:
        tree.register(_tagVideo ??= TagVideo(this).buildOp);
    }
    return super.parse(tree);
  }
}
