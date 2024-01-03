import 'package:flutter_test/flutter_test.dart';

import '../../_.dart';

Future<void> main() async {
  group('line-height', () {
    testWidgets('renders number', (WidgetTester tester) async {
      const html = '<span style="line-height: 1">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+height=1.0:Foo)]'));
    });

    testWidgets('renders decimal', (WidgetTester tester) async {
      const html = '<span style="line-height: 1.1">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+height=1.1:Foo)]'));
    });

    testWidgets('renders em', (WidgetTester tester) async {
      const html = '<span style="line-height: 5em">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+height=5.0:Foo)]'));
    });

    testWidgets('renders percentage', (WidgetTester tester) async {
      const html = '<span style="line-height: 50%">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+height=0.5:Foo)]'));
    });

    testWidgets('renders pt', (WidgetTester tester) async {
      const html = '<span style="line-height: 50pt">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+height=6.7:Foo)]'));
    });

    testWidgets('renders px', (WidgetTester tester) async {
      const html = '<span style="line-height: 50px">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(+height=5.0:Foo)]'));
    });

    testWidgets('renders invalid', (WidgetTester tester) async {
      const html = '<span style="line-height: xxx">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('renders fixed height over 0 font size', (tester) async {
      // TODO: doesn't match browser output
      const html = '<span style="font-size: 0; line-height: 10px">Foo</span>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(@0.0:Foo)]'));
    });

    testWidgets('renders child element (same)', (WidgetTester tester) async {
      const html = '<span style="line-height: 1">Foo <em>bar</em></span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:(+height=1.0:Foo )(+height=1.0+i:bar))]'));
    });

    testWidgets('renders child element (override)', (tester) async {
      const html = '<span style="line-height: 1">Foo '
          '<em style="line-height: 2">bar</em></span>';
      final e = await explain(tester, html);
      expect(e, equals('[RichText:(:(+height=1.0:Foo )(+height=2.0+i:bar))]'));
    });

    group('reset to normal', () {
      testWidgets('cannot reset to null', (tester) async {
        const html = '<span style="line-height: 2">Foo '
            '<em style="line-height: normal">bar</em></span>';
        final explained = await explain(
          tester,
          html,
          // ignore: avoid_redundant_argument_values
          height: null,
        );
        expect(
          explained,
          equals('[RichText:(:(+height=2.0:Foo )(+height=2.0+i:bar))]'),
        );
      });

      testWidgets('reset to 1', (tester) async {
        const html = '<span style="line-height: 2">Foo '
            '<em style="line-height: normal">bar</em></span>';
        final explained = await explain(tester, html, height: 1);
        expect(
          explained,
          equals(
            '[RichText:(+height=1.0:(+height=2.0:Foo )'
            '(+height=1.0+i:bar))]',
          ),
        );
      });
    });
  });
}
