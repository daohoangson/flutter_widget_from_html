part of '../ops.dart';

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
    if (e.localName != 'source') return;
    if (e.parent != videoMeta.domElement) return;

    final a = e.attributes;
    if (!a.containsKey('src')) return;

    final url = wf.urlFull(a['src']);
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
      autoplay: a.containsKey('autoplay'),
      controls: a.containsKey('controls'),
      height: a.containsKey('height') ? double.tryParse(a['height']) : null,
      loop: a.containsKey('loop'),
      posterUrl: a.containsKey('poster') ? wf.urlFull(a['poster']) : null,
      width: a.containsKey('width') ? double.tryParse(a['width']) : null,
    );
  }
}
