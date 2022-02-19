part of '../core_ops.dart';

const kCssBackground = 'background';
const kCssBackgroundColor = 'background-color';

class StyleBgColor {
  final WidgetFactory wf;

  static final _skipBuilding = Expando<bool>();

  StyleBgColor(this.wf);

  BuildOp get buildOp => BuildOp(
        onTreeFlattening: (tree) {
          if (_skipBuilding[tree] == true) {
            return;
          }

          final bgColor = _parseColor(wf, tree);
          if (bgColor == null) {
            return;
          }

          _skipBuilding[tree] = true;
          tree.styleBuilder.enqueue(_builder, bgColor);
        },
        onWidgets: (tree, widgets) {
          if (_skipBuilding[tree] == true || widgets.isEmpty) {
            return widgets;
          }

          final color = _parseColor(wf, tree);
          if (color == null) {
            return null;
          }

          _skipBuilding[tree] = true;
          return listOrNull(
                wf.buildColumnPlaceholder(tree, widgets)?.wrapWith(
                      (_, child) =>
                          wf.buildDecoration(tree, child, color: color),
                    ),
              ) ??
              widgets;
        },
        onWidgetsIsOptional: true,
        priority: StyleBorder.kPriorityBoxModel5k + 1,
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
