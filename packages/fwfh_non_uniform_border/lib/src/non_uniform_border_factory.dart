import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:non_uniform_border/non_uniform_border.dart';

/// A mixin that can render border radius with `non_uniform_border` package.
mixin NonUniformBorderFactory on WidgetFactory {
  @override
  Widget? buildDecoration(
    BuildTree tree,
    Widget child, {
    Border? border,
    BorderRadius? borderRadius,
    Color? color,
  }) {
    final built = super.buildDecoration(
      tree,
      child,
      border: border,
      borderRadius: borderRadius,
      color: color,
    );

    if (borderRadius == null || built is! Container) {
      return built;
    }

    final decoration = built.decoration;
    if (decoration is! BoxDecoration || decoration.borderRadius != null) {
      return built;
    }

    final builtBorder = decoration.border;
    if (builtBorder is! Border) {
      return built;
    }

    final topColor = builtBorder.top.color;
    final colorIsUniform = builtBorder.left.color == topColor &&
        builtBorder.bottom.color == topColor &&
        builtBorder.right.color == topColor;
    if (!colorIsUniform) {
      // even non_uniform_border can't handle non-uniform color, sorry
      return built;
    }

    final shape = NonUniformBorder(
      leftWidth: builtBorder.left.width,
      rightWidth: builtBorder.right.width,
      topWidth: builtBorder.top.width,
      bottomWidth: builtBorder.bottom.width,
      color: topColor,
      borderRadius: borderRadius,
    );

    return Container(
      decoration: ShapeDecoration(
        color: decoration.color,
        image: decoration.image,
        gradient: decoration.gradient,
        shadows: decoration.boxShadow,
        shape: shape,
      ),
      clipBehavior: Clip.hardEdge,
      child: built.child,
    );
  }
}
