import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '_.dart' as helper;

void main() {
  group('image.png', () {
    final src = 'http://domain.com/image.png';
    final explain = (WidgetTester tester, String html) =>
        mockNetworkImagesFor(() async => helper.explain(tester, html));

    testWidgets('renders src', (WidgetTester tester) async {
      final html = '<img src="$src" />';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[Image:image=CachedNetworkImageProvider("$src", scale: 1.0)]'),
      );
    });

    testWidgets('renders src+alt', (WidgetTester tester) async {
      final html = '<img src="$src" alt="Foo" />';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[Image:'
            'image=CachedNetworkImageProvider("$src", scale: 1.0),'
            'semanticLabel=Foo'
            ']'),
      );
    });

    testWidgets('renders src+title', (WidgetTester tester) async {
      final html = '<img src="$src" title="Bar" />';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Tooltip:'
              'child=[Image:'
              'image=CachedNetworkImageProvider("http://domain.com/image.png", scale: 1.0),'
              'semanticLabel=Bar'
              '],'
              'message=Bar'
              ']'));
    });

    testWidgets('renders src+alt+title', (WidgetTester tester) async {
      final html = '<img src="$src" alt="Foo" title="Bar" />';
      final e = await explain(tester, html);
      expect(
          e,
          equals('[Tooltip:'
              'child=[Image:'
              'image=CachedNetworkImageProvider("http://domain.com/image.png", scale: 1.0),'
              'semanticLabel=Foo'
              '],'
              'message=Bar'
              ']'));
    });
  });
}
