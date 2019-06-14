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
        equals("[Wrap:children=[Image:image=[NetworkImage:url=$src]]]"),
      );
    });

    testWidgets('renders data-src', (WidgetTester tester) async {
      final html = '<img data-src="$src" />';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals("[Wrap:children=[Image:image=[NetworkImage:url=$src]]]"),
      );
    });

    testWidgets('renders in one wrap', (WidgetTester tester) async {
      final html = '<img src="$src" /><img src="$src" />';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals("[Wrap:children=[Image:image=[NetworkImage:url=$src]],"
            "[Image:image=[NetworkImage:url=$src]]]"),
      );
    });

    testWidgets('renders alt', (WidgetTester tester) async {
      final html = '<img alt="Foo" /> bar';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals(
              '[Column:children=[Wrap:children=[Text:Foo]],[RichText:(:bar)]]'));
    });

    testWidgets('renders title', (WidgetTester tester) async {
      final html = '<img title="Foo" /> bar';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals(
              '[Column:children=[Wrap:children=[Text:Foo]],[RichText:(:bar)]]'));
    });

    testWidgets('renders dimensions', (WidgetTester tester) async {
      final html = '<img src="$src" width="800" height="600" />';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Wrap:children=[LimitedBox:h=600.0,w=800.0,child='
              '[AspectRatio:aspectRatio=1.33,child='
              '[Image:image=[NetworkImage:url=$src]]]]]'));
    });

    testWidgets('renders between texts', (WidgetTester tester) async {
      final html = 'Before text. <img src="$src" /> After text.';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Column:children=[RichText:(:Before text.)],'
              '[Wrap:children=[Image:image=[NetworkImage:url=$src]]],'
              '[RichText:(:After text.)]]'));
    });
  });

  group('asset', () {
    final explain = _.explain;

    testWidgets('renders asset', (WidgetTester tester) async {
      final html = '<img src="asset:path/image.png" />';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Wrap:children=[Image:image='
              '[AssetImage:assetName=path/image.png]]]'));
    });

    testWidgets('renders asset (specified package)', (tester) async {
      final html = '<img src="asset:path/image.png?package=package" />';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Wrap:children=[Image:image='
              '[AssetImage:assetName=path/image.png,package=package]]]'));
    });

    testWidgets('renders bad asset name', (WidgetTester tester) async {
      final html = '<img src="asset:" />';
      final explained = await explain(tester, html);
      expect(explained, equals('[Wrap:children=[Text:]]'));
    });
  });

  group('data uri', () {
    final explain = _.explain;

    testWidgets('renders data uri', (WidgetTester tester) async {
      // https://stackoverflow.com/questions/6018611/smallest-data-uri-image-possible-for-a-transparent-image
      final html = '<img src="data:image/gif;base64,'
          'R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" />';
      final explained = await explain(tester, html);
      expect(explained, equals('[Wrap:children=[Image:image=[MemoryImage:]]]'));
    });

    testWidgets('renders bad data uri', (WidgetTester tester) async {
      final html = '<img src="data:image/xxx" />';
      final explained = await explain(tester, html);
      expect(explained, equals('[Wrap:children=[Text:]]'));
    });

    testWidgets('renders bad data uri with alt text', (WidgetTester t) async {
      final html = '<img src="data:image/xxx" alt="Foo" />';
      final explained = await explain(t, html);
      expect(explained, equals('[Wrap:children=[Text:Foo]]'));
    });

    testWidgets('renders bad data uri with title text', (WidgetTester t) async {
      final html = '<img src="data:image/xxx" title="Foo" />';
      final explained = await explain(t, html);
      expect(explained, equals('[Wrap:children=[Text:Foo]]'));
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
        equals('[Wrap:children=[Image:image=[NetworkImage:url=$fullUrl]]]'),
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
