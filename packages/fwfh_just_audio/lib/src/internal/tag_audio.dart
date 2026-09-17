// TODO: remove ignore for file when our minimum core version >= 1.0
// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../just_audio_factory.dart';

const kAttributeAudioAutoplay = 'autoplay';
const kAttributeAudioLoop = 'loop';
const kAttributeAudioMuted = 'muted';
const kAttributeAudioPreload = 'preload';
const kAttributeAudioPreloadNone = 'none';
const kAttributeAudioSrc = 'src';

const kTagAudio = 'audio';

class TagAudio {
  final JustAudioFactory wf;

  TagAudio(this.wf);

  BuildOp get buildOp => BuildOp(
        // TODO: set debugLabel when our minimum core version >= 1.0
        onWidgets: (meta, widgets) {
          if (defaultTargetPlatform != TargetPlatform.android &&
              defaultTargetPlatform != TargetPlatform.iOS &&
              defaultTargetPlatform != TargetPlatform.macOS &&
              !kIsWeb) {
            // these are the just_audio's supported platforms
            // https://pub.dev/packages/just_audio/versions/0.9.5
            return widgets;
          }

          final attrs = meta.element.attributes;
          final url = wf.urlFull(attrs[kAttributeAudioSrc] ?? '');
          if (url == null) {
            return widgets;
          }

          final built = wf.buildAudioPlayer(
            meta,
            url,
            autoplay: attrs.containsKey(kAttributeAudioAutoplay),
            loop: attrs.containsKey(kAttributeAudioLoop),
            muted: attrs.containsKey(kAttributeAudioMuted),
            preload: attrs.containsKey(kAttributeAudioPreload) &&
                attrs[kAttributeAudioPreload] != kAttributeAudioPreloadNone,
          );

          return listOrNull(built) ?? widgets;
        },
      );
}
