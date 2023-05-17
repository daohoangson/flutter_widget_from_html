import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  const src = 'http://domain.com/video.mp4';
  const defaultAspectRatio = '1.78';

  mockVideoPlayerPlatform();

  testWidgets('renders video player', (tester) async {
    const html = '<video><source src="$src"></video>';
    final e = await explain(tester, html);
    expect(e, equals('[VideoPlayer:url=$src,aspectRatio=$defaultAspectRatio]'));
  });

  group('renders progress indicator', () {
    const html = '<video><source src="$src"></video>';
    Future<String> _explain(WidgetTester tester) async {
      final explained = await explain(
        tester,
        html,
        delay: Duration.zero,
        useExplainer: false,
      );
      return explained;
    }

    testWidgets('renders material style (Android)', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      final explained = await _explain(tester);
      expect(explained, contains('CircularProgressIndicator'));
      expect(explained, isNot(contains('CupertinoActivityIndicator')));
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('renders cupertino style (iOS)', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      final explained = await _explain(tester);
      expect(explained, contains('CupertinoActivityIndicator'));
      debugDefaultTargetPlatformOverride = null;
    });
  });

  group('useExplainer: false', () {
    const html = '<video><source src="$src"></video>';
    Future<String> _explain(WidgetTester tester) async {
      final explained = await explain(tester, html, useExplainer: false);
      return explained;
    }

    testWidgets('renders video player (Android)', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      final explained = await _explain(tester);
      expect(explained, contains('Chewie(state: ChewieState)'));
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('renders video player (iOS)', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      final explained = await _explain(tester);
      expect(explained, contains('Chewie(state: ChewieState)'));
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('skips video player (linux)', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      final explained = await _explain(tester);
      expect(explained, isNot(contains('Chewie(state: ChewieState)')));
      debugDefaultTargetPlatformOverride = null;
    });
  });

  testWidgets('renders video player with specified dimensions', (tester) async {
    const html = '<video width="400" height="300"><source src="$src"></video>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[VideoPlayer:'
        'url=$src,'
        'aspectRatio=1.33,'
        'autoResize=false'
        ']',
      ),
    );
  });

  testWidgets('renders video player with autoplay', (tester) async {
    const html = '<video autoplay><source src="$src"></video>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[VideoPlayer:'
        'url=$src,'
        'aspectRatio=$defaultAspectRatio,'
        'autoplay=true'
        ']',
      ),
    );
  });

  testWidgets('renders video player with controls', (tester) async {
    const html = '<video controls><source src="$src"></video>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[VideoPlayer:'
        'url=$src,'
        'aspectRatio=$defaultAspectRatio,'
        'controls=true'
        ']',
      ),
    );
  });

  testWidgets('renders video player with loop', (tester) async {
    const html = '<video loop><source src="$src"></video>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[VideoPlayer:'
        'url=$src,'
        'aspectRatio=$defaultAspectRatio,'
        'loop=true'
        ']',
      ),
    );
  });

  group('poster', () {
    testWidgets('renders video player with asset', (tester) async {
      const package = 'flutter_widget_from_html_core';
      const assetName = 'test/images/logo.png';
      const h = '<video poster="asset:$assetName?package=$package">'
          '<source src="$src"></video>';
      final explained = await explain(tester, h);
      expect(
        explained,
        equals(
          '[VideoPlayer:'
          'url=$src,'
          'aspectRatio=$defaultAspectRatio,'
          'poster=[Image:image=AssetImage(bundle: null, name: "packages/$package/$assetName")]'
          ']',
        ),
      );
    });

    testWidgets('renders video player with data uri', (tester) async {
      const h = '<video poster="$kDataUri"><source src="$src"></video>';
      final e = await explain(tester, h);
      final explained = e.replaceAll(RegExp('Uint8List#[0-9a-f]+,'), 'bytes,');
      expect(
        explained,
        equals(
          '[VideoPlayer:'
          'url=$src,'
          'aspectRatio=$defaultAspectRatio,'
          'poster=[Image:image=MemoryImage(bytes, scale: 1.0)]'
          ']',
        ),
      );
    });

    testWidgets('renders video player with url', (tester) async {
      const posterSrc = 'http://domain.com/image.png';
      const html = '<video poster="$posterSrc"><source src="$src"></video>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[VideoPlayer:'
          'url=$src,'
          'aspectRatio=$defaultAspectRatio,'
          'poster=[Image:image=NetworkImage("$posterSrc", scale: 1.0)]'
          ']',
        ),
      );
    });
  });

  group('errors', () {
    testWidgets('no source', (tester) async {
      const html = '<video></video>';
      final explained = await explain(tester, html);
      expect(explained, equals('[widget0]'));
    });

    testWidgets('bad source (cannot build full url)', (tester) async {
      const html = '<video><source src="bad"></video>';
      final explained = await explain(tester, html);
      expect(explained, equals('[widget0]'));
    });

    testWidgets('initialization error', (tester) async {
      const html =
          '<video><source src="http://domain.com/init/error.mp4"></video>';
      final explained = await explain(tester, html, useExplainer: false);
      expect(explained, contains('Text("❌")'));
    });
  });
}
