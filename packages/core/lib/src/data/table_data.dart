part of '../core_data.dart';

class TableData extends StatelessWidget {
  final BorderSide border;
  final List<TableDataCell> cells = [];
  final Map<int, Map<int, int>> grid = Map();

  TableData({
    this.border,
    Key key,
  }) : super(key: key);

  int get cols => grid.values.fold(0, _colsCombine);

  int get rows => grid.keys.length;

  int addCell(int rowIndex, TableDataCell cell) {
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

class TableDataCell extends StatelessWidget {
  final Iterable<Widget> children;
  final int colspan;
  final int rowspan;

  const TableDataCell({
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
