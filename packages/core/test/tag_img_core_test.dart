import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
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
              '[Image:image=NetworkImage("$src", scale: 1.0)]'
              ']'));
    });

    testWidgets('renders in one RichText', (WidgetTester tester) async {
      final html = '<img src="$src" /> <img src="$src" />';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[RichText:(:'
            '[CssSizing:$sizingConstraints,child=[Image:image=NetworkImage("$src", scale: 1.0)]]'
            '(: )'
            '[CssSizing:$sizingConstraints,child=[Image:image=NetworkImage("$src", scale: 1.0)]]'
            ')]'),
      );
    });

    testWidgets('renders alt', (WidgetTester tester) async {
      final html = '<img alt="Foo" /> bar';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo bar)]'));
    });

    testWidgets('renders title', (WidgetTester tester) async {
      final html = '<img title="Foo" /> bar';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo bar)]'));
    });

    testWidgets('renders dimensions', (WidgetTester tester) async {
      final html = '<img src="$src" width="800" height="600" />';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals(
              '[CssSizing:height≥0.0,height=600.0,width≥0.0,width=800.0,child='
              '[AspectRatio:aspectRatio=1.3,child=[Image:image=NetworkImage("$src", scale: 1.0)]]'
              ']'));
    });

    testWidgets('renders between texts', (WidgetTester tester) async {
      final html = 'Before text. <img src="$src" /> After text.';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[RichText:(:'
              'Before text. '
              '[CssSizing:$sizingConstraints,child=[Image:image=NetworkImage("$src", scale: 1.0)]]'
              '(: After text.)'
              ')]'));
    });

    testWidgets('renders block', (WidgetTester tester) async {
      final html = '<img src="$src" style="display: block" />';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:$sizingConstraints,child='
              '[Image:image=NetworkImage("$src", scale: 1.0)]]'));
    });

    testWidgets('renders block without src', (WidgetTester tester) async {
      final html = '<img style="display: block" />';
      final explained = await explain(tester, html);
      expect(explained, equals('[widget0]'));
    });
  });

  group('asset', () {
    final assetName = 'test/images/logo.png';
    final explain = (WidgetTester tester, String html, {String package}) =>
        helper.explain(tester, html);

    testWidgets('renders asset', (WidgetTester tester) async {
      final html = '<img src="asset:$assetName" />';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssSizing:$sizingConstraints,child='
              '[Image:image=AssetImage('
              'bundle: null, '
              'name: "$assetName"'
              ')]]'));
    });

    testWidgets('renders asset (specified package)', (tester) async {
      final package = 'flutter_widget_from_html_core';
      final html = '<img src="asset:$assetName?package=$package" />';
      final explained = await explain(tester, html, package: package);
      expect(
          explained,
          equals('[CssSizing:$sizingConstraints,child='
              '[Image:image=AssetImage('
              'bundle: null, '
              'name: "packages/$package/$assetName"'
              ')]]'));
    });

    testWidgets('renders bad asset', (WidgetTester tester) async {
      final html = '<img src="asset:" />';
      final explained = await explain(tester, html);
      expect(explained, equals('[widget0]'));
    });

    testWidgets('renders bad asset with alt text', (WidgetTester tester) async {
      final html = '<img src="asset:" alt="Foo" />';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('renders bad asset with title text', (tester) async {
      final html = '<img src="asset:" title="Foo" />';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });
  });

  group('data uri', () {
    final explain = helper.explain;

    testWidgets('renders data uri', (WidgetTester tester) async {
      final html = '<img src="${helper.kDataUri}" />';
      final explained = (await explain(tester, html))
          .replaceAll(RegExp(r'Uint8List#[0-9a-f]+,'), 'bytes,');
      expect(
          explained,
          equals('[CssSizing:$sizingConstraints,child='
              '[Image:image=MemoryImage(bytes, scale: 1.0)]'
              ']'));
    });

    testWidgets('renders bad data uri', (WidgetTester tester) async {
      final html = '<img src="data:image/xxx" />';
      final explained = await explain(tester, html);
      expect(explained, equals('[widget0]'));
    });

    testWidgets('renders bad data uri with alt text', (tester) async {
      final html = '<img src="data:image/xxx" alt="Foo" />';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('renders bad data uri with title text', (tester) async {
      final html = '<img src="data:image/xxx" title="Foo" />';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });
  });

  group('file uri', () {
    final explain = helper.explain;
    final filePath = '${Directory.current.path}/test/images/logo.png';
    final fileUri = 'file://$filePath';

    testWidgets('renders file uri', (WidgetTester tester) async {
      final html = '<img src="$fileUri" />';
      final explained = (await explain(tester, html))
          .replaceAll(RegExp(r'Uint8List#[0-9a-f]+,'), 'bytes,');
      expect(
          explained,
          equals('[CssSizing:$sizingConstraints,child='
              '[Image:image=FileImage("$filePath", scale: 1.0)]'
              ']'));
    });
  });

  group('baseUrl', () {
    final test = (
      WidgetTester tester,
      String html,
      String fullUrl, {
      Uri baseUrl,
    }) async {
      final explained = await helper.explain(tester, null,
          hw: HtmlWidget(
            html,
            baseUrl: baseUrl ?? Uri.parse('http://base.com/path/'),
            key: helper.hwKey,
          ));
      expect(
          explained,
          equals('[CssSizing:$sizingConstraints,child='
              '[Image:image=NetworkImage("$fullUrl", scale: 1.0)]'
              ']'));
    };

    testWidgets('renders full url', (WidgetTester tester) async {
      final fullUrl = 'http://domain.com/image.png';
      final html = '<img src="$fullUrl" />';
      await test(tester, html, fullUrl);
    });

    testWidgets('renders protocol relative url', (WidgetTester tester) async {
      final html = '<img src="//protocol.relative" />';
      final fullUrl = 'http://protocol.relative';
      await test(tester, html, fullUrl);
    });

    testWidgets('renders protocol relative url (https)', (tester) async {
      final html = '<img src="//protocol.relative/secured" />';
      final fullUrl = 'https://protocol.relative/secured';
      await test(
        tester,
        html,
        fullUrl,
        baseUrl: Uri.parse('https://base.com/secured'),
      );
    });

    testWidgets('renders root relative url', (WidgetTester tester) async {
      final html = '<img src="/root.relative" />';
      final fullUrl = 'http://base.com/root.relative';
      await test(tester, html, fullUrl);
    });

    testWidgets('renders relative url', (WidgetTester tester) async {
      final html = '<img src="relative" />';
      final fullUrl = 'http://base.com/path/relative';
      await test(tester, html, fullUrl);
    });
  });

  testWidgets('onTapImage', (WidgetTester tester) async {
    final taps = <ImageMetadata>[];
    await tester.pumpWidget(_TapTestApp(onTapImage: taps.add));
    await tester.tap(find.byType(Image));
    expect(taps.length, equals(1));
  });

  group('error handing', () {
    testWidgets('executes errorBuilder', (WidgetTester tester) async {
      final html = 'Foo <img src="data:image/jpg;base64,xxxx" /> bar';
      await tester.pumpWidget(MaterialApp(home: HtmlWidget(html)));
      await tester.pumpAndSettle();
      await expect(find.text('❌'), findsOneWidget);
    });
  });
}

class _TapTestApp extends StatelessWidget {
  final void Function(ImageMetadata) onTapImage;

  const _TapTestApp({Key key, this.onTapImage}) : super(key: key);

  @override
  Widget build(BuildContext _) => MaterialApp(
        home: Scaffold(
          body: HtmlWidget(
            '<img src="asset:test/images/logo.png" width="10" height="10" />',
            onTapImage: onTapImage,
          ),
        ),
      );
}
