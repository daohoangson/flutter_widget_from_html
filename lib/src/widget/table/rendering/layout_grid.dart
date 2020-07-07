part of '../../table_layout.dart';

/// Parent data for use with [RenderLayoutGrid].
class GridParentData extends ContainerBoxParentData<RenderBox> {
  GridParentData({
    @required this.columnStart,
    this.columnSpan = 1,
    @required this.rowStart,
    this.rowSpan = 1,
    this.debugLabel,
  })  : assert(columnStart != null),
        assert(rowStart != null);

  /// If `null`, the item is auto-placed.
  int columnStart;
  int columnSpan = 1;

  /// If `null`, the item is auto-placed.
  int rowStart;
  int rowSpan = 1;

  String debugLabel;

  int startForAxis(Axis axis) =>
      axis == Axis.horizontal ? columnStart : rowStart;

  int spanForAxis(Axis axis) => //
      axis == Axis.horizontal ? columnSpan : rowSpan;

  GridArea get area => GridArea(
        columnStart: columnStart,
        columnEnd: columnStart + columnSpan,
        rowStart: rowStart,
        rowEnd: rowStart + rowSpan,
      );

  @override
  String toString() {
    final values = <String>[
      if (columnStart != null) 'columnStart=$columnStart',
      if (columnSpan != null) 'columnSpan=$columnSpan',
      if (rowStart != null) 'rowStart=$rowStart',
      if (rowSpan != null) 'rowSpan=$rowSpan',
      if (debugLabel != null) 'debugLabel=$debugLabel',
    ];
    values.add(super.toString());
    return values.join('; ');
  }
}

/// Implements the grid layout algorithm.
///
/// TODO(shyndman): Describe algorithm.
class RenderLayoutGrid extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, GridParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, GridParentData> {
  /// Creates a layout grid render object.
  RenderLayoutGrid({
    List<RenderBox> children,
    double columnGap = 0,
    double rowGap = 0,
    @required List<TrackSize> templateColumnSizes,
    @required List<TrackSize> templateRowSizes,
    TextDirection textDirection = TextDirection.ltr,
  })  : assert(textDirection != null),
        _templateColumnSizes = templateColumnSizes,
        _templateRowSizes = templateRowSizes,
        _columnGap = columnGap,
        _rowGap = rowGap,
        _textDirection = textDirection {
    addAll(children);
  }

  bool _needsPlacement = true;
  PlacementGrid _placementGrid;

  /// Defines the sizing functions of the grid's columns.
  List<TrackSize> get templateColumnSizes => _templateColumnSizes;
  List<TrackSize> _templateColumnSizes;
  set templateColumnSizes(List<TrackSize> value) {
    if (_templateColumnSizes == value) return;
    _templateColumnSizes = value;
    markNeedsPlacement();
    markNeedsLayout();
  }

  /// Defines the sizing functions of the grid's rows.
  List<TrackSize> get templateRowSizes => _templateRowSizes;
  List<TrackSize> _templateRowSizes;
  set templateRowSizes(List<TrackSize> value) {
    if (_templateRowSizes == value) return;
    _templateRowSizes = value;
    markNeedsPlacement();
    markNeedsLayout();
  }

  /// The space between column tracks
  double get columnGap => _columnGap;
  double _columnGap;
  set columnGap(double value) {
    if (_columnGap == value) return;
    _columnGap = value;
    markNeedsLayout();
  }

  /// The space between row tracks
  double get rowGap => _rowGap;
  double _rowGap;
  set rowGap(double value) {
    if (_rowGap == value) return;
    _rowGap = value;
    markNeedsLayout();
  }

