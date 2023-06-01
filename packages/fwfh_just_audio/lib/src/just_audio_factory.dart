import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import 'audio_player/audio_player.dart';
import 'internal/tag_audio.dart';

/// A mixin that can build player for AUDIO.
mixin JustAudioFactory on WidgetFactory {
  BuildOp? _tagAudio;

  /// Builds [AudioPlayer].
  Widget? buildAudioPlayer(
    // ignore: deprecated_member_use
    BuildMetadata meta,
    String url, {
    required bool autoplay,
    required bool loop,
    required bool muted,
    required bool preload,
  }) =>
      AudioPlayer(
        url,
        autoplay: autoplay,
        loop: loop,
        muted: muted,
        preload: preload,
      );

  @override
  // ignore: deprecated_member_use
  void parse(BuildMetadata meta) {
    switch (meta.element.localName) {
      case kTagAudio:
        meta.register(_tagAudio ??= TagAudio(this).buildOp);
        break;
    }
    return super.parse(meta);
  }
}
