import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:test/test.dart';

void main() {
  group('TableMetadata', () {
    group('happy path', () {
      final table = TableMetadata();

      final cell00 = Container();
      final cell01 = Container();
      final cell10 = Container();
      final cell11 = Container();
      table.addCell(0, cell00);
      table.addCell(0, cell01);
      table.addCell(1, cell10);
      table.addCell(1, cell11);

      test('returns cols', () => expect(table.cols, equals(2)));

      test('returns length', () => expect(table.length, equals(4)));

      test('returns rows', () => expect(table.rows, equals(2)));

      group('getIndexAt', () {
        test('returns 0',
            () => expect(table.getIndexAt(row: 0, column: 0), equals(0)));
        test('returns 1',
            () => expect(table.getIndexAt(row: 0, column: 1), equals(1)));
        test('returns 2',
            () => expect(table.getIndexAt(row: 1, column: 0), equals(2)));
        test('returns 3',
            () => expect(table.getIndexAt(row: 1, column: 1), equals(3)));
      });

      group('getWidgetAt', () {
        test('returns 00', () => expect(table.getWidgetAt(0), equals(cell00)));
        test('returns 01', () => expect(table.getWidgetAt(1), equals(cell01)));
        test('returns 10', () => expect(table.getWidgetAt(2), equals(cell10)));
        test('returns 11', () => expect(table.getWidgetAt(3), equals(cell11)));
      });

      test('visitCells', () {
        var i = 0;
        table.visitCells((col, row, widget, colspan, rowspan) {
          switch (i) {
            case 0:
              expect(row, equals(0));
              expect(col, equals(0));
              expect(widget, equals(cell00));
              break;
            case 1:
              expect(row, equals(0));
              expect(col, equals(1));
              expect(widget, equals(cell01));
              break;
            case 2:
              expect(row, equals(1));
              expect(col, equals(0));
              expect(widget, equals(cell10));
              break;
            case 3:
              expect(row, equals(1));
              expect(col, equals(1));
              expect(widget, equals(cell11));
              break;
          }

          expect(colspan, equals(1));
          expect(rowspan, equals(1));

          i++;
        });
      });
    });

    group('empty table', () {
      final table = TableMetadata();

      test('cols returns 0', () => expect(table.cols, equals(0)));
      test('length returns 0', () => expect(table.length, equals(0)));
      test('rows returns 0', () => expect(table.rows, equals(0)));
    });

    group('cell not at (0, 0)', () {
      final table = TableMetadata();
      final cell = Container();
      table.addCell(4, cell);

      test('cols returns 1', () => expect(table.cols, equals(1)));
      test('rows returns 5', () => expect(table.rows, equals(5)));
    });

    group('colspan', () {
      final table = TableMetadata();
      final cell = Container();
      table.addCell(0, cell, colspan: 10);

      test('cols returns 10', () => expect(table.cols, equals(10)));
      test('rows returns 1', () => expect(table.rows, equals(1)));
    });

    group('rowspan', () {
      final table = TableMetadata();
      final cell = Container();
      table.addCell(0, cell, rowspan: 10);

      test('cols returns 1', () => expect(table.cols, equals(1)));
      test('rows returns 10', () => expect(table.rows, equals(10)));
    });

    group('colspan+rowspan', () {
      final table = TableMetadata();
      final cell = Container();
      table.addCell(0, cell, colspan: 5, rowspan: 5);

      test('cols returns 5', () => expect(table.cols, equals(5)));
      test('rows returns 5', () => expect(table.rows, equals(5)));
    });
  });
}
