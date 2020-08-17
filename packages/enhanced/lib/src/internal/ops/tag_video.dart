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
  final NodeMetadata videoMeta;
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

  void onChild(NodeMetadata childMeta, dom.Element e) {
    if (e.localName != kTagVideoSource) return;
    if (e.parent != videoMeta.domElement) return;

    final a = e.attributes;
    if (!a.containsKey(kAttributeVideoSrc)) return;

    final url = wf.urlFull(a[kAttributeVideoSrc]);
    if (url == null) return;

    _sourceUrls.add(url);
  }

  Iterable<WidgetPlaceholder> onWidgets(
      NodeMetadata _, Iterable<WidgetPlaceholder> widgets) {
    final player = build();
    if (player == null) return widgets;

    return [
      WidgetPlaceholder<NodeMetadata>(child: player, generator: videoMeta),
    ];
  }

  Widget build() {
    if (_sourceUrls.isEmpty) return null;

    final a = videoMeta.domElement.attributes;
    return wf.buildVideoPlayer(
      videoMeta,
      _sourceUrls.first,
      autoplay: a.containsKey(kAttributeVideoAutoplay),
      controls: a.containsKey(kAttributeVideoControls),
      height: a.containsKey(kAttributeVideoHeight)
          ? double.tryParse(a[kAttributeVideoHeight])
          : null,
      loop: a.containsKey(kAttributeVideoLoop),
      posterUrl: a.containsKey(kAttributeVideoPoster)
          ? wf.urlFull(a[kAttributeVideoPoster])
          : null,
      width: a.containsKey(kAttributeVideoWidth)
          ? double.tryParse(a[kAttributeVideoWidth])
          : null,
    );
  }
}
