import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

typedef Baselines = Map<int, List<_ValignBaselineRenderObject>>;

class ValignBaselineContainer extends StatefulWidget {
  final Widget child;

  const ValignBaselineContainer({required this.child, super.key});

  @override
  State<ValignBaselineContainer> createState() => _ValignBaselineState();
}

/// A `valign=baseline` widget.
class ValignBaseline extends SingleChildRenderObjectWidget {
  final int index;

  /// Creates a `valign=baseline` widget.
  const ValignBaseline({
    required Widget super.child,
    required this.index,
    super.key,
  });

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _ValignBaselineRenderObject(context.baselines, index);

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) =>
      (renderObject as _ValignBaselineRenderObject)
        ..setBaselines(context.baselines)
        ..setIndex(index);
}

extension on BuildContext {
  Baselines get baselines =>
      dependOnInheritedWidgetOfExactType<_ValignBaselineInheritedWidget>()
          ?.baselines ??
      {};
}

class _ValignBaselineState extends State<ValignBaselineContainer> {
  final Baselines baselines = {};

  @override
  Widget build(BuildContext context) {
    return _ValignBaselineInheritedWidget(
      baselines,
      _ValignBaselineClearer(child: widget.child),
    );
  }
}

class _ValignBaselineInheritedWidget extends InheritedWidget {
  final Baselines baselines;

  const _ValignBaselineInheritedWidget(this.baselines, Widget child)
      : super(child: child);

  @override
  bool updateShouldNotify(_ValignBaselineInheritedWidget oldWidget) =>
      !identical(baselines, oldWidget.baselines);
}

class _ValignBaselineClearer extends SingleChildRenderObjectWidget {
  const _ValignBaselineClearer({required Widget super.child});

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _ValignBaselineClearerRenderObject(context.baselines);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _ValignBaselineClearerRenderObject renderObject,
  ) =>
      renderObject.setBaselines(context.baselines);
}

class _ValignBaselineClearerRenderObject extends RenderProxyBox {
  _ValignBaselineClearerRenderObject(this._baselines);

  Baselines _baselines;
  void setBaselines(Baselines v) {
    if (!identical(v, _baselines)) {
      _baselines = v;
      markNeedsPaint();
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _baselines.clear();
    super.paint(context, offset);
  }
}

class _ValignBaselineRenderObject extends RenderProxyBox {
  _ValignBaselineRenderObject(this._baselines, this._index);

  Baselines _baselines;
  void setBaselines(Baselines v) {
    if (!identical(v, _baselines)) {
      _baselines = v;
      markNeedsLayout();
    }
  }

  int _index;
  void setIndex(int v) {
    if (v != _index) {
      _index = v;
      markNeedsLayout();
    }
  }

  double? _baselineWithOffset;
  var _paddingTop = 0.0;

  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      _compute(child, constraints, ChildLayoutHelper.dryLayoutChild);

  @override
  void paint(PaintingContext context, Offset offset) {
    final effectiveOffset = offset.translate(0, _paddingTop);

    final child = this.child;
    if (child == null) {
      return;
    }

    final baselineWithOffset = _baselineWithOffset = effectiveOffset.dy +
        (child.getDistanceToBaseline(TextBaseline.alphabetic) ?? 0.0);

    final siblings = _baselines;
    if (siblings.containsKey(_index)) {
      final siblingBaseline = siblings[_index]!
          .map((e) => e._baselineWithOffset!)
          .reduce((v, e) => max(v, e));
      siblings[_index]!.add(this);

      if (siblingBaseline > baselineWithOffset) {
        final offsetY = siblingBaseline - baselineWithOffset;
        if (size.height - child.size.height >= offsetY) {
          // paint child with additional offset
          context.paintChild(child, effectiveOffset.translate(0, offsetY));
          return;
        } else {
          // skip painting this frame, wait for the correct padding
          _paddingTop += offsetY;
          _baselineWithOffset = siblingBaseline;
          WidgetsBinding.instance
              .addPostFrameCallback((_) => markNeedsLayout());
          return;
        }
      } else if (siblingBaseline < baselineWithOffset) {
        for (final sibling in siblings[_index]!) {
          if (sibling == this) {
            continue;
          }

          final offsetY = baselineWithOffset - sibling._baselineWithOffset!;
          if (offsetY != 0.0) {
            sibling._paddingTop += offsetY;
            sibling._baselineWithOffset = baselineWithOffset;
            WidgetsBinding.instance
                .addPostFrameCallback((_) => sibling.markNeedsLayout());
          }
        }
      }
    } else {
      siblings[_index] = [this];
    }

    context.paintChild(child, effectiveOffset);
  }

  @override
  void performLayout() =>
      size = _compute(child, constraints, ChildLayoutHelper.layoutChild);

  @override
  String toStringShort() => '_ValignBaselineRenderObject(index: $_index)';

  Size _compute(RenderBox? child, BoxConstraints bc, ChildLayouter fn) {
    final cc = bc.loosen().deflate(EdgeInsets.only(top: _paddingTop));
    final childSize = child != null ? fn(child, cc) : Size.zero;
    return bc.constrain(childSize + Offset(0, _paddingTop));
  }
}