  /// The text direction with which to resolve column ordering.
  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value) return;
    _textDirection = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! GridParentData) {
      child.parentData = GridParentData();
    }
  }

  @override
  double computeMinIntrinsicWidth(double height) =>
      _computeIntrinsicSize(BoxConstraints.tightFor(height: height)).minWidth;

  @override
  double computeMaxIntrinsicWidth(double height) =>
      _computeIntrinsicSize(BoxConstraints(minHeight: height)).maxWidth;

  @override
  double computeMinIntrinsicHeight(double width) =>
      _computeIntrinsicSize(BoxConstraints.tightFor(width: width)).minHeight;

  @override
  double computeMaxIntrinsicHeight(double width) =>
      _computeIntrinsicSize(BoxConstraints(minWidth: width)).maxHeight;

  // TODO(https://github.com/madewithfelt/flutter_layout_grid/issues/1):
  // This implementation is not likely to be correct. Revisit once Flutter's
  // sizing rules are better understood.
  GridSizingInfo _computeIntrinsicSize(BoxConstraints constraints) =>
      _computeGridSize(constraints);

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    return defaultComputeDistanceToHighestActualBaseline(baseline);
  }

  List<RenderBox> getChildrenInTrack(TrackType trackType, int trackIndex) {
    return _placementGrid
        .getCellsInTrack(trackIndex, trackType)
        .expand((cell) => cell.occupants)
        .where(removeDuplicates())
        .toList(growable: false);
  }

  @override
  void performLayout() {
    // Size the grid
    final gridSizing = _computeGridSize(constraints);
    size = gridSizing.gridSize;

    // Position and lay out the grid items
    var child = firstChild;
    while (child != null) {
      final parentData = child.parentData as GridParentData;
      final area = _placementGrid.itemAreas[child];

      parentData.offset = gridSizing.offsetForArea(area);
      child.layout(BoxConstraints.loose(gridSizing.sizeForArea(area)));
      child = parentData.nextSibling;
    }
  }

  GridSizingInfo _computeGridSize(BoxConstraints constraints) {
    // Distribute grid items into cells
    performItemPlacement();

    // Ready an object that contains our sizing information
    final gridSizing = GridSizingInfo.fromTrackSizeFunctions(
      columnSizeFunctions: _templateColumnSizes,
      rowSizeFunctions: _templateRowSizes,
      textDirection: textDirection,
      columnGap: columnGap,
      rowGap: rowGap,
    );

    // Determine the size of the column tracks
    final columnTracks = performTrackSizing(TrackType.column, gridSizing,
        constraints: constraints);
    gridSizing.hasColumnSizing = true;

    // Determine the size of the row tracks
    final rowTracks =
        performTrackSizing(TrackType.row, gridSizing, constraints: constraints);
    gridSizing.hasRowSizing = true;

    // Stretch intrinsics
    _stretchIntrinsicTracks(TrackType.column, gridSizing);
    _stretchIntrinsicTracks(TrackType.row, gridSizing);

    final gridWidth = sum(columnTracks.map((t) => t.baseSize)) +
        columnGap * (columnTracks.length - 1);
    final gridHeight =
        sum(rowTracks.map((t) => t.baseSize)) + rowGap * (rowTracks.length - 1);
    gridSizing.gridSize = constraints.constrain(Size(gridWidth, gridHeight));

    return gridSizing;
  }

  /// Determines where each grid item is positioned in the grid, using the
  /// auto-placement algorithm if necessary.
  void performItemPlacement() {
    if (_needsPlacement) {
      _needsPlacement = false;
      _placementGrid = computeItemPlacement(this);
    }
  }

  /// A rough approximation of
  /// https://drafts.csswg.org/css-grid/#algo-track-sizing. There are a bunch of
  /// steps left out because our model is simpler.
  List<GridTrack> performTrackSizing(
    TrackType typeBeingSized,
    GridSizingInfo gridSizing, {
    @visibleForTesting BoxConstraints constraints,
  }) {
    constraints ??= this.constraints;

    final sizingAxis = measurementAxisForTrackType(typeBeingSized);
    final intrinsicTracks = <GridTrack>[];
    final flexibleTracks = <GridTrack>[];
    final tracks = gridSizing.tracksForType(typeBeingSized);
    final maxConstraint = maxConstraintForAxis(constraints, sizingAxis);
    final initialFreeSpace = maxConstraint.isFinite
        ? maxConstraintForAxis(constraints, sizingAxis) -
            gridSizing.unitGapAlongAxis(sizingAxis) * (tracks.length - 1)
        : 0.0;
    final isAxisDefinite = isTightlyConstrainedForAxis(constraints, sizingAxis);

    // 1. Initialize track sizes

    for (var i = 0; i < tracks.length; i++) {
      final track = tracks[i];

      if (track.sizeFunction
          .isFixedForConstraints(typeBeingSized, constraints)) {
        // Fixed, definite
        final fixedSize = track.sizeFunction
            .minIntrinsicSize(typeBeingSized, [], initialFreeSpace);
        track.baseSize = track.growthLimit = fixedSize;
      } else if (track.sizeFunction.isFlexible) {
        // Flexible sizing
        track.baseSize = track.growthLimit = 0;
        flexibleTracks.add(track);
      } else {
        // Intrinsic sizing
        track.baseSize = 0;
        track.growthLimit = double.infinity;
        intrinsicTracks.add(track);
      }

      track.growthLimit = math.max(track.growthLimit, track.baseSize);
    }

    // 2. Resolve intrinsic track sizes

    _resolveIntrinsicTrackSizes(typeBeingSized, sizingAxis, tracks,
        intrinsicTracks, gridSizing, constraints, initialFreeSpace);

    // 3. Grow all tracks from their baseSize up to their growthLimit value
    //    until freeSpace is exhausted.

    var baseSizesWithoutMaximization = 0.0,
        growthLimitsWithoutMaximization = 0.0;
    for (final track in tracks) {
      assert(!track.isInfinite);
      baseSizesWithoutMaximization += track.baseSize;
      growthLimitsWithoutMaximization += track.growthLimit;
    }

    var freeSpace = initialFreeSpace - baseSizesWithoutMaximization;
    gridSizing.setFreeSpaceForAxis(freeSpace, sizingAxis);
    gridSizing.setMinMaxForAxis(baseSizesWithoutMaximization,
        growthLimitsWithoutMaximization, sizingAxis);

    // We're already overflowing
    if (isAxisDefinite && freeSpace < 0) {
      return tracks;
    }

    if (isAxisDefinite) {
      freeSpace =
          _distributeFreeSpace(freeSpace, tracks, [], _IntrinsicDimension.min);
    } else {
      for (final track in tracks) {
        freeSpace -= track.growthLimit - track.baseSize;
        track.baseSize = track.growthLimit;
      }
    }
    gridSizing.setFreeSpaceForAxis(freeSpace, sizingAxis);

    // 4. Size flexible tracks to fill remaining space, if any

    if (flexibleTracks.isEmpty) {
      return tracks;
    }

    // TODO(shyndman): This is not to spec. Flexible rows should have a minimum
    // size of their content's minimum contribution. We may add this as soon
    // as we have the notion of distinct minimum and maximum track size
    // functions, but requires some consideration because of the expense to
    // compute.
    // https://drafts.csswg.org/css-grid/#valdef-grid-template-columns-flex
    final flexFraction =
        _findFlexFactorUnitSize(tracks, flexibleTracks, initialFreeSpace);

    for (final track in flexibleTracks) {
      track.baseSize = flexFraction * track.sizeFunction.flex;

      freeSpace -= track.baseSize;
      baseSizesWithoutMaximization += track.baseSize;
      growthLimitsWithoutMaximization += track.baseSize;
    }

    gridSizing.setFreeSpaceForAxis(freeSpace, sizingAxis);
    gridSizing.setMinMaxForAxis(baseSizesWithoutMaximization,
        growthLimitsWithoutMaximization, sizingAxis);

    return tracks;
  }

  void _resolveIntrinsicTrackSizes(
    TrackType type,
    Axis sizingAxis,
    List<GridTrack> tracks,
    List<GridTrack> intrinsicTracks,
    GridSizingInfo gridSizing,
    BoxConstraints constraints,
    double freeSpace,
  ) {
    final itemsInIntrinsicTracks = intrinsicTracks
        .expand((t) => getChildrenInTrack(type, t.index))
        .where(removeDuplicates());

    final itemsBySpan = groupBy(itemsInIntrinsicTracks, (RenderObject item) {
      return _placementGrid.itemAreas[item].spanForAxis(sizingAxis);
    });
    final sortedSpans = itemsBySpan.keys.toList()..sort();

    // Iterate over the spans we find in our items list, in ascending order.
    for (var span in sortedSpans) {
      final spanItems = itemsBySpan[span];
      // TODO(shyndman): This is unnecessary work. We should be able to
      // construct what we need above.
      final spanItemsByTrack = groupBy<RenderBox, int>(
        spanItems,
        (item) => _placementGrid.itemAreas[item].startForAxis(sizingAxis),
      );

      // Size all spans containing at least one intrinsic track and zero
      // flexible tracks.
      for (final i in spanItemsByTrack.keys) {
        final spannedTracks = tracks.getRange(i, i + span);
        final spanItemsInTrack = spanItemsByTrack[i];
        final intrinsicTrack = spannedTracks
            .firstWhere((t) => t.sizeFunction.isIntrinsic, orElse: () => null);

        // We don't size flexible tracks until later
        if (intrinsicTrack == null ||
            spannedTracks.any((t) => t.sizeFunction.isFlexible)) {
          continue;
        }

        final crossAxis = flipAxis(sizingAxis);
        final crossAxisSizeForItem = gridSizing.isAxisSized(crossAxis)
            ? (RenderBox item) {
                return gridSizing.sizeForAreaOnAxis(
                    _placementGrid.itemAreas[item], crossAxis);
              }
            : (RenderBox _) => double.infinity;

        // Calculate the min-size of the spanned items, and distribute the
        // additional space to the spanned tracks' base sizes.
        final minSpanSize = intrinsicTrack.sizeFunction.minIntrinsicSize(
            type, spanItemsInTrack, freeSpace,
            crossAxisSizeForItem: crossAxisSizeForItem);
        _distributeCalculatedSpaceToSpannedTracks(
            minSpanSize, type, spannedTracks, _IntrinsicDimension.min);

        // Calculate the max-size of the spanned items, and distribute the
        // additional space to the spanned tracks' growth limits.
        final maxSpanSize = intrinsicTrack.sizeFunction.maxIntrinsicSize(
            type, spanItemsInTrack, freeSpace,
            crossAxisSizeForItem: crossAxisSizeForItem);
        _distributeCalculatedSpaceToSpannedTracks(
            maxSpanSize, type, spannedTracks, _IntrinsicDimension.max);
      }
    }

    // The time for infinite growth limits is over!
    for (final track in intrinsicTracks) {
      if (track.isInfinite) track.growthLimit = track.baseSize;
    }
  }

  /// Distributes free space among [spannedTracks]
  void _distributeCalculatedSpaceToSpannedTracks(
    double calculatedSpace,
    TrackType type,
    Iterable<GridTrack> spannedTracks,
    _IntrinsicDimension dimension,
  ) {
    // Subtract calculated dimensions of the tracks
    var freeSpace = calculatedSpace;
    for (final track in spannedTracks) {
      freeSpace -= dimension == _IntrinsicDimension.min
          ? track.baseSize
          : track.isInfinite ? track.baseSize : track.growthLimit;
    }

    // If there's no free space to distribute, freeze the tracks and we're done
    if (freeSpace <= 0) {
      for (final track in spannedTracks) {
        if (track.isInfinite) {
          track.growthLimit = track.baseSize;
        }
      }
      return;
    }

    // Filter to the intrinsicly sized tracks in the span
    final intrinsicTracks = spannedTracks
        .where((track) => track.sizeFunction.isIntrinsic)
        .toList(growable: false);

    // Now distribute the free space between them
    if (intrinsicTracks.isNotEmpty) {
      _distributeFreeSpace(
          freeSpace, intrinsicTracks, intrinsicTracks, dimension);
    }
  }

  double _distributeFreeSpace(
    double freeSpace,
    List<GridTrack> tracks,
    List<GridTrack> growableAboveMaxTracks,
    _IntrinsicDimension dimension,
  ) {
    assert(freeSpace >= 0);

    final distribute = (List<GridTrack> tracks,
        double Function(GridTrack, double) getShareForTrack) {
      final trackCount = tracks.length;
      for (var i = 0; i < trackCount; i++) {
        final track = tracks[i];
        final availableShare = freeSpace / (tracks.length - i);
        final shareForTrack = getShareForTrack(track, availableShare);
        assert(shareForTrack >= 0.0, 'Never shrink a track');

        track.sizeDuringDistribution += shareForTrack;
        freeSpace -= shareForTrack;
      }
    };

    // Setup a size that will be used for distribution calculations, and
    // assigned back to the sizes when we complete.
    for (final track in tracks) {
      track.sizeDuringDistribution = dimension == _IntrinsicDimension.min
          ? track.baseSize
          : track.isInfinite ? track.baseSize : track.growthLimit;
    }

    tracks.sort(_sortByGrowthPotential);

    // Distribute the free space between tracks
    distribute(tracks, (track, availableShare) {
      return track.isInfinite
          ? availableShare
          // Grow up until limit
          : math.min(
              availableShare,
              track.growthLimit - track.sizeDuringDistribution,
            );
    });

    // If we still have space leftover, let's unfreeze and grow some more
    // (ignoring limit)
    if (freeSpace > 0 && growableAboveMaxTracks != null) {
      distribute(
          growableAboveMaxTracks, (track, availableShare) => availableShare);
    }

    // Assign back the calculated sizes
    for (final track in tracks) {
      if (dimension == _IntrinsicDimension.min) {
        track.baseSize = math.max(track.baseSize, track.sizeDuringDistribution);
      } else {
        track.growthLimit = track.isInfinite
            ? track.sizeDuringDistribution
            : math.max(track.growthLimit, track.sizeDuringDistribution);
      }
    }

    return freeSpace;
  }

  double _findFlexFactorUnitSize(
    List<GridTrack> tracks,
    List<GridTrack> flexibleTracks,
    double freeSpace,
  ) {
    var flexSum = 0.0;
    for (final track in tracks) {
      if (!track.sizeFunction.isFlexible) {
        freeSpace -= track.baseSize;
      } else {
        flexSum += track.sizeFunction.flex;
      }
    }

    assert(flexSum > 0);
    // TODO(shyndman): This is not to spec. We need to consider track base sizes
    // (when measuring the content minimum) that are bigger than what the flex
    // would provide.
    return freeSpace / flexSum;
  }

  void _stretchIntrinsicTracks(TrackType type, GridSizingInfo gridSizing) {
    final sizingAxis = measurementAxisForTrackType(type);
    final freeSpace = gridSizing.freeSpaceForAxis(sizingAxis);
    if (freeSpace <= 0) return;

    final tracks = gridSizing.tracksForType(type);
    final intrinsicTracks = tracks.where((t) => t.sizeFunction.isIntrinsic);
    if (intrinsicTracks.isEmpty) return;

    final shareForTrack = freeSpace / intrinsicTracks.length;
    for (final track in intrinsicTracks) {
      track.baseSize += shareForTrack;
    }

    gridSizing.setFreeSpaceForAxis(0, sizingAxis);
  }

  void markNeedsPlacement() => _needsPlacement = true;

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }
}

