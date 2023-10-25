import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class HorizontalMargin extends SingleChildRenderObjectWidget {
  final double left;
  final double right;

  const HorizontalMargin({
    super.child,
    super.key,
    required this.left,
    required this.right,
  })  : assert(left >= .0),
        assert(right >= .0);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _HorizontalMarginRenderObject(left, right);
  }

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    (renderObject as _HorizontalMarginRenderObject)
      ..setLeft(left)
      ..setRight(right);
  }
}

class _HorizontalMarginRenderObject extends RenderProxyBox {
  _HorizontalMarginRenderObject(this._left, this._right);

  double _left;
  void setLeft(double value) {
    if (_left != value) {
      _left = value;
      markNeedsLayout();
    }
  }

  double _right;
  void setRight(double value) {
    if (_right != value) {
      _right = value;
      markNeedsLayout();
    }
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      _compute(child, constraints, ChildLayoutHelper.dryLayoutChild);

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_left == .0) {
      super.paint(context, offset);
    } else {
      final fullWidth = size.width;
      final childWidth = child?.size.width ?? .0;
      final margins = max(.0, fullWidth - childWidth);
      super.paint(context, offset.translate(min(_left, margins / 2), 0));
    }
  }

  @override
  void performLayout() =>
      size = _compute(child, constraints, ChildLayoutHelper.layoutChild);

  Size _compute(RenderBox? child, BoxConstraints bc, ChildLayouter fn) {
    final padLeft = _left.isInfinite ? .0 : _left;
    final padRight = _right.isInfinite ? .0 : _right;
    if (child != null) {
      final scopedConstraints = constraints;
      final minWidth = max(.0, scopedConstraints.minWidth - padLeft - padRight);
      final cc = scopedConstraints.copyWith(
        minWidth: minWidth,
        maxWidth: max(
          minWidth,
          scopedConstraints.maxWidth - padLeft - padRight,
        ),
      );
      final childSize = fn(child, cc);
      final paddedSize = Size(
        (constraints.hasBoundedWidth && (_left.isInfinite || _right.isInfinite))
            ? constraints.maxWidth
            : childSize.width + padLeft + padRight,
        childSize.height,
      );
      return constraints.constrain(paddedSize);
    } else {
      return computeSizeForNoChild(constraints);
    }
  }
}
