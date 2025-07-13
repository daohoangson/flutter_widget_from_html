import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fwfh_just_audio/fwfh_just_audio.dart' as fwfh;
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:just_audio_platform_interface/just_audio_platform_interface.dart';
import 'package:tuple/tuple.dart';

import '../../core/test/_.dart' as core;
import 'mock_just_audio_platform.dart';

Future<void> main() async {
  await loadAppFonts();

  const audioSessionMc = MethodChannel('com.ryanheise.audio_session');
  const src = 'http://domain.com/audio.mp3';

  group('AudioPlayer', () {
    mockJustAudioPlatform();

    setUp(() {
      initializeMockPlatform();

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        audioSessionMc,
        (_) => null,
      );
    });

    tearDown(() {
      disposeMockPlatform();
    });

    testWidgets('plays then pauses on completion', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: fwfh.AudioPlayer(src),
          ),
        ),
      );

      await tester.tapWithAsyncDelay(find.byIcon(Icons.play_arrow));
      expect(
        commands,
        equals(const [
          Tuple2(CommandType.setVolume, 1.0),
          Tuple2(CommandType.play, null),
          Tuple2(CommandType.load, src),
        ]),
      );
      commands.clear();

      // simulate a completed event
      playbackEvents.add(
        PlaybackEventMessage(
          processingState: ProcessingStateMessage.completed,
          updateTime: DateTime.now(),
          updatePosition: duration,
          bufferedPosition: duration,
          duration: duration,
          icyMetadata: null,
          currentIndex: 0,
          androidAudioSessionId: null,
        ),
      );
      await tester.runAsync(() => Future.delayed(Duration.zero));

      await tester.cleanupWidget();

      expect(
        commands,
        containsAll(const [
          Tuple2(CommandType.pause, null),
          Tuple2(CommandType.seek, Duration.zero),
        ]),
      );
      expect(commands.length, equals(2));
    });

    testWidgets('shows remaining (narrow)', (tester) async {
      tester.setWindowSize(const Size(320, 568));

      duration = const Duration(minutes: 12, seconds: 34);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: fwfh.AudioPlayer(src, preload: true),
          ),
        ),
      );
      expect(find.text('-0:00'), findsOneWidget);

      await tester.waitForTextUpdate('-12:34');

      await tester.cleanupWidget();
    });

    testWidgets('shows position & duration (wide)', (tester) async {
      duration = const Duration(minutes: 12, seconds: 34);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: fwfh.AudioPlayer(src, preload: true),
          ),
        ),
      );
      expect(find.text('0:00 / 0:00'), findsOneWidget);

      await tester.waitForTextUpdate('0:00 / 12:34');

      await tester.cleanupWidget();
    });

    testWidgets('seeks', (tester) async {
      duration = const Duration(seconds: 100);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: fwfh.AudioPlayer(src, preload: true),
          ),
        ),
      );

      await tester.waitForTextUpdate('0:00 / 1:40');
      expect(
        commands,
        equals(const [
          Tuple2(CommandType.setVolume, 1.0),
          Tuple2(CommandType.load, src),
        ]),
      );
      commands.clear();

      await tester.tapWithAsyncDelay(find.byType(Slider));
      await tester.pumpAndSettle();
      expect(find.text('0:50 / 1:40'), findsOneWidget);
      expect(commands, equals([Tuple2(CommandType.seek, duration * .5)]));

      await tester.cleanupWidget();
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
        commands.clear();

        await tester.tapWithAsyncDelay(find.byIcon(iconOn));
        await tester.pumpAndSettle();

        expect(commands, equals(const [Tuple2(CommandType.setVolume, 0.0)]));
        expect(find.byIcon(iconOff), findsOneWidget);

        await tester.cleanupWidget();
      });

      testWidgets('shows muted and unmutes', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: fwfh.AudioPlayer(src, muted: true, preload: true),
            ),
          ),
        );

        await tester.waitForCommandUpdate(CommandType.load);
        commands.clear();

        await tester.tapWithAsyncDelay(find.byIcon(iconOff));
        await tester.pumpAndSettle();

        expect(commands, equals(const [Tuple2(CommandType.setVolume, 1.0)]));
        expect(find.byIcon(iconOn), findsOneWidget);

        await tester.cleanupWidget();
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

extension on WidgetTester {
  /// Wait for text to appear with simplified polling
  Future<void> waitForTextUpdate(String expectedText) async {
    await pumpAndSettle();
    await runAsync(() async {
      for (int i = 0; i < 10; i++) {
        await Future.delayed(const Duration(milliseconds: 50));
        await pumpAndSettle();
        if (find.text(expectedText).evaluate().isNotEmpty) {
          return;
        }
      }
    });
  }

  /// Wait for commands with simplified polling
  Future<void> waitForCommandUpdate(CommandType commandType) async {
    await runAsync(() => Future.delayed(Duration.zero));
    await pumpAndSettle();
    await runAsync(() async {
      for (int i = 0; i < 10; i++) {
        await Future.delayed(const Duration(milliseconds: 50));
        await pumpAndSettle();
        if (commands.any((cmd) => cmd.item1 == commandType)) {
          break;
        }
      }
    });
  }

  /// Tap with async delay - for interactions that trigger async operations
  Future<void> tapWithAsyncDelay(Finder finder) async {
    await tap(finder);
    await runAsync(() => Future.delayed(Duration.zero));
  }

  /// Standard cleanup
  Future<void> cleanupWidget() async {
    await pumpWidget(const SizedBox.shrink());
    await pumpAndSettle();
  }
}
