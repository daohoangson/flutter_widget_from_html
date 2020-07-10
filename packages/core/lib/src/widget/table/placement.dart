part of '../table_layout.dart';

_PlacementGrid computeItemPlacement(_TableRenderBox renderBox) {
  final occupancy = _PlacementGrid(renderBox);

  var child = renderBox.firstChild;
  while (child != null) {
    final placement = child.parentData as _RenderingPlacementData;
    final area = placement.area;
    if (area != null) occupancy.addItemToArea(child, area);

    child = placement.nextSibling;
  }

  return occupancy;
}

class _PlacementGrid {
  final int cols;
  final _TableRenderBox renderBox;
  final Map<RenderBox, _PlacementArea> itemAreas = {};
  final int rows;

  List<_PlacementCell> _cells;

  _PlacementGrid(this.renderBox)
      : cols = renderBox.templateColumnSizes.length,
        rows = renderBox.templateRowSizes.length {
    _cells = List.generate(cols * rows, (i) => _PlacementCell(this, i));
  }

  _PlacementCell getCellAt(int column, int row) => _cells[row * cols + column];

  Iterable<_PlacementCell> getCellsInTrack(
    int trackIndex,
    _TrackType trackType,
  ) sync* {
    final trackMainAxis =
        trackType == _TrackType.column ? Axis.vertical : Axis.horizontal;
    final firstCellIndex =
        trackMainAxis == Axis.vertical ? trackIndex : trackIndex * cols;

    final cell = _cells.length > firstCellIndex ? _cells[firstCellIndex] : null;
    if (cell != null) {
      yield* [cell].followedBy(cell.nextCellsAlongAxis(trackMainAxis));
    }
  }

  Iterable<_PlacementCell> getCellsInArea(_PlacementArea area) sync* {
    for (var x = area.columnStart; x < area.columnEnd; x++) {
      for (var y = area.rowStart; y < area.rowEnd; y++) {
        yield getCellAt(x, y);
      }
    }
  }

  void addItemToArea(RenderBox item, _PlacementArea area) {
    for (final cell in getCellsInArea(area)) {
      cell.occupants.add(item);
    }
    itemAreas[item] = area;
  }
}

@immutable
class _PlacementArea {
  _PlacementArea({
    @required this.columnStart,
    @required this.columnEnd,
    @required this.rowStart,
    @required this.rowEnd,
  });

  final int columnStart;
  final int rowStart;
  final int columnEnd;
  final int rowEnd;

  int startForAxis(Axis axis) =>
      axis == Axis.horizontal ? columnStart : rowStart;
  int endForAxis(Axis axis) => axis == Axis.horizontal ? columnEnd : rowEnd;
  int spanForAxis(Axis axis) => endForAxis(axis) - startForAxis(axis);
}

@immutable
class _PlacementCell {
  _PlacementCell(this.grid, this.index);

  final _PlacementGrid grid;
  final int index;
  final occupants = <RenderBox>{};

  Iterable<_PlacementCell> nextCellsAlongAxis(Axis axis) sync* {
    final next = axis == Axis.horizontal ? nextInRow : nextInColumn;
    if (next != null) {
      yield next;
      yield* next.nextCellsAlongAxis(axis);
    }
  }

  _PlacementCell get nextInRow {
    final column = (index + 1) % grid.cols;
    return column == 0 ? null : grid._cells[index + 1];
  }

  _PlacementCell get nextInColumn {
    final i = index + grid.cols;
    return i >= grid._cells.length ? null : grid._cells[i];
  }
}
