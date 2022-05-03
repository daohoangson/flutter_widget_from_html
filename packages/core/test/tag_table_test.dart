import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '_.dart';

String _padding(String child) =>
    '[HtmlTableCell:child=[Align:alignment=centerLeft,child='
    '[Padding:(1,1,1,1),child=$child]]]';

String _richtext(String text) => _padding('[RichText:(:$text)]');

const bg = 'BoxDecoration(border: all(BorderSide(Color(0xff000000), '
    '1.0, BorderStyle.solid)))';

const border = 'all(BorderSide(Color(0xff000000), 1.0, BorderStyle.solid))';

Future<void> main() async {
  await loadAppFonts();

  group('basic usage', () {
    const html = '<table>'
        '<caption>Caption</caption>'
        '<tbody>'
        '<tr><th>Header 1</th><th>Header 2</th></tr>'
        '<tr><td>Value 1</td><td>Value 2</td></tr>'
        '</tbody>'
        '</table>';

    testWidgets('renders', (WidgetTester tester) async {
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[Column:children='
          '[_TableCaption:child=[CssBlock:child='
          '[RichText:align=center,(:Caption)]]],'
          '[HtmlTable:children='
          '${_padding('[RichText:(+b:Header 1)]')},'
          '${_padding('[RichText:(+b:Header 2)]')},'
          '${_richtext('Value 1')},'
          '${_richtext('Value 2')}'
          ']]',
        ),
      );
    });

    testWidgets('useExplainer=false', (WidgetTester tester) async {
      final explained = await explain(tester, html, useExplainer: false);
      expect(
        explained,
        equals(
          'TshWidget\n'
          '└ColumnPlaceholder(BuildMetadata(<root></root>))\n'
          ' └Column()\n'
          '  ├_TableCaption()\n'
          '  │└CssBlock()\n'
          '  │ └RichText(textAlign: center, text: "Caption")\n'
          '  └HtmlTable(borderSpacing: 2.0)\n'
          '   ├HtmlTableCell(columnStart: 0, rowStart: 0)\n'
          '   │└WidgetPlaceholder<CssLengthBox>(CssLengthBox.all(1.0px))\n'
          '   │ └Align(alignment: centerLeft)\n'
          '   │  └Padding(padding: all(1.0))\n'
          '   │   └RichText(text: "Header 1")\n'
          '   ├HtmlTableCell(columnStart: 1, rowStart: 0)\n'
          '   │└WidgetPlaceholder<CssLengthBox>(CssLengthBox.all(1.0px))\n'
          '   │ └Align(alignment: centerLeft)\n'
          '   │  └Padding(padding: all(1.0))\n'
          '   │   └RichText(text: "Header 2")\n'
          '   ├HtmlTableCell(columnStart: 0, rowStart: 1)\n'
          '   │└WidgetPlaceholder<CssLengthBox>(CssLengthBox.all(1.0px))\n'
          '   │ └Align(alignment: centerLeft)\n'
          '   │  └Padding(padding: all(1.0))\n'
          '   │   └RichText(text: "Value 1")\n'
          '   └HtmlTableCell(columnStart: 1, rowStart: 1)\n'
          '    └WidgetPlaceholder<CssLengthBox>(CssLengthBox.all(1.0px))\n'
          '     └Align(alignment: centerLeft)\n'
          '      └Padding(padding: all(1.0))\n'
          '       └RichText(text: "Value 2")\n'
          '\n',
        ),
      );
    });
  });

  group('rtl', () {
    const html = '<table dir="rtl">'
        '<tbody><tr><td>Foo</td><td>Bar</td></tr></tbody>'
        '</table>';

    testWidgets('renders', (WidgetTester tester) async {
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[HtmlTable:children='
          '[HtmlTableCell:child=[Align:alignment=centerRight,child='
          '[Padding:(1,1,1,1),child=[RichText:dir=rtl,(:Foo)]]]],'
          '[HtmlTableCell:child=[Align:alignment=centerRight,child='
          '[Padding:(1,1,1,1),child=[RichText:dir=rtl,(:Bar)]]]]'
          ']',
        ),
      );
    });

    testWidgets('useExplainer=false', (WidgetTester tester) async {
      final explained = await explain(tester, html, useExplainer: false);
      expect(
        explained,
        equals(
          'TshWidget\n'
          '└WidgetPlaceholder<BuildMetadata>(BuildMetadata($html))\n'
          ' └HtmlTable(borderSpacing: 2.0, textDirection: rtl)\n'
          '  ├HtmlTableCell(columnStart: 0, rowStart: 0)\n'
          '  │└WidgetPlaceholder<CssLengthBox>(CssLengthBox.all(1.0px))\n'
          '  │ └Align(alignment: centerRight)\n'
          '  │  └Padding(padding: all(1.0))\n'
          '  │   └RichText(textDirection: rtl, text: "Foo")\n'
          '  └HtmlTableCell(columnStart: 1, rowStart: 0)\n'
          '   └WidgetPlaceholder<CssLengthBox>(CssLengthBox.all(1.0px))\n'
          '    └Align(alignment: centerRight)\n'
          '     └Padding(padding: all(1.0))\n'
          '      └RichText(textDirection: rtl, text: "Bar")\n'
          '\n',
        ),
      );
    });
  });

  testWidgets('renders 2 tables', (WidgetTester tester) async {
    const html = '<table><tr><td>Foo</td></tr></table>'
        '<table><tr><td>Bar</td></tr></table>';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[Column:children='
        '[HtmlTable:children=${_richtext('Foo')}],'
        '[HtmlTable:children=${_richtext('Bar')}]'
        ']',
      ),
    );
  });

  testWidgets('renders THEAD/TBODY/TFOOT tags', (WidgetTester tester) async {
    const html = '''
<table>
  <tfoot><tr><td>Footer 1</td><td>Footer 2</td></tr></tfoot>
  <tbody><tr><td>Value 1</td><td>Value 2</td></tr></tbody>
  <thead><tr><th>Header 1</th><th>Header 2</th></tr></thead>
</table>''';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[HtmlTable:children='
        '${_padding('[RichText:(+b:Header 1)]')},'
        '${_padding('[RichText:(+b:Header 2)]')},'
        '${_richtext('Value 1')},'
        '${_richtext('Value 2')},'
        '${_richtext('Footer 1')},'
        '${_richtext('Footer 2')}'
        ']',
      ),
    );
  });

  group('inline style', () {
    testWidgets('renders cell stylings', (WidgetTester tester) async {
      const html = '<table>'
          '<tr><th>Header 1</th><th style="text-align: center">Header 2</th></tr>'
          '<tr><td>Value <em>1</em></td><td style="font-weight: bold">Value 2</td></tr>'
          '</table>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[HtmlTable:children='
          '${_padding('[RichText:(+b:Header 1)]')},'
          '[HtmlTableCell:child=[Align:alignment=centerLeft,child='
          '[Padding:(1,1,1,1),child=[CssBlock:child='
          '[RichText:align=center,(+b:Header 2)]]]]],'
          '${_padding('[RichText:(:Value (+i:1))]')},'
          '${_padding('[RichText:(+b:Value 2)]')}'
          ']',
        ),
      );
    });

    testWidgets('renders row stylings', (WidgetTester tester) async {
      const html = '<table>'
          '<tr style="text-align: center"><th>Header 1</th><th>Header 2</th></tr>'
          '<tr style="font-weight: bold"><td>Value <em>1</em></td><td>Value 2</td></tr>'
          '</table>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[HtmlTable:children='
          '${_padding('[RichText:align=center,(+b:Header 1)]')},'
          '${_padding('[RichText:align=center,(+b:Header 2)]')},'
          '${_padding('[RichText:(+b:Value (+i+b:1))]')},'
          '${_padding('[RichText:(+b:Value 2)]')}'
          ']',
        ),
      );
    });

    testWidgets('renders section stylings', (WidgetTester tester) async {
      const html = '<table>'
          '<tbody style="text-align: right">'
          '<tr><th>Header 1</th><th style="text-align: center">Header 2</th></tr>'
          '<tr><td>Value <em>1</em></td><td style="font-weight: bold">Value 2</td></tr>'
          '</tbody>'
          '</table>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[HtmlTable:children='
          '${_padding('[RichText:align=right,(+b:Header 1)]')},'
          '[HtmlTableCell:child=[Align:alignment=centerLeft,child='
          '[Padding:(1,1,1,1),child=[CssBlock:child='
          '[RichText:align=center,(+b:Header 2)]]]]],'
          '${_padding('[RichText:align=right,(:Value (+i:1))]')},'
          '${_padding('[RichText:align=right,(+b:Value 2)]')}'
          ']',
        ),
      );
    });
  });

  group('border', () {
    testWidgets('renders border=0', (WidgetTester tester) async {
      const html =
          '<table border="0"><tbody><tr><td>Foo</td></tr></tbody></table>';
      final explained = await explain(tester, html, useExplainer: false);
      expect(explained, contains('HtmlTable(borderSpacing: 2.0)'));
    });

    testWidgets('renders border=1', (WidgetTester tester) async {
      const html =
          '<table border="1"><tbody><tr><td>Foo</td></tr></tbody></table>';
      final e = await explain(tester, html, useExplainer: false);
      expect(e, contains('HtmlTable(border: $border, borderSpacing: 2.0)'));
    });

    testWidgets('renders style', (WidgetTester tester) async {
      const html = '<table style="border: 1px solid black"><tbody>'
          '<tr><td>Foo</td></tr></tbody></table>';
      final e = await explain(tester, html, useExplainer: false);
      expect(e, contains('HtmlTable(border: $border, borderSpacing: 2.0)'));
    });
  });

  group('cellpadding', () {
    testWidgets('renders without cellpadding', (WidgetTester tester) async {
      const html = '<table><tr><td>Foo</td></tr></table>';
      final e = await explain(tester, html);
      expect(e, equals('[HtmlTable:children=${_richtext('Foo')}]'));
    });

    testWidgets('renders cellpadding=2', (WidgetTester tester) async {
      const html = '<table cellpadding="2"><tr><td>Foo</td></tr></table>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[HtmlTable:children='
          '[HtmlTableCell:child='
          '[Align:alignment=centerLeft,child='
          '[Padding:(2,2,2,2),child='
          '[RichText:(:Foo)]'
          ']]]]',
        ),
      );
    });

    group('inline style', () {
      testWidgets('renders table=1 cell=1', (WidgetTester tester) async {
        const html = '<table cellpadding="1">'
            '<tr><td style="padding: 1px">Foo</td></tr>'
            '</table>';
        final e = await explain(tester, html);
        expect(e, equals('[HtmlTable:children=${_richtext('Foo')}]'));
      });

      testWidgets('renders table=1 cell=2', (WidgetTester tester) async {
        const html = '<table cellpadding="1">'
            '<tr><td style="padding: 2px">Foo</td></tr>'
            '</table>';
        final explained = await explain(tester, html);
        expect(
          explained,
          equals(
            '[HtmlTable:children='
            '[HtmlTableCell:child='
            '[Align:alignment=centerLeft,child='
            '[Padding:(2,2,2,2),child='
            '[RichText:(:Foo)]'
            ']]]]',
          ),
        );
      });
    });
  });

  group('cellspacing', () {
    testWidgets('renders without cellspacing', (WidgetTester tester) async {
      const html = '<table><tbody><tr><td>Foo</td></tr></tbody></table>';
      final explained = await explain(tester, html, useExplainer: false);
      expect(explained, contains('HtmlTable(borderSpacing: 2.0)'));
    });

    testWidgets('renders cellspacing=1', (WidgetTester tester) async {
      const html = '<table cellspacing="1"><tbody>'
          '<tr><td>Foo</td></tr>'
          '</tbody></table>';
      final explained = await explain(tester, html, useExplainer: false);
      expect(explained, contains('HtmlTable(borderSpacing: 1.0)'));
    });

    testWidgets('renders border-spacing', (WidgetTester tester) async {
      const html = '<table style="border-spacing: 1px"><tbody>'
          '<tr><td>Foo</td></tr>'
          '</tbody></table>';
      final explained = await explain(tester, html, useExplainer: false);
      expect(explained, contains('HtmlTable(borderSpacing: 1.0)'));
    });

    testWidgets('renders border-collapse without border', (tester) async {
      const html = '<table style="border-collapse: collapse"><tbody>'
          '<tr><td>Foo</td></tr>'
          '</tbody></table>';
      final e = await explain(tester, html, useExplainer: false);
      expect(e, contains('(borderCollapse: true, borderSpacing: 2.0)'));
    });

    testWidgets('renders border-collapse with border=1', (tester) async {
      const html = '<table border="1" style="border-collapse: collapse"><tbody>'
          '<tr><td>Foo</td></tr>'
          '</tbody></table>';
      final explained = await explain(tester, html, useExplainer: false);
      expect(
        explained,
        contains(
          'HtmlTable(border: $border, '
          'borderCollapse: true, borderSpacing: 2.0)',
        ),
      );
    });
  });

  group('colspan / rowspan', () {
    testWidgets('renders colspan=1', (WidgetTester tester) async {
      const html =
          '<table><tbody><tr><td colspan="1">Foo</td></tr></tbody></table>';
      final explained = await explain(tester, html, useExplainer: false);
      expect(explained, contains('HtmlTableCell(columnStart: 0, rowStart: 0)'));
    });

    testWidgets('renders colspan=2 as 1', (WidgetTester tester) async {
      const html =
          '<table><tbody><tr><td colspan="2">Foo</td></tr></tbody></table>';
      final explained = await explain(tester, html, useExplainer: false);
      expect(explained, contains('HtmlTableCell(columnStart: 0, rowStart: 0)'));
    });

    testWidgets('renders colspan=2', (WidgetTester tester) async {
      const html = '<table><tbody>'
          '<tr><td>1</td><td>2</td></tr>'
          '<tr><td colspan="2">Foo</td></tr>'
          '</tbody></table>';
      final e = await explain(tester, html, useExplainer: false);
      expect(e, contains('(columnSpan: 2, columnStart: 0, rowStart: 1)'));
    });

    testWidgets('renders colspan=3 as 2', (WidgetTester tester) async {
      const html = '<table><tbody>'
          '<tr><td>1</td><td>2</td></tr>'
          '<tr><td colspan="3">Foo</td></tr>'
          '</tbody></table>';
      final e = await explain(tester, html, useExplainer: false);
      expect(e, contains('(columnSpan: 2, columnStart: 0, rowStart: 1)'));
    });

    testWidgets('renders rowspan=1', (WidgetTester tester) async {
      const html =
          '<table><tbody><tr><td rowspan="1">Foo</td></tr></tbody></table>';
      final explained = await explain(tester, html, useExplainer: false);
      expect(explained, contains('HtmlTableCell(columnStart: 0, rowStart: 0)'));
    });

    testWidgets('renders rowspan=2 as 1', (WidgetTester tester) async {
      const html =
          '<table><tbody><tr><td rowspan="2">Foo</td></tr></tbody></table>';
      final explained = await explain(tester, html, useExplainer: false);
      expect(explained, contains('HtmlTableCell(columnStart: 0, rowStart: 0)'));
    });

    testWidgets('renders rowspan=2', (WidgetTester tester) async {
      const html = '<table><tbody>'
          '<tr><td rowspan="2">Foo</td><td>1</td></tr>'
          '<tr><td>2</td></tr>'
          '</tbody></table>';
      final explained = await explain(tester, html, useExplainer: false);
      expect(
        explained,
        contains('HtmlTableCell(columnStart: 0, rowSpan: 2, rowStart: 0)'),
      );
    });

    testWidgets('renders rowspan=3 as 2', (WidgetTester tester) async {
      const html = '<table><tbody>'
          '<tr><td rowspan="3">Foo</td><td>1</td></tr>'
          '<tr><td>2</td></tr>'
          '</tbody></table>';
      final explained = await explain(tester, html, useExplainer: false);
      expect(
        explained,
        contains('HtmlTableCell(columnStart: 0, rowSpan: 2, rowStart: 0)'),
      );
    });

    testWidgets('renders rowspan=0', (t) async {
      const html = '<table><tbody>'
          '<tr><td rowspan="0">1.1</td><td>1.2</td></tr>'
          '<tr><td>2</td></tr>'
          '</tbody></table>';
      final explained = await explain(t, html, useExplainer: false);

      expect(explained, contains('(columnStart: 0, rowSpan: 2, rowStart: 0)'));
      expect(explained, contains('HtmlTableCell(columnStart: 1, rowStart: 0)'));
      expect(explained, contains('HtmlTableCell(columnStart: 1, rowStart: 1)'));
    });

    testWidgets('renders colspan=2 rowspan=2 as 1', (tester) async {
      const html =
          '<table><tbody><tr><td colspan="2" rowspan="2">Foo</td></tr></tbody></table>';
      final explained = await explain(tester, html, useExplainer: false);
      expect(explained, contains('HtmlTableCell(columnStart: 0, rowStart: 0)'));
    });

    testWidgets('renders colspan=2 rowspan=2', (WidgetTester tester) async {
      const html = '<table><tbody>'
          '<tr><td colspan="2" rowspan="2">Foo</td><td>1</td></tr>'
          '<tr><td>2</td></td>'
          '<tr><td>3</td><td>4</td><td>5</td></td>'
          '</tbody></table>';
      final explained = await explain(tester, html, useExplainer: false);
      expect(
        explained,
        contains(
          'HtmlTableCell(columnSpan: 2, columnStart: 0, '
          'rowSpan: 2, rowStart: 0)',
        ),
      );
    });

    testWidgets('renders cells being split by rowspan from above', (t) async {
      const html = '<table><tbody>'
          '<tr><td>1.1</td><td rowspan="2">1.2</td><td>1.3</td></tr>'
          '<tr><td>2.1</td><td>2.2</td></tr>'
          '</tbody></table>';
      final explained = await explain(t, html, useExplainer: false);

      expect(explained, contains('HtmlTableCell(columnStart: 0, rowStart: 0)'));
      expect(explained, contains('(columnStart: 1, rowSpan: 2, rowStart: 0)'));
      expect(explained, contains('HtmlTableCell(columnStart: 2, rowStart: 0)'));
      expect(explained, contains('HtmlTableCell(columnStart: 0, rowStart: 1)'));
      expect(explained, contains('HtmlTableCell(columnStart: 2, rowStart: 1)'));
    });
  });

  group('valign', () {
    testWidgets('renders without align', (WidgetTester tester) async {
      const html = '<table><tr><td>Foo</td></tr></table>';
      final e = await explain(tester, html);
      expect(e, equals('[HtmlTable:children=${_richtext('Foo')}]'));
    });

    testWidgets('renders align=bottom', (WidgetTester tester) async {
      const html = '<table><tr><td valign="bottom">Foo</td></tr></table>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[HtmlTable:children='
          '[HtmlTableCell:child='
          '[Align:alignment=bottomLeft,child='
          '[Padding:(1,1,1,1),child='
          '[RichText:(:Foo)]'
          ']]]]',
        ),
      );
    });

    testWidgets('renders align=middle', (WidgetTester tester) async {
      const html = '<table><tr><td valign="middle">Foo</td></tr></table>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[HtmlTable:children='
          '[HtmlTableCell:child='
          '[Align:alignment=centerLeft,child='
          '[Padding:(1,1,1,1),child='
          '[RichText:(:Foo)]'
          ']]]]',
        ),
      );
    });

    testWidgets('renders align=top', (WidgetTester tester) async {
      const html = '<table><tr><td valign="top">Foo</td></tr></table>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[HtmlTable:children='
          '[HtmlTableCell:child='
          '[Align:alignment=topLeft,child='
          '[Padding:(1,1,1,1),child='
          '[RichText:(:Foo)]'
          ']]]]',
        ),
      );
    });
  });

  group('error handling', () {
    testWidgets('missing header', (WidgetTester tester) async {
      const html = '<table><tbody>'
          '<tr><th>Header 1</th></tr>'
          '<tr><td>Value 1</td><td>Value 2</td></tr>'
          '</tbody></table>';
      final explained = await explain(tester, html, useExplainer: false);

      expect(explained, contains('HtmlTableCell(columnStart: 0, rowStart: 0)'));
      expect(explained, contains('HtmlTableCell(columnStart: 0, rowStart: 1)'));
      expect(explained, contains('HtmlTableCell(columnStart: 1, rowStart: 1)'));
    });

    testWidgets('missing cell', (WidgetTester tester) async {
      const html = '<table><tbody>'
          '<tr><th>Header 1</th><th>Header 2</th></tr>'
          '<tr><td>Value 1</td></tr>'
          '</tbody></table>';
      final explained = await explain(tester, html, useExplainer: false);

      expect(explained, contains('HtmlTableCell(columnStart: 0, rowStart: 0)'));
      expect(explained, contains('HtmlTableCell(columnStart: 1, rowStart: 0)'));
      expect(explained, contains('HtmlTableCell(columnStart: 0, rowStart: 1)'));
    });

    testWidgets('standalone CAPTION', (WidgetTester tester) async {
      const html = '<caption>Foo</caption>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('standalone TABLE', (WidgetTester tester) async {
      const html = '<table>Foo</table>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('TABLE display: none', (WidgetTester tester) async {
      const html =
          'Foo <table style="display: none"><tr><td>Bar</td></tr></table>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('standalone TD', (WidgetTester tester) async {
      const html = '<td>Foo</td>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('standalone TH', (WidgetTester tester) async {
      const html = '<th>Foo</th>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('standalone TR', (WidgetTester tester) async {
      const html = '<tr>Foo</tr>';
      final explained = await explain(tester, html);
      expect(explained, equals('[RichText:(:Foo)]'));
    });

    testWidgets('TR display:none', (WidgetTester tester) async {
      const html = '<table><tr style="display: none"><td>Foo</td></tr>'
          '<tr><td>Bar</td></tr></table>';
      final explained = await explain(tester, html);
      expect(explained, equals('[HtmlTable:children=${_richtext('Bar')}]'));
    });

    testWidgets('empty TD (#494)', (WidgetTester tester) async {
      const html =
          '<table><tbody><tr><td></td><td>Foo</td></tr></tbody></table>';
      final explained = await explain(tester, html, useExplainer: false);

      expect(explained, contains('HtmlTableCell(columnStart: 0, rowStart: 0)'));
      expect(explained, contains('HtmlTableCell(columnStart: 1, rowStart: 0)'));
    });

    testWidgets('TD display:none', (WidgetTester tester) async {
      const html = '<table><tr><td style="display: none">Foo</td>'
          '<td>Bar</td></tr></table>';
      final explained = await explain(tester, html);
      expect(explained, equals('[HtmlTable:children=${_richtext('Bar')}]'));
    });

    testWidgets('empty CAPTION', (WidgetTester tester) async {
      const html = '<table><caption></caption></table>';
      final explained = await explain(tester, html);
      expect(explained, equals('[widget0]'));
    });

    testWidgets('empty TR', (WidgetTester tester) async {
      const html = '<table><tr></tr></table>';
      final explained = await explain(tester, html);
      expect(explained, equals('[widget0]'));
    });

    testWidgets('empty TBODY', (WidgetTester tester) async {
      const html = '<table><tbody></tbody></table>';
      final explained = await explain(tester, html);
      expect(explained, equals('[widget0]'));
    });

    testWidgets('empty TABLE', (WidgetTester tester) async {
      const html = '<table></table>';
      final explained = await explain(tester, html);
      expect(explained, equals('[widget0]'));
    });

    testWidgets('#171: background-color', (WidgetTester tester) async {
      const html = '<table><tr>'
          '<td style="background-color: #f00">Foo</td>'
          '</tr></table>';
      final explained = await explain(tester, html);
      expect(
        explained,
        equals(
          '[HtmlTable:children='
          '[HtmlTableCell:child='
          '[DecoratedBox:bg=#FFFF0000,child='
          '[Align:alignment=centerLeft,child='
          '[Padding:(1,1,1,1),child='
          '[RichText:(:Foo)]'
          ']]]]]',
        ),
      );
    });
  });

  testWidgets('renders display: table', (WidgetTester tester) async {
    const html = '''
<div style="display: table">
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
      equals(
        '[Column:children='
        '[_TableCaption:child=[CssBlock:child='
        '[RichText:align=center,(:Caption)]]],'
        '[HtmlTable:children='
        '[HtmlTableCell:child=[RichText:(+b:Header 1)]],'
        '[HtmlTableCell:child=[RichText:(+b:Header 2)]],'
        '[HtmlTableCell:child=[RichText:(:Value 1)]],'
        '[HtmlTableCell:child=[RichText:(:Value 2)]]'
        ']]',
      ),
    );
  });

  group('HtmlTable', () {
    group('_TableRenderObject setters', () {
      testWidgets('updates border', (WidgetTester tester) async {
        final before = await explain(
          tester,
          '<table border="1"><tr><td>Foo</td></tr></table>',
          useExplainer: false,
        );
        expect(
          before,
          contains(
            '└HtmlTable(border: all(BorderSide(Color(0xff000000), '
            '1.0, BorderStyle.solid)),',
          ),
        );

        final after = await explain(
          tester,
          '<table border="2"><tr><td>Foo</td></tr></table>',
          useExplainer: false,
        );
        expect(
          after,
          contains(
            '└HtmlTable(border: all(BorderSide(Color(0xff000000), '
            '2.0, BorderStyle.solid)),',
          ),
        );
      });

      testWidgets('updates borderCollapse', (WidgetTester tester) async {
        const str = '└HtmlTable(borderCollapse: true,';
        final before = await explain(
          tester,
          '<table style="border-collapse: separate"><tr><td>Foo</td></tr></table>',
          useExplainer: false,
        );
        expect(before, isNot(contains(str)));

        final after = await explain(
          tester,
          '<table style="border-collapse: collapse"><tr><td>Foo</td></tr></table>',
          useExplainer: false,
        );
        expect(after, contains(str));
      });

      testWidgets('updates borderSpacing', (WidgetTester tester) async {
        final before = await explain(
          tester,
          '<table cellspacing="10"><tr><td>Foo</td></tr></table>',
          useExplainer: false,
        );
        expect(before, contains('└HtmlTable(borderSpacing: 10.0)'));

        final after = await explain(
          tester,
          '<table cellspacing="20"><tr><td>Foo</td></tr></table>',
          useExplainer: false,
        );
        expect(after, contains('└HtmlTable(borderSpacing: 20.0)'));
      });

      testWidgets('updates textDirection', (WidgetTester tester) async {
        final before = await explain(
          tester,
          '<table><tr><td>Foo</td></tr></table>',
          useExplainer: false,
        );
        expect(before, contains('└HtmlTable(borderSpacing: 2.0)'));

        final after = await explain(
          tester,
          '<table dir="rtl"><tr><td>Foo</td></tr></table>',
          useExplainer: false,
        );
        expect(
          after,
          contains('└HtmlTable(borderSpacing: 2.0, textDirection: rtl)'),
        );
      });
    });

    testWidgets('_ValignBaselineRenderObject updates row', (tester) async {
      await explain(
        tester,
        '<table style="border-collapse: separate">'
        '<tr><td>Foo</td>'
        '<td valign="baseline">Bar</td></tr>'
        '</table>',
        useExplainer: false,
      );
      final finder = find.byType(HtmlTableValignBaseline);
      final before = tester.firstRenderObject(finder);
      expect(before.toStringShort(), endsWith('(row: 0)'));

      await explain(
        tester,
        '<table style="border-collapse: separate">'
        '<tr><td>Foo</td></tr>'
        '<tr><td valign="baseline">Bar</td></tr>'
        '</table>',
        useExplainer: false,
      );
      final after = tester.firstRenderObject(finder);
      expect(after.toStringShort(), endsWith('(row: 1)'));
    });

    testWidgets('performs hit test', (tester) async {
      const href = 'href';
      final urls = <String>[];

      await tester.pumpWidget(
        HitTestApp(
          html: '<table><tr><td><a href="$href">Tap me</a></td></tr></table>',
          list: urls,
        ),
      );
      expect(await tapText(tester, 'Tap me'), equals(1));

      await tester.pumpAndSettle();
      expect(urls, equals(const [href]));
    });

    final goldenSkipEnvVar = Platform.environment['GOLDEN_SKIP'];
    final goldenSkip = goldenSkipEnvVar == null
        ? Platform.isLinux
            ? null
            : 'Linux only'
        : 'GOLDEN_SKIP=$goldenSkipEnvVar';

    GoldenToolkit.runWithConfiguration(
      () {
        group(
          'screenshot testing',
          () {
            setUp(() => WidgetFactory.debugDeterministicLoadingWidget = true);
            tearDown(
              () => WidgetFactory.debugDeterministicLoadingWidget = false,
            );

            final multiline =
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit.<br />\n' *
                    3;
            const tableWithImage =
                '<table border="1"><tr><td><img src="asset:test/images/logo.png" width="50" height="50" /></td></tr></table>';
            final testCases = <String, String>{
              'aspect_ratio_img': '''
<div>$tableWithImage</div><br />

<div style="width: 25px">$tableWithImage</div><br />

<div style="height: 25px">$tableWithImage</div>

Foo should float on top of table.''',
              'collapsed_border': '''
<table border="1" style="border-collapse: collapse">
  <tr>
    <td>Foo</td>
    <td style="border: 1px solid red">Foo</td>
    <td style="border: 5px solid green">Bar</td>
  </tr>
</table>''',
              'colspan': '''
<table border="1">
  <tr><td colspan="2">Lorem ipsum dolor sit amet.</td></tr>
  <tr><td>Foo</td><td>Bar</td></tr>
</table>''',
              'height_as_min_height':
                  'Above<table border="1" style="height: 1px">'
                      '<tr><td style="height: 1px">Foo</td></tr></table>Below',
              'rowspan': '''
<table border="1">
  <tr><td rowspan="2">$multiline</td><td>Foo</td></tr>
  <tr><td>Bar</td></tr>
</table>''',
              'valign_baseline_1a': '''
<table border="1">
  <tr>
    <td valign="baseline">$multiline</td>
    <td valign="baseline"><div style="margin: 10px">Foo</div></td>
  </tr>
</table>''',
              'valign_baseline_1b': '''
<table border="1">
  <tr>
    <td valign="baseline">Foo</td>
    <td valign="baseline"><div style="margin: 10px">10px</div></td>
    <td valign="baseline"><div style="margin: 30px">30px</div></td>
    <td valign="baseline"><div style="margin: 20px">20px</div></td>
  </tr>
</table>''',
              'valign_baseline_1c': '''
<table border="1">
  <tr>
    <td valign="baseline"><div style="margin: 10px">10px</div></td>
    <td valign="baseline">Foo</td>
    <td valign="baseline"><div style="margin: 30px">30px</div></td>
    <td valign="baseline"><div style="margin: 20px">20px</div></td>
  </tr>
</table>''',
              'valign_baseline_2': '''
<table border="1">
  <tr>
    <td valign="baseline"><div style="padding: 10px">Foo</div></td>
    <td valign="baseline">$multiline</td>
  </tr>
</table>''',
              'valign_baseline_3': '''
<table border="1">
  <tr>
    <td valign="baseline"><div style="padding: 10px">$multiline</div></td>
    <td valign="baseline">Foo</td>
  </tr>
</table>''',
              'valign_baseline_computeDryLayout': '''
<div style="width: 100px; height: 100px;">
  <table border="1">
    <tr>
      <td valign="baseline">Lorem ipsum dolor sit amet, consectetur adipiscing elit.</td>
      <td valign="baseline"><div style="margin: 10px">Foo</div></td>
    </tr>
  </table>
</div>''',
              'rtl': '''
<table dir="rtl">
  <tr>
    <td>Foo</td>
    <td>Bar</td>
  </tr>
</table>
''',
              'table_in_list': '''
<ul>
  <li>
    <table border="1"><tr><td>Foo</td></tr></table>
  </li>
</ul>''',
              'table_with_2_cells_in_list': '''
<ul>
  <li>
    <table border="1">
      <tr>
        <td><div style="margin: 5px">Foo</div></td>
        <td>Bar<br />Bar</td>
      </tr>
    </table>
  </li>
</ul>''',
              'table_in_table': '''
<table border="1">
  <tr>
    <td style="background: red">
      <table border="1">
        <tr><td style="background: green">Foo</td></tr>
      </table>
    </td>
    <td>$multiline</td>
  </tr>
</table>''',
            };

            for (final testCase in testCases.entries) {
              testGoldens(
                testCase.key,
                (tester) async {
                  await tester.pumpWidgetBuilder(
                    _Golden(testCase.value.trim()),
                    wrapper: materialAppWrapper(theme: ThemeData.light()),
                    surfaceSize: const Size(600, 400),
                  );

                  await screenMatchesGolden(tester, testCase.key);
                },
                skip: goldenSkip != null,
              );
            }
          },
          skip: goldenSkip,
        );
      },
      config: GoldenToolkitConfiguration(
        fileNameFactory: (name) => '$kGoldenFilePrefix/table/$name.png',
      ),
    );
  });
}

class _Golden extends StatelessWidget {
  final String contents;

  const _Golden(this.contents, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext _) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: HtmlWidget(contents),
        ),
      );
}
