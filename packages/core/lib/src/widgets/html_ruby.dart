import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A RUBY widget.
class HtmlRuby extends MultiChildRenderObjectWidget {
  /// Creates a RUBY widget.
  HtmlRuby({
    Key? key,
    Widget? rt,
    Widget? ruby,
  }) : super(
          children: [
            if (ruby != null) ruby,
            if (rt != null) rt,
          ],
          key: key,
        );

  @override
  RenderObject createRenderObject(BuildContext _) => _RubyRenderObject();
}

class _RubyParentData extends ContainerBoxParentData<RenderBox> {}

class _RubyRenderObject extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _RubyParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _RubyParentData> {
  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    final ruby = firstChild;
    if (ruby == null) {
      return super.computeDistanceToActualBaseline(baseline);
    }

    final rubyValue = ruby.getDistanceToActualBaseline(baseline) ?? 0.0;
    final offset = (ruby.parentData! as _RubyParentData).offset;
    return offset.dy + rubyValue;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final ruby = firstChild;
    if (ruby == null) {
      return constraints.smallest;
    }
    return _performLayout(ruby, constraints, _performLayoutDry);
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    final ruby = firstChild;
    if (ruby == null) {
      return super.computeMaxIntrinsicHeight(width);
    }

    final rubyValue = ruby.computeMaxIntrinsicHeight(width);
    final rt = (ruby.parentData! as _RubyParentData).nextSibling;
    if (rt == null) {
      return rubyValue;
    }

    final rtValue = rt.computeMaxIntrinsicHeight(width);
    return rubyValue + rtValue;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final ruby = firstChild;
    if (ruby == null) {
      return super.computeMaxIntrinsicWidth(height);
    }

    final rubyValue = ruby.computeMaxIntrinsicWidth(height);
    final rt = (ruby.parentData! as _RubyParentData).nextSibling;
    if (rt == null) {
      return rubyValue;
    }

    return max(rubyValue, rt.computeMaxIntrinsicWidth(height));
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final ruby = firstChild;
    if (ruby == null) {
      return super.computeMinIntrinsicHeight(width);
    }

    final rubyValue = ruby.computeMinIntrinsicHeight(width);
    final rt = (ruby.parentData! as _RubyParentData).nextSibling;
    if (rt == null) {
      return rubyValue;
    }

    final rtValue = rt.computeMinIntrinsicHeight(width);
    return rubyValue + rtValue;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    final ruby = firstChild;
    if (ruby == null) {
      return super.computeMinIntrinsicWidth(height);
    }

    final rubyValue = ruby.getMinIntrinsicWidth(height);
    final rt = (ruby.parentData! as _RubyParentData).nextSibling;
    if (rt == null) {
      return rubyValue;
    }

    return min(rubyValue, rt.getMinIntrinsicWidth(height));
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);

  @override
  void paint(PaintingContext context, Offset offset) =>
      defaultPaint(context, offset);

  @override
  void performLayout() {
    final ruby = firstChild;
    if (ruby == null) {
      size = constraints.smallest;
      return;
    }
    size = _performLayout(ruby, constraints, _performLayoutLayouter);
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _RubyParentData) {
      child.parentData = _RubyParentData();
    }
  }

  static Size _performLayout(
    RenderBox ruby,
    BoxConstraints constraints,
    Size Function(RenderBox renderBox, BoxConstraints constraints) layouter,
  ) {
    final rubyConstraints = constraints.loosen();
    final rubyData = ruby.parentData! as _RubyParentData;
    final rubySize = layouter(ruby, rubyConstraints);

    final rt = rubyData.nextSibling;
    final rtConstraints = rubyConstraints.copyWith(
      maxHeight: rubyConstraints.maxHeight - rubySize.height,
    );
    _RubyParentData? rtData;
    var rtSize = Size.zero;
    if (rt != null) {
      rtData = rt.parentData! as _RubyParentData;
      rtSize = layouter(rt, rtConstraints);
    }

    final height = rubySize.height + rtSize.height;
    final width = max(rubySize.width, rtSize.width);

    if (ruby.hasSize) {
      rubyData.offset = Offset((width - rubySize.width) / 2, rtSize.height);
      rtData?.offset = Offset((width - rtSize.width) / 2, 0);
    }

    return constraints.constrain(Size(width, height));
  }

  static Size _performLayoutDry(
    RenderBox renderBox,
    BoxConstraints constraints,
  ) =>
      renderBox.getDryLayout(constraints);

  static Size _performLayoutLayouter(
    RenderBox renderBox,
    BoxConstraints constraints,
  ) {
    renderBox.layout(constraints, parentUsesSize: true);
    return renderBox.size;
  }
}
