import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  testWidgets('renders basic table', (WidgetTester tester) async {
    final html = """<table>
      <caption>Caption</caption>
      <tr><th>Header 1</th><th>Header 2</th></tr>
      <tr><td>Value 1</td><td>Value 2</td></tr>
    </table>""";
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[Column:children=[Text,align=center:Caption],[Table:\n' +
            '[RichText:(+b:Header 1)] | [RichText:(+b:Header 2)]\n' +
            '[Text:Value 1] | [Text:Value 2]\n' +
            ']]'));
  });

  testWidgets('renders THEAD/TBODY/TFOOT tags', (WidgetTester tester) async {
    final html = """<table>
      <tfoot><tr><td>Footer 1</td><td>Footer 2</td></tr></tfoot>
      <tbody><tr><td>Value 1</td><td>Value 2</td></tr></tbody>
      <thead><tr><th>Header 1</th><th>Header 2</th></tr></thead>
    </table>""";
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[Table:\n'
            '[RichText:(+b:Header 1)] | [RichText:(+b:Header 2)]\n'
            '[Text:Value 1] | [Text:Value 2]\n'
            '[Text:Footer 1] | [Text:Footer 2]\n'
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

  group('error handling', () {
    testWidgets('missing header', (WidgetTester tester) async {
      final html = """<table>
      <tr><th>Header 1</th></tr>
      <tr><td>Value 1</td><td>Value 2</td></tr>
    </table>""";
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Table:\n' +
              '[RichText:(+b:Header 1)] | [Container:]\n' +
              '[Text:Value 1] | [Text:Value 2]\n' +
              ']'));
    });

    testWidgets('missing cell', (WidgetTester tester) async {
      final html = """<table>
      <tr><th>Header 1</th><th>Header 2</th></tr>
      <tr><td>Value 1</td></tr>
    </table>""";
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Table:\n' +
              '[RichText:(+b:Header 1)] | [RichText:(+b:Header 2)]\n' +
              '[Text:Value 1] | [Container:]\n' +
              ']'));
    });

    testWidgets('standalone CAPTION', (WidgetTester tester) async {
      final html = '<caption>Foo</caption>';
      final explained = await explain(tester, html);
      expect(explained, equals('[Text:Foo]'));
    });

    testWidgets('standalone TABLE', (WidgetTester tester) async {
      final html = '<table>Foo</table>';
      final explained = await explain(tester, html);
      expect(explained, equals('[Text:Foo]'));
    });

    testWidgets('standalone TD', (WidgetTester tester) async {
      final html = '<td>Foo</td>';
      final explained = await explain(tester, html);
      expect(explained, equals('[Text:Foo]'));
    });

    testWidgets('standalone TH', (WidgetTester tester) async {
      final html = '<th>Foo</th>';
      final explained = await explain(tester, html);
      expect(explained, equals('[Text:Foo]'));
    });

    testWidgets('standalone TR', (WidgetTester tester) async {
      final html = '<tr>Foo</tr>';
      final explained = await explain(tester, html);
      expect(explained, equals('[Text:Foo]'));
    });
  });
}
