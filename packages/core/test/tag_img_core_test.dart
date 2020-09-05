import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '_.dart' as helper;

void main() {
  group('image.png', () {
    final src = 'http://domain.com/image.png';
    final explain = (WidgetTester tester, String html) =>
        mockNetworkImagesFor(() async => helper.explain(tester, html));

    testWidgets('renders src', (WidgetTester tester) async {
      final html = '<img src="$src" />';
      final e = await explain(tester, html);
      expect(e, equals('[Image:image=NetworkImage("$src", scale: 1.0)]'));
    });

    testWidgets('renders in one RichText', (WidgetTester tester) async {
      final html = '<img src="$src" /> <img src="$src" />';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[RichText:(:'
            '[Image:image=NetworkImage("$src", scale: 1.0)]'
            '(: )'
            '[Image:image=NetworkImage("$src", scale: 1.0)]'
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
          equals('[CssSizing:height=600.0,width=800.0,child='
              '[Image:image=NetworkImage("$src", scale: 1.0)]'
              ']'));
    });

    testWidgets('renders between texts', (WidgetTester tester) async {
      final html = 'Before text. <img src="$src" /> After text.';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[RichText:(:'
              'Before text. '
              '[Image:image=NetworkImage("$src", scale: 1.0)]'
              '(: After text.)'
              ')]'));
    });

    testWidgets('renders block', (WidgetTester tester) async {
      final html = '<img src="$src" style="display: block" />';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child='
              '[Image:image=NetworkImage("$src", scale: 1.0)]]'));
    });

    testWidgets('renders block without src', (WidgetTester tester) async {
      final html = '<img style="display: block" />';
      final explained = await explain(tester, html);
      expect(explained, equals('[widget0]'));
    });
  });

  group('asset', () {
    final assetName = 'path/image.png';
    final explain = (WidgetTester tester, String html, {String package}) =>
        helper.explain(tester, html);

    testWidgets('renders asset', (WidgetTester tester) async {
      final html = '<img src="asset:$assetName" />';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Image:image=AssetImage('
              'bundle: null, '
              'name: "$assetName"'
              ')]'));
    });

    testWidgets('renders asset (specified package)', (tester) async {
      final package = 'package';
      final html = '<img src="asset:$assetName?package=$package" />';
      final explained = await explain(tester, html, package: package);
      expect(
          explained,
          equals('[Image:image=AssetImage('
              'bundle: null, '
              'name: "packages/$package/$assetName"'
              ')]'));
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
      final explained = await explain(tester, html);
      final e = explained.replaceAll(RegExp(r'Uint8List#[0-9a-f]+,'), 'bytes,');
      expect(e, equals('[Image:image=MemoryImage(bytes, scale: 1.0)]'));
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

  group('baseUrl', () {
    final test = (
      WidgetTester tester,
      String html,
      String fullUrl, {
      Uri baseUrl,
    }) async {
      final e = await helper.explain(tester, null,
          hw: HtmlWidget(
            html,
            baseUrl: baseUrl ?? Uri.parse('http://base.com/path/'),
            key: helper.hwKey,
          ));
      expect(e, equals('[Image:image=NetworkImage("$fullUrl", scale: 1.0)]'));
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

  group('text-align', () {
    group('CENTER', () {
      final src = 'http://domain.com/image.png';
      final html = '<center><img src="$src" /></center>';

      testWidgets('renders', (WidgetTester tester) async {
        final explained =
            await mockNetworkImagesFor(() => helper.explain(tester, html));
        expect(
            explained,
            equals('[CssBlock:child=[RichText:align=center,'
                '[Image:image=NetworkImage("http://domain.com/image.png", scale: 1.0)]'
                ']]'));
      });

      testWidgets('useExplainer=false', (WidgetTester tester) async {
        final explained = await mockNetworkImagesFor(
            () => helper.explain(tester, html, useExplainer: false));
        expect(
            explained,
            equals('TshWidget\n'
                '└WidgetPlaceholder<BuildTree>(BuildTree#0 tsb#1(parent=#2):\n'
                ' │  BuildTree#3 tsb#4(parent=#1):\n'
                ' │    WidgetBit.inline#5 WidgetPlaceholder(ImageMetadata(sources: [ImageSource("$src")]))\n'
                ' │)\n'
                ' └CssBlock()\n'
                '  └RichText(textAlign: center, text: "￼")\n'
                '   └WidgetPlaceholder<ImageMetadata>(ImageMetadata(sources: [ImageSource("$src")]))\n'
                '    └_LoosenConstraintsWidget(crossAxisAlignment: center)\n'
                '     └Image(image: NetworkImage("$src", scale: 1.0), alignment: center, this.excludeFromSemantics: true)\n'
                '      └RawImage(alignment: center)\n\n'));
      });
    });

    testWidgets('updates crossAxisAlignment', (WidgetTester tester) async {
      final src = 'http://domain.com/image.png';
      final textAlign = ValueNotifier<String>('left');
      final explainedLeft =
          await mockNetworkImagesFor(() => helper.explain(tester, null,
              hw: ValueListenableBuilder(
                valueListenable: textAlign,
                builder: (_, value, __) => HtmlWidget(
                  '<div style="text-align: $value"><img src="$src" /></div>',
                  key: helper.hwKey,
                ),
              )));

      textAlign.value = '-webkit-center';
      await tester.pumpAndSettle();
      final explainedRight = await helper.explainWithoutPumping();

      expect(explainedRight, isNot(equals(explainedLeft)));
    });
  });
}
