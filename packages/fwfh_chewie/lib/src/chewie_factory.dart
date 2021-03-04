import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import 'internal/tag_video.dart';
import 'video_player/video_player.dart';

/// A mixin that can build player for VIDEO.
mixin ChewieFactory on WidgetFactory {
  /// Builds [VideoPlayer].
  Widget? buildVideoPlayer(
    BuildMetadata meta,
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
        ? buildImage(meta, ImageMetadata(sources: [ImageSource(posterUrl)]))
        : null;
    return VideoPlayer(
      url,
      aspectRatio: dimensOk ? width! / height! : 16 / 9,
      autoResize: !dimensOk,
      autoplay: autoplay,
      controls: controls,
      loop: loop,
      poster: poster,
    );
  }

  @override
  void parse(BuildMetadata meta) {
    switch (meta.element.localName) {
      case kTagVideo:
        meta.register(TagVideo(this, meta).op);
        break;
    }
    return super.parse(meta);
  }
}
