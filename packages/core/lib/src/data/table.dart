part of '../core_data.dart';

@immutable
class TableMetadata {
  final BorderSide border;

  final Map<int, Map<int, int>> _grid = {};

  final List<_TableMetadataSlot> _slots = [];

  TableMetadata({this.border});

  int get cols => _grid.values.fold(0, _colsCombine);

  int get length => _slots.length;

  int get rows => _grid.keys.fold(0, _rowsCombine);

  int addCell(int row, Widget child, {int colspan = 1, int rowspan = 1}) {
    _grid[row] ??= {};
    var col = 0;
    while (_grid[row].containsKey(col)) {
      col++;
    }

    final index = _slots.length;
    _slots.add(_TableMetadataSlot(
        child: child, col: col, colspan: colspan, row: row, rowspan: rowspan));

    for (var r = 0; r < rowspan; r++) {
      for (var c = 0; c < colspan; c++) {
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

  int getIndexAt({int column, int row}) {
    if (!_grid.containsKey(row)) return -1;
    final map = _grid[row];
    if (!map.containsKey(column)) return -1;
    return map[column];
  }

  Widget getWidgetAt(int index) => _slots[index].child;

  void visitCells(
    void Function(int col, int row, Widget widget, int colspan, int rowspan)
        callback,
  ) {
    for (final slot in _slots) {
      callback(slot.col, slot.row, slot.child, slot.colspan, slot.rowspan);
    }
  }

  static int _colsCombine(int prev, Map<int, int> row) =>
      max(prev, row.keys.length);

  static int _rowsCombine(int prev, int rowId) => max(prev, rowId + 1);
}

@immutable
class _TableMetadataSlot {
  final Widget child;
  final int col;
  final int colspan;
  final int row;
  final int rowspan;

  _TableMetadataSlot(
      {this.child, this.col, this.colspan, this.row, this.rowspan});
}
