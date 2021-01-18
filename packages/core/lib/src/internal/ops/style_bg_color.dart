part of '../core_ops.dart';

const kCssBackground = 'background';
const kCssBackgroundColor = 'background-color';

class StyleBgColor {
  final WidgetFactory wf;

  StyleBgColor(this.wf);

  BuildOp get buildOp => BuildOp(
        onTree: (meta, tree) {
          if (meta.willBuildSubtree) return;

          final bgColor = _parseColor(wf, meta);
          if (bgColor == null) return;

          for (final bit in tree.bits) {
            bit.tsb?.enqueue(_tsb, bgColor);
          }
        },
        onWidgets: (meta, widgets) {
          final color = _parseColor(wf, meta);
          if (color == null) return null;
          return listOrNull(wf.buildColumnPlaceholder(meta, widgets)?.wrapWith(
              (_, child) => wf.buildDecoratedBox(meta, child, color: color)));
        },
        onWidgetsIsOptional: true,
        priority: 4900,
      );

  Color _parseColor(WidgetFactory wf, BuildMetadata meta) {
    Color color;
    for (final style in meta.styles) {
      switch (style.key) {
        case kCssBackgroundColor:
          final parsed = tryParseColor(style.value);
          if (parsed != null) color = parsed;
          break;
        case kCssBackground:
          for (final value in style.values) {
            final parsed = tryParseColor(value);
            if (parsed != null) color = parsed;
          }
          break;
      }
    }

    return color;
  }

  static TextStyleHtml _tsb(TextStyleHtml p, Color c) =>
      p.copyWith(style: p.style.copyWith(background: Paint()..color = c));
}