double minConstraintForAxis(BoxConstraints constraints, Axis axis) {
  return axis == Axis.vertical ? constraints.minHeight : constraints.minWidth;
}

double maxConstraintForAxis(BoxConstraints constraints, Axis axis) {
  return axis == Axis.vertical ? constraints.maxHeight : constraints.maxWidth;
}

bool isTightlyConstrainedForAxis(BoxConstraints constraints, Axis axis) {
  return axis == Axis.vertical
      ? constraints.hasTightHeight
      : constraints.hasTightWidth;
}

enum _IntrinsicDimension { min, max }

class GridTrack {
  GridTrack(this.index, this.sizeFunction);

  final int index;
  final TrackSize sizeFunction;

  double _baseSize = 0;
  double _growthLimit = 0;

  double sizeDuringDistribution = 0;

  double get baseSize => _baseSize;
  set baseSize(double value) {
    _baseSize = value;
    _increaseGrowthLimitIfNecessary();
  }

  double get growthLimit => _growthLimit;
  set growthLimit(double value) {
    _growthLimit = value;
    _increaseGrowthLimitIfNecessary();
  }

  bool get isInfinite => _growthLimit == double.infinity;

  void _increaseGrowthLimitIfNecessary() {
    if (_growthLimit != double.infinity && _growthLimit < _baseSize) {
      _growthLimit = _baseSize;
    }
  }

