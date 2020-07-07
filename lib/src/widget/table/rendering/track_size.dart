part of '../../table_layout.dart';

/// Passed to [TrackSize] functions to indicate the type of track whose
/// cross-axis is being measured.
enum TrackType {
  column,
  row,
}

/// Returns the direction of cell layout for the provided [type].
Axis mainAxisForTrackType(TrackType type) =>
    type == TrackType.column ? Axis.vertical : Axis.horizontal;

/// Returns the axis measured by a [TrackSize] associated with a particular
/// [TrackType].
Axis measurementAxisForTrackType(TrackType type) {
  return type == TrackType.column ? Axis.horizontal : Axis.vertical;
}

/// Base class to describe the width (for columns) or height (for rows) of a
/// track in a [RenderLayoutGrid].
///
/// To size a track to a specific number of pixels, use a [FixedTrackSize]. This
/// is the cheapest way to size a track.
///
/// Another algorithm that is relatively cheap include [FlexibleTrackSize],
/// which distributes the space equally among the flexible tracks.
abstract class TrackSize {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const TrackSize();

  /// Returns whether this size can resolve to a fixed value provided the
  /// grid's box constraints.
  bool isFixedForConstraints(TrackType type, BoxConstraints gridConstraints) {
    return false;
  }

  /// Returns whether this sizing function requires measurement of a track's
  /// items to resolve its size.
  bool get isIntrinsic {
    return false;
  }

  /// Returns whether this sizing function consumes space left over from the
  /// initial sizing of the grid.
  bool get isFlexible {
    return false;
  }

  /// The smallest width (for columns) or height (for rows) that a track can
  /// have.
  ///
  /// The [type] argument indicates whether this track represents a row or
  /// a column.
  ///
  /// The [items] argument is an iterable that provides all the items in the
  /// grid for this track. Walking the items is by definition O(N), so
  /// algorithms that do that should be considered expensive.
  ///
  /// The [measurementAxisMaxSize] argument is the `maxWidth` or `maxHeight` of
  /// the incoming constraints for grid, and might be infinite.
  ///
  /// The [crossAxisSizeForItem] will be provided to assist in calculations if
  /// the cross axis sizing is known.
  double minIntrinsicSize(
    TrackType type,
    Iterable<RenderBox> items,
    double measurementAxisMaxSize, {
    double Function(RenderBox) crossAxisSizeForItem,
  });

  /// The ideal cross axis size of this track. This must be equal to or greater
  /// than the [minIntrinsicSize] for the same [type]. The track might be bigger
  /// than this size, e.g. if the track is flexible or if the grid's size ends
  /// up being forced to be bigger than the sum of all the maxIntrinsicSize
  /// values.
  ///
  /// The [type] argument indicates whether this track represents a row or a
  /// column. If vertical, this function returns a width. If horizontal, a
  /// height.
  ///
  /// The [items] argument is an iterable that provides all the items in the
  /// grid for this track. Walking the items is by definition O(N), so
  /// algorithms that do that should be considered expensive.
  ///
  /// The [measurementAxisMaxSize] argument is the `maxWidth` (for column
  /// tracks) or `maxHeight` (for row tracks) of the incoming constraints for
  /// the grid, and might be infinite.
  ///
  /// The [crossAxisSizeForItem] will be provided to assist in calculations if
  /// the cross axis sizing is known.
  double maxIntrinsicSize(
    TrackType type,
    Iterable<RenderBox> items,
    double measurementAxisMaxSize, {
    double Function(RenderBox) crossAxisSizeForItem,
  });

  /// The flex factor to apply to the track if there is any room left over when
  /// laying out the grid. The remaining space is distributed to any tracks
  /// with flex in proportion to their flex value (higher values get more
  /// space).
  double get flex => null;

  /// Helper function for determining the minimum intrinsic size of an item
  /// along the vertical or horizontal axis.
  @protected
  double _itemMinIntrinsicSizeOnAxis(
      RenderBox item, Axis axis, double crossAxisSize) {
    return axis == Axis.horizontal
        ? item.getMinIntrinsicWidth(crossAxisSize)
        : item.getMinIntrinsicHeight(crossAxisSize);
  }

  /// Helper function for determining the maximum intrinsic size of an item
  /// along the vertical or horizontal axis.
  @protected
  double _itemMaxIntrinsicSizeOnAxis(
      RenderBox item, Axis axis, double crossAxisSize) {
    return axis == Axis.horizontal
        ? item.getMaxIntrinsicWidth(crossAxisSize)
        : item.getMaxIntrinsicHeight(crossAxisSize);
  }

  @override
  String toString() => '$runtimeType';
}

/// Sizes the track by taking a part of the remaining space once all the other
/// tracks have been laid out on the same axis.
///
/// For example, if two columns have a [FlexibleTrackSize] with the same
/// [flexFactor], then half the space will go to one and half the space will go
/// to the other.
///
/// This is a cheap way to size a track.
class FlexibleTrackSize extends TrackSize {
  /// Creates a track size based on a fraction of the grid's leftover space.
  ///
  /// The [flexFactor] argument must not be null.
  const FlexibleTrackSize(this.flexFactor)
      : assert(flexFactor != null && flexFactor > 0);

  /// The flex factor to use for this track
  ///
  /// The amount of space the track can occupy on the track's cross axis is
  /// determined by dividing the free space (after placing the inflexible
  /// children) according to the flex factors of the flexible children.
  final double flexFactor;

  @override
  bool get isFlexible {
    return true;
  }

  @override
  double minIntrinsicSize(
    TrackType type,
    Iterable<RenderBox> items,
    double measurementAxisMaxSize, {
    double Function(RenderBox) crossAxisSizeForItem,
  }) {
    return 0;
  }

  @override
  double maxIntrinsicSize(
    TrackType type,
    Iterable<RenderBox> items,
    double measurementAxisMaxSize, {
    double Function(RenderBox) crossAxisSizeForItem,
  }) {
    return 0;
  }

  @override
  double get flex => flexFactor;

  @override
  String toString() => '$runtimeType(flexFactor=$flexFactor)';
}

/// Sizes the track according to the intrinsic dimensions of all its cells.
///
/// This is a very expensive way to size a column.
class IntrinsicContentTrackSize extends TrackSize {
  const IntrinsicContentTrackSize();

  @override
  bool get isIntrinsic {
    return true;
  }

  @override
  double minIntrinsicSize(
    TrackType type,
    Iterable<RenderBox> items,
    double measurementAxisMaxSize, {
    double Function(RenderBox) crossAxisSizeForItem,
  }) {
    crossAxisSizeForItem ??= (_) => double.infinity;
    final minContentContributions = items.map(
      (item) => _itemMinIntrinsicSizeOnAxis(
        item,
        measurementAxisForTrackType(type),
        crossAxisSizeForItem(item),
      ),
    );
    return max(
      minContentContributions,
    );
  }

  @override
  double maxIntrinsicSize(
    TrackType type,
    Iterable<RenderBox> items,
    double measurementAxisMaxSize, {
    double Function(RenderBox) crossAxisSizeForItem,
  }) {
    crossAxisSizeForItem ??= (_) => double.infinity;
    final maxContentContributions = items.map(
      (item) => _itemMaxIntrinsicSizeOnAxis(
        item,
        measurementAxisForTrackType(type),
        crossAxisSizeForItem(item),
      ),
    );
    return max(maxContentContributions);
  }
}
