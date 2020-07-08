part of '../table_layout.dart';

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
  final int cols;
  final RenderLayoutGrid grid;
  final Map<RenderBox, GridArea> itemAreas = {};
  final int rows;

  List<GridCell> _cells;

  PlacementGrid({@required this.grid})
      : cols = grid.templateColumnSizes.length,
        rows = grid.templateRowSizes.length {
    _cells = List.generate(cols * rows, (i) => GridCell(this, i));
  }

  GridCell getCellAt(int column, int row) => _cells[row * cols + column];

  Iterable<GridCell> getCellsInTrack(
    int trackIndex,
    TrackType trackType,
  ) sync* {
    final trackMainAxis = mainAxisForTrackType(trackType);
    final firstCellIndex =
        trackMainAxis == Axis.vertical ? trackIndex : trackIndex * cols;

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

  void addItemToArea(RenderBox item, GridArea area) {
    for (final cell in getCellsInArea(area)) {
      cell.occupants.add(item);
    }
    itemAreas[item] = area;
  }
}

@immutable
class GridArea {
  GridArea({
    @required this.columnStart,
    @required this.columnEnd,
    @required this.rowStart,
    @required this.rowEnd,
  })  : assert(columnStart != null),
        assert(columnEnd != null),
        assert(rowStart != null),
        assert(rowEnd != null);

  final int columnStart;
  final int rowStart;
  final int columnEnd;
  final int rowEnd;

  int startForAxis(Axis axis) =>
      axis == Axis.horizontal ? columnStart : rowStart;
  int endForAxis(Axis axis) => axis == Axis.horizontal ? columnEnd : rowEnd;
  int spanForAxis(Axis axis) => endForAxis(axis) - startForAxis(axis);

  @override
  int get hashCode => hashObjects([columnStart, columnEnd, rowStart, rowEnd]);

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final typedOther = other as GridArea;
    return typedOther.columnStart == columnStart &&
        typedOther.columnEnd == columnEnd &&
        typedOther.rowStart == rowStart &&
        typedOther.rowEnd == rowEnd;
  }
}

@immutable
class GridCell {
  GridCell(this.grid, this.index);

  final PlacementGrid grid;
  final int index;
  final occupants = <RenderBox>{};

  Iterable<GridCell> nextCellsAlongAxis(Axis axis) sync* {
    final next = axis == Axis.horizontal ? nextInRow : nextInColumn;
    if (next != null) {
      yield next;
      yield* next.nextCellsAlongAxis(axis);
    }
  }

  GridCell get nextInRow {
    final column = (index + 1) % grid.cols;
    return column == 0 ? null : grid._cells[index + 1];
  }

  GridCell get nextInColumn {
    final i = index + grid.cols;
    return i >= grid._cells.length ? null : grid._cells[i];
  }
}
