import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

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
  Widget buildView(int textureId) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
      ),
    );
  }

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
