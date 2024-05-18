import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fwfh_just_audio/fwfh_just_audio.dart' as fwfh;
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:just_audio_platform_interface/just_audio_platform_interface.dart';
import 'package:tuple/tuple.dart';

import '../../core/test/_.dart' as core;

final _commands = <Tuple2>[];
late Duration _duration;
late StreamController<PlaybackEventMessage> _playbackEvents;

Future<void> main() async {
  await loadAppFonts();

  const audioSessionMc = MethodChannel('com.ryanheise.audio_session');
  const src = 'http://domain.com/audio.mp3';

  group('AudioPlayer', () {
    JustAudioPlatform.instance = _JustAudioPlatform();

    setUp(() {
      _commands.clear();
      _duration = const Duration(milliseconds: 10);
      _playbackEvents = StreamController<PlaybackEventMessage>.broadcast();

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        audioSessionMc,
        (_) => null,
      );
    });

    tearDown(() {
      _playbackEvents.close();
    });

    testWidgets('plays then pauses on completion', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
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
          Tuple2(_CommandType.setVolume, 1.0),
          Tuple2(_CommandType.play, null),
          Tuple2(_CommandType.load, src),
        ]),
      );
      _commands.clear();

      // simulate a completed event
      _playbackEvents.add(
        PlaybackEventMessage(
          processingState: ProcessingStateMessage.completed,
          updateTime: DateTime.now(),
          updatePosition: _duration,
          bufferedPosition: _duration,
          duration: _duration,
          icyMetadata: null,
          currentIndex: 0,
          androidAudioSessionId: null,
        ),
      );
      await tester.runAsync(() => Future.delayed(Duration.zero));

      // force a widget tree disposal
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();

      expect(
        _commands,
        equals(const [
          Tuple2(_CommandType.pause, null),
          Tuple2(_CommandType.seek, Duration.zero),
        ]),
      );
    });

    testWidgets('shows remaining (narrow)', (tester) async {
      tester.setWindowSize(const Size(320, 568));

      _duration = const Duration(minutes: 12, seconds: 34);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: fwfh.AudioPlayer(src, preload: true),
          ),
        ),
      );
      expect(find.text('-0:00'), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.text('-12:34'), findsOneWidget);

      // force a widget tree disposal
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    });

    testWidgets('shows position & duration (wide)', (tester) async {
      _duration = const Duration(minutes: 12, seconds: 34);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: fwfh.AudioPlayer(src, preload: true),
          ),
        ),
      );
      expect(find.text('0:00 / 0:00'), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.text('0:00 / 12:34'), findsOneWidget);

      // force a widget tree disposal
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    });

    testWidgets('seeks', (tester) async {
      _duration = const Duration(seconds: 100);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: fwfh.AudioPlayer(src, preload: true),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('0:00 / 1:40'), findsOneWidget);
      expect(
        _commands,
        equals(const [
          Tuple2(_CommandType.setVolume, 1.0),
          Tuple2(_CommandType.load, src),
        ]),
      );
      _commands.clear();

      await tester.tap(find.byType(Slider));
      await tester.runAsync(() => Future.delayed(Duration.zero));
      await tester.pumpAndSettle();
      expect(find.text('0:50 / 1:40'), findsOneWidget);
      expect(_commands, equals([Tuple2(_CommandType.seek, _duration * .5)]));

      // force a widget tree disposal
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    });

    group('mute', () {
      const iconOn = Icons.volume_up;
      const iconOff = Icons.volume_off_outlined;

      testWidgets('shows unmuted and mutes', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: fwfh.AudioPlayer(src, preload: true),
            ),
          ),
        );

        await tester.pumpAndSettle();
        _commands.clear();

        await tester.tap(find.byIcon(iconOn));
        await tester.runAsync(() => Future.delayed(Duration.zero));
        await tester.pumpAndSettle();

        expect(_commands, equals(const [Tuple2(_CommandType.setVolume, 0.0)]));
        expect(find.byIcon(iconOff), findsOneWidget);

        // force a widget tree disposal
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();
      });

      testWidgets('shows muted and unmutes', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: fwfh.AudioPlayer(src, muted: true, preload: true),
            ),
          ),
        );

        await tester.runAsync(() => Future.delayed(Duration.zero));
        await tester.pumpAndSettle();
        _commands.clear();

        await tester.tap(find.byIcon(iconOff));
        await tester.runAsync(() => Future.delayed(Duration.zero));
        await tester.pumpAndSettle();

        expect(_commands, equals(const [Tuple2(_CommandType.setVolume, 1.0)]));
        expect(find.byIcon(iconOn), findsOneWidget);

        // force a widget tree disposal
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();
      });
    });

    final goldenSkipEnvVar = Platform.environment['GOLDEN_SKIP'];
    final goldenSkip = goldenSkipEnvVar == null
        ? Platform.isLinux
            ? null
            : 'Linux only'
        : 'GOLDEN_SKIP=$goldenSkipEnvVar';

    GoldenToolkit.runWithConfiguration(
      () {
        testGoldens(
          'screenshot testing',
          (tester) async {
            Widget build(ThemeData theme) {
              final wrapper = materialAppWrapper(theme: theme);
              return AspectRatio(
                aspectRatio: 4,
                child: wrapper(const Center(child: fwfh.AudioPlayer(src))),
              );
            }

            final builder = GoldenBuilder.column()
              ..addScenario('Light theme', build(ThemeData.light()))
              ..addScenario('Dark theme', build(ThemeData.dark()));
            await tester.pumpWidgetBuilder(builder.build());
            await screenMatchesGolden(tester, 'scenarios');
          },
          skip: goldenSkip != null,
        );
      },
      config: GoldenToolkitConfiguration(
        fileNameFactory: (name) =>
            '${core.kGoldenFilePrefix}/just_audio/$name.png',
      ),
    );
  });
}

