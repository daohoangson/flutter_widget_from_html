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
  final BuildMetadata videoMeta;
  final ChewieFactory wf;

  final _sourceUrls = <String>[];

  late final BuildOp op;

  TagVideo(this.wf, this.videoMeta) {
    op = BuildOp(
      onChild: onChild,
      onWidgets: onWidgets,
    );
  }

  void onChild(BuildMetadata childMeta) {
    final e = childMeta.element;
    if (e.localName != kTagVideoSource) return;
    if (e.parent != videoMeta.element) return;

    final attrs = e.attributes;
    final url = wf.urlFull(attrs[kAttributeVideoSrc] ?? '');
    if (url == null) return;

    _sourceUrls.add(url);
  }

  Iterable<Widget>? onWidgets(BuildMetadata _, Iterable<WidgetPlaceholder> ws) {
    final player = _buildPlayer();
    if (player == null) return ws;

    return [WidgetPlaceholder<BuildMetadata>(videoMeta, child: player)];
  }

  Widget? _buildPlayer() {
    if (_sourceUrls.isEmpty) return null;

    final attrs = videoMeta.element.attributes;
    return wf.buildVideoPlayer(
      videoMeta,
      _sourceUrls.first,
      autoplay: attrs.containsKey(kAttributeVideoAutoplay),
      controls: attrs.containsKey(kAttributeVideoControls),
      height: tryParseDoubleFromMap(attrs, kAttributeVideoHeight),
      loop: attrs.containsKey(kAttributeVideoLoop),
      posterUrl: wf.urlFull(attrs[kAttributeVideoPoster] ?? ''),
      width: tryParseDoubleFromMap(attrs, kAttributeVideoWidth),
    );
  }
}
