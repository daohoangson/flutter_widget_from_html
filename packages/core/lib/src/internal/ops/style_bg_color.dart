part of '../core_ops.dart';

const kCssBackground = 'background';
const kCssBackgroundColor = 'background-color';

class StyleBgColor {
  final WidgetFactory wf;

  StyleBgColor(this.wf);

  BuildOp get buildOp => BuildOp(
        isBlockElement: false,
        onPieces: (meta, pieces) {
          if (meta.isBlockElement) return pieces;

          final bgColor = _parseColor(wf, meta);
          if (bgColor == null) return pieces;

          return pieces.map((p) => p.hasWidgets ? p : _buildBlock(p, bgColor));
        },
        onWidgets: (meta, widgets) {
          final color = _parseColor(wf, meta);
          if (color == null) return null;
          return listOrNull(wf.buildColumnPlaceholder(meta, widgets)?.wrapWith(
              (child) => wf.buildDecoratedBox(meta, child, color: color)));
        },
        priority: 15000,
      );

  BuiltPiece _buildBlock(BuiltPiece piece, Color bgColor) =>
      piece..text.bits.forEach((bit) => bit.tsb?.enqueue(_tsb, bgColor));

  Color _parseColor(WidgetFactory wf, NodeMetadata meta) {
    Color color;
    for (final style in meta.styles) {
      switch (style.key) {
        case kCssBackgroundColor:
          final parsed = wf.parseColor(style.value);
          if (parsed != null) color = parsed;
          break;
        case kCssBackground:
          for (final v in splitCssValues(style.value)) {
            final parsed = wf.parseColor(v);
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
