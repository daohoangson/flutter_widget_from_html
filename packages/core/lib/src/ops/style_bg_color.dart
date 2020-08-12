part of '../core_widget_factory.dart';

const _kCssBackgroundColor = 'background-color';

class _StyleBgColor {
  final WidgetFactory wf;

  _StyleBgColor(this.wf);

  BuildOp get buildOp => BuildOp(
        isBlockElement: false,
        onPieces: (meta, pieces) {
          if (meta.isBlockElement) return pieces;

          final bgColor = wf.parseColor(meta.style(_kCssBackgroundColor));
          if (bgColor == null) return pieces;

          return pieces.map((p) => p.hasWidgets ? p : _buildBlock(p, bgColor));
        },
        onWidgets: (meta, widgets) {
          final color = wf.parseColor(meta.style(_kCssBackgroundColor));
          if (color == null) return null;
          return _listOrNull(wf
              .buildColumnPlaceholder(widgets)
              ?.wrapWith((child) => wf.buildDecoratedBox(child, color: color)));
        },
        priority: 15000,
      );

  BuiltPiece _buildBlock(BuiltPiece piece, Color bgColor) =>
      piece..text.bits.forEach((bit) => bit.tsb?.enqueue(_tsb, bgColor));

  static TextStyleHtml _tsb(TextStyleHtml p, Color c) =>
      p.copyWith(style: p.style.copyWith(background: Paint()..color = c));
}
