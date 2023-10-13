// TODO: remove ignore for file when our minimum core version >= 1.0
// ignore_for_file: deprecated_member_use

import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import 'audio_player/audio_player.dart';
import 'internal/tag_audio.dart';

/// A mixin that can build player for AUDIO.
mixin JustAudioFactory on WidgetFactory {
  BuildOp? _tagAudio;

  /// Builds [AudioPlayer].
  Widget? buildAudioPlayer(
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
  void parse(BuildMetadata meta) {
    switch (meta.element.localName) {
      case kTagAudio:
        _tagAudio ??= TagAudio(this).buildOp;
        meta.register(_tagAudio!);
        break;
    }
    return super.parse(meta);
  }
}
