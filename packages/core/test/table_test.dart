import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  testWidgets('renders basic table', (WidgetTester tester) async {
    final html = """<table>
      <tr><th>Header 1</th><th>Header 2</th></tr>
      <tr><td>Value 1</td><td>Value 2</td></tr>
    </table>""";
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[Table:\n' +
            '[RichText:(+b:Header 1)] | [RichText:(+b:Header 2)]\n' +
            '[Text:Value 1] | [Text:Value 2]\n' +
            ']'));
  });

  testWidgets('renders missing header', (WidgetTester tester) async {
    final html = """<table>
      <tr><th>Header 1</th></tr>
      <tr><td>Value 1</td><td>Value 2</td></tr>
    </table>""";
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[Table:\n' +
            '[RichText:(+b:Header 1)] | [Container:child=[Null:]]\n' +
            '[Text:Value 1] | [Text:Value 2]\n' +
            ']'));
  });

  testWidgets('renders missing cell', (WidgetTester tester) async {
    final html = """<table>
      <tr><th>Header 1</th><th>Header 2</th></tr>
      <tr><td>Value 1</td></tr>
    </table>""";
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[Table:\n' +
            '[RichText:(+b:Header 1)] | [RichText:(+b:Header 2)]\n' +
            '[Text:Value 1] | [Container:child=[Null:]]\n' +
            ']'));
  });

  testWidgets('renders stylings', (WidgetTester tester) async {
    final html = """<table>
      <tr><th>Header 1</th><th style="text-align: center">Header 2</th></tr>
      <tr><td>Value <em>1</em></td><td style="font-weight: bold">Value 2</td></tr>
    </table>""";
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[Table:\n' +
            '[RichText:(+b:Header 1)] | [RichText,align=center:(+b:Header 2)]\n' +
            '[RichText:(:Value (+i:1))] | [RichText:(+b:Value 2)]\n' +
            ']'));
  });

  group('border', () {
    testWidgets('renders border=0', (WidgetTester tester) async {
      final html = '<table border="0"><tr><td>Foo</td></tr></table>';
      final explained = await explain(tester, html);
      expect(explained, equals('[Table:\n[Text:Foo]\n]'));
    });

    testWidgets('renders border=1', (WidgetTester tester) async {
      final html = '<table border="1"><tr><td>Foo</td></tr></table>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[Table:border=(Color(0xff000000),w=1.0)\n[Text:Foo]\n]'),
      );
    });

    testWidgets('renders style="border: 1px"', (WidgetTester tester) async {
      final html = '<table style="border: 1px"><tr><td>Foo</td></tr></table>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[Table:border=(Color(0xff000000),w=1.0)\n[Text:Foo]\n]'),
      );
    });

    testWidgets('renders style="border: 2px"', (WidgetTester tester) async {
      final html = '<table style="border: 2px"><tr><td>Foo</td></tr></table>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[Table:border=(Color(0xff000000),w=2.0)\n[Text:Foo]\n]'),
      );
    });

    testWidgets(
      'renders style="border: 1px solid #f00"',
      (WidgetTester tester) async {
        final html = '<table style="border: 1px solid #f00">' +
            '<tr><td>Foo</td></tr></table>';
        final explained = await explain(tester, html);
        expect(
          explained,
          equals('[Table:border=(Color(0xffff0000),w=1.0)\n[Text:Foo]\n]'),
        );
      },
    );
  });
}
