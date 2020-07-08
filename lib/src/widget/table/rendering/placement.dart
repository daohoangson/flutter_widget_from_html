part of '../../table_layout.dart';

PlacementGrid computeItemPlacement(RenderLayoutGrid grid) {
  final occupancy = PlacementGrid(grid: grid);

  var child = grid.firstChild;
  while (child != null) {
    final childParentData = child.parentData as GridParentData;
    final area = childParentData.area;
    if (area != null) occupancy.addItemToArea(child, area);
    child = childParentData.nextSibling;
  }

  return occupancy;
}

class PlacementGrid {
  PlacementGrid({
    @required this.grid,
  })  : explicitColumnCount = grid.templateColumnSizes.length,
        explicitRowCount = grid.templateRowSizes.length {
    _cells = List<GridCell>.generate(
        explicitColumnCount * explicitRowCount, (i) => GridCell(this, i));
  }

  final RenderLayoutGrid grid;
  final int explicitColumnCount;
  final int explicitRowCount;

  Map<RenderBox, GridArea> itemAreas = {};
  List<GridCell> _cells;

  GridCell getCellAt(int column, int row) =>
      _cells[row * explicitColumnCount + column];

  Iterable<GridCell> getCellsInTrack(
    int trackIndex,
    TrackType trackType,
  ) sync* {
    final trackMainAxis = mainAxisForTrackType(trackType);
    final firstCellIndex = trackMainAxis == Axis.vertical
        ? trackIndex
        : trackIndex * explicitColumnCount;

    final cell = _cells.length > firstCellIndex ? _cells[firstCellIndex] : null;
    if (cell != null) {
      yield* [cell].followedBy(cell.nextCellsAlongAxis(trackMainAxis));
    }
  }

  Iterable<GridCell> getCellsInArea(GridArea area) sync* {
    for (var x = area.columnStart; x < area.columnEnd; x++) {
      for (var y = area.rowStart; y < area.rowEnd; y++) {
        yield getCellAt(x, y);
      }
    }
  }

  /// Returns `true` if the specified [area] is vacant.
  bool checkIsVacant(GridArea area) =>
      getCellsInArea(area).every((c) => c.isVacant);

  void addItemToArea(RenderBox item, GridArea area) {
    if (area.columnEnd > explicitColumnCount) {
      throw FlutterError.fromParts([
        ErrorSummary('GridPlacement.columnEnd cannot exceed column count\n'),
        grid?.toDiagnosticsNode(name: 'grid'),
        item.toDiagnosticsNode(name: 'gridItem'),
      ]);
    }

    if (area.rowEnd > explicitRowCount) {
      throw FlutterError.fromParts([
        ErrorSummary('GridPlacement.rowEnd cannot exceed row count\n'),
        grid?.toDiagnosticsNode(name: 'grid'),
        item.toDiagnosticsNode(name: 'gridItem'),
      ]);
    }

    for (final cell in getCellsInArea(area)) {
      cell.occupants.add(item);
    }
    itemAreas[item] = area;
  }

  @override
  String toString() {
    final cap = '┼${'-' * (explicitColumnCount * 2 - 1)}┼';
    final rows = partition(
            _cells.map((c) => c.isOccupied ? c.debugLabel ?? 'x' : ' '),
            explicitColumnCount)
        .map((row) => row.join(','));
    return '$cap\n|${rows.join('|\n|')}|\n$cap';
  }
}

@immutable
class GridCell {
  GridCell(this.grid, this.index);

  final PlacementGrid grid;
  final int index;
  final occupants = <RenderBox>{};

  int get column => index % grid.explicitColumnCount;
  int get row => index ~/ grid.explicitColumnCount;

  bool get isOccupied => occupants.isNotEmpty;
  bool get isVacant => !isOccupied;

  String get debugLabel => occupants.isNotEmpty
      ? (occupants.first.parentData as GridParentData).debugLabel
      : null;

  Iterable<GridCell> nextCellsAlongAxis(Axis axis) sync* {
    final next = axis == Axis.horizontal ? nextInRow : nextInColumn;
    if (next != null) {
      yield next;
      yield* next.nextCellsAlongAxis(axis);
    }
  }

  /// The cell next to this one in the row, or `null` if none.
  GridCell get nextInRow {
    final column = (index + 1) % grid.explicitColumnCount;
    return column == 0 ? null : grid._cells[index + 1];
  }

  /// The cell below this one in the column, or `null` if none.
  GridCell get nextInColumn {
    final i = index + grid.explicitColumnCount;
    return i >= grid._cells.length ? null : grid._cells[i];
  }

  @override
  String toString() {
    return 'GridCell($column, $row, isOccupied=$isOccupied)';
  }
}
