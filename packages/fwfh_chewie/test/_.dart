import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_chewie/fwfh_chewie.dart';
import 'package:video_player_platform_interface/messages.dart';
import 'package:video_player_platform_interface/test.dart';

import '../../core/test/_.dart' as helper;

final kDataUri = helper.kDataUri;

String? videoPlayerExplainer(helper.Explainer parent, Widget widget) {
  if (widget is VideoPlayer) {
    return '[VideoPlayer:url=${widget.url}'
        ',aspectRatio=${widget.aspectRatio.toStringAsFixed(2)}'
        "${!widget.autoResize ? ',autoResize=${widget.autoResize}' : ''}"
        "${widget.autoplay ? ',autoplay=${widget.autoplay}' : ''}"
        "${widget.controls ? ',controls=${widget.controls}' : ''}"
        "${widget.loop ? ',loop=${widget.loop}' : ''}"
        "${widget.poster != null ? ',poster=${parent.explain(widget.poster!)}' : ''}"
        ']';
  }

  return null;
}

Future<String> explain(
  WidgetTester tester,
  String html, {
  bool useExplainer = true,
}) async {
  await helper.explain(
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

  await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 10)));
  await tester.pumpAndSettle();

  return helper.explainWithoutPumping(
    explainer: videoPlayerExplainer,
    useExplainer: useExplainer,
  );
}

void mockVideoPlayerPlatform() => _FakeVideoPlayerPlatform();

class _FakeVideoPlayerPlatform extends TestHostVideoPlayerApi {
  var nextTextureId = 0;

  _FakeVideoPlayerPlatform() {
    TestHostVideoPlayerApi.setup(this);
  }

  @override
  TextureMessage create(CreateMessage arg) {
    _FakeVideoEventStream(nextTextureId);
    return TextureMessage()..textureId = nextTextureId++;
  }

  @override
  void initialize() {}

  @override
  void dispose(TextureMessage arg) {}

  @override
  void pause(TextureMessage arg) {}

  @override
  void play(TextureMessage arg) {}

  @override
  PositionMessage position(TextureMessage arg) => PositionMessage();

  @override
  void seekTo(PositionMessage arg) {}

  @override
  void setLooping(LoopingMessage arg) {}

  @override
  void setMixWithOthers(MixWithOthersMessage arg) {}

  @override
  void setPlaybackSpeed(PlaybackSpeedMessage arg) {}

  @override
  void setVolume(VolumeMessage arg) {}
}

class _FakeVideoEventStream {
  final int textureId;

  _FakeVideoEventStream(this.textureId) {
    MethodChannel(name).setMockMethodCallHandler(_handler);
  }

  String get name => 'flutter.io/videoPlayer/videoEvents$textureId';

  Future<dynamic> _handler(MethodCall call) async {
    switch (call.method) {
      case 'listen':
        final data = <String, dynamic>{
          'event': 'initialized',
          'duration': 1000,
          'width': 100,
          'height': 100,
        };
        final byteData = StandardMethodCodec().encodeSuccessEnvelope(data);

        final messenger = ServicesBinding.instance!.defaultBinaryMessenger;
        await messenger.handlePlatformMessage(name, byteData, (_) {});
        break;
    }
  }
}

class _WidgetFactory extends WidgetFactory with ChewieFactory {}
