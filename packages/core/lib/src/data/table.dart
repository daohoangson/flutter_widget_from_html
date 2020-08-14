part of '../core_data.dart';

/// A table being processed.
@immutable
class TableMetadata {
  /// The table's border.
  final BorderSide border;

  final Map<int, Map<int, int>> _grid = {};

  final List<_TableMetadataSlot> _slots = [];

  /// Creates a table.
  TableMetadata({this.border});

  /// The number of columns.
  int get cols => _grid.values.fold(0, _colsCombine);

  /// The number of cells.
  int get length => _slots.length;

  /// The number of rows.
  int get rows => _grid.keys.length;

  /// Adds cell at the specified [row] taking [colspan] and [rowspan] into account.
  ///
  /// The column number will be determined automatically.
  int addCell(int row, Widget child, {int colspan, int rowspan}) {
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

  /// Gets the cell index by [column] and [row].
  int getIndexAt(int column, int row) {
    if (!_grid.containsKey(row)) return -1;
    final map = _grid[row];
    if (!map.containsKey(column)) return -1;
    return map[column];
  }

  /// Gets the cell widget by [index].
  Widget getWidgetAt(int index) => _slots[index].child;

  /// Applies the function [callback] to each cell.
  void visitCells(
    void Function(int col, int row, Widget widget, int colspan, int rowspan)
        callback,
  ) {
    for (final slot in _slots) {
      callback(slot.col, slot.row, slot.child, slot.colspan, slot.rowspan);
    }
  }

  static int _colsCombine(int prev, Map<int, int> row) {
    final cols = row.keys.length;
    return prev > cols ? prev : cols;
  }
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
