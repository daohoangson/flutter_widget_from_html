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
  late final BuildOp op;
  final ChewieFactory wf;

  TagVideo(this.wf) {
    op = BuildOp(onChild: _onChild, onWidgets: _onWidgets);
  }

  void _onChild(BuildMetadata videoMeta, BuildMetadata childMeta) {
    final e = childMeta.element;
    if (e.localName != kTagVideoSource) {
      return;
    }
    if (e.parent != videoMeta.element) {
      return;
    }

    final attrs = e.attributes;
    final url = wf.urlFull(attrs[kAttributeVideoSrc] ?? '');
    if (url == null) {
      return;
    }

    videoMeta.sourceUrls.add(url);
  }

  Iterable<Widget>? _onWidgets(
    BuildMetadata meta,
    Iterable<WidgetPlaceholder> ws,
  ) {
    if (defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS &&
        !kIsWeb) {
      // these are the chewie's supported platforms
      // https://pub.dev/packages/chewie/versions/1.2.2
      return ws;
    }

    final attrs = meta.element.attributes;
    final url = wf.urlFull(attrs[kAttributeVideoSrc] ?? '');
    if (url != null) {
      meta.sourceUrls.add(url);
    }

    return listOrNull(_buildPlayer(meta)) ?? ws;
  }

  Widget? _buildPlayer(BuildMetadata meta) {
    final sourceUrls = meta.sourceUrls;
    if (sourceUrls.isEmpty) {
      return null;
    }

    final attrs = meta.element.attributes;
    return wf.buildVideoPlayer(
      meta,
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

extension _BuildMetadata on BuildMetadata {
  static final _sourceUrls = Expando<List<String>>();

  List<String> get sourceUrls {
    final existing = _sourceUrls[this];
    if (existing != null) {
      return existing;
    }

    return _sourceUrls[this] = [];
  }
}
