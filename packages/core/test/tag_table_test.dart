import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:logging/logging.dart';

import '_.dart' as helper;

Future<void> main() async {
  _loggerSetup();
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
          '[SingleChildScrollView:child=[HtmlTable:children='
          '[HtmlTableCaption:child=[RichText:align=center,(:Caption)]],'
          '${_padding('[RichText:(+b:Header 1)]')},'
          '${_padding('[RichText:(+b:Header 2)]')},'
          '${_richtext('Value 1')},'
          '${_richtext('Value 2')}'
          ']]',
        ),
      );
    });
  });

  group('horizontal scroll view', () {
    final hw = HtmlWidget(
      '<table><tr><td>Foo</td></tr></table>',
      key: helper.hwKey,
    );

    testWidgets('renders in constrainted width', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        null,
        hw: hw,
        useExplainer: false,
      );
      expect(explained, contains('SingleChildScrollView'));
    });

    testWidgets('skips in unconstrainted width', (WidgetTester tester) async {
      final explained = await explain(
        tester,
        null,
        hw: SingleChildScrollView(scrollDirection: Axis.horizontal, child: hw),
        useExplainer: false,
      );
      // because the entire `HtmlWidget` is already inside a scroll view
      // `HtmlTable` should not be put inside another one
      expect(explained, isNot(contains('SingleChildScrollView')));
    });
  });

  group('rtl', () {
    const html = '<table dir="rtl">'
        '<tbody><tr><td>Foo</td><td>Bar</td></tr></tbody>'
        '</table>';

    testWidgets('renders', (WidgetTester tester) async {
      final explained = await explain(tester, html);
      expect(explained, contains('[Align:alignment=centerRight,'));
      expect(explained, contains('[RichText:dir=rtl,(:Foo)]'));
      expect(explained, contains('[RichText:dir=rtl,(:Bar)]'));
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
        '[SingleChildScrollView:child=[HtmlTable:children=${_richtext('Foo')}]],'
        '[SingleChildScrollView:child=[HtmlTable:children=${_richtext('Bar')}]]'
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
        '[SingleChildScrollView:child=[HtmlTable:children='
        '${_padding('[RichText:(+b:Header 1)]')},'
        '${_padding('[RichText:(+b:Header 2)]')},'
        '${_richtext('Value 1')},'
        '${_richtext('Value 2')},'
        '${_richtext('Footer 1')},'
        '${_richtext('Footer 2')}'
        ']]',
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
      expect(explained, contains('[RichText:align=center,(+b:Header 2)]'));
      expect(explained, contains('[RichText:(:Value (+i:1))]'));
      expect(explained, contains('[RichText:(+b:Value 2)]'));
    });

    testWidgets('renders row stylings', (WidgetTester tester) async {
      const html = '<table>'
          '<tr style="text-align: center"><th>Header 1</th><th>Header 2</th></tr>'
          '<tr style="font-weight: bold"><td>Value <em>1</em></td><td>Value 2</td></tr>'
          '</table>';
      final explained = await explain(tester, html);
      expect(explained, contains('[RichText:align=center,(+b:Header 1)]'));
      expect(explained, contains('[RichText:align=center,(+b:Header 2)]'));
      expect(explained, contains('[RichText:(+b:Value (+i+b:1))]'));
      expect(explained, contains('[RichText:(+b:Value 2)]'));
    });

    testWidgets('renders section stylings', (WidgetTester tester) async {
      const html = '<table>'
          '<tbody style="text-align: right">'
          '<tr><th>Header 1</th><th style="text-align: center">Header 2</th></tr>'
          '<tr><td>Value <em>1</em></td><td style="font-weight: bold">Value 2</td></tr>'
          '</tbody>'
          '</table>';
      final explained = await explain(tester, html);
      expect(explained, contains('[RichText:align=right,(+b:Header 1)]'));
      expect(explained, contains('[RichText:align=center,(+b:Header 2)]'));
      expect(explained, contains('[RichText:align=right,(:Value (+i:1))]'));
      expect(explained, contains('[RichText:align=right,(+b:Value 2)]'));
    });
  });

  group('border', () {
    testWidgets('renders border=0', (WidgetTester tester) async {
      const html =
          '<table border="0"><tbody><tr><td>Foo</td></tr></tbody></table>';
      await explain(tester, html);
      final table = tester.table;
      expect(table.border, isNull);
      expect(tester.table.borderSpacing, equals(2.0));
    });

    testWidgets('renders border=1', (WidgetTester tester) async {
      const html =
          '<table border="1"><tbody><tr><td>Foo</td></tr></tbody></table>';
      await explain(tester, html);
      final table = tester.table;
      expect(table.border, isNotNull);
      expect(tester.table.borderSpacing, equals(2.0));

      // default border color must match text color
      expect(table.border?.top.color, equals(const Color(0xFF001234)));
    });

    testWidgets('renders style', (WidgetTester tester) async {
      const html = '<table style="border: 1px solid black"><tbody>'
          '<tr><td>Foo</td></tr></tbody></table>';
      await explain(tester, html);
      final table = tester.table;
      expect(table.border, isNotNull);
      expect(tester.table.borderSpacing, equals(2.0));
    });
  });

  group('cellpadding', () {
    testWidgets('renders without cellpadding', (WidgetTester tester) async {
      const html = '<table><tr><td>Foo</td></tr></table>';
      final explained = await explain(tester, html);
      expect(explained, contains('[Padding:(1,1,1,1),child='));
    });

    testWidgets('renders cellpadding=2', (WidgetTester tester) async {
      const html = '<table cellpadding="2"><tr><td>Foo</td></tr></table>';
      final explained = await explain(tester, html);
      expect(explained, isNot(contains('[Padding:(1,1,1,1),child=')));
      expect(explained, contains('[Padding:(2,2,2,2),child='));
    });

    group('inline style', () {
      testWidgets('renders table=1 cell=1', (WidgetTester tester) async {
        const html = '<table cellpadding="1">'
            '<tr><td style="padding: 1px">Foo</td></tr>'
            '</table>';
        final explained = await explain(tester, html);
        expect(explained, contains('[Padding:(1,1,1,1),child='));
      });

      testWidgets('renders table=1 cell=2', (WidgetTester tester) async {
        const html = '<table cellpadding="1">'
            '<tr><td style="padding: 2px">Foo</td></tr>'
            '</table>';
        final explained = await explain(tester, html);
        expect(explained, isNot(contains('[Padding:(1,1,1,1),child=')));
        expect(explained, contains('[Padding:(2,2,2,2),child='));
      });
    });
  });

  group('cellspacing', () {
    testWidgets('renders without cellspacing', (WidgetTester tester) async {
      const html = '<table><tbody><tr><td>Foo</td></tr></tbody></table>';
      await explain(tester, html);
      expect(tester.table.borderSpacing, equals(2.0));
    });

    testWidgets('renders cellspacing=1', (WidgetTester tester) async {
      const html = '<table cellspacing="1"><tbody>'
          '<tr><td>Foo</td></tr>'
          '</tbody></table>';
      await explain(tester, html);
      expect(tester.table.borderSpacing, equals(1.0));
    });

    testWidgets('renders border-spacing', (WidgetTester tester) async {
      const html = '<table style="border-spacing: 1px"><tbody>'
          '<tr><td>Foo</td></tr>'
          '</tbody></table>';
      await explain(tester, html);
      expect(tester.table.borderSpacing, equals(1.0));
    });

    testWidgets('renders border-collapse without border', (tester) async {
      const html = '<table style="border-collapse: collapse"><tbody>'
          '<tr><td>Foo</td></tr>'
          '</tbody></table>';
      await explain(tester, html);
      final table = tester.table;
      expect(table.border, isNull);
      expect(table.borderCollapse, isTrue);
      expect(table.borderSpacing, equals(2.0));
    });

    testWidgets('renders border-collapse with border=1', (tester) async {
      const html = '<table border="1" style="border-collapse: collapse"><tbody>'
          '<tr><td>Foo</td></tr>'
          '</tbody></table>';
      await explain(tester, html);
      final table = tester.table;
      expect(table.border, isNotNull);
      expect(table.borderCollapse, isTrue);
      expect(table.borderSpacing, equals(2.0));
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
      final explained = await explain(tester, html);
      expect(explained, contains('[Align:alignment=centerLeft,'));
    });

    testWidgets('renders align=bottom', (WidgetTester tester) async {
      const html = '<table><tr><td valign="bottom">Foo</td></tr></table>';
      final explained = await explain(tester, html);
      expect(explained, isNot(contains('[Align:alignment=centerLeft,')));
      expect(explained, contains('[Align:alignment=bottomLeft,'));
    });

    testWidgets('renders align=middle', (WidgetTester tester) async {
      const html = '<table><tr><td valign="middle">Foo</td></tr></table>';
      final explained = await explain(tester, html);
      expect(explained, contains('[Align:alignment=centerLeft,'));
    });

    testWidgets('renders align=top', (WidgetTester tester) async {
      const html = '<table><tr><td valign="top">Foo</td></tr></table>';
      final explained = await explain(tester, html);
      expect(explained, isNot(contains('[Align:alignment=centerLeft,')));
      expect(explained, contains('[Align:alignment=topLeft,'));
    });
  });

  group('combos', () {
    testWidgets('renders nested table', (WidgetTester tester) async {
      // https://github.com/daohoangson/flutter_widget_from_html/issues/1070
      const html = '<p>Foo bar bar</p>'
          '<table cellpadding="0"><tr><td>'
          '<table cellpadding="0"><tr>'
          '<td>Foo bar</td>'
          '<td></td>'
          '</tr></table>'
          '</td></tr></table>';
      await explain(tester, html);

      final fooBarBar = tester.getSize(helper.findText('Foo bar bar'));
      final fooBar = tester.getSize(helper.findText('Foo bar'));

      // previous version has a bug that makes text in nested table to break line
      // this test makes sure that bug is fixed
      expect(fooBar.height, equals(fooBarBar.height));
    });

    testWidgets('renders align=center', (WidgetTester tester) async {
      // https://github.com/daohoangson/flutter_widget_from_html/issues/1070
      const windowSize = 100.0;
      tester.setWindowSize(const Size(windowSize, windowSize));

      const html = '<table style="width: 100%"><tr><td align="center">'
          '<table><tr><td>Foo</td></tr></table>'
          '</td></tr></table>';
      await explain(tester, html);

      final foo = tester.getRect(find.byType(RichText));
      final width = foo.right - foo.left;
      final margin = (windowSize - width) / 2;
      expect(foo.left, equals(margin));
      expect(foo.right, equals(windowSize - margin));
    });

    testWidgets('renders HR tag', (WidgetTester tester) async {
      // https://github.com/daohoangson/flutter_widget_from_html/issues/1070
      const html = '<table><tr><td>Foo<hr /></td></tr></table>';
      await explain(tester, html);
      final foo = tester.getSize(find.byType(RichText));
      expect(foo.width, greaterThan(.0));

      final containerFinder = find.byType(Container);
      expect(
        containerFinder,
        findsNWidgets(2),
        reason: 'Implementation details: HR renders two `Container` widgets.',
      );
      final box = tester.firstRenderObject(containerFinder).renderBox;
      expect(box.size.width, equals(foo.width));
      expect(box.size.height, greaterThan(.0));
    });

    testWidgets('renders P tag inside justify', (WidgetTester tester) async {
      // https://github.com/daohoangson/flutter_widget_from_html/issues/1118
      const html =
          '<table style="text-align: justify;"><tr><td><p>Foo</p></td></tr></table>';
      final explained = await explain(tester, html);
      expect(explained, contains('[RichText:align=justify,(:Foo)]'));
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
      expect(
        explained,
        equals(
          '[SingleChildScrollView:child=[HtmlTable:children=${_richtext('Bar')}]]',
        ),
      );
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
      expect(
        explained,
        equals(
          '[SingleChildScrollView:child=[HtmlTable:children=${_richtext('Bar')}]]',
        ),
      );
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
        '[SingleChildScrollView:child=[HtmlTable:children='
        '[HtmlTableCaption:child=[RichText:align=center,(:Caption)]],'
        '[HtmlTableCell:child=[CssBlock:child=[RichText:(+b:Header 1)]]],'
        '[HtmlTableCell:child=[CssBlock:child=[RichText:(+b:Header 2)]]],'
        '[HtmlTableCell:child=[CssBlock:child=[RichText:(:Value 1)]]],'
        '[HtmlTableCell:child=[CssBlock:child=[RichText:(:Value 2)]]]'
        ']]',
      ),
    );
  });

  testWidgets('renders display: table-cell without row', (tester) async {
    const html = '''
<div style="display: table">
  <div style="display: table-cell">Foo</div>
  <div style="display: table-cell">Bar</div>
</div>''';
    final explained = await explain(tester, html);
    expect(
      explained,
      equals(
        '[SingleChildScrollView:child=[HtmlTable:children='
        '[HtmlTableCell:child=[CssBlock:child=[RichText:(:Foo)]]],'
        '[HtmlTableCell:child=[CssBlock:child=[RichText:(:Bar)]]]'
        ']]',
      ),
    );
  });

  group('HtmlTable', () {
    group('_TableRenderObject setters', () {
      testWidgets('updates border', (WidgetTester tester) async {
        await explain(tester, '<table border="1"><tr><td>1</td></tr></table>');
        final before = tester.table;
        expect(before.border!.bottom.width, equals(1.0));

        await explain(tester, '<table border="2"><tr><td>2</td></tr></table>');
        final after = tester.table;
        expect(after.border!.bottom.width, equals(2.0));
      });

      testWidgets('updates borderCollapse', (WidgetTester tester) async {
        await explain(
          tester,
          '<table style="border-collapse: separate"><tr><td>1</td></tr></table>',
        );
        final before = tester.table;
        expect(before.borderCollapse, isFalse);

        await explain(
          tester,
          '<table style="border-collapse: collapse"><tr><td>2</td></tr></table>',
        );
        final after = tester.table;
        expect(after.borderCollapse, isTrue);
      });

      testWidgets('updates borderSpacing', (WidgetTester t) async {
        await explain(t, '<table cellspacing="10"><tr><td>1</td></tr></table>');
        final before = t.table;
        expect(before.borderSpacing, equals(10.0));

        await explain(t, '<table cellspacing="20"><tr><td>2</td></tr></table>');
        final after = t.table;
        expect(after.borderSpacing, equals(20.0));
      });

      testWidgets('updates textDirection', (WidgetTester tester) async {
        await explain(tester, '<table><tr><td>Foo</td></tr></table>');
        final before = tester.table;
        expect(before.textDirection, equals(TextDirection.ltr));

        await explain(tester, '<table dir="rtl"><tr><td>Foo</td></tr></table>');
        final after = tester.table;
        expect(after.textDirection, equals(TextDirection.rtl));
      });
    });

    testWidgets('computeDistanceToActualBaseline', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                HtmlTable(
                  children: [
                    HtmlTableCell(
                      columnStart: 0,
                      rowStart: 0,
                      child: Text('Foo'),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('Bar'),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    });

    testWidgets('computeDistanceToActualBaseline with 2 cells', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                HtmlTable(
                  children: [
                    HtmlTableCell(
                      columnStart: 0,
                      rowStart: 0,
                      child: Text('One'),
                    ),
                    HtmlTableCell(
                      columnStart: 1,
                      rowStart: 0,
                      child: Text('Two'),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('Foo'),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    });

    testWidgets('computeDistanceToActualBaseline without cell', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                HtmlTable(
                  children: [],
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('Foo'),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    });

    testWidgets('computeDryLayout', (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        HtmlTable(
          key: key,
          children: const [
            HtmlTableCell(
              columnStart: 0,
              rowStart: 0,
              child: SizedBox(width: 100, height: 50),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(
        key.renderBox.getDryLayout(
          const BoxConstraints(
            maxHeight: 100,
            maxWidth: 100,
          ),
        ),
        equals(const Size(100, 50)),
      );
    });

    testWidgets('computeDryLayout without cell', (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        HtmlTable(
          key: key,
          children: const [],
        ),
      );
      await tester.pumpAndSettle();

      expect(
        key.renderBox.getDryLayout(const BoxConstraints()),
        equals(Size.zero),
      );
    });

    testWidgets('performs hit test', (tester) async {
      const href = 'href';
      final urls = <String>[];

      await tester.pumpWidget(
        helper.HitTestApp(
          html: '<table><tr><td><a href="$href">Tap me</a></td></tr></table>',
          list: urls,
        ),
      );
      expect(await helper.tapText(tester, 'Tap me'), equals(1));

      await tester.pumpAndSettle();
      expect(urls, equals(const [href]));
    });

    group('getMinIntrinsicWidth', () {
      final left = GlobalKey(debugLabel: 'left');
      final right = GlobalKey(debugLabel: 'right');
      final table = GlobalKey(debugLabel: 'table');

      Future<void> pumpColumn(WidgetTester tester, List<Widget> children) {
        tester.setWindowSize(const Size(100, 200));

        return tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ),
        );
      }

      testWidgets("uses cell's natural width by default", (tester) async {
        final natural = GlobalKey(debugLabel: 'natural');

        await pumpColumn(tester, [
          Text('Foo foo', key: natural),
          HtmlTable(
            key: table,
            children: [
              HtmlTableCell(
                columnStart: 0,
                rowStart: 0,
                child: Text('Foo foo', key: left),
              ),
              HtmlTableCell(
                columnStart: 1,
                rowStart: 0,
                child: Text('Foo foo', key: right),
              ),
            ],
          ),
        ]);

        expect(left.width, equals(natural.width));
        expect(right.width, equals(natural.width));
        expect(left.width + right.width, lessThanOrEqualTo(table.width));
      });

      testWidgets("uses cell's min width if too crowded", (tester) async {
        final min = GlobalKey(debugLabel: 'min');

        await pumpColumn(tester, [
          Text('Foo', key: min),
          HtmlTable(
            key: table,
            children: [
              HtmlTableCell(
                columnStart: 0,
                rowStart: 0,
                child: Text('Foo foo foo foo', key: left),
              ),
              const HtmlTableCell(
                columnStart: 1,
                rowStart: 0,
                child: Text('super' 'wide' 'without' 'space'),
              ),
            ],
          ),
        ]);

        expect(left.width, equals(min.width));
      });

      testWidgets("uses fair width if crowded but couldn't measure", (t) async {
        await pumpColumn(t, [
          HtmlTable(
            key: table,
            children: [
              HtmlTableCell(
                columnStart: 0,
                rowStart: 0,
                child: LayoutBuilder(
                  builder: (_, __) => const Text('Foo foo foo foo'),
                  key: left,
                ),
              ),
              const HtmlTableCell(
                columnStart: 1,
                rowStart: 0,
                child: Text('super' 'wide' 'without' 'space'),
              ),
            ],
          ),
        ]);

        expect(left.width, equals(table.width / 2));
      });

      testWidgets("skips narrow cell in the same column", (tester) async {
        _loggerMessages.clear();
        final first = GlobalKey(debugLabel: 'first');
        final second = GlobalKey(debugLabel: 'second');

        await pumpColumn(tester, [
          HtmlTable(
            key: table,
            children: [
              HtmlTableCell(
                columnStart: 0,
                rowStart: 0,
                child: Text('Foofoofoofoo', key: first),
              ),
              const HtmlTableCell(
                columnStart: 1,
                rowStart: 0,
                child: Text('super' 'wide' 'without' 'space'),
              ),
              HtmlTableCell(
                columnStart: 0,
                rowStart: 1,
                child: Text('Foo', key: second),
              ),
              const HtmlTableCell(
                columnStart: 1,
                rowStart: 1,
                child: Text('Bar'),
              ),
            ],
          ),
        ]);

        expect(second.width, equals(first.width));
      });
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

<div style="height: 25px">$tableWithImage</div>''',
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
              'rowspan': '''
<table border="1">
  <tr><td rowspan="2">$multiline</td><td>Foo</td></tr>
  <tr><td>Bar</td></tr>
</table>''',
              // TODO: doesn't match browser output
              'sizing_height_1px': '''
Above

<table border="1" style="height: 1px">
  <tr>
    <td style="height: 1px">Foo</td>
  </tr>
</table>

Below''',
              'sizing_width_100_percent': '''
<table border="1" style="width: 100%">
  <tr>
    <td>One</td>
    <td>Two</td>
    <td>Three</td>
  </tr>
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
              // https://github.com/daohoangson/flutter_widget_from_html/issues/171
              // https://github.com/daohoangson/flutter_widget_from_html/issues/1028
              'row_color': '''
<table style="border-collapse: collapse;">
  <tr>
    <th>First Name</th>
    <th>Last Name</th>
    <th>Points</th>
  </tr>
  <tr style="background-color: #f2f2f2;">
    <td>Jill</td>
    <td>Smith</td>
    <td>50</td>
  </tr>
  <tr>
    <td>Eve</td>
    <td>Jackson</td>
    <td>94</td>
  </tr>
  <tr style="background-color: #f2f2f2;">
    <td>Adam</td>
    <td>Johnson</td>
    <td style="background-color: red;">67</td>
  </tr>
</table>''',
              'rtl': '''
<table dir="rtl">
  <tr>
    <td>Foo Foo Foo</td>
    <td>Bar</td>
  </tr>
  <tr>
    <td>Foo</td>
    <td>Bar Bar Bar</td>
  </tr>
</table>
''',
              // TODO: doesn't match browser output
              // `LayoutBuilder` prevents baseline alignment from working properly since #1073
              'table_in_list': '''
<ul>
  <li>
    <table border="1"><tr><td>Foo</td></tr></table>
  </li>
</ul>''',
              // TODO: doesn't match browser output
              // `LayoutBuilder` prevents baseline alignment from working properly since #1073
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
              // https://github.com/daohoangson/flutter_widget_from_html/issues/1322
              // https://github.com/daohoangson/flutter_widget_from_html/issues/1446
              'text_align_center': '''
<table border="1">
  <tr>
    <td>Long long long text</td>
  </tr>
  <tr>
    <td style="text-align: center;">Short text</td>
  </tr>
</table>
''',
              'width_redistribution_wide': '''
<div style="background: red; width: 400px">
  <table border="1">
    <tr>
      <td>Foo</td>
      <td>Lorem ipsum dolor sit amet.</td>
      <td>Foo bar</td>
    </tr>
  </table>
</div>''',
              'width_redistribution_wide2': '''
<div style="background: red; width: 200px">
  <table border="1">
    <tr>
      <td>Foo</td>
      <td>Lorem ipsum dolor sit amet.</td>
      <td>Foo bar</td>
    </tr>
  </table>
</div>''',
              // TODO: doesn't match browser output
              'width_in_percent': '''
<table border="1">
  <tr>
    <td style="background: red; width: 30%">Foo</td>
    <td style="background: green; width: 70%">Bar</td>
  </tr>
</table>''',
              'width_in_percent_100_nested': '''
<table border="1">
  <tr>
    <td>
      <table border="1">
        <tr>
          <td style="width: 100%">Foo</td>
        </tr>
      </table>
    </td>
  </tr>
</table>''',
              'width_in_percent_100_nested_with_gaps': '''
<table border="1">
  <tr><td>Foo foo foo</td></tr>
  <tr>
    <td>
      <table border="1">
        <tr>
          <td style="width: 100%">Foo</td>
        </tr>
      </table>
    </td>
  </tr>
</table>''',
              'width_in_percent_100_nested_stretch': '''
<table border="1">
  <tr><td>Foo foo foo</td></tr>
  <tr>
    <td>
      <table border="1" style="width: 100%">
        <tr>
          <td style="width: 100%">Foo</td>
        </tr>
      </table>
    </td>
  </tr>
</table>''',
              'width_in_px': '''
<table border="1">
  <tr>
    <td style="width: 50px">Foo</td>
    <td style="width: 100px">Bar</td>
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

            testGoldens(
              'horizontal_scroll_view',
              (tester) async {
                await tester.pumpWidgetBuilder(
                  const _Golden('''
<table border="1">
  <tr>
    <td>Foofoofoofoofoofoofoofoofoofoo</td>
    <td>Bar</td>
  </tr>
</table>
'''),
                  wrapper: materialAppWrapper(theme: ThemeData.light()),
                  surfaceSize: const Size(100, 100),
                );

                await screenMatchesGolden(tester, 'horizontal_scroll_view/foo');

                final bar = helper.findText('Bar').evaluate().single;
                await Scrollable.ensureVisible(bar);
                await screenMatchesGolden(tester, 'horizontal_scroll_view/bar');
              },
              skip: goldenSkip != null,
            );
          },
          skip: goldenSkip,
        );
      },
      config: GoldenToolkitConfiguration(
        fileNameFactory: (n) => '${helper.kGoldenFilePrefix}/table/$n.png',
      ),
    );
  });

  group('HtmlTableCell', () {
    group('debugTypicalAncestorWidgetClass', () {
      testWidgets('throws error if parent is not HtmlTable', (tester) async {
        await tester.pumpWidget(
          const HtmlTableCell(columnStart: 0, rowStart: 0, child: widget0),
        );
        expect(
          tester.takeException(),
          isAssertionError.having(
            (error) => error.message,
            'message',
            contains(
              'Typically, HtmlTableCell widgets are placed directly inside HtmlTable widgets.',
            ),
          ),
        );
      });
    });
  });

  group('ValignBaseline', () {
    testWidgets('_ValignBaselineRenderObject updates index', (tester) async {
      await explain(
        tester,
        '<table style="border-collapse: separate">'
        '<tr><td>Foo</td>'
        '<td valign="baseline">Bar</td></tr>'
        '</table>',
        useExplainer: false,
      );
      final finder = find.byType(ValignBaseline);
      final before = tester.firstRenderObject(finder);
      expect(before.toStringShort(), endsWith('(index: 0)'));

      await explain(
        tester,
        '<table style="border-collapse: separate">'
        '<tr><td>Foo</td></tr>'
        '<tr><td valign="baseline">Bar</td></tr>'
        '</table>',
        useExplainer: false,
      );
      final after = tester.firstRenderObject(finder);
      expect(after.toStringShort(), endsWith('(index: 1)'));
    });

    testWidgets("renders first text by second's baseline", (tester) async {
      final foo = GlobalKey();
      final bar = GlobalKey();
      const padding = EdgeInsets.all(12);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ValignBaselineContainer(
              child: Row(
                children: [
                  ValignBaseline(
                    index: 0,
                    child: Text('Foo', key: foo),
                  ),
                  ValignBaseline(
                    index: 0,
                    child: Padding(
                      padding: padding,
                      child: Text('Bar', key: bar),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final fooTop = foo.renderBox.top;
      final barTop = bar.renderBox.top;
      expect(fooTop, equals(padding.top));
      expect(barTop, equals(fooTop));
    });

    testWidgets("renders second text by first's baseline", (tester) async {
      final foo = GlobalKey();
      final bar = GlobalKey();
      const padding = EdgeInsets.all(21);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ValignBaselineContainer(
              child: Row(
                children: [
                  ValignBaseline(
                    index: 0,
                    child: Padding(
                      padding: padding,
                      child: Text('Foo', key: foo),
                    ),
                  ),
                  ValignBaseline(
                    index: 0,
                    child: Text('Bar', key: bar),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final fooTop = foo.renderBox.top;
      final barTop = bar.renderBox.top;
      expect(fooTop, equals(padding.top));
      expect(barTop, equals(fooTop));
    });

    testWidgets('renders without container', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ValignBaseline(
              index: 0,
              child: Text('Foo'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Foo'), findsOneWidget);
    });
  });
}

Future<String> explain(
  WidgetTester tester,
  String? html, {
  Widget? hw,
  bool useExplainer = true,
}) {
  _loggerMessages.clear();
  return helper.explain(tester, html, hw: hw, useExplainer: useExplainer);
}

String _padding(String child) => '[HtmlTableCell:child='
    '[Padding:(1,1,1,1),child='
    '[Align:alignment=centerLeft,widthFactor=1.0,child=[CssBlock:child='
    '$child]]]]';

final _loggerIsGitHubAction = Platform.environment['GITHUB_ACTIONS'] == 'true';
final _loggerMessages = [];

void _loggerSetup() {
  Logger.root.level = Level.FINER;
  Logger.root.onRecord.listen((LogRecord record) {
    _loggerMessages.add(record.message);
    if (_loggerIsGitHubAction) {
      // skip printing if we are in GitHub Actions, it's too noisy
      return;
    }

    final prefix = '${record.time.toIso8601String().substring(11)} '
        '${record.loggerName}@${record.level.name} ';
    debugPrint('$prefix${record.message}');

    final error = record.error;
    if (error != null) {
      debugPrint('$prefix$error');
    }
  });
}

String _richtext(String text) => _padding('[RichText:(:$text)]');

extension on WidgetTester {
  HtmlTable get table => widget(find.byType(HtmlTable));
}

class _Golden extends StatelessWidget {
  final String contents;

  const _Golden(this.contents);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: HtmlWidget(contents),
        ),
      );
}
