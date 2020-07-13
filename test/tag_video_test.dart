import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  final src = 'http://domain.com/video.mp4';
  final defaultAspectRatio = '1.78';

  testWidgets('renders video player', (tester) async {
    final html = '<video><source src="$src"></video>';
    final explained = await explain(tester, html);
    expect(explained,
        equals('[VideoPlayer:url=$src,aspectRatio=$defaultAspectRatio]'));
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
      final assetName = 'test/images/logo.png';
      final h = '<video poster="asset:$assetName"><source src="$src"></video>';
      final explained = await explain(tester, h);
      expect(
          explained,
          equals('[VideoPlayer:'
              'url=$src,'
              'aspectRatio=$defaultAspectRatio,'
              'poster=[Image:'
              'image=AssetImage(bundle: null, name: "$assetName")'
              ']]'));
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
              'poster=[Image:'
              'image=MemoryImage(bytes, scale: 1.0)'
              ']]'));
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
              'poster=[Image:'
              'image=CachedNetworkImageProvider("$posterSrc", scale: 1.0)'
              ']]'));
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
