import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '_.dart' as _;

void main() {
  group('image.png', () {
    final src = 'http://domain.com/image.png';
    final explain = (WidgetTester tester, String html) => _.explain(
          tester,
          html,
          imageUrlToPrecache: src,
        );

    testWidgets('renders src', (WidgetTester tester) async {
      final html = '<img src="$src" />';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[RichText:[NetworkImage:url=$src]]'),
      );
    });

    testWidgets('renders data-src', (WidgetTester tester) async {
      final html = '<img data-src="$src" />';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:[NetworkImage:url=$src]]'));
    });

    testWidgets('renders data uri', (WidgetTester tester) async {
      // https://stackoverflow.com/questions/6018611/smallest-data-uri-image-possible-for-a-transparent-image
      final html = '<img src="data:image/gif;base64,'
          'R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" />';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:[MemoryImage:]]'));
    });

    testWidgets('renders bad data uri', (WidgetTester tester) async {
      final html = '<img src="data:image/xxx" />';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:)]'));
    });

    testWidgets('renders bad data uri with alt text', (WidgetTester t) async {
      final html = '<img src="data:image/xxx" alt="Foo" />';
      final explained = await explain(t, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('renders bad data uri with title text', (WidgetTester t) async {
      final html = '<img src="data:image/xxx" title="Foo" />';
      final explained = await explain(t, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('renders in one RichText', (WidgetTester tester) async {
      final html = '<img src="$src" /> <img src="$src" />';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[RichText:(:'
            "[NetworkImage:url=$src]"
            '(: )'
            "[NetworkImage:url=$src]"
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
          equals('[RichText:'
              "[ImageLayout:child=[NetworkImage:url=$src],"
              'height=600.0,'
              'width=800.0'
              ']]'));
    });

    testWidgets('renders dimensions in inline style', (tester) async {
      final html = '<img src="$src" style="height: 600px; width: 800px" />';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[RichText:'
              "[ImageLayout:child=[NetworkImage:url=$src],"
              'height=600.0,'
              'width=800.0'
              ']]'));
    });

    testWidgets('renders between texts', (WidgetTester tester) async {
      final html = 'Before text. <img src="$src" /> After text.';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[RichText:(:'
              'Before text. '
              "[NetworkImage:url=$src]"
              '(: After text.)'
              ')]'));
    });
  });

  group('asset', () {
    final assetName = 'path/image.png';
    final explain = (
      WidgetTester tester,
      String html, {
      String package,
    }) =>
        _.explain(
          tester,
          html,
          preTest: (context) {
            precacheImage(
              AssetImage(assetName, package: package),
              context,
              onError: (_, __) {},
            );
          },
        );

    testWidgets('renders asset', (WidgetTester tester) async {
      final html = '<img src="asset:$assetName" />';
      final e = await explain(tester, html);
      expect(e, equals("[RichText:[AssetImage:assetName=$assetName]]"));
    });

    testWidgets('renders asset (specified package)', (tester) async {
      final package = 'package';
      final html = '<img src="asset:$assetName?package=$package" />';
      final explained = await explain(tester, html, package: package);
      expect(
          explained,
          equals(
            "[RichText:[AssetImage:assetName=$assetName,package=$package]]",
          ));
    });

    testWidgets('renders bad asset', (WidgetTester tester) async {
      final html = '<img src="asset:" />';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:)]'));
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
    final explain = _.explain;

    testWidgets('renders data uri', (WidgetTester tester) async {
      // https://stackoverflow.com/questions/6018611/smallest-data-uri-image-possible-for-a-transparent-image
      final html = '<img src="data:image/gif;base64,'
          'R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" />';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:[MemoryImage:]]'));
    });

    testWidgets('renders bad data uri', (WidgetTester tester) async {
      final html = '<img src="data:image/xxx" />';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:)]'));
    });

    testWidgets('renders bad data uri with alt text', (WidgetTester t) async {
      final html = '<img src="data:image/xxx" alt="Foo" />';
      final explained = await explain(t, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('renders bad data uri with title text', (WidgetTester t) async {
      final html = '<img src="data:image/xxx" title="Foo" />';
      final explained = await explain(t, html);
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
      final explained = await _.explain(
        tester,
        html,
        baseUrl: baseUrl ?? Uri.parse('http://base.com/path/'),
        imageUrlToPrecache: fullUrl,
      );
      expect(
        explained,
        equals('[RichText:[NetworkImage:url=$fullUrl]]'),
      );
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
}
