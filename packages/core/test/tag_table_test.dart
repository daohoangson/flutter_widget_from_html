import 'package:flutter_test/flutter_test.dart';

import '_.dart';

void main() {
  testWidgets('renders basic table', (WidgetTester tester) async {
    final html = '''<table>
      <caption>Caption</caption>
      <tr><th>Header 1</th><th>Header 2</th></tr>
      <tr><td>Value 1</td><td>Value 2</td></tr>
    </table>''';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[Column:children=[RichText,align=center:(:Caption)],[Table:\n'
            '[RichText:(+b:Header 1)] | [RichText:(+b:Header 2)]\n'
            '[RichText:(:Value 1)] | [RichText:(:Value 2)]\n'
            ']]'));
  });

  testWidgets('renders 2 tables', (WidgetTester tester) async {
    final html = '<table><tr><td>Foo</td></tr></table>'
        '<table><tr><td>Bar</td></tr></table>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[Column:children='
            '[Table:\n[RichText:(:Foo)]\n],'
            '[Table:\n[RichText:(:Bar)]\n]'
            ']'));
  });

  testWidgets('renders THEAD/TBODY/TFOOT tags', (WidgetTester tester) async {
    final html = '''<table>
      <tfoot><tr><td>Footer 1</td><td>Footer 2</td></tr></tfoot>
      <tbody><tr><td>Value 1</td><td>Value 2</td></tr></tbody>
      <thead><tr><th>Header 1</th><th>Header 2</th></tr></thead>
    </table>''';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[Table:\n'
            '[RichText:(+b:Header 1)] | [RichText:(+b:Header 2)]\n'
            '[RichText:(:Value 1)] | [RichText:(:Value 2)]\n'
            '[RichText:(:Footer 1)] | [RichText:(:Footer 2)]\n'
            ']'));
  });

  group('inline style', () {
    testWidgets('renders cell stylings', (WidgetTester tester) async {
      final html = '<table>'
          '<tr><th>Header 1</th><th style="text-align: center">Header 2</th></tr>'
          '<tr><td>Value <em>1</em></td><td style="font-weight: bold">Value 2</td></tr>'
          '</table>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Table:\n'
              '[RichText:(+b:Header 1)] | [RichText,align=center:(+b:Header 2)]\n'
              '[RichText:(:Value (+i:1))] | [RichText:(+b:Value 2)]\n'
              ']'));
    });

    testWidgets('renders row stylings', (WidgetTester tester) async {
      final html = '<table>'
          '<tr style="text-align: center"><th>Header 1</th><th>Header 2</th></tr>'
          '<tr style="font-weight: bold"><td>Value <em>1</em></td><td>Value 2</td></tr>'
          '</table>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Table:\n'
              '[RichText,align=center:(+b:Header 1)] | [RichText,align=center:(+b:Header 2)]\n'
              '[RichText:(+b:Value (+i+b:1))] | [RichText:(+b:Value 2)]\n'
              ']'));
    });

    testWidgets('renders section stylings', (WidgetTester tester) async {
      final html = '<table>'
          '<tbody style="text-align: right">'
          '<tr><th>Header 1</th><th style="text-align: center">Header 2</th></tr>'
          '<tr><td>Value <em>1</em></td><td style="font-weight: bold">Value 2</td></tr>'
          '</tbody>'
          '</table>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Table:\n'
              '[RichText,align=right:(+b:Header 1)] | [RichText,align=center:(+b:Header 2)]\n'
              '[RichText,align=right:(:Value (+i:1))] | [RichText,align=right:(+b:Value 2)]\n'
              ']'));
    });
  });

  group('border', () {
    testWidgets('renders border=0', (WidgetTester tester) async {
      final html = '<table border="0"><tr><td>Foo</td></tr></table>';
      final explained = await explain(tester, html);
      expect(explained, equals('[Table:\n[RichText:(:Foo)]\n]'));
    });

    testWidgets('renders border=1', (WidgetTester tester) async {
      final html = '<table border="1"><tr><td>Foo</td></tr></table>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[Table:border=(Color(0xff000000),w=1.0)\n[RichText:(:Foo)]\n]'),
      );
    });

    testWidgets('renders style="border: 1px"', (WidgetTester tester) async {
      final html = '<table style="border: 1px"><tr><td>Foo</td></tr></table>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[Table:border=(Color(0xff000000),w=1.0)\n[RichText:(:Foo)]\n]'),
      );
    });

    testWidgets('renders style="border: 2px"', (WidgetTester tester) async {
      final html = '<table style="border: 2px"><tr><td>Foo</td></tr></table>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[Table:border=(Color(0xff000000),w=2.0)\n[RichText:(:Foo)]\n]'),
      );
    });

    testWidgets(
      'renders style="border: 1px solid #f00"',
      (WidgetTester tester) async {
        final html = '<table style="border: 1px solid #f00">'
            '<tr><td>Foo</td></tr></table>';
        final explained = await explain(tester, html);
        expect(
          explained,
          equals('[Table:border=(Color(0xffff0000),w=1.0)\n'
              '[RichText:(:Foo)]\n]'),
        );
      },
    );

    testWidgets('#70: renders border=1 with inline `text-align`', (t) async {
      final html = '<table border="1" style="text-align: left">'
          '<tr><td>Foo</td></tr></table>';
      final explained = await explain(t, html);
      expect(
        explained,
        equals('[Table:border=(Color(0xff000000),w=1.0)\n'
            '[RichText,align=left:(:Foo)]\n]'),
      );
    });
  });

  group('error handling', () {
    testWidgets('missing header', (WidgetTester tester) async {
      final html = '''<table>
      <tr><th>Header 1</th></tr>
      <tr><td>Value 1</td><td>Value 2</td></tr>
    </table>''';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Table:\n'
              '[RichText:(+b:Header 1)] | [widget0]\n'
              '[RichText:(:Value 1)] | [RichText:(:Value 2)]\n'
              ']'));
    });

    testWidgets('missing cell', (WidgetTester tester) async {
      final html = '''<table>
      <tr><th>Header 1</th><th>Header 2</th></tr>
      <tr><td>Value 1</td></tr>
    </table>''';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Table:\n'
              '[RichText:(+b:Header 1)] | [RichText:(+b:Header 2)]\n'
              '[RichText:(:Value 1)] | [widget0]\n'
              ']'));
    });

    testWidgets('standalone CAPTION', (WidgetTester tester) async {
      final html = '<caption>Foo</caption>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('standalone TABLE', (WidgetTester tester) async {
      final html = '<table>Foo</table>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[Column:children=[RichText:(:Foo)],[widget0]]'),
      );
    });

    testWidgets('standalone TD', (WidgetTester tester) async {
      final html = '<td>Foo</td>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('standalone TH', (WidgetTester tester) async {
      final html = '<th>Foo</th>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('standalone TR', (WidgetTester tester) async {
      final html = '<tr>Foo</tr>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('#80: empty TD', (WidgetTester tester) async {
      final html = '<table><tr><td></td></tr></table>';
      final explained = await explain(tester, html);
      expect(explained, equals('[Table:\n[widget0]\n]'));
    });

    testWidgets('empty TR', (WidgetTester tester) async {
      final html = '<table><tr></tr></table>';
      final explained = await explain(tester, html);
      expect(explained, equals('[widget0]'));
    });

    testWidgets('empty TBODY', (WidgetTester tester) async {
      final html = '<table><tbody></tbody></table>';
      final explained = await explain(tester, html);
      expect(explained, equals('[widget0]'));
    });

    testWidgets('empty TABLE', (WidgetTester tester) async {
      final html = '<table></table>';
      final explained = await explain(tester, html);
      expect(explained, equals('[widget0]'));
    });

    testWidgets('#171: background-color', (WidgetTester tester) async {
      final html = '<table><tr>'
          '<td style="background-color: #f00">Foo</td>'
          '</tr></table>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Table:\n'
              '[DecoratedBox:bg=#FFFF0000,child=[RichText:(:Foo)]]\n'
              ']'));
    });

    testWidgets('#171: background-color wraps padding', (tester) async {
      final html = '<table><tr>'
          '<td style="background-color: #f00; padding: 1px">Foo</td>'
          '</tr></table>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[Table:\n'
              '[DecoratedBox:bg=#FFFF0000,child=[Padding:(1,1,1,1),child=[RichText:(:Foo)]]]\n'
              ']'));
    });
  });
}
