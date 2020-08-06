import 'dart:convert';

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
              'message=Bar,'
              'child=[Image:'
              'image=CachedNetworkImageProvider("http://domain.com/image.png", scale: 1.0),'
              'semanticLabel=Bar'
              ']]'));
    });

    testWidgets('renders src+alt+title', (WidgetTester tester) async {
      final html = '<img src="$src" alt="Foo" title="Bar" />';
      final e = await explain(tester, html);
      expect(
          e,
          equals('[Tooltip:'
              'message=Bar,'
              'child=[Image:'
              'image=CachedNetworkImageProvider("http://domain.com/image.png", scale: 1.0),'
              'semanticLabel=Foo'
              ']]'));
    });
  });

  group('SvgPicture', () {
    testWidgets('renders asset picture', (WidgetTester tester) async {
      final assetName = 'test/images/logo.svg';
      final html = '<img src="asset:$assetName" />';
      final explained = await helper.explain(tester, html);
      expect(
        explained,
        equals('[SvgPicture:'
            'pictureProvider=ExactAssetPicture(name: "$assetName", bundle: null, colorFilter: null)'
            ']'),
      );
    });

    group('MemoryPicture', () {
      final explain = (WidgetTester tester, String html) => helper
          .explain(tester, html)
          .then((e) => e.replaceAll(RegExp(r'\(Uint8List#.+\)'), '(bytes)'));

      testWidgets('renders base64', (WidgetTester tester) async {
        final base64 =
            base64Encode(utf8.encode('<svg viewBox="0 0 1 1"></svg>'));
        final html = '<img src="data:image/svg+xml;base64,$base64" />';
        final e = await explain(tester, html);
        expect(e, equals('[SvgPicture:pictureProvider=MemoryPicture(bytes)]'));
      });

      testWidgets('renders utf8', (WidgetTester tester) async {
        final utf8 = '&lt;svg viewBox=&quot;0 0 1 1&quot;&gt;&lt;/svg&gt;';
        final html = '<img src="data:image/svg+xml;utf8,$utf8" />';
        final e = await explain(tester, html);
        expect(e, equals('[SvgPicture:pictureProvider=MemoryPicture(bytes)]'));
      });
    });

    testWidgets('renders network picture', (WidgetTester t) async {
      final src = 'http://domain.com/image.svg';
      final h = '<img src="$src" />';
      final explained = await mockNetworkImagesFor(() => helper.explain(t, h));
      expect(
        explained,
        equals('[SvgPicture:'
            'pictureProvider=NetworkPicture("$src", headers: null, colorFilter: null)'
            ']'),
      );
    });
  });
}
