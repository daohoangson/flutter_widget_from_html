import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '_.dart' as helper;

final svgBytes = utf8.encode('<svg viewBox="0 0 1 1"></svg>');

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

  testWidgets('logo.svg', (WidgetTester tester) async {
    final assetName = 'test/images/logo.svg';
    final package = 'fwfh_svg';
    final html = '<img src="asset:$assetName?package=$package" />';
    final explained = await helper.explain(tester, html);
    expect(
      explained,
      equals('[CssSizing:$sizingConstraints,child='
          '[SvgPicture:'
          'pictureProvider=ExactAssetPicture(name: "packages/$package/$assetName", bundle: null, colorFilter: null)'
          ']]'),
    );
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
