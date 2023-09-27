part of '../core_ops.dart';

const kCssBackground = 'background';
const kCssBackgroundColor = 'background-color';
const kCssBackgroundImage = 'background-image';

class StyleBg {
  static const kPriorityBoxModel7k5 = 7500;

  final WidgetFactory wf;

  static final _skipBuilding = Expando<bool>();

  StyleBg(this.wf);

  BuildOp get buildOp => BuildOp(
        onTreeFlattening: (meta, tree) {
          if (_skipBuilding[meta] == true) {
            return;
          }

          final bgColor = _parseColor(wf, meta);
          if (bgColor == null) {
            return;
          }

          _skipBuilding[meta] = true;
          meta.tsb.enqueue(_tsb, bgColor);
        },
        onWidgets: (meta, widgets) {
          if (_skipBuilding[meta] == true || widgets.isEmpty) {
            return widgets;
          }

          final color = _parseColor(wf, meta);
          final bgImageUrl = _parseBackgroundImageUrl(wf, meta);

          if (color == null && bgImageUrl == null) {
            return null;
          }

          _skipBuilding[meta] = true;
          return listOrNull(
            wf.buildColumnPlaceholder(meta, widgets)?.wrapWith(
                  (_, child) => wf.buildDecoration(meta, child, color: color, bgImageUrl: bgImageUrl),
                ),
          );
        },
        onWidgetsIsOptional: true,
        priority: kPriorityBoxModel7k5,
      );

  Color? _parseColor(WidgetFactory wf, BuildMetadata meta) {
    Color? color;
    for (final style in meta.styles) {
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

  /// Attempts to parse the background image URL from the [meta] styles.
  String? _parseBackgroundImageUrl(WidgetFactory wf, BuildMetadata meta) {
    for (final style in meta.styles) {
      final styleValue = style.value;
      if (styleValue == null) {
        continue;
      }

      switch (style.property) {
        case kCssBackground:
        case kCssBackgroundImage:
          for (final expression in style.values) {
            if (expression is css.UriTerm) {
              return expression.text;
            }
          }
          break;
      }
    }

    return null;
  }

  static TextStyleHtml _tsb(TextStyleHtml p, Color c) =>
      p.copyWith(style: p.style.copyWith(background: Paint()..color = c));
}
