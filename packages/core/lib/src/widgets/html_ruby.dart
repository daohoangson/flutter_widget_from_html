import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A RUBY widget.
class HtmlRuby extends MultiChildRenderObjectWidget {
  /// Creates a RUBY widget.
  HtmlRuby(Widget ruby, Widget rt, {Key key})
      : assert(ruby != null),
        assert(rt != null),
        super(children: [ruby, rt], key: key);

  @override
  RenderObject createRenderObject(BuildContext _) => _RubyRenderObject();
}

class _RubyParentData extends ContainerBoxParentData<RenderBox> {}

class _RubyRenderObject extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _RubyParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _RubyParentData> {
  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) =>
      defaultComputeDistanceToHighestActualBaseline(baseline);

  @override
  double computeMaxIntrinsicHeight(double width) {
    final ruby = firstChild;
    final rubyValue = ruby.computeMaxIntrinsicHeight(width);

    final rt = (ruby.parentData as _RubyParentData).nextSibling;
    final rtValue = rt.computeMaxIntrinsicHeight(width);

    return rubyValue + 2 * rtValue;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final ruby = firstChild;
    final rubyValue = ruby.computeMaxIntrinsicWidth(height);

    final rt = (ruby.parentData as _RubyParentData).nextSibling;
    final rtValue = rt.computeMaxIntrinsicWidth(height);

    return max(rubyValue, rtValue);
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final ruby = firstChild;
    final rubyValue = ruby.computeMinIntrinsicHeight(width);

    final rt = (ruby.parentData as _RubyParentData).nextSibling;
    final rtValue = rt.computeMinIntrinsicHeight(width);

    return rubyValue + 2 * rtValue;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    final ruby = firstChild;
    final rubyValue = ruby.getMinIntrinsicWidth(height);

    final rt = (ruby.parentData as _RubyParentData).nextSibling;
    final rtValue = rt.getMinIntrinsicWidth(height);

    return min(rubyValue, rtValue);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) =>
      defaultHitTestChildren(result, position: position);

  @override
  void paint(PaintingContext context, Offset offset) =>
      defaultPaint(context, offset);

  @override
  void performLayout() {
    final ruby = firstChild;
    final rubyData = ruby.parentData as _RubyParentData;
    ruby.layout(constraints, parentUsesSize: true);
    final rubySize = ruby.size;

    final rt = rubyData.nextSibling;
    final rtData = rt.parentData as _RubyParentData;
    rt.layout(constraints, parentUsesSize: true);
    final rtSize = rt.size;

    size = Size(
      max(rubySize.width, rtSize.width),
      rubySize.height + 2 * rtSize.height,
    );

    rubyData.offset = Offset((size.width - rubySize.width) / 2, rtSize.height);
    rtData.offset = Offset((size.width - rtSize.width) / 2, 0);
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _RubyParentData) {
      child.parentData = _RubyParentData();
    }
  }
}
