part of '../widget_factory.dart';

class _TagVideo extends BuildOp {
  final NodeMetadata videoMeta;
  final WidgetFactory wf;

  final _sourceUrls = <String>[];

  _TagVideo(this.wf, this.videoMeta) : super(isBlockElement: true);

  @override
  bool get hasOnChild => true;

  @override
  void onChild(NodeMetadata childMeta, dom.Element e) {
    if (e.localName != 'source') return;
    if (e.parent != videoMeta.domElement) return;

    final a = e.attributes;
    if (!a.containsKey('src')) return;

    final url = wf.constructFullUrl(a['src']);
    if (url == null) return;

    _sourceUrls.add(url);
  }

  @override
  Iterable<WidgetPlaceholder> onWidgets(
      NodeMetadata _, Iterable<WidgetPlaceholder> widgets) {
    final player = build();
    if (player == null) return widgets;

    return [
      WidgetPlaceholder<Widget>(
        builder: (_, __, input) => input,
        input: player,
      ),
    ];
  }

  Widget build() {
    if (_sourceUrls.isEmpty) return null;

    final a = videoMeta.domElement.attributes;
    return wf.buildVideoPlayer(
      _sourceUrls.first,
      autoplay: a.containsKey('autoplay'),
      controls: a.containsKey('controls'),
      height: a.containsKey('height') ? double.tryParse(a['height']) : null,
      loop: a.containsKey('loop'),
      posterUrl:
          a.containsKey('poster') ? wf.constructFullUrl(a['poster']) : null,
      width: a.containsKey('width') ? double.tryParse(a['width']) : null,
    );
  }
}
