part of '../core_ops.dart';

class StyleBorder {
  final WidgetFactory wf;

  static final _sidesPaintedElsewhere = Expando<bool>();
  static final _skipBuilding = Expando<bool>();

  StyleBorder(this.wf);

  BuildOp get buildOp => BuildOp(
        alwaysRenderBlock: false,
        debugLabel: kCssBorder,
        onParsed: (tree) {
          final parent = tree.parent;
          if (tree.isInline != true) {
            return tree;
          }

          final border = tryParseBorder(tree);
          if (border.isNoOp) {
            return tree;
          }

          // Don't skip onRenderBlock — let it handle border decoration
          // during tree.build() so it can be merged with background color
          // by buildDecoration's Container merge logic.
          return parent.sub()
            ..append(
              WidgetBit.inline(
                tree,
                WidgetPlaceholder(
                  debugLabel: '${tree.element.localName}--$kCssBorder',
                  child: tree.build(),
                ),
              ),
            );
        },
        onRenderBlock: (tree, placeholder) {
          if (_skipBuilding[tree] == true) {
            return placeholder;
          }

          final border = tryParseBorder(tree);
          if (border.isNoOp) {
            return placeholder;
          }

          skip(tree);
          return WidgetPlaceholder(
            builder: (ctx, _) => _buildBorder(tree, ctx, placeholder, border),
            debugLabel: '${tree.element.localName}--$kCssBorder',
          );
        },
        priority: BoxModel.border,
      );

  Widget? _buildBorder(
    BuildTree tree,
    BuildContext context,
    Widget child,
    CssBorder cssBorder,
  ) {
    final resolved = tree.inheritanceResolvers.resolve(context);
    final border = cssBorder.getBorder(resolved);
    final borderRadius = cssBorder.getBorderRadius(resolved);

    final radiusInsideSides = _sidesPaintedElsewhere[tree];
    if (radiusInsideSides != null) {
      if (borderRadius == null || border?.isUniform == false) {
        return child;
      }

      final width = radiusInsideSides ? border?.top.width ?? 0.0 : 0.0;
      return wf.buildDecoration(
        tree,
        child,
        borderRadius: _deflate(borderRadius, width),
      );
    }

    return wf.buildDecoration(
      tree,
      child,
      border: border,
      borderRadius: borderRadius,
    );
  }

  static void skip(BuildTree tree) => _skipBuilding[tree] = true;

  /// Skips the border sides of [tree] because its parent widget paints them.
  ///
  /// The border radius is still applied to the decoration,
  /// reduced by the sides width when [radiusInsideSides] is `true`.
  static void skipSides(BuildTree tree, {bool radiusInsideSides = false}) =>
      _sidesPaintedElsewhere[tree] = radiusInsideSides;

  static BorderRadius _deflate(BorderRadius borderRadius, double width) {
    if (width == 0) {
      return borderRadius;
    }

    Radius deflate(Radius radius) =>
        (radius - Radius.circular(width)).clamp(minimum: Radius.zero);

    return BorderRadius.only(
      topLeft: deflate(borderRadius.topLeft),
      topRight: deflate(borderRadius.topRight),
      bottomLeft: deflate(borderRadius.bottomLeft),
      bottomRight: deflate(borderRadius.bottomRight),
    );
  }
}
