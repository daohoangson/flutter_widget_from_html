part of '../core_ops.dart';

const kCssBackground = 'background';
const kCssBackgroundColor = 'background-color';

class StyleBackground {
  final WidgetFactory wf;

  StyleBackground(this.wf);

  BuildOp get buildOp => BuildOp.v1(
        alwaysRenderBlock: false,
        debugLabel: kCssBackground,
        onRenderBlock: (tree, placeholder) {
          final color = _parseColor(tree);
          if (color == null) {
            return placeholder;
          }

          return placeholder.wrapWith(
            (_, child) => wf.buildDecoration(tree, child, color: color),
          );
        },
        onRenderInline: (tree) {
          final color = _parseColor(tree);
          if (color == null) {
            return;
          }

          tree.apply(_color, color);
        },
        priority: BoxModel.background,
      );

  static HtmlStyle _color(HtmlStyle style, Color color) =>
      style.mergeWith(TextStyle(background: Paint()..color = color));

  static Color? _parseColor(BuildTree tree) {
    Color? color;
    for (final style in tree.styles) {
      switch (style.property) {
        case kCssBackground:
          for (final expression in style.values) {
            color = tryParseColor(expression) ?? color;
          }
          break;
        case kCssBackgroundColor:
          color = tryParseColor(style.value) ?? color;
          break;
      }
    }

    return color;
  }
}
