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

  BuildOp get op => BuildOp(
        onWidgets: (meta, widgets) {
          if (defaultTargetPlatform != TargetPlatform.android &&
              defaultTargetPlatform != TargetPlatform.iOS &&
              defaultTargetPlatform != TargetPlatform.macOS &&
              !kIsWeb) {
            return widgets;
          }

          final attrs = meta.element.attributes;
          final url = wf.urlFull(attrs[kAttributeAudioSrc] ?? '');
          if (url == null) return widgets;

          return listOrNull(wf.buildAudioPlayer(
            meta,
            url,
            autoplay: attrs.containsKey(kAttributeAudioAutoplay),
            loop: attrs.containsKey(kAttributeAudioLoop),
            muted: attrs.containsKey(kAttributeAudioMuted),
            preload: attrs.containsKey(kAttributeAudioPreload)
                ? attrs[kAttributeAudioPreload] != kAttributeAudioPreloadNone
                : false,
          ));
        },
      );
}
