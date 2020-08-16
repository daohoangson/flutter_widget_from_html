part of '../ops.dart';

const kCssPadding = 'padding';

WidgetPlaceholder _paddingInlineAfter(TextStyleBuilder tsb, CssLengthBox box) =>
    WidgetPlaceholder<CssLengthBox>(
      child: _paddingInlineSizedBox(box.getValueRight(tsb.build())),
      generator: box,
    );

WidgetPlaceholder _paddingInlineBefore(TextStyleBuilder tsb, CssLengthBox b) =>
    WidgetPlaceholder<CssLengthBox>(
      child: _paddingInlineSizedBox(b.getValueLeft(tsb.build())),
      generator: b,
    );

Widget _paddingInlineSizedBox(double width) =>
    width != null && width > 0 ? SizedBox(width: width) : widget0;

class StylePadding {
  final WidgetFactory wf;

  StylePadding(this.wf);

  BuildOp get buildOp => BuildOp(
        isBlockElement: false,
        onPieces: (meta, pieces) {
          if (meta.isBlockElement) return pieces;
          final padding = wf.parseCssLengthBox(meta, kCssPadding);
          if (padding?.hasLeftOrRight != true) return pieces;

          return _wrapTextBits(
            pieces,
            appendBuilder: (parent) =>
                TextWidget(parent, _paddingInlineAfter(parent.tsb, padding)),
            prependBuilder: (parent) =>
                TextWidget(parent, _paddingInlineBefore(parent.tsb, padding)),
          );
        },
        onWidgets: (meta, widgets) {
          if (widgets?.isNotEmpty != true) return null;
          final padding = wf.parseCssLengthBox(meta, kCssPadding);
          if (padding == null) return null;

          return listOrNull(wf
              .buildColumnPlaceholder(meta, widgets)
              ?.wrapWith((child) => _build(meta, child, padding)));
        },
        priority: 9999,
      );

  Widget _build(NodeMetadata meta, Widget child, CssLengthBox padding) {
    final tsh = meta.tsb().build();
    return wf.buildPadding(
      meta,
      child,
      EdgeInsets.fromLTRB(
        padding.getValueLeft(tsh) ?? 0,
        padding.top?.getValue(tsh) ?? 0,
        padding.getValueRight(tsh) ?? 0,
        padding.bottom?.getValue(tsh) ?? 0,
      ),
    );
  }
}
