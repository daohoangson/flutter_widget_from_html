import 'package:flutter_test/flutter_test.dart';

import '_.dart';

String _padding(String child) =>
    '[CssBlock:child=[Padding:(1,1,1,1),child=$child]]';

String _richtext(String text) => _padding('[RichText:(:$text)]');

void main() {
  group('basic table', () {
    final html = '''<table>
      <caption>Caption</caption>
      <tr><th>Header 1</th><th>Header 2</th></tr>
      <tr><td>Value 1</td><td>Value 2</td></tr>
    </table>''';

    testWidgets('renders', (WidgetTester tester) async {
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child=[Column:children='
              '[CssBlock:child=[RichText:align=center,(:Caption)]],'
              '[Table:\n'
              '${_padding('[RichText:(+b:Header 1)]')} | ${_padding('[RichText:(+b:Header 2)]')}\n'
              '${_richtext('Value 1')} | ${_richtext('Value 2')}\n'
              ']]]'));
    });

    testWidgets('useExplainer=false', (WidgetTester tester) async {
      final explained = await explain(tester, html, useExplainer: false);
      expect(
          explained,
          equals('TshWidget\n'
              '└WidgetPlaceholder<BuildMetadata>(BuildMetadata(<table>\n'
              ' │      <caption>Caption</caption>\n'
              ' │      <tbody><tr><th>Header 1</th><th>Header 2</th></tr>\n'
              ' │      <tr><td>Value 1</td><td>Value 2</td></tr>\n'
              ' │    </tbody></table>)\n'
              ' │)\n'
              ' └CssBlock()\n'
              '  └Column()\n'
              '   ├WidgetPlaceholder<TextBits>(TextBits#0 tsb#1(parent=#2):\n'
              '   ││  "Caption"\n'
              '   ││)\n'
              '   │└CssBlock()\n'
              '   │ └RichText(textAlign: center, text: "Caption")\n'
              '   └Table()\n'
              '    ├TableCell(verticalAlignment: null)\n'
              '    │└WidgetPlaceholder<TextBits>(TextBits#3 tsb#4(parent=#5):\n'
              '    │ │  "Header 1"\n'
              '    │ │)\n'
              '    │ └CssBlock()\n'
              '    │  └Padding(padding: all(1.0))\n'
              '    │   └RichText(text: "Header 1")\n'
              '    ├TableCell(verticalAlignment: null)\n'
              '    │└WidgetPlaceholder<TextBits>(TextBits#6 tsb#7(parent=#5):\n'
              '    │ │  "Header 2"\n'
              '    │ │)\n'
              '    │ └CssBlock()\n'
              '    │  └Padding(padding: all(1.0))\n'
              '    │   └RichText(text: "Header 2")\n'
              '    ├TableCell(verticalAlignment: null)\n'
              '    │└WidgetPlaceholder<TextBits>(TextBits#8 tsb#9(parent=#10):\n'
              '    │ │  "Value 1"\n'
              '    │ │)\n'
              '    │ └CssBlock()\n'
              '    │  └Padding(padding: all(1.0))\n'
              '    │   └RichText(text: "Value 1")\n'
              '    └TableCell(verticalAlignment: null)\n'
              '     └WidgetPlaceholder<TextBits>(TextBits#11 tsb#12(parent=#10):\n'
              '      │  "Value 2"\n'
              '      │)\n'
              '      └CssBlock()\n'
              '       └Padding(padding: all(1.0))\n'
              '        └RichText(text: "Value 2")\n'
              '\n'));
    });
  });

  testWidgets('renders 2 tables', (WidgetTester tester) async {
    final html = '<table><tr><td>Foo</td></tr></table>'
        '<table><tr><td>Bar</td></tr></table>';
    final explained = await explain(tester, html);
    expect(
        explained,
        equals('[Column:children='
            '[CssBlock:child=[Table:\n${_richtext('Foo')}\n]],'
            '[CssBlock:child=[Table:\n${_richtext('Bar')}\n]]'
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
        equals('[CssBlock:child=[Table:\n'
            '${_padding('[RichText:(+b:Header 1)]')} | ${_padding('[RichText:(+b:Header 2)]')}\n'
            '${_richtext('Value 1')} | ${_richtext('Value 2')}\n'
            '${_richtext('Footer 1')} | ${_richtext('Footer 2')}\n'
            ']]'));
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
          equals('[CssBlock:child=[Table:\n'
              '${_padding('[RichText:(+b:Header 1)]')} | ${_padding('[RichText:align=center,(+b:Header 2)]')}\n'
              '${_padding('[RichText:(:Value (+i:1))]')} | ${_padding('[RichText:(+b:Value 2)]')}\n'
              ']]'));
    });

    testWidgets('renders row stylings', (WidgetTester tester) async {
      final html = '<table>'
          '<tr style="text-align: center"><th>Header 1</th><th>Header 2</th></tr>'
          '<tr style="font-weight: bold"><td>Value <em>1</em></td><td>Value 2</td></tr>'
          '</table>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child=[Table:\n'
              '${_padding('[RichText:align=center,(+b:Header 1)]')} | ${_padding('[RichText:align=center,(+b:Header 2)]')}\n'
              '${_padding('[RichText:(+b:Value (+i+b:1))]')} | ${_padding('[RichText:(+b:Value 2)]')}\n'
              ']]'));
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
          equals('[CssBlock:child=[Table:\n'
              '${_padding('[RichText:align=right,(+b:Header 1)]')} | ${_padding('[RichText:align=center,(+b:Header 2)]')}\n'
              '${_padding('[RichText:align=right,(:Value (+i:1))]')} | ${_padding('[RichText:align=right,(+b:Value 2)]')}\n'
              ']]'));
    });
  });

  group('border', () {
    testWidgets('renders border=0', (WidgetTester tester) async {
      final html = '<table border="0"><tr><td>Foo</td></tr></table>';
      final e = await explain(tester, html);
      expect(e, equals('[CssBlock:child=[Table:\n${_richtext('Foo')}\n]]'));
    });

    testWidgets('renders border=1', (WidgetTester tester) async {
      final html = '<table border="1"><tr><td>Foo</td></tr></table>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[CssBlock:child=[Table:border=1.0@solid#FF000000,\n'
            '${_richtext('Foo')}\n'
            ']]'),
      );
    });

    testWidgets('renders style="border: 1px"', (WidgetTester tester) async {
      final html = '<table style="border: 1px"><tr><td>Foo</td></tr></table>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[CssBlock:child=[Table:border=1.0@solid#FF000000,\n'
            '${_richtext('Foo')}\n'
            ']]'),
      );
    });

    testWidgets('renders style="border: 2px"', (WidgetTester tester) async {
      final html = '<table style="border: 2px"><tr><td>Foo</td></tr></table>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[CssBlock:child=[Table:border=2.0@solid#FF000000,\n'
            '${_richtext('Foo')}\n'
            ']]'),
      );
    });

    testWidgets('renders style="border: 1px solid #f00"', (tester) async {
      final html = '<table style="border: 1px solid #f00">'
          '<tr><td>Foo</td></tr></table>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals('[CssBlock:child=[Table:border=1.0@solid#FFFF0000,\n'
            '${_richtext('Foo')}\n'
            ']]'),
      );
    });

    testWidgets('#70: renders border=1 with inline text-align', (t) async {
      final html = '<table border="1" style="text-align: left">'
          '<tr><td>Foo</td></tr></table>';
      final explained = await explain(t, html);
      expect(
        explained,
        equals('[CssBlock:child=[Table:border=1.0@solid#FF000000,\n'
            '${_padding('[RichText:align=left,(:Foo)]')}\n'
            ']]'),
      );
    });

    testWidgets('#70: renders border=1 with cell text-align', (t) async {
      final html = '<table border="1">'
          '<tr><td style="text-align: left">Foo</td></tr></table>';
      final explained = await explain(t, html);
      expect(
        explained,
        equals('[CssBlock:child=[Table:border=1.0@solid#FF000000,\n'
            '${_padding('[RichText:align=left,(:Foo)]')}\n'
            ']]'),
      );
    });
  });

  group('cellpadding', () {
    testWidgets('renders cellpadding=1', (WidgetTester tester) async {
      final html = '<table cellpadding="1"><tr><td>Foo</td></tr></table>';
      final e = await explain(tester, html);
      expect(e, equals('[CssBlock:child=[Table:\n${_richtext('Foo')}\n]]'));
    });

    testWidgets('renders cellpadding=2', (WidgetTester tester) async {
      final html = '<table cellpadding="2"><tr><td>Foo</td></tr></table>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child=[Table:\n'
              '[CssBlock:child=[Padding:(2,2,2,2),child=[RichText:(:Foo)]]]\n'
              ']]'));
    });

    group('inline style', () {
      testWidgets('renders table=1 cell=1', (WidgetTester tester) async {
        final html = '<table cellpadding="1">'
            '<tr><td style="padding: 1px">Foo</td></tr>'
            '</table>';
        final e = await explain(tester, html);
        expect(e, equals('[CssBlock:child=[Table:\n${_richtext('Foo')}\n]]'));
      });

      testWidgets('renders table=1 cell=2', (WidgetTester tester) async {
        final html = '<table cellpadding="1">'
            '<tr><td style="padding: 2px">Foo</td></tr>'
            '</table>';
        final explained = await explain(tester, html);
        expect(
            explained,
            equals('[CssBlock:child=[Table:\n'
                '[CssBlock:child=[Padding:(2,2,2,2),child=[RichText:(:Foo)]]]\n'
                ']]'));
      });
    });
  });

  group('colspan / rowspan', () {
    testWidgets('renders colspan=1', (WidgetTester tester) async {
      final html = '<table><tr><td colspan="1">Foo</td></tr></table>';
      final e = await explain(tester, html);
      expect(e, equals('[CssBlock:child=[Table:\n${_richtext('Foo')}\n]]'));
    });

    testWidgets('renders colspan=2', (WidgetTester tester) async {
      final html = '<table><tr><td colspan="2">Foo</td></tr></table>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child=[Table:\n'
              '${_richtext('Foo')} | [widget0]\n'
              ']]'));
    });

    testWidgets('renders rowspan=1', (WidgetTester tester) async {
      final html = '<table><tr><td rowspan="1">Foo</td></tr></table>';
      final e = await explain(tester, html);
      expect(e, equals('[CssBlock:child=[Table:\n${_richtext('Foo')}\n]]'));
    });

    testWidgets('renders rowspan=2', (WidgetTester tester) async {
      final html = '<table><tr><td rowspan="2">Foo</td></tr></table>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child=[Table:\n'
              '${_richtext('Foo')}\n'
              '[widget0]\n'
              ']]'));
    });

    testWidgets('renders colspan=2 rowspan=2', (WidgetTester tester) async {
      final html = '<table><tr>'
          '<td colspan="2" rowspan="2">Foo</td>'
          '</tr></table>';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child=[Table:\n'
              '${_richtext('Foo')} | [widget0]\n'
              '[widget0] | [widget0]\n'
              ']]'));
    });

    testWidgets('renders cells being split by rowspan from above', (t) async {
      final html = '<table>'
          '<tr><td>1.1</td><td rowspan="2">1.2</td><td>1.3</td></tr>'
          '<tr><td>2.1</td><td>2.2</td></tr>'
          '</table>';
      final explained = await explain(t, html);
      expect(
          explained,
          equals('[CssBlock:child=[Table:\n'
              '${_richtext('1.1')} | ${_richtext('1.2')} | ${_richtext('1.3')}\n'
              '${_richtext('2.1')} | [widget0] | ${_richtext('2.2')}\n'
              ']]'));
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
          equals('[CssBlock:child=[Table:\n'
              '${_padding('[RichText:(+b:Header 1)]')} | [widget0]\n'
              '${_richtext('Value 1')} | ${_richtext('Value 2')}\n'
              ']]'));
    });

    testWidgets('missing cell', (WidgetTester tester) async {
      final html = '''<table>
      <tr><th>Header 1</th><th>Header 2</th></tr>
      <tr><td>Value 1</td></tr>
    </table>''';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child=[Table:\n'
              '${_padding('[RichText:(+b:Header 1)]')} | ${_padding('[RichText:(+b:Header 2)]')}\n'
              '${_richtext('Value 1')} | [widget0]\n'
              ']]'));
    });

    testWidgets('standalone CAPTION', (WidgetTester tester) async {
      final html = '<caption>Foo</caption>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('standalone TABLE', (WidgetTester tester) async {
      final html = '<table>Foo</table>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
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
      expect(explained, equals('[widget0]'));
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
          equals('[CssBlock:child=[Table:\n'
              '[DecoratedBox:bg=#FFFF0000,child=[CssBlock:child=[Padding:(1,1,1,1),child=[RichText:(:Foo)]]]]\n'
              ']]'));
    });
  });

  group('display: table', () {
    testWidgets('renders basic table', (WidgetTester tester) async {
      final html = '''<div style="display: table">
      <div style="display: table-caption; text-align: center">Caption</div>
      <div style="display: table-row; font-weight: bold">
        <span style="display: table-cell">Header 1</span>
        <span style="display: table-cell">Header 2</span>
      </div>
      <div style="display: table-row">
        <span style="display: table-cell">Value 1</span>
        <span style="display: table-cell">Value 2</span>
      </div>
    </div>''';
      final explained = await explain(tester, html);
      expect(
          explained,
          equals('[CssBlock:child=[Column:children='
              '[CssBlock:child=[RichText:align=center,(:Caption)]],'
              '[Table:\n'
              '[CssBlock:child=[RichText:(+b:Header 1)]] | [CssBlock:child=[RichText:(+b:Header 2)]]\n'
              '[CssBlock:child=[RichText:(:Value 1)]] | [CssBlock:child=[RichText:(:Value 2)]]\n'
              ']]]'));
    });
  });

  testWidgets('renders UL inside', (WidgetTester tester) async {
    final html = '<table><tr><td><ul><li>Foo</li></ul></td></tr></table>';
    final explained = await explain(tester, html);
    final expectedList = '[CssBlock:child=[Padding:(0,0,0,25),child='
        '[CssBlock:child=[Stack:children='
        '[RichText:(:Foo)],'
        '[Positioned:(0.0,null,null,-45.0),child=[SizedBox:40.0x0.0,child=[RichText:align=right,(:•)]]]'
        ']]]]';
    expect(
        explained,
        equals('[CssBlock:child=[Table:\n'
            '[Column:children='
            '[SizedBox:0.0x10.0],'
            '${_padding(expectedList)},'
            '[SizedBox:0.0x10.0]'
            ']\n'
            ']]'));
  });
}
