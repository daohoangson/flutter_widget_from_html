import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio_platform_interface/just_audio_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:tuple/tuple.dart';

final commands = <Tuple2>[];
late Duration duration;
late StreamController<PlaybackEventMessage> playbackEvents;

void mockJustAudioPlatform() {
  _FakeJustAudioPlatform();
}

void initializeMockPlatform() {
  commands.clear();
  duration = const Duration(milliseconds: 10);
  playbackEvents = StreamController<PlaybackEventMessage>.broadcast();
}

void disposeMockPlatform() {
  playbackEvents.close();
}

class _FakeJustAudioPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements JustAudioPlatform {
  _FakeJustAudioPlatform() {
    JustAudioPlatform.instance = this;
  }

  @override
  Future<AudioPlayerPlatform> init(InitRequest request) async =>
      _FakeAudioPlayerPlatform(request.id);

  @override
  Future<DisposePlayerResponse> disposePlayer(
    DisposePlayerRequest request,
  ) async =>
      DisposePlayerResponse();
}

class _FakeAudioPlayerPlatform extends Fake implements AudioPlayerPlatform {
  final String _id;

  _FakeAudioPlayerPlatform(this._id);

  @override
  String get id => _id;

  @override
  Stream<PlaybackEventMessage> get playbackEventMessageStream =>
      playbackEvents.stream;

  @override
  Stream<PlayerDataMessage> get playerDataMessageStream => const Stream.empty();

  @override
  Future<LoadResponse> load(LoadRequest request) async {
    final map = request.audioSourceMessage.toMap();

    // Extract the URI from the audio source message structure
    String? uri;
    if (map['type'] == 'concatenating') {
      // For concatenating sources, extract URI from the first child
      final children = map['children'] as List?;
      if (children != null && children.isNotEmpty) {
        final firstChild = children[0] as Map?;
        uri = firstChild?['uri'] as String?;
      }
    } else {
      // For single sources, extract URI directly
      uri = map['uri'] as String?;
    }

    commands.add(Tuple2(CommandType.load, uri ?? map));

    // Send multiple events to properly simulate the loading process
    playbackEvents.add(
      PlaybackEventMessage(
        processingState: ProcessingStateMessage.loading,
        updateTime: DateTime.now(),
        updatePosition: Duration.zero,
        bufferedPosition: Duration.zero,
        duration: null,
        icyMetadata: null,
        currentIndex: 0,
        androidAudioSessionId: null,
      ),
    );

    // Small delay to simulate loading
    await Future.delayed(Duration.zero);

    playbackEvents.add(
      PlaybackEventMessage(
        processingState: ProcessingStateMessage.ready,
        updateTime: DateTime.now(),
        updatePosition: Duration.zero,
        bufferedPosition: duration,
        duration: duration,
        icyMetadata: null,
        currentIndex: 0,
        androidAudioSessionId: null,
      ),
    );

    return LoadResponse(duration: duration);
  }

  @override
  Future<PlayResponse> play(PlayRequest request) async {
    commands.add(Tuple2(CommandType.play, null));
    return PlayResponse();
  }

  @override
  Future<PauseResponse> pause(PauseRequest request) async {
    commands.add(Tuple2(CommandType.pause, null));
    return PauseResponse();
  }

  @override
  Future<SetVolumeResponse> setVolume(SetVolumeRequest request) async {
    commands.add(Tuple2(CommandType.setVolume, request.volume));
    return SetVolumeResponse();
  }

  @override
  Future<SeekResponse> seek(SeekRequest request) async {
    commands.add(Tuple2(CommandType.seek, request.position));
    return SeekResponse();
  }

  @override
  Future<SetSpeedResponse> setSpeed(SetSpeedRequest request) async =>
      SetSpeedResponse();

  @override
  Future<SetPitchResponse> setPitch(SetPitchRequest request) async =>
      SetPitchResponse();

  @override
  Future<SetSkipSilenceResponse> setSkipSilence(
          SetSkipSilenceRequest request) async =>
      SetSkipSilenceResponse();

  @override
  Future<SetLoopModeResponse> setLoopMode(SetLoopModeRequest request) async =>
      SetLoopModeResponse();

  @override
  Future<SetShuffleModeResponse> setShuffleMode(
    SetShuffleModeRequest request,
  ) async =>
      SetShuffleModeResponse();

  @override
  Future<SetShuffleOrderResponse> setShuffleOrder(
    SetShuffleOrderRequest request,
  ) async =>
      SetShuffleOrderResponse();

  @override
  Future<SetAutomaticallyWaitsToMinimizeStallingResponse>
      setAutomaticallyWaitsToMinimizeStalling(
    SetAutomaticallyWaitsToMinimizeStallingRequest request,
  ) async =>
          SetAutomaticallyWaitsToMinimizeStallingResponse();

  @override
  Future<SetCanUseNetworkResourcesForLiveStreamingWhilePausedResponse>
      setCanUseNetworkResourcesForLiveStreamingWhilePaused(
    SetCanUseNetworkResourcesForLiveStreamingWhilePausedRequest request,
  ) async =>
          SetCanUseNetworkResourcesForLiveStreamingWhilePausedResponse();

  @override
  Future<SetPreferredPeakBitRateResponse> setPreferredPeakBitRate(
    SetPreferredPeakBitRateRequest request,
  ) async =>
      SetPreferredPeakBitRateResponse();

  @override
  Future<SetAllowsExternalPlaybackResponse> setAllowsExternalPlayback(
    SetAllowsExternalPlaybackRequest request,
  ) async =>
      SetAllowsExternalPlaybackResponse();

  @override
  Future<SetAndroidAudioAttributesResponse> setAndroidAudioAttributes(
    SetAndroidAudioAttributesRequest request,
  ) async =>
      SetAndroidAudioAttributesResponse();

  @override
  Future<DisposeResponse> dispose(DisposeRequest request) async =>
      DisposeResponse();

  @override
  Future<ConcatenatingInsertAllResponse> concatenatingInsertAll(
    ConcatenatingInsertAllRequest request,
  ) async =>
      ConcatenatingInsertAllResponse();

  @override
  Future<ConcatenatingRemoveRangeResponse> concatenatingRemoveRange(
    ConcatenatingRemoveRangeRequest request,
  ) async =>
      ConcatenatingRemoveRangeResponse();

  @override
  Future<ConcatenatingMoveResponse> concatenatingMove(
    ConcatenatingMoveRequest request,
  ) async =>
      ConcatenatingMoveResponse();
}

enum CommandType {
  load,
  pause,
  play,
  seek,
  setVolume,
}
