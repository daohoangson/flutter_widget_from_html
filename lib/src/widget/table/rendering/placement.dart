part of '../../table_layout.dart';

/// Implementation of the auto-placement algorithm, described here:
/// https://drafts.csswg.org/css-grid/#auto-placement-algo
PlacementGrid computeItemPlacement(RenderLayoutGrid grid) {
  final occupancy = PlacementGrid(grid: grid);

  final growthAxis = Axis.vertical;
  final fixedAxis = flipAxis(growthAxis);

  final fullyPlacedChildren = <RenderBox>[];
  final flowAxisPlacedChildren = <RenderBox>[];
  final remainingChildren = <RenderBox>[];

  // 0. Bucket children into lists based on their placement priority
  var child = grid.firstChild;
  while (child != null) {
    final childParentData = child.parentData as GridParentData;

    if (childParentData.isDefinitelyPlaced) {
      fullyPlacedChildren.add(child);
    } else if (childParentData.isDefinitelyPlacedOnAxis(growthAxis)) {
      flowAxisPlacedChildren.add(child);
    } else {
      remainingChildren.add(child);
    }

    child = childParentData.nextSibling;
  }

  // 1. Occupy cells with definitely placed items (have both columns and rows
  //    specified)
  for (final child in fullyPlacedChildren) {
    final childParentData = child.parentData as GridParentData;
    occupancy.addItemToArea(child, childParentData.area);
  }

  // 2. Iterate over the children definitely placed on the flow axis, finding
  //    them spots
  for (final child in flowAxisPlacedChildren) {
    final childParentData = child.parentData as GridParentData;
    final cursor = occupancy.createCursor()
      ..fixToAxisIndex(childParentData.startForAxis(growthAxis), growthAxis);

    final area = cursor.moveToNextEmptyArea(
        childParentData.columnSpan, childParentData.rowSpan);
    occupancy.addItemToArea(child, area);
  }

  // 3. Distribute the rest of the children, using a cursor appropriate for the
  //    auto-flow mode.
  final autoFlowCursor = occupancy.createCursor();
  for (final child in remainingChildren) {
    final childParentData = child.parentData as GridParentData;
    if (childParentData.isDefinitelyPlacedOnAxis(fixedAxis)) {
      autoFlowCursor.fixToAxisIndex(
          childParentData.startForAxis(fixedAxis), growthAxis);
    } else {
      autoFlowCursor.unfixFromTrack();
    }

    final area = autoFlowCursor.moveToNextEmptyArea(
        childParentData.columnSpan, childParentData.rowSpan);
    occupancy.addItemToArea(child, area);
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

  /// Creates a cursor that for traversing the grid to find vacancy.
  PlacementGridCursor createCursor() => PlacementGridCursor(this);

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

/// Navigates the grid in order to find empty spots.
class PlacementGridCursor {
  PlacementGridCursor(this.grid);

  final PlacementGrid grid;

  Axis get autoPlacementTraversalAxis => Axis.horizontal;

  /// The column under the cursor
  int currentColumn = -1;

  /// The row under the cursor
  int currentRow = -1;

  /// The current position of the cursor on the specified axis.
  int currentIndexOnAxis(Axis axis) =>
      axis == Axis.horizontal ? currentColumn : currentRow;

  /// Sets the current position of the cursor on the specified axis.
  void setCurrentIndexOnAxis(int index, Axis axis) {
    if (axis == Axis.vertical) {
      currentRow = index;
    } else {
      currentColumn = index;
    }
  }

  int getAxisLength(Axis axis) => axis == Axis.horizontal
      ? grid.explicitColumnCount
      : grid.explicitRowCount;

  /// The index of the track that we're currently searching for space.
  int fixedTrackIndex;

  /// horizontal for column, vertical for row
  Axis fixedAxis;

  /// `true` if this cursor is fixed to traversing a single track
  bool get isFixedToTrack => fixedAxis != null;

  /// `true` if this cursor is fixed to an axis, but requires a
  /// [moveToNextEmptyArea] to be positioned correctly
  bool get requiresMoveToFixedAxisIndex =>
      isFixedToTrack && currentIndexOnAxis(fixedAxis) != fixedTrackIndex;

  void fixToAxisIndex(int fixedIndex, Axis fixedAxis) {
    fixedTrackIndex = fixedIndex;
    fixedAxis = fixedAxis;
  }

  void unfixFromTrack() {
    fixedTrackIndex = null;
    fixedAxis = null;
  }

  GridArea moveToNextEmptyArea(int columnSpan, int rowSpan) {
    Iterable<GridArea> Function(int, int) moveFn;
    if (isFixedToTrack) {
      moveFn = _moveFixedToNext;
    } else {
      moveFn = _moveAutoToNext;
    }

    return moveFn(columnSpan, rowSpan).firstWhere(grid.checkIsVacant);
  }

  Iterable<GridArea> _moveFixedToNext(int columnSpan, int rowSpan) sync* {
    final traversalAxis = flipAxis(fixedAxis);
    final traversalAxisIndex = () => currentIndexOnAxis(traversalAxis);

    if (requiresMoveToFixedAxisIndex) {
      if (currentColumn == -1 && currentRow == -1) {
        setCurrentIndexOnAxis(0, traversalAxis);
      } else {
        final fixedAxisIndex = currentIndexOnAxis(fixedAxis);
        if (fixedTrackIndex < fixedAxisIndex) {
          setCurrentIndexOnAxis(traversalAxisIndex() + 1, traversalAxis);
        }
      }
      setCurrentIndexOnAxis(fixedTrackIndex, fixedAxis);
      yield _currentAreaForSpans(columnSpan, rowSpan);
    }

    while (true) {
      setCurrentIndexOnAxis(traversalAxisIndex() + 1, traversalAxis);
      yield _currentAreaForSpans(columnSpan, rowSpan);
    }
  }

  Iterable<GridArea> _moveAutoToNext(int columnSpan, int rowSpan) sync* {
    // The axis we will attempt to fill before moving to the next index on the
    // growth axis.
    final fixedAxis = autoPlacementTraversalAxis;
    final fixedAxisIndex = () => currentIndexOnAxis(fixedAxis);

    // The direction of growth of the grid.
    final growthAxis = flipAxis(autoPlacementTraversalAxis);
    final growthAxisIndex = () => currentIndexOnAxis(growthAxis);

    // Auto-placement flow
    while (true) {
      if (currentColumn == -1 && currentRow == -1) {
        currentColumn = currentRow = 0;
      } else if (fixedAxisIndex() + 1 == getAxisLength(fixedAxis)) {
        setCurrentIndexOnAxis(0, fixedAxis);
        setCurrentIndexOnAxis(growthAxisIndex() + 1, growthAxis);
      } else {
        setCurrentIndexOnAxis(fixedAxisIndex() + 1, fixedAxis);
      }

      yield _currentAreaForSpans(columnSpan, rowSpan);
    }
  }

  GridArea _currentAreaForSpans(int columnSpan, int rowSpan) {
    return GridArea.withSpans(
      columnStart: currentColumn,
      columnSpan: columnSpan,
      rowStart: currentRow,
      rowSpan: rowSpan,
    );
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