  @override
  String toString() {
    return 'GridTrack(baseSize=$baseSize, growthLimit=$growthLimit, sizeFunction=$sizeFunction)';
  }
}

List<GridTrack> _sizesToTracks(Iterable<TrackSize> sizes) => enumerate(sizes)
    .map((s) => GridTrack(s.index, s.value))
    .toList(growable: false);

class GridSizingInfo {
  GridSizingInfo({
    @required this.columnTracks,
    @required this.rowTracks,
    @required this.columnGap,
    @required this.rowGap,
    @required this.textDirection,
  })  : assert(columnTracks != null),
        assert(rowTracks != null),
        assert(columnGap != null),
        assert(rowGap != null),
        assert(textDirection != null);

  GridSizingInfo.fromTrackSizeFunctions({
    @required List<TrackSize> columnSizeFunctions,
    @required List<TrackSize> rowSizeFunctions,
    @required TextDirection textDirection,
    double columnGap = 0,
    double rowGap = 0,
  }) : this(
          columnTracks: _sizesToTracks(columnSizeFunctions),
          rowTracks: _sizesToTracks(rowSizeFunctions),
          textDirection: textDirection,
          columnGap: columnGap,
          rowGap: rowGap,
        );

  Size gridSize;
  final double columnGap;
  final double rowGap;