class _JustAudioPlatform extends JustAudioPlatform {
  @override
  Future<AudioPlayerPlatform> init(InitRequest request) async =>
      _AudioPlayerPlatform(request.id);

  @override
  Future<DisposePlayerResponse> disposePlayer(
    DisposePlayerRequest request,
  ) async =>
      DisposePlayerResponse();
}

class _AudioPlayerPlatform extends AudioPlayerPlatform {
  _AudioPlayerPlatform(super.id);

  @override
  Stream<PlaybackEventMessage> get playbackEventMessageStream =>
      _playbackEvents.stream;

  @override
  Future<LoadResponse> load(LoadRequest request) async {
    final map = request.audioSourceMessage.toMap();
    _commands.add(Tuple2(_CommandType.load, map['uri'] ?? map));

    _playbackEvents.add(
      PlaybackEventMessage(
        processingState: ProcessingStateMessage.ready,
        updateTime: DateTime.now(),
        updatePosition: Duration.zero,
        bufferedPosition: _duration,
        duration: _duration,
        icyMetadata: null,
        currentIndex: 0,
        androidAudioSessionId: null,
      ),
    );

    return LoadResponse(duration: _duration);
  }

  @override
  Future<PlayResponse> play(PlayRequest request) async {
    _commands.add(const Tuple2(_CommandType.play, null));
    return PlayResponse();
  }

  @override
  Future<PauseResponse> pause(PauseRequest request) async {
    _commands.add(const Tuple2(_CommandType.pause, null));
    return PauseResponse();
  }

  @override
  Future<SetVolumeResponse> setVolume(SetVolumeRequest request) async {
    _commands.add(Tuple2(_CommandType.setVolume, request.volume));
    return SetVolumeResponse();
  }

  @override
  Future<SetSpeedResponse> setSpeed(SetSpeedRequest request) async =>
      SetSpeedResponse();

  @override
  Future<SetLoopModeResponse> setLoopMode(SetLoopModeRequest request) async =>
      SetLoopModeResponse();

  @override
  Future<SetShuffleModeResponse> setShuffleMode(
    SetShuffleModeRequest request,
  ) async =>
      SetShuffleModeResponse();

  @override
  Future<SeekResponse> seek(SeekRequest request) async {
    _commands.add(Tuple2(_CommandType.seek, request.position));
    return SeekResponse();
  }

  @override
  Future<SetAndroidAudioAttributesResponse> setAndroidAudioAttributes(
    SetAndroidAudioAttributesRequest request,
  ) async =>
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
  setVolume,
}
