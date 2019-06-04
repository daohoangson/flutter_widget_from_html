part of '../widget_factory.dart';

class TagVideo {
  final WidgetFactory wf;

  final _sourceBuildOp = BuildOp(onWidgets: (meta, _) {
    final a = meta.domElement.attributes;
    if (!a.containsKey('src')) return null;
    return [_Source(a['src'])];
  });

  TagVideo(this.wf);

  BuildOp get buildOp => BuildOp(
        onChild: (meta, e) => e.localName == 'source'
            ? lazySet(null, buildOp: _sourceBuildOp)
            : null,
        onWidgets: (meta, widgets) {
          final player = build(
            meta,
            widgets
                .map<String>((w) => w is _Source ? w.src : null)
                .where((s) => s?.isNotEmpty == true),
          );
          return player != null ? [player] : null;
        },
      );

  Widget build(NodeMetadata meta, Iterable<String> sources) {
    if (sources.isEmpty) return null;

    final src = wf.constructFullUrl(sources.first);
    if (src == null) return null;

    final a = meta.domElement.attributes;
    return wf.buildVideoPlayer(
      src,
      autoplay: a.containsKey('autoplay'),
      controls: a.containsKey('controls'),
      height: a.containsKey('height') ? double.tryParse(a['height']) : null,
      loop: a.containsKey('loop'),
      width: a.containsKey('width') ? double.tryParse(a['width']) : null,
    );
  }
}

class _Source extends StatelessWidget {
  final String src;

  _Source(this.src);

  @override
  Widget build(BuildContext context) => core.widget0;
}
