import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  final src = 'http://domain.com/audio.mp3';

  testWidgets('renders audio player', (tester) async {
    final html = '<audio src="$src"></audio>';
    final explained = await explain(tester, html);
    expect(explained, equals('[AudioPlayer:url=$src]'));
  });

  group('useExplainer: false', () {
    final html = '<audio src="$src"></audio>';
    final _explain = (WidgetTester tester) async {
      final explained = await explain(tester, html, useExplainer: false);
      return explained;
    };

    testWidgets('renders audio player (Android)', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      final explained = await _explain(tester);
      expect(explained, contains('AudioPlayer(state: _AudioPlayerState)'));
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('renders audio player (iOS)', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      final explained = await _explain(tester);
      expect(explained, contains('AudioPlayer(state: _AudioPlayerState)'));
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('renders audio player (macOS)', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      final explained = await _explain(tester);
      expect(explained, contains('AudioPlayer(state: _AudioPlayerState)'));
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('skips audio player (linux)', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      final e = await _explain(tester);
      expect(e, isNot(contains('AudioPlayer(state: _AudioPlayerState)')));
      debugDefaultTargetPlatformOverride = null;
    });
  });

  testWidgets('renders audio player with autoplay', (tester) async {
    final html = '<audio src="$src" autoplay></audio>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[AudioPlayer:'
            'url=$src,'
            'autoplay=true'
            ']'));
  });

  testWidgets('renders audio player with loop', (tester) async {
    final html = '<audio src="$src" loop></audio>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[AudioPlayer:'
            'url=$src,'
            'loop=true'
            ']'));
  });

  testWidgets('renders audio player with muted', (tester) async {
    final html = '<audio src="$src" muted></audio>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[AudioPlayer:'
            'url=$src,'
            'muted=true'
            ']'));
  });

  group('preload', () {
    testWidgets('renders audio player without preload', (tester) async {
      final html = '<audio src="$src"></audio>';
      final explained = await explain(tester, html);
      expect(explained, isNot(contains('preload=true')));
    });

    testWidgets('renders audio player with preload', (tester) async {
      final html = '<audio src="$src" preload></audio>';
      final explained = await explain(tester, html);
      expect(explained, contains('preload=true'));
    });

    testWidgets('renders audio player with preload="auto"', (tester) async {
      final html = '<audio src="$src" preload="auto"></audio>';
      final explained = await explain(tester, html);
      expect(explained, contains('preload=true'));
    });

    testWidgets('renders audio player with preload="metadata"', (tester) async {
      final html = '<audio src="$src" preload="metadata"></audio>';
      final explained = await explain(tester, html);
      expect(explained, contains('preload=true'));
    });

    testWidgets('renders audio player with preload="none"', (tester) async {
      final html = '<audio src="$src" preload="none"></audio>';
      final explained = await explain(tester, html);
      expect(explained, isNot(contains('preload=true')));
    });
  });

  group('errors', () {
    testWidgets('no source', (tester) async {
      final html = '<audio></audio>';
      final explained = await explain(tester, html);
      expect(explained, equals('[widget0]'));
    });

    testWidgets('bad source (cannot build full url)', (tester) async {
      final html = '<audio src="bad"></audio>';
      final explained = await explain(tester, html);
      expect(explained, equals('[widget0]'));
    });
  });
}
