// TODO: remove ignore for file when our minimum core version >= 1.0
// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../just_audio_factory.dart';

const kAttributeAudioAutoplay = 'autoplay';
const kAttributeAudioLoop = 'loop';
const kAttributeAudioMuted = 'muted';
const kAttributeAudioPreload = 'preload';
const kAttributeAudioPreloadNone = 'none';
const kAttributeAudioSrc = 'src';

const kTagAudio = 'audio';
const kTagAudioSource = 'source';

class TagAudio {
  final JustAudioFactory wf;

  TagAudio(this.wf);

  BuildOp get buildOp => BuildOp(
        debugLabel: kTagAudio,
        onRenderBlock: (tree, placeholder) {
          if (defaultTargetPlatform != TargetPlatform.android &&
              defaultTargetPlatform != TargetPlatform.iOS &&
              defaultTargetPlatform != TargetPlatform.macOS &&
              !kIsWeb) {
            // these are the just_audio's supported platforms
            // https://pub.dev/packages/just_audio/versions/0.9.5
            return placeholder;
          }

          final attrs = tree.element.attributes;
          final url = wf.urlFull(attrs[kAttributeAudioSrc] ?? '');
          if (url != null) {
            tree.audioData.urls.add(url);
          }

          return _buildPlayer(tree) ?? placeholder;
        },
        onVisitChild: (tree, subTree) {
          final e = subTree.element;
          if (e.localName != kTagAudioSource) {
            return;
          }
          if (e.parent != tree.element) {
            return;
          }

          final attrs = e.attributes;
          final url = wf.urlFull(attrs[kAttributeAudioSrc] ?? '');
          if (url == null) {
            return;
          }

          tree.audioData.urls.add(url);
        },
      );

  Widget? _buildPlayer(BuildTree tree) {
    final sourceUrls = tree.audioData.urls;
    if (sourceUrls.isEmpty) {
      return null;
    }

    final attrs = tree.element.attributes;
    return wf.buildAudioPlayer(
      tree,
      sourceUrls.first,
      autoplay: attrs.containsKey(kAttributeAudioAutoplay),
      loop: attrs.containsKey(kAttributeAudioLoop),
      muted: attrs.containsKey(kAttributeAudioMuted),
      preload: attrs.containsKey(kAttributeAudioPreload) &&
          attrs[kAttributeAudioPreload] != kAttributeAudioPreloadNone,
    );
  }
}

extension on BuildTree {
  _TagAudioData get audioData =>
      getNonInherited<_TagAudioData>() ?? setNonInherited(_TagAudioData());
}

@immutable
class _TagAudioData {
  final urls = <String>[];
}
