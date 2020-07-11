part of '../core_data.dart';

class TableData extends StatelessWidget {
  final BorderSide border;
  final Map<int, Map<int, int>> _grid = {};
  final List<TableDataSlot> _slots = [];

  TableData({
    this.border,
    Key key,
  }) : super(key: key);

  Iterable<TableDataSlot> get slots => _slots;

  int get cols => _grid.values.fold(0, _colsCombine);

  int get rows => _grid.keys.length;

  int addCell(int row, TableDataCell cell) {
    _grid[row] ??= {};
    var col = 0;
    while (_grid[row].containsKey(col)) {
      col++;
    }

    final index = _slots.length;
    _slots.add(TableDataSlot._(index, cell, row, col));

    for (var r = 0; r < cell.rowspan; r++) {
      for (var c = 0; c < cell.colspan; c++) {
        var rr = row + r;
        _grid[rr] ??= {};

        var cc = col + c;
        if (!_grid[rr].containsKey(cc)) {
          _grid[rr][cc] = index;
        }
      }
    }

    return index;
  }

  @override
  Widget build(BuildContext context) => widget0;

  TableDataSlot getSlot({int col, int index, int row}) {
    assert((col == null) == (row == null));
    assert((col == null) != (index == null));

    if (col != null && row != null) {
      if (!_grid.containsKey(row)) return null;
      final map = _grid[row];
      if (!map.containsKey(col)) return null;
      index = map[col];
    }

    return _slots[index];
  }

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

@immutable
class TableDataSlot {
  final TableDataCell cell;
  final int col;
  final int index;
  final int row;

  TableDataSlot._(this.index, this.cell, this.row, this.col);
}