  final List<GridTrack> columnTracks;
  final List<GridTrack> rowTracks;

  final TextDirection textDirection;

  List<double> _ltrColumnStarts;
  List<double> get columnStartsWithoutGaps {
    _ltrColumnStarts ??= cumulativeSum(
      columnTracks.map((t) => t.baseSize),
      includeLast: false,
    ).toList(growable: false);
    return _ltrColumnStarts;
  }

  List<double> _rowStarts;
  List<double> get rowStartsWithoutGaps {
    _rowStarts ??= cumulativeSum(
      rowTracks.map((t) => t.baseSize),
      includeLast: false,
    ).toList(growable: false);
    return _rowStarts;
  }

  double minWidth = 0.0;
  double minHeight = 0.0;

  double maxWidth = 0.0;
  double maxHeight = 0.0;

  double columnFreeSpace = 0.0;
  double rowFreeSpace = 0.0;

  bool hasColumnSizing = false;
  bool hasRowSizing = false;

  Offset offsetForArea(GridArea area) {
    return Offset(
        textDirection == TextDirection.ltr
            ? columnStartsWithoutGaps[area.columnStart] +
                columnGap * area.columnStart
            : gridSize.width -
                columnStartsWithoutGaps[area.columnStart] -
                sizeForAreaOnAxis(area, Axis.horizontal) -
                columnGap * area.columnStart,
        rowStartsWithoutGaps[area.rowStart] + rowGap * area.rowStart);
  }

