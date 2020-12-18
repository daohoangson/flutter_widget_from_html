import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '_.dart' as helper;

void main() {
  final sizingConstraints = 'height≥0.0,height=auto,width≥0.0,width=auto';

  group('image.png', () {
    final src = 'http://domain.com/image.png';
    final explain = (WidgetTester tester, String html) =>
        mockNetworkImagesFor(() async => helper.explain(tester, html));

    testWidgets('renders src', (WidgetTester tester) async {
      final html = '<img src="$src" />';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[CssSizing:$sizingConstraints,child='
            '[Image:image=CachedNetworkImageProvider("$src", scale: 1.0)]'
            ']'),
      );
    });

    testWidgets('renders src+alt', (WidgetTester tester) async {
      final html = '<img src="$src" alt="Foo" />';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[CssSizing:$sizingConstraints,child='
            '[Image:'
            'image=CachedNetworkImageProvider("$src", scale: 1.0),'
            'semanticLabel=Foo'
            ']]'),
      );
    });

    testWidgets('renders src+title', (WidgetTester tester) async {
      final html = '<img src="$src" title="Bar" />';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:$sizingConstraints,child='
              '[Tooltip:'
              'message=Bar,'
              'child=[Image:'
              'image=CachedNetworkImageProvider("http://domain.com/image.png", scale: 1.0),'
              'semanticLabel=Bar'
              ']]]'));
    });

    testWidgets('renders src+alt+title', (WidgetTester tester) async {
      final html = '<img src="$src" alt="Foo" title="Bar" />';
      final e = await explain(tester, html);
      expect(
          e,
          equals('[CssSizing:$sizingConstraints,child='
              '[Tooltip:'
              'message=Bar,'
              'child=[Image:'
              'image=CachedNetworkImageProvider("http://domain.com/image.png", scale: 1.0),'
              'semanticLabel=Foo'
              ']]]'));
    });

    testWidgets('onTapImage', (WidgetTester tester) async {
      final taps = <ImageMetadata>[];
      await tester
          .pumpWidget(_TapTestApp('http://domain.com/image.png', taps.add));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Image));
      expect(taps.length, equals(1));
    });
  });

  group('SvgPicture', () {
    testWidgets('renders asset picture', (WidgetTester tester) async {
      final assetName = 'test/images/logo.svg';
      final html = '<img src="asset:$assetName" />';
      final explained = await helper.explain(tester, html);
      expect(
        explained,
        equals('[CssSizing:$sizingConstraints,child='
            '[SvgPicture:'
            'pictureProvider=ExactAssetPicture(name: "$assetName", bundle: null, colorFilter: null)'
            ']]'),
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
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[CssSizing:$sizingConstraints,child='
                '[SvgPicture:pictureProvider=MemoryPicture(bytes)]'
                ']'));
      });

      testWidgets('renders utf8', (WidgetTester tester) async {
        final utf8 = '&lt;svg viewBox=&quot;0 0 1 1&quot;&gt;&lt;/svg&gt;';
        final html = '<img src="data:image/svg+xml;utf8,$utf8" />';
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[CssSizing:$sizingConstraints,child='
                '[SvgPicture:pictureProvider=MemoryPicture(bytes)]'
                ']'));
      });
    });

    testWidgets('renders network picture', (WidgetTester t) async {
      final src = 'http://domain.com/image.svg';
      final h = '<img src="$src" />';
      final explained = await mockNetworkImagesFor(() => helper.explain(t, h));
      expect(
        explained,
        equals('[CssSizing:$sizingConstraints,child='
            '[SvgPicture:'
            'pictureProvider=NetworkPicture("$src", headers: null, colorFilter: null)'
            ']]'),
      );
    });
  });

  testWidgets('onTapImage', (WidgetTester tester) async {
    final taps = <ImageMetadata>[];
    await tester
        .pumpWidget(_TapTestApp('asset:test/images/logo.svg', taps.add));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(SvgPicture));
    expect(taps.length, equals(1));
  });
}

class _TapTestApp extends StatelessWidget {
  final void Function(ImageMetadata) onTapImage;
  final String src;

  const _TapTestApp(this.src, this.onTapImage, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext _) => MaterialApp(
        home: Scaffold(
          body: HtmlWidget(
            '<img src="$src" width="10" height="10" />',
            onTapImage: onTapImage,
          ),
        ),
      );
}
