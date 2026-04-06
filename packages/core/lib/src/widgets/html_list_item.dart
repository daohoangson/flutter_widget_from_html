import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

const _kGapVsMarker = 5.0;

/// A list item widget.
class HtmlListItem extends MultiChildRenderObjectWidget {
  /// The alignment of the item contents.
  final TextAlign? textAlign;

  /// The directionality of the item.
  final TextDirection textDirection;

  /// Creates a list item widget.
  HtmlListItem({
    Widget? child,
    super.key,
    Widget? marker,
    this.textAlign,
    required this.textDirection,
  }) : super(
          children: child != null
              ? [
                  child,
                  if (marker != null) marker,
                ]
              : const [],
        );

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _ListItemRenderObject(
        textAlign: textAlign,
        textDirection: textDirection,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty('textAlign', textAlign, defaultValue: null));
    properties.add(DiagnosticsProperty('textDirection', textDirection));
  }

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    renderObject as _ListItemRenderObject
      ..textAlign = textAlign
      ..textDirection = textDirection;
  }
}

class _ListItemData extends ContainerBoxParentData<RenderBox> {}

class _ListItemRenderObject extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _ListItemData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _ListItemData> {
  _ListItemRenderObject({
    TextAlign? textAlign,
    required TextDirection textDirection,
  })  : _textAlign = textAlign,
        _textDirection = textDirection;

  TextAlign? get textAlign => _textAlign;
  TextAlign? _textAlign;
  set textAlign(TextAlign? value) {
    if (_textAlign == value) {
      return;
    }

    _textAlign = value;
    markNeedsLayout();
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value) {
      return;
    }

    _textDirection = value;
    markNeedsLayout();
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) =>
      defaultComputeDistanceToFirstActualBaseline(baseline);

  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      _compute(firstChild, constraints, ChildLayoutHelper.dryLayoutChild);

  @override
  double computeMaxIntrinsicHeight(double width) =>
      firstChild?.computeMaxIntrinsicHeight(width) ??
      super.computeMaxIntrinsicHeight(width);

  @override
  double computeMaxIntrinsicWidth(double height) =>
      firstChild?.computeMaxIntrinsicWidth(height) ??
      super.computeMaxIntrinsicWidth(height);

  @override
  double computeMinIntrinsicHeight(double width) =>
      firstChild?.computeMinIntrinsicHeight(width) ??
      super.computeMinIntrinsicHeight(width);

  @override
  double computeMinIntrinsicWidth(double height) =>
      firstChild?.getMinIntrinsicWidth(height) ??
      super.computeMinIntrinsicWidth(height);

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);

  @override
  void paint(PaintingContext context, Offset offset) =>
      defaultPaint(context, offset);

  @override
  void performLayout() =>
      size = _compute(firstChild, constraints, ChildLayoutHelper.layoutChild);

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _ListItemData) {
      child.parentData = _ListItemData();
    }
  }

  Size _compute(RenderBox? child, BoxConstraints bc, ChildLayouter fn) {
    if (child == null) {
      return bc.smallest;
    }

    final childData = child.parentData! as _ListItemData;
    final childConstraints = bc.maxWidth.isFinite && textAlign != null
        ? bc.tighten(width: bc.maxWidth)
        : bc;
    final childSize = fn(child, childConstraints);
    final marker = childData.nextSibling;
    final markerSize = marker != null ? fn(marker, bc.loosen()) : Size.zero;
    final height = childSize.height > 0 ? childSize.height : markerSize.height;
    final size = bc.constrain(Size(childSize.width, height));

    if (identical(fn, ChildLayoutHelper.layoutChild)) {
      childData.offset = Offset.zero;

      if (marker != null) {
        const baseline = TextBaseline.alphabetic;
        final markerDistance =
            marker.getDistanceToBaseline(baseline, onlyReal: true) ??
                markerSize.height;
        final childDistance =
            child.getDistanceToBaseline(baseline, onlyReal: true) ??
                markerDistance;

        final markerData = marker.parentData! as _ListItemData;
        markerData.offset = Offset(
          textDirection == TextDirection.ltr
              ? -markerSize.width - _kGapVsMarker
              : childSize.width + _kGapVsMarker,
          childDistance - markerDistance,
        );
      }
    }

    return size;
  }
}
