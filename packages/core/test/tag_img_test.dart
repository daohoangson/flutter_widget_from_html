import 'package:flutter_test/flutter_test.dart';

import '_.dart' as _;

void main() {
  group('image.png', () {
    final explain = (WidgetTester t, String h) =>
        _.explain(t, h, imageUrlToPrecache: "image.png");

    testWidgets('renders src', (WidgetTester tester) async {
      final html = '<img src="image.png" />';
      final explained = await explain(tester, html);
      expect(explained, equals('[Image:image=[NetworkImage:url=image.png]]'));
    });

    testWidgets('renders data-src', (WidgetTester tester) async {
      final html = '<img data-src="image.png" />';
      final explained = await explain(tester, html);
      expect(explained, equals('[Image:image=[NetworkImage:url=image.png]]'));
    });

    testWidgets('renders data uri', (WidgetTester tester) async {
      // https://stackoverflow.com/questions/6018611/smallest-data-uri-image-possible-for-a-transparent-image
      final html = '<img src="data:image/gif;base64,'
          'R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" />';
      final explained = await explain(tester, html);
      expect(explained, equals('[Image:image=[MemoryImage:]]'));
    });

    testWidgets('renders alt', (WidgetTester tester) async {
      final html = '<img alt="Foo" />';
      final explained = await explain(tester, html);
      expect(explained, equals('[Text:Foo]'));
    });

    testWidgets('renders title', (WidgetTester tester) async {
      final html = '<img title="Foo" />';
      final explained = await explain(tester, html);
      expect(explained, equals('[Text:Foo]'));
    });

    testWidgets('renders dimensions', (WidgetTester tester) async {
      final html = '<img src="image.png" width="800" height="600" />';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[AspectRatio:aspectRatio=1.33,'
              'child=[Image:image=[NetworkImage:url=image.png]]]'));
    });

    testWidgets('renders between texts', (WidgetTester tester) async {
      final html = 'Before text. <img src="image.png" /> After text.';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Column:children=[RichText:(:Before text.)],'
              '[Image:image=[NetworkImage:url=image.png]],'
              '[RichText:(:After text.)]]'));
    });
  });

  group('baseUrl', () {
    final test = (
      WidgetTester tester,
      String html,
      String fullUrl,
    ) =>
        _
            .explain(
              tester,
              html,
              baseUrl: Uri.parse('http://base.com/path'),
              imageUrlToPrecache: fullUrl,
            )
            .then((explained) => expect(
                  explained,
                  equals('[Image:image=[NetworkImage:url=$fullUrl]]'),
                ));

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
