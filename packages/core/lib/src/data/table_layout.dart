part of '../core_data.dart';

class TableLayout extends StatelessWidget {
  final Map<int, Map<int, int>> grid = Map();
  final List<TableLayoutCell> cells = [];

  TableLayout({Key key}) : super(key: key);

  int get cols => grid.values.fold(0, _colsCombine);

  int get rows => grid.keys.length;

  int addCell(int rowIndex, TableLayoutCell cell) {
    final cellIndex = cells.length;
    cells.add(cell);

    grid[rowIndex] ??= Map();
    var cellIndexInRow = 0;
    while (grid[rowIndex].containsKey(cellIndexInRow)) {
      cellIndexInRow++;
    }

    for (var i = 0; i < cell.colspan; i++) {
      for (var j = 0; j < cell.rowspan; j++) {
        var rj = rowIndex + j;
        grid[rj] ??= Map();

        var ci = cellIndexInRow + i;
        if (!grid[rj].containsKey(ci)) {
          grid[rj][ci] = cellIndex;
        }
      }
    }

    return cellIndex;
  }

  @override
  Widget build(BuildContext context) => widget0;

  static int _colsCombine(int prev, Map<int, int> row) {
    final cols = row.keys.length;
    return prev > cols ? prev : cols;
  }
}

class TableLayoutCell extends StatelessWidget {
  final Iterable<Widget> children;
  final int colspan;
  final int rowspan;

  const TableLayoutCell({
    Key key,
    @required this.children,
    @required this.colspan,
    @required this.rowspan,
  })  : assert(children != null),
        assert(colspan != null),
        assert(rowspan != null),
        super(key: key);

  @override
  Widget build(BuildContext context) => widget0;
}

class TableLayoutRow extends StatelessWidget {
  final Iterable<TableLayoutCell> cells;

  const TableLayoutRow({Key key, @required this.cells})
      : assert(cells != null),
        super(key: key);

  int get colspan => cells.fold(0, _colspanCombine);

  int get rowspan => cells.fold(0, _rowspanCombine);

  @override
  Widget build(BuildContext context) => widget0;

  static int _colspanCombine(int prev, TableLayoutCell cell) =>
      prev + cell.colspan;

  static int _rowspanCombine(int prev, TableLayoutCell cell) =>
      prev > cell.rowspan ? prev : cell.rowspan;
}

class TableLayoutGroup extends StatelessWidget {
  final Iterable<TableLayoutRow> rows;
  final String type;

  const TableLayoutGroup({
    Key key,
    @required this.rows,
    @required this.type,
  })  : assert(rows != null),
        assert(type != null),
        super(key: key);

  @override
  Widget build(BuildContext context) => widget0;
}
