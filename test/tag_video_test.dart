import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  final src = 'http://domain.com/video.mp4';

  testWidgets('renders video player', (tester) async {
    final html = '<video><source src="$src"></video>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[VideoPlayer:url=$src,aspectRatio=1.78,'
            'autoResize=1,autoplay=0,controls=0,loop=0]'));
  });

  testWidgets('renders video player with specified dimensions', (tester) async {
    final html = '<video width="400" height="300"><source src="$src"></video>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[VideoPlayer:url=$src,aspectRatio=1.33,'
            'autoResize=0,autoplay=0,controls=0,loop=0]'));
  });

  testWidgets('renders video player with autoplay', (tester) async {
    final html = '<video autoplay><source src="$src"></video>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[VideoPlayer:url=$src,aspectRatio=1.78,'
            'autoResize=1,autoplay=1,controls=0,loop=0]'));
  });

  testWidgets('renders video player with controls', (tester) async {
    final html = '<video controls><source src="$src"></video>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[VideoPlayer:url=$src,aspectRatio=1.78,'
            'autoResize=1,autoplay=0,controls=1,loop=0]'));
  });

  testWidgets('renders video player with loop', (tester) async {
    final html = '<video loop><source src="$src"></video>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[VideoPlayer:url=$src,aspectRatio=1.78,'
            'autoResize=1,autoplay=0,controls=0,loop=1]'));
  });

  group('errors', () {
    testWidgets('no source', (tester) async {
      final html = '<video></video>';
      final explained = await explain(tester, html);
      expect(explained, equals("[Text:$html]"));
    });

    testWidgets('bad source (cannot build full url)', (tester) async {
      final html = '<video><source src="bad"></video>';
      final explained = await explain(tester, html);
      expect(explained, equals("[Text:$html]"));
    });
  });
}
