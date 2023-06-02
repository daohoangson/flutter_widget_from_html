import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../chewie_factory.dart';

const kAttributeVideoAutoplay = 'autoplay';
const kAttributeVideoControls = 'controls';
const kAttributeVideoHeight = 'height';
const kAttributeVideoLoop = 'loop';
const kAttributeVideoPoster = 'poster';
const kAttributeVideoSrc = 'src';
const kAttributeVideoWidth = 'width';

const kTagVideo = 'video';
const kTagVideoSource = 'source';

class TagVideo {
  final ChewieFactory wf;

  TagVideo(this.wf);

  BuildOp get buildOp => BuildOp(
        debugLabel: kTagVideo,
        onChild: (tree, subTree) {
          final e = subTree.element;
          if (e.localName != kTagVideoSource) {
            return;
          }
          if (e.parent != tree.element) {
            return;
          }

          final attrs = e.attributes;
          final url = wf.urlFull(attrs[kAttributeVideoSrc] ?? '');
          if (url == null) {
            return;
          }

          tree.sourceUrls = [...tree.sourceUrls, url];
        },
        onRenderBlock: (tree, placeholder) {
          if (defaultTargetPlatform != TargetPlatform.android &&
              defaultTargetPlatform != TargetPlatform.iOS &&
              !kIsWeb) {
            // these are the chewie's supported platforms
            // https://pub.dev/packages/chewie/versions/1.2.2
            return placeholder;
          }

          final attrs = tree.element.attributes;
          final url = wf.urlFull(attrs[kAttributeVideoSrc] ?? '');
          if (url != null) {
            tree.sourceUrls = [...tree.sourceUrls, url];
          }

          return _buildPlayer(tree) ?? placeholder;
        },
      );

  Widget? _buildPlayer(BuildTree tree) {
    final sourceUrls = tree.sourceUrls;
    if (sourceUrls.isEmpty) {
      return null;
    }

    final attrs = tree.element.attributes;
    return wf.buildVideoPlayer(
      tree,
      sourceUrls.first,
      autoplay: attrs.containsKey(kAttributeVideoAutoplay),
      controls: attrs.containsKey(kAttributeVideoControls),
      height: tryParseDoubleFromMap(attrs, kAttributeVideoHeight),
      loop: attrs.containsKey(kAttributeVideoLoop),
      posterUrl: wf.urlFull(attrs[kAttributeVideoPoster] ?? ''),
      width: tryParseDoubleFromMap(attrs, kAttributeVideoWidth),
    );
  }
}

extension on BuildTree {
  Iterable<String> get sourceUrls =>
      value<_TagVideoData>()?.sourceUrls ?? const [];

  set sourceUrls(Iterable<String> v) {
    value(_TagVideoData(v));
  }
}

@immutable
class _TagVideoData {
  final Iterable<String> sourceUrls;
  const _TagVideoData(this.sourceUrls);
}
