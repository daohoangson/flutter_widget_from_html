import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  final src = 'http://domain.com/video.mp4';
  final defaultAspectRatio = '1.78';

  testWidgets('renders video player', (tester) async {
    final html = '<video><source src="$src"></video>';
    final e = await explain(tester, html);
    expect(e, equals('[VideoPlayer:url=$src,aspectRatio=$defaultAspectRatio]'));
  });

  group('useExplainer: false', () {
    final html = '<video><source src="$src"></video>';
    final _explain = (WidgetTester tester) async {
      final explained = await explain(tester, html, useExplainer: false);
      return explained;
    };

    final videoPlayer = 'TshWidget\n'
        '└WidgetPlaceholder<Widget>(VideoPlayer)\n'
        ' └VideoPlayer(state: _VideoPlayerState)\n'
        '  └AspectRatio(aspectRatio: 1.8)\n'
        '   └Chewie(state: ChewieState)\n'
        '    └_ChewieControllerProvider\n'
        '     └PlayerWithControls()\n'
        '      └Center(alignment: center)\n'
        '       └SizedBox(width: 800.0, height: 600.0)\n'
        '        └AspectRatio(aspectRatio: 1.3)\n'
        '         └Stack(alignment: topStart, fit: loose)\n'
        '          ├Container\n'
        '          │└LimitedBox(maxWidth: 0.0, maxHeight: 0.0)\n'
        '          │ └ConstrainedBox(BoxConstraints(biggest))\n'
        '          ├Center(alignment: center)\n'
        '          │└AspectRatio(aspectRatio: 1.8)\n'
        '          │ └VideoPlayer(state: _VideoPlayerState)\n'
        '          │  └Container\n'
        '          │   └LimitedBox(maxWidth: 0.0, maxHeight: 0.0)\n'
        '          │    └ConstrainedBox(BoxConstraints(biggest))\n'
        '          ├Container\n'
        '          │└LimitedBox(maxWidth: 0.0, maxHeight: 0.0)\n'
        '          │ └ConstrainedBox(BoxConstraints(biggest))\n'
        '          └Container\n'
        '           └LimitedBox(maxWidth: 0.0, maxHeight: 0.0)\n'
        '            └ConstrainedBox(BoxConstraints(biggest))\n'
        '\n';

    testWidgets('renders video player (Android)', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      final explained = await _explain(tester);
      expect(explained, equals(videoPlayer));
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('renders video player (iOS)', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      final explained = await _explain(tester);
      expect(explained, equals(videoPlayer));
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('skips video player (linux)', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      final explained = await _explain(tester);
      expect(
          explained,
          equals('TshWidget\n'
              '└WidgetPlaceholder<Widget>(VideoPlayer)\n'
              ' └VideoPlayer(state: _PlaceholderState)\n'
              '  └AspectRatio(aspectRatio: 1.8)\n'
              '   └DecoratedBox(bg: BoxDecoration(color: Color(0x7f000000)))\n'
              '    └Center(alignment: center)\n'
              '     └Text("platform=TargetPlatform.linux")\n'
              '      └RichText(text: "platform=TargetPlatform.linux")\n'
              '\n'));
      debugDefaultTargetPlatformOverride = null;
    });
  });

  testWidgets('renders video player with specified dimensions', (tester) async {
    final html = '<video width="400" height="300"><source src="$src"></video>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[VideoPlayer:'
            'url=$src,'
            'aspectRatio=1.33,'
            'autoResize=false'
            ']'));
  });

  testWidgets('renders video player with autoplay', (tester) async {
    final html = '<video autoplay><source src="$src"></video>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[VideoPlayer:'
            'url=$src,'
            'aspectRatio=$defaultAspectRatio,'
            'autoplay=true'
            ']'));
  });

  testWidgets('renders video player with controls', (tester) async {
    final html = '<video controls><source src="$src"></video>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[VideoPlayer:'
            'url=$src,'
            'aspectRatio=$defaultAspectRatio,'
            'controls=true'
            ']'));
  });

  testWidgets('renders video player with loop', (tester) async {
    final html = '<video loop><source src="$src"></video>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[VideoPlayer:'
            'url=$src,'
            'aspectRatio=$defaultAspectRatio,'
            'loop=true'
            ']'));
  });

  group('poster', () {
    testWidgets('renders video player with asset', (tester) async {
      final package = 'flutter_widget_from_html_core';
      final assetName = 'test/images/logo.png';
      final h = '<video poster="asset:$assetName?package=$package">'
          '<source src="$src"></video>';
      final explained = await explain(tester, h);
      expect(
          explained,
          equals('[VideoPlayer:'
              'url=$src,'
              'aspectRatio=$defaultAspectRatio,'
              'poster=[Image:image=AssetImage(bundle: null, name: "packages/$package/$assetName")]'
              ']'));
    });

    testWidgets('renders video player with data uri', (tester) async {
      final h = '<video poster="$kDataUri"><source src="$src"></video>';
      final e = await explain(tester, h);
      final explained = e.replaceAll(RegExp(r'Uint8List#[0-9a-f]+,'), 'bytes,');
      expect(
          explained,
          equals('[VideoPlayer:'
              'url=$src,'
              'aspectRatio=$defaultAspectRatio,'
              'poster=[Image:image=MemoryImage(bytes, scale: 1.0)]'
              ']'));
    });

    testWidgets('renders video player with url', (tester) async {
      final posterSrc = 'http://domain.com/image.png';
      final html = '<video poster="$posterSrc"><source src="$src"></video>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[VideoPlayer:'
              'url=$src,'
              'aspectRatio=$defaultAspectRatio,'
              'poster=[Image:image=NetworkImage("$posterSrc", scale: 1.0)]'
              ']'));
    });
  });

  group('errors', () {
    testWidgets('no source', (tester) async {
      final html = '<video></video>';
      final explained = await explain(tester, html);
      expect(explained, equals('[widget0]'));
    });

    testWidgets('bad source (cannot build full url)', (tester) async {
      final html = '<video><source src="bad"></video>';
      final explained = await explain(tester, html);
      expect(explained, equals('[widget0]'));
    });
  });
}
