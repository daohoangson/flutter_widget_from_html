part of '../table_layout.dart';

class _RenderingPlacementData extends ContainerBoxParentData<RenderBox> {
  int columnStart;
  int columnSpan = 1;
  int rowStart;
  int rowSpan = 1;

  _PlacementArea get area => columnStart != null && rowStart != null
      ? _PlacementArea(
          columnStart: columnStart,
          columnEnd: columnStart + columnSpan,
          rowStart: rowStart,
          rowEnd: rowStart + rowSpan,
        )
      : null;
}

class _TableRenderBox extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _RenderingPlacementData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _RenderingPlacementData> {
  _TableRenderBox({
    List<RenderBox> children,
    double gap = 0,
    List<_TrackSize> templateColumnSizes,
    List<_TrackSize> templateRowSizes,
    TextDirection textDirection = TextDirection.ltr,
  })  : _gap = gap,
        _templateColumnSizes = templateColumnSizes,
        _templateRowSizes = templateRowSizes,
        _textDirection = textDirection {
    addAll(children);
  }

  bool _needsPlacement = true;
  _PlacementGrid _placementGrid;

  double get gap => _gap;
  double _gap;
  set gap(double value) {
    if (_gap == value) return;
    _gap = value;
    markNeedsLayout();
  }

  List<_TrackSize> get templateColumnSizes => _templateColumnSizes;
  List<_TrackSize> _templateColumnSizes;
  set templateColumnSizes(List<_TrackSize> value) {
    if (_templateColumnSizes == value) return;
    _templateColumnSizes = value;
    markNeedsPlacement();
    markNeedsLayout();
  }

