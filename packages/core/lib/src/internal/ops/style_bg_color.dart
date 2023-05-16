part of '../core_ops.dart';

const kCssBackground = 'background';
const kCssBackgroundColor = 'background-color';

class StyleBgColor {
  static const kPriorityBoxModel7k5 = 7500;

  final WidgetFactory wf;

  static final _skipBuilding = Expando<bool>();

  StyleBgColor(this.wf);

  BuildOp get buildOp => BuildOp(
        debugLabel: kCssBackground,
        onFlattening: (tree) {
          if (_skipBuilding[tree] == true) {
            return;
          }

          final bgColor = _parseColor(wf, tree);
          if (bgColor == null) {
            return;
          }

          _skipBuilding[tree] = true;
          tree.apply(_builder, bgColor);
        },
        onBuilt: (tree, placeholder) {
          if (_skipBuilding[tree] == true) {
            return null;
          }

          final color = _parseColor(wf, tree);
          if (color == null) {
            return null;
          }

          _skipBuilding[tree] = true;
          return placeholder.wrapWith(
            (_, child) => wf.buildDecoration(tree, child, color: color),
          );
        },
        onWidgetsIsOptional: true,
        priority: kPriorityBoxModel7k5,
      );

  Color? _parseColor(WidgetFactory wf, BuildTree tree) {
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

  static HtmlStyle _builder(HtmlStyle style, Color color) => style.copyWith(
        textStyle: style.textStyle.copyWith(background: Paint()..color = color),
      );
}