  Size sizeForArea(GridArea area) {
    return Size(
      sizeForAreaOnAxis(area, Axis.horizontal),
      sizeForAreaOnAxis(area, Axis.vertical),
    );
  }

  void markTrackTypeSized(TrackType type) {
    if (type == TrackType.column) {
      hasColumnSizing = true;
    } else {
      hasRowSizing = true;
    }
  }

  double freeSpaceForAxis(Axis sizingAxis) =>
      sizingAxis == Axis.horizontal ? columnFreeSpace : rowFreeSpace;

  double setFreeSpaceForAxis(double freeSpace, Axis sizingAxis) {
    if (sizingAxis == Axis.horizontal) {
      columnFreeSpace = freeSpace;
    } else {
      rowFreeSpace = freeSpace;
    }
    return freeSpace;
  }

  void setMinMaxForAxis(double min, double max, Axis sizingAxis) {
    if (sizingAxis == Axis.horizontal) {
      minWidth = min;
      maxWidth = max;
    } else {
      minHeight = min;
      maxHeight = max;
    }
  }

  double unitGapAlongAxis(Axis axis) =>
      axis == Axis.horizontal ? columnGap : rowGap;

  bool isAxisSized(Axis sizingAxis) =>
      sizingAxis == Axis.horizontal ? hasColumnSizing : hasRowSizing;

  List<GridTrack> tracksForType(TrackType type) =>
      type == TrackType.column ? columnTracks : rowTracks;

  List<GridTrack> tracksAlongAxis(Axis sizingAxis) =>
      sizingAxis == Axis.horizontal ? columnTracks : rowTracks;

  double sizeForAreaOnAxis(GridArea area, Axis axis) {
    assert(isAxisSized(axis));

    // TODO(shyndman): Support row/col gaps

    final trackBaseSizes = tracksAlongAxis(axis)
        .getRange(area.startForAxis(axis), area.endForAxis(axis))
        .map((t) => t.baseSize);
    final gapSize = (area.spanForAxis(axis) - 1) * unitGapAlongAxis(axis);
    return math.max(0, sum(trackBaseSizes) + gapSize);
  }
}

int _sortByGrowthPotential(GridTrack a, GridTrack b) {
  if (a.isInfinite != b.isInfinite) return a.isInfinite ? -1 : 1;
  return (a.growthLimit - a.baseSize).compareTo(b.growthLimit - b.baseSize);
}
