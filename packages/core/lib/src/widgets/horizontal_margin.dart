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
    return _HorizontalMarginRenderObject(left: left, right: right);
  }

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    (renderObject as _HorizontalMarginRenderObject)
      ..setLeft(left)
      ..setRight(right);
  }
}

class _HorizontalMarginRenderObject extends RenderShiftedBox {
  _HorizontalMarginRenderObject({
    RenderBox? child,
    required double left,
    required double right,
  })  : _left = left,
        _right = right,
        super(child);

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

  double get marginsOrZero => _left.or(0) + _right.or(0);

  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      _compute(child, constraints, ChildLayoutHelper.dryLayoutChild);

  @override
  double computeMaxIntrinsicWidth(double height) {
    final scopedChild = child;
    if (scopedChild == null) {
      return marginsOrZero;
    }

    return scopedChild.getMaxIntrinsicWidth(height) + marginsOrZero;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    final scopedChild = child;
    if (scopedChild == null) {
      return marginsOrZero;
    }

    return scopedChild.getMinIntrinsicWidth(height) + marginsOrZero;
  }

  @override
  void performLayout() =>
      size = _compute(child, constraints, ChildLayoutHelper.layoutChild);

  Size _compute(RenderBox? scopedChild, BoxConstraints bc, ChildLayouter fn) {
    if (scopedChild == null) {
      return bc.constrain(Size(marginsOrZero, 0));
    }

    final edges = EdgeInsets.only(left: _left.or(0), right: _right.or(0));
    final cc = bc.deflate(edges);
    final childSize = fn(scopedChild, cc);
    final width = bc.maxWidth.orChildWithMargins(childSize, _left, _right);
    final fullSize = bc.constrain(Size(width, childSize.height));

    if (identical(fn, ChildLayoutHelper.layoutChild)) {
      final delta = max(.0, fullSize.width - childSize.width);
      final leftWeight = _left.or(fullSize.width);
      final totalWeight = leftWeight + _right.or(fullSize.width);
      final leftMax = totalWeight == .0 ? .0 : delta / totalWeight * leftWeight;

      final data = scopedChild.parentData! as BoxParentData;
      data.offset = Offset(min(_left, leftMax), 0);
    }

    return fullSize;
  }
}

extension on double {
  double orChildWithMargins(Size child, double left, double right) =>
      (isFinite && (left.isInfinite || right.isInfinite))
          ? this
          : child.width + left.or(0) + right.or(0);

  double or(double value) => isInfinite ? value : this;
}
