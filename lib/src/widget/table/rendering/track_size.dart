part of '../../table_layout.dart';

enum TrackType { column, row }

Axis mainAxisForTrackType(TrackType type) =>
    type == TrackType.column ? Axis.vertical : Axis.horizontal;

Axis measurementAxisForTrackType(TrackType type) {
  return type == TrackType.column ? Axis.horizontal : Axis.vertical;
}

abstract class TrackSize {
  const TrackSize();

  double get flex => null;
  bool get isIntrinsic => false;
  bool get isFlexible => false;

  double minIntrinsicSize(
    TrackType type,
    Iterable<RenderBox> items,
    double measurementAxisMaxSize, {
    double Function(RenderBox) crossAxisSizeForItem,
  });

  double maxIntrinsicSize(
    TrackType type,
    Iterable<RenderBox> items,
    double measurementAxisMaxSize, {
    double Function(RenderBox) crossAxisSizeForItem,
  });

  @protected
  double _itemMinIntrinsicSizeOnAxis(
      RenderBox item, Axis axis, double crossAxisSize) {
    return axis == Axis.horizontal
        ? item.getMinIntrinsicWidth(crossAxisSize)
        : item.getMinIntrinsicHeight(crossAxisSize);
  }

  @protected
  double _itemMaxIntrinsicSizeOnAxis(
      RenderBox item, Axis axis, double crossAxisSize) {
    return axis == Axis.horizontal
        ? item.getMaxIntrinsicWidth(crossAxisSize)
        : item.getMaxIntrinsicHeight(crossAxisSize);
  }
}

class FlexibleTrackSize extends TrackSize {
  final double _flex;

  const FlexibleTrackSize(this._flex) : assert(_flex != null && _flex > 0);

  @override
  double get flex => _flex;

  @override
  bool get isFlexible => true;

  @override
  double minIntrinsicSize(
    TrackType type,
    Iterable<RenderBox> items,
    double measurementAxisMaxSize, {
    double Function(RenderBox) crossAxisSizeForItem,
  }) =>
      0;

  @override
  double maxIntrinsicSize(
    TrackType type,
    Iterable<RenderBox> items,
    double measurementAxisMaxSize, {
    double Function(RenderBox) crossAxisSizeForItem,
  }) =>
      0;
}

class IntrinsicContentTrackSize extends TrackSize {
  const IntrinsicContentTrackSize();

  @override
  bool get isIntrinsic => true;

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
    return max(minContentContributions);
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
