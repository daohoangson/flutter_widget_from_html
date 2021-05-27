import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fwfh_just_audio/fwfh_just_audio.dart' as fwfh;
import 'package:just_audio_platform_interface/just_audio_platform_interface.dart';
import 'package:tuple/tuple.dart';

final _commands = <Tuple2>[];
late Duration _duration;
late StreamController<PlaybackEventMessage> _playbackEvents;

void main() {
  const audioSessionMc = MethodChannel('com.ryanheise.audio_session');
  const src = 'http://domain.com/audio.mp3';

  group('AudioPlayer', () {
    JustAudioPlatform.instance = _JustAudioPlatform();

    setUp(() {
      _commands.clear();
      _duration = Duration(milliseconds: 10);
      _playbackEvents = StreamController<PlaybackEventMessage>.broadcast();

      audioSessionMc.setMockMethodCallHandler((_) {});
    });

    tearDown(() {
      audioSessionMc.setMockMethodCallHandler(null);
      _playbackEvents.close();
    });

    testWidgets('play then pause on completion', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: fwfh.AudioPlayer(src),
          ),
        ),
      );

      final playArrow = find.byIcon(Icons.play_arrow);
      await tester.tap(playArrow);
      await tester.runAsync(() => Future.delayed(Duration.zero));
      expect(
          _commands,
          equals(const [
            Tuple2(_CommandType.play, null),
            Tuple2(_CommandType.load, src),
          ]));
      _commands.clear();

      // simulate a completed event
      _playbackEvents.add(PlaybackEventMessage(
        processingState: ProcessingStateMessage.completed,
        updateTime: DateTime.now(),
        updatePosition: _duration,
        bufferedPosition: _duration,
        duration: _duration,
        icyMetadata: null,
        currentIndex: 0,
        androidAudioSessionId: null,
      ));
      await tester.runAsync(() => Future.delayed(Duration.zero));

      // force a widget tree disposal
      await tester
          .pumpWidget(MaterialApp(home: Scaffold(body: SizedBox.shrink())));
      await tester.pumpAndSettle();

      expect(
          _commands,
          equals(const [
            Tuple2(_CommandType.pause, null),
            Tuple2(_CommandType.seek, Duration.zero),
          ]));
    });
  });
}

class _JustAudioPlatform extends JustAudioPlatform {
  @override
  Future<AudioPlayerPlatform> init(InitRequest request) async =>
      _AudioPlayerPlatform(request.id);

  @override
  Future<DisposePlayerResponse> disposePlayer(
          DisposePlayerRequest request) async =>
      DisposePlayerResponse();
}

class _AudioPlayerPlatform extends AudioPlayerPlatform {
  _AudioPlayerPlatform(String id) : super(id);

  @override
  Stream<PlaybackEventMessage> get playbackEventMessageStream =>
      _playbackEvents.stream;

  @override
  Future<LoadResponse> load(LoadRequest request) async {
    final map = request.audioSourceMessage.toMap();
    _commands.add(Tuple2(_CommandType.load, map['uri'] ?? map));
    return LoadResponse(duration: _duration);
  }

  @override
  Future<PlayResponse> play(PlayRequest request) async {
    _commands.add(Tuple2(_CommandType.play, null));
    return PlayResponse();
  }

  @override
  Future<PauseResponse> pause(PauseRequest request) async {
    _commands.add(Tuple2(_CommandType.pause, null));
    return PauseResponse();
  }

  @override
  Future<SetVolumeResponse> setVolume(SetVolumeRequest request) async =>
      SetVolumeResponse();

  @override
  Future<SetSpeedResponse> setSpeed(SetSpeedRequest request) async =>
      SetSpeedResponse();

  @override
  Future<SetLoopModeResponse> setLoopMode(SetLoopModeRequest request) async =>
      SetLoopModeResponse();

  @override
  Future<SetShuffleModeResponse> setShuffleMode(
          SetShuffleModeRequest request) async =>
      SetShuffleModeResponse();

  @override
  Future<SeekResponse> seek(SeekRequest request) async {
    _commands.add(Tuple2(_CommandType.seek, request.position));
    return SeekResponse();
  }

  @override
  Future<SetAndroidAudioAttributesResponse> setAndroidAudioAttributes(
          SetAndroidAudioAttributesRequest request) async =>
      SetAndroidAudioAttributesResponse();

  @override
  Future<DisposeResponse> dispose(DisposeRequest request) async =>
      DisposeResponse();
}

enum _CommandType {
  load,
  pause,
  play,
  seek,
}
