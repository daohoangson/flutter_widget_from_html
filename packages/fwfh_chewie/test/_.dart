import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_chewie/fwfh_chewie.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import '../../core/test/_.dart' as helper;

const kDataUri = helper.kDataUri;

String? videoPlayerExplainer(helper.Explainer parent, Widget widget) {
  if (widget is VideoPlayer) {
    final poster = widget.poster != null
        ? ',poster=${parent.explain(widget.poster!)}'
        : '';
    return '[VideoPlayer:url=${widget.url}'
        ',aspectRatio=${widget.aspectRatio.toStringAsFixed(2)}'
        "${!widget.autoResize ? ',autoResize=${widget.autoResize}' : ''}"
        "${widget.autoplay ? ',autoplay=${widget.autoplay}' : ''}"
        "${widget.controls ? ',controls=${widget.controls}' : ''}"
        "${widget.loop ? ',loop=${widget.loop}' : ''}"
        '$poster'
        ']';
  }

  return null;
}

Future<String> explain(
  WidgetTester tester,
  String html, {
  bool useExplainer = true,
  Duration delay = const Duration(milliseconds: 10),
}) async {
  final explained = await helper.explain(
    tester,
    null,
    explainer: videoPlayerExplainer,
    hw: HtmlWidget(
      html,
      key: helper.hwKey,
      factoryBuilder: () => _WidgetFactory(),
    ),
    useExplainer: useExplainer,
  );

  if (delay == Duration.zero) {
    return explained;
  }

  await tester.runAsync(() => Future.delayed(delay));
  await tester.pump();

  return helper.explainWithoutPumping(
    explainer: videoPlayerExplainer,
    useExplainer: useExplainer,
  );
}

void mockVideoPlayerPlatform() => _FakeVideoPlayerPlatform();

class _FakeVideoPlayerPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements VideoPlayerPlatform {
  var _nextTextureId = 0;

  final uris = <int, String?>{};

  _FakeVideoPlayerPlatform() {
    VideoPlayerPlatform.instance = this;
  }

  @override
  Widget buildView(int textureId) => const SizedBox.shrink();

  @override
  Future<int?> create(DataSource dataSource) async {
    final textureId = _nextTextureId++;
    uris[textureId] = dataSource.uri;
    return textureId;
  }

  @override
  Future<void> dispose(int textureId) async {/* intentionally left empty */}

  @override
  Future<void> init() async {/* intentionally left empty */}

  @override
  Future<void> play(int textureId) async {/* intentionally left empty */}

  @override
  Future<void> pause(int textureId) async {/* intentionally left empty */}

  @override
  Future<void> setLooping(int textureId, bool looping) async {
    /* intentionally left empty */
  }

  @override
  Future<void> setPlaybackSpeed(int textureId, double speed) async {
    /* intentionally left empty */
  }

  @override
  Future<void> setVolume(int textureId, double volume) async {
    /* intentionally left empty */
  }

  @override
  Stream<VideoEvent> videoEventsFor(int textureId) async* {
    final uri = uris[textureId] ?? '';
    if (uri.endsWith('init/error.mp4') == true) {
      throw PlatformException(code: 'init_error', message: uri);
    } else {
      yield VideoEvent(
        eventType: VideoEventType.initialized,
        duration: const Duration(seconds: 1),
        size: const Size(1600, 900),
      );
    }
  }
}

class _WidgetFactory extends WidgetFactory with ChewieFactory {}
