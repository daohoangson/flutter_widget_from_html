part of '../table_layout.dart';

enum _TrackType { column, row }

Axis _measurementAxisForTrackType(_TrackType type) =>
    type == _TrackType.column ? Axis.horizontal : Axis.vertical;

abstract class _TrackSize {
  const _TrackSize();

  double get flex => null;
  bool get isIntrinsic => false;
  bool get isFlexible => false;

  double minIntrinsicSize(
    _TrackType type,
    Iterable<RenderBox> items,
    double measurementAxisMaxSize, {
    double Function(RenderBox) crossAxisSizeForItem,
  });

  double maxIntrinsicSize(
    _TrackType type,
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

class _TrackSizeFlexible extends _TrackSize {
  final double _flex;

  const _TrackSizeFlexible(this._flex) : assert(_flex != null && _flex > 0);

  @override
  double get flex => _flex;

  @override
  bool get isFlexible => true;

  @override
  double minIntrinsicSize(
    _TrackType type,
    Iterable<RenderBox> items,
    double measurementAxisMaxSize, {
    double Function(RenderBox) crossAxisSizeForItem,
  }) =>
      0;

  @override
  double maxIntrinsicSize(
    _TrackType type,
    Iterable<RenderBox> items,
    double measurementAxisMaxSize, {
    double Function(RenderBox) crossAxisSizeForItem,
  }) =>
      0;
}

class _TrackSizeIntrinsic extends _TrackSize {
  const _TrackSizeIntrinsic();

  @override
  bool get isIntrinsic => true;

  @override
  double minIntrinsicSize(
    _TrackType type,
    Iterable<RenderBox> items,
    double measurementAxisMaxSize, {
    double Function(RenderBox) crossAxisSizeForItem,
  }) {
    crossAxisSizeForItem ??= (_) => double.infinity;
    final minContentContributions = items.map(
      (item) => _itemMinIntrinsicSizeOnAxis(
        item,
        _measurementAxisForTrackType(type),
        crossAxisSizeForItem(item),
      ),
    );
    return max(minContentContributions);
  }

  @override
  double maxIntrinsicSize(
    _TrackType type,
    Iterable<RenderBox> items,
    double measurementAxisMaxSize, {
    double Function(RenderBox) crossAxisSizeForItem,
  }) {
    crossAxisSizeForItem ??= (_) => double.infinity;
    final maxContentContributions = items.map(
      (item) => _itemMaxIntrinsicSizeOnAxis(
        item,
        _measurementAxisForTrackType(type),
        crossAxisSizeForItem(item),
      ),
    );
    return max(maxContentContributions);
  }
}
