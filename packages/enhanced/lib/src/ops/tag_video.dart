part of '../widget_factory.dart';

class _TagVideo {
  final WidgetFactory wf;

  BuildOp _sourceOp;

  _TagVideo(this.wf);

  BuildOp get buildOp => BuildOp(
        onChild: (meta, e) =>
            e.localName == 'source' ? meta.op = sourceOp : null,
        onWidgets: (meta, widgets) {
          final player = build(
            meta,
            widgets
                .map<String>((w) =>
                    w is WidgetPlaceholder<String> ? w.inputs.first : null)
                .where((s) => s != null),
          );
          return player != null ? [player] : null;
        },
      );

  BuildOp get sourceOp {
    _sourceOp ??= BuildOp(onWidgets: (meta, _) {
      final a = meta.domElement.attributes;
      if (!a.containsKey('src')) return null;

      final url = wf.constructFullUrl(a['src']);
      if (url == null) return null;

      return [WidgetPlaceholder(builder: _sourceBuilder, input: url)];
    });
    return _sourceOp;
  }

  Widget build(NodeMetadata meta, Iterable<String> urls) {
    if (urls.isEmpty) return null;

    final a = meta.domElement.attributes;
    return wf.buildVideoPlayer(
      urls.first,
      autoplay: a.containsKey('autoplay'),
      controls: a.containsKey('controls'),
      height: a.containsKey('height') ? double.tryParse(a['height']) : null,
      loop: a.containsKey('loop'),
      posterUrl:
          a.containsKey('poster') ? wf.constructFullUrl(a['poster']) : null,
      width: a.containsKey('width') ? double.tryParse(a['width']) : null,
    );
  }

  static Widget _sourceBuilder(BuildContext _, Widget __, String url) =>
      Text(url);
}
