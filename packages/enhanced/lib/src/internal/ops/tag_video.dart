part of '../ops.dart';

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
  final WidgetFactory wf;

  final _sourceUrls = <String>[];

  BuildOp _videoOp;

  TagVideo(this.wf, this.videoMeta);

  BuildOp get op {
    _videoOp = BuildOp(
      onChild: onChild,
      onWidgets: onWidgets,
    );
    return _videoOp;
  }

  void onChild(BuildMetadata childMeta) {
    final e = childMeta.element;
    if (e.localName != kTagVideoSource) return;
    if (e.parent != videoMeta.element) return;

    final attrs = e.attributes;
    final url = attrs.containsKey(kAttributeVideoSrc)
        ? wf.urlFull(attrs[kAttributeVideoSrc])
        : null;
    if (url == null) return;

    _sourceUrls.add(url);
  }

  Iterable<Widget> onWidgets(BuildMetadata _, Iterable<WidgetPlaceholder> ws) {
    final player = build();
    if (player == null) return ws;

    return [WidgetPlaceholder<BuildMetadata>(videoMeta, child: player)];
  }

  Widget build() {
    if (_sourceUrls.isEmpty) return null;

    final attrs = videoMeta.element.attributes;
    return wf.buildVideoPlayer(
      videoMeta,
      _sourceUrls.first,
      autoplay: attrs.containsKey(kAttributeVideoAutoplay),
      controls: attrs.containsKey(kAttributeVideoControls),
      height: tryParseDoubleFromMap(attrs, kAttributeVideoHeight),
      loop: attrs.containsKey(kAttributeVideoLoop),
      posterUrl: attrs.containsKey(kAttributeVideoPoster)
          ? wf.urlFull(attrs[kAttributeVideoPoster])
          : null,
      width: tryParseDoubleFromMap(attrs, kAttributeVideoWidth),
    );
  }
}