  List<_TrackSize> get templateRowSizes => _templateRowSizes;
  List<_TrackSize> _templateRowSizes;
  set templateRowSizes(List<_TrackSize> value) {
    if (_templateRowSizes == value) return;
    _templateRowSizes = value;
    markNeedsPlacement();
    markNeedsLayout();
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value) return;
    _textDirection = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _RenderingPlacementData) {
      child.parentData = _RenderingPlacementData();
    }
  }

  @override
  double computeMinIntrinsicWidth(double height) =>
      _computeRenderingSize(BoxConstraints.tightFor(height: height)).minWidth;

  @override
  double computeMaxIntrinsicWidth(double height) =>
      _computeRenderingSize(BoxConstraints(minHeight: height)).maxWidth;

  @override
  double computeMinIntrinsicHeight(double width) =>
      _computeRenderingSize(BoxConstraints.tightFor(width: width)).minHeight;

  @override
  double computeMaxIntrinsicHeight(double width) =>
      _computeRenderingSize(BoxConstraints(minWidth: width)).maxHeight;

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) =>
      defaultComputeDistanceToHighestActualBaseline(baseline);

  List<RenderBox> getChildrenInTrack(_TrackType trackType, int trackIndex) =>
      _placementGrid
          .getCellsInTrack(trackIndex, trackType)
          .expand((cell) => cell.occupants)
          .where(_removeDuplicates())
          .toList(growable: false);

  @override
  void performLayout() {
    final renderingSize = _computeRenderingSize(constraints);
    size = renderingSize.size;

    var child = firstChild;
    while (child != null) {
      final placement = child.parentData as _RenderingPlacementData;
      final area = _placementGrid.itemAreas[child];
      placement.offset = renderingSize.offsetForArea(area);
      child.layout(BoxConstraints.loose(renderingSize.sizeForArea(area)));

      child = placement.nextSibling;
    }
  }

  _RenderingSize _computeRenderingSize(BoxConstraints constraints) {
    performItemPlacement();

    final renderingSize = _RenderingSize.fromTrackSizes(
      columnSizeFunctions: _templateColumnSizes,
      gap: gap,
      rowSizeFunctions: _templateRowSizes,
      textDirection: textDirection,
    );

    final columnTracks = performTrackSizing(_TrackType.column, renderingSize,
        constraints: constraints);
    renderingSize.hasColumnSizing = true;

    final rowTracks = performTrackSizing(_TrackType.row, renderingSize,
        constraints: constraints);
    renderingSize.hasRowSizing = true;

    _stretchIntrinsicTracks(_TrackType.column, renderingSize);
    _stretchIntrinsicTracks(_TrackType.row, renderingSize);

    final gridWidth = _sum(columnTracks.map((t) => t.baseSize)) +
        gap * (columnTracks.length - 1);
    final gridHeight =
        _sum(rowTracks.map((t) => t.baseSize)) + gap * (rowTracks.length - 1);
    renderingSize.size = constraints.constrain(Size(gridWidth, gridHeight));

    return renderingSize;
  }

  void performItemPlacement() {
    if (_needsPlacement) {
      _needsPlacement = false;
      _placementGrid = computeItemPlacement(this);
    }
  }

  List<_RenderingTrack> performTrackSizing(
    _TrackType typeBeingSized,
    _RenderingSize renderingSize, {
    BoxConstraints constraints,
  }) {
    constraints ??= this.constraints;

    final sizingAxis = _measurementAxisForTrackType(typeBeingSized);
    final intrinsicTracks = <_RenderingTrack>[];
    final flexibleTracks = <_RenderingTrack>[];
    final tracks = renderingSize.tracksForType(typeBeingSized);
    final maxConstraint = maxConstraintForAxis(constraints, sizingAxis);
    final initialFreeSpace = maxConstraint.isFinite
        ? maxConstraintForAxis(constraints, sizingAxis) -
            renderingSize.gap * (tracks.length - 1)
        : 0.0;
    final isAxisDefinite = sizingAxis == Axis.vertical
        ? constraints.hasTightHeight
        : constraints.hasTightWidth;

    // 1. Initialize track sizes
    for (var i = 0; i < tracks.length; i++) {
      final track = tracks[i];

      if (track.sizeFunction.isFlexible) {
        track.baseSize = track.growthLimit = 0;
        flexibleTracks.add(track);
      } else {
        track.baseSize = 0;
        track.growthLimit = double.infinity;
        intrinsicTracks.add(track);
      }

      track.growthLimit = math.max(track.growthLimit, track.baseSize);
    }

    // 2. Resolve intrinsic track sizes
    _resolveIntrinsicTrackSizes(typeBeingSized, sizingAxis, tracks,
        intrinsicTracks, renderingSize, constraints, initialFreeSpace);

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
    renderingSize.setFreeSpaceForAxis(freeSpace, sizingAxis);
    renderingSize.setMinMaxForAxis(baseSizesWithoutMaximization,
        growthLimitsWithoutMaximization, sizingAxis);
    if (isAxisDefinite && freeSpace < 0) return tracks;

    if (isAxisDefinite) {
      freeSpace =
          _distributeFreeSpace(freeSpace, tracks, [], _IntrinsicDimension.min);
    } else {
      for (final track in tracks) {
        freeSpace -= track.growthLimit - track.baseSize;
        track.baseSize = track.growthLimit;
      }
    }
    renderingSize.setFreeSpaceForAxis(freeSpace, sizingAxis);

    // 4. Size flexible tracks to fill remaining space, if any
    if (flexibleTracks.isEmpty) return tracks;
    final flexFraction =
        _findFlexFactorUnitSize(tracks, flexibleTracks, initialFreeSpace);
    for (final track in flexibleTracks) {
      track.baseSize = flexFraction * track.sizeFunction.flex;

      freeSpace -= track.baseSize;
      baseSizesWithoutMaximization += track.baseSize;
      growthLimitsWithoutMaximization += track.baseSize;
    }

    renderingSize.setFreeSpaceForAxis(freeSpace, sizingAxis);
    renderingSize.setMinMaxForAxis(baseSizesWithoutMaximization,
        growthLimitsWithoutMaximization, sizingAxis);

    return tracks;
  }

  void _resolveIntrinsicTrackSizes(
    _TrackType type,
    Axis sizingAxis,
    List<_RenderingTrack> tracks,
    List<_RenderingTrack> intrinsicTracks,
    _RenderingSize renderingSize,
    BoxConstraints constraints,
    double freeSpace,
  ) {
    final itemsInIntrinsicTracks = intrinsicTracks
        .expand((t) => getChildrenInTrack(type, t.index))
        .where(_removeDuplicates());

    final itemsBySpan = groupBy(itemsInIntrinsicTracks,
        (item) => _placementGrid.itemAreas[item].spanForAxis(sizingAxis));
    final sortedSpans = itemsBySpan.keys.toList()..sort();
    for (var span in sortedSpans) {
      final spanItems = itemsBySpan[span];
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
        final crossAxisSizeForItem = renderingSize.isAxisSized(crossAxis)
            ? (RenderBox item) {
                return renderingSize.sizeForAreaOnAxis(
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
    _TrackType type,
    Iterable<_RenderingTrack> spannedTracks,
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
    List<_RenderingTrack> tracks,
    List<_RenderingTrack> growableAboveMaxTracks,
    _IntrinsicDimension dimension,
  ) {
    assert(freeSpace >= 0);

    final distribute = (List<_RenderingTrack> tracks,
        double Function(_RenderingTrack, double) getShareForTrack) {
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

    tracks.sort(sortByGrowthPotential);

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
    List<_RenderingTrack> tracks,
    List<_RenderingTrack> flexibleTracks,
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
    return freeSpace / flexSum;
  }

  void _stretchIntrinsicTracks(_TrackType type, _RenderingSize renderingSize) {
    final sizingAxis = _measurementAxisForTrackType(type);
    final freeSpace = renderingSize.freeSpaceForAxis(sizingAxis);
    if (freeSpace <= 0) return;

    final tracks = renderingSize.tracksForType(type);
    final intrinsicTracks = tracks.where((t) => t.sizeFunction.isIntrinsic);
    if (intrinsicTracks.isEmpty) return;

    final shareForTrack = freeSpace / intrinsicTracks.length;
    for (final track in intrinsicTracks) {
      track.baseSize += shareForTrack;
    }

    renderingSize.setFreeSpaceForAxis(0, sizingAxis);
  }

  void markNeedsPlacement() => _needsPlacement = true;

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) =>
      defaultHitTestChildren(result, position: position);

  @override
  void paint(PaintingContext context, Offset offset) =>
      defaultPaint(context, offset);

  static double maxConstraintForAxis(BoxConstraints constraints, Axis axis) =>
      axis == Axis.vertical ? constraints.maxHeight : constraints.maxWidth;

  static int sortByGrowthPotential(_RenderingTrack a, _RenderingTrack b) {
    if (a.isInfinite != b.isInfinite) return a.isInfinite ? -1 : 1;
    return (a.growthLimit - a.baseSize).compareTo(b.growthLimit - b.baseSize);
  }
}

enum _IntrinsicDimension { min, max }

class _RenderingTrack {
  _RenderingTrack(this.index, this.sizeFunction);

  final int index;
  final _TrackSize sizeFunction;

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

class _RenderingSize {
  _RenderingSize({
    @required this.columnTracks,
    @required this.gap,
    @required this.rowTracks,
    @required this.textDirection,
  });

  _RenderingSize.fromTrackSizes({
    @required List<_TrackSize> columnSizeFunctions,
    double gap = 0,
    @required List<_TrackSize> rowSizeFunctions,
    @required TextDirection textDirection,
  }) : this(
          columnTracks: sizesToTracks(columnSizeFunctions),
          gap: gap,
          rowTracks: sizesToTracks(rowSizeFunctions),
          textDirection: textDirection,
        );

  final List<_RenderingTrack> columnTracks;
  final double gap;
  final List<_RenderingTrack> rowTracks;
  final TextDirection textDirection;

  List<double> _columnStarts;
  List<double> get columnStartsWithoutGaps {
    _columnStarts ??= _cumulativeSum(
      columnTracks.map((t) => t.baseSize),
      includeLast: false,
    ).toList(growable: false);
    return _columnStarts;
  }

  List<double> _rowStarts;
  List<double> get rowStartsWithoutGaps {
    _rowStarts ??= _cumulativeSum(
      rowTracks.map((t) => t.baseSize),
      includeLast: false,
    ).toList(growable: false);
    return _rowStarts;
  }

  Size size;
  double minWidth = 0.0;
  double minHeight = 0.0;
  double maxWidth = 0.0;
  double maxHeight = 0.0;

  double columnFreeSpace = 0.0;
  double rowFreeSpace = 0.0;

  bool hasColumnSizing = false;
  bool hasRowSizing = false;

  Offset offsetForArea(_PlacementArea area) {
    return Offset(
        textDirection == TextDirection.ltr
            ? columnStartsWithoutGaps[area.columnStart] + gap * area.columnStart
            : size.width -
                columnStartsWithoutGaps[area.columnStart] -
                sizeForAreaOnAxis(area, Axis.horizontal) -
                gap * area.columnStart,
        rowStartsWithoutGaps[area.rowStart] + gap * area.rowStart);
  }

  Size sizeForArea(_PlacementArea area) {
    return Size(
      sizeForAreaOnAxis(area, Axis.horizontal),
      sizeForAreaOnAxis(area, Axis.vertical),
    );
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

  bool isAxisSized(Axis sizingAxis) =>
      sizingAxis == Axis.horizontal ? hasColumnSizing : hasRowSizing;

  List<_RenderingTrack> tracksForType(_TrackType type) =>
      type == _TrackType.column ? columnTracks : rowTracks;

  List<_RenderingTrack> tracksAlongAxis(Axis sizingAxis) =>
      sizingAxis == Axis.horizontal ? columnTracks : rowTracks;

  double sizeForAreaOnAxis(_PlacementArea area, Axis axis) {
    assert(isAxisSized(axis));

    final trackBaseSizes = tracksAlongAxis(axis)
        .getRange(area.startForAxis(axis), area.endForAxis(axis))
        .map((t) => t.baseSize);
    final gapSize = (area.spanForAxis(axis) - 1) * gap;
    return math.max(0, _sum(trackBaseSizes) + gapSize);
  }

  static List<_RenderingTrack> sizesToTracks(Iterable<_TrackSize> sizes) =>
      enumerate(sizes)
          .map((s) => _RenderingTrack(s.index, s.value))
          .toList(growable: false);
}
