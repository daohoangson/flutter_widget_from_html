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
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    final ruby = firstChild;
    final rubyValue = ruby.getDistanceToActualBaseline(baseline);
    final offset = (ruby.parentData as _RubyParentData).offset;

    return offset.dy + rubyValue;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    final ruby = firstChild;
    final rubyValue = ruby.computeMaxIntrinsicHeight(width);

    final rt = (ruby.parentData as _RubyParentData).nextSibling;
    final rtValue = rt.computeMaxIntrinsicHeight(width);

    return rubyValue + rtValue;
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

    return rubyValue + rtValue;
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
    final rubyConstraints = constraints.loosen();
    ruby.layout(rubyConstraints, parentUsesSize: true);
    final rubyData = ruby.parentData as _RubyParentData;
    final rubySize = ruby.size;

    final rt = rubyData.nextSibling;
    final rtConstraints = rubyConstraints.copyWith(
        maxHeight: rubyConstraints.maxHeight - rubySize.height);
    rt.layout(rtConstraints, parentUsesSize: true);
    final rtData = rt.parentData as _RubyParentData;
    final rtSize = rt.size;

    final height = rubySize.height + rtSize.height;
    final width = max(rubySize.width, rtSize.width);
    rubyData.offset = Offset((width - rubySize.width) / 2, rtSize.height);
    rtData.offset = Offset((width - rtSize.width) / 2, 0);
    size = constraints.constrain(Size(width, height));
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _RubyParentData) {
      child.parentData = _RubyParentData();
    }
  }
}
