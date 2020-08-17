part of '../core_ops.dart';

const kCssPadding = 'padding';

WidgetPlaceholder _paddingInlineAfter(TextStyleBuilder tsb, CssLengthBox box) =>
    WidgetPlaceholder<CssLengthBox>(box)
      ..wrapWith((context, _) =>
          _paddingInlineSizedBox(box.getValueRight(tsb.build(context))));

WidgetPlaceholder _paddingInlineBefore(TextStyleBuilder tsb, CssLengthBox b) =>
    WidgetPlaceholder<CssLengthBox>(b)
      ..wrapWith((context, _) =>
          _paddingInlineSizedBox(b.getValueLeft(tsb.build(context))));

Widget _paddingInlineSizedBox(double width) =>
    width != null && width > 0 ? SizedBox(width: width) : widget0;

class StylePadding {
  final WidgetFactory wf;

  StylePadding(this.wf);

  BuildOp get buildOp => BuildOp(
        isBlockElement: false,
        onPieces: (meta, pieces) {
          if (meta.isBlockElement) return pieces;
          final padding = tryParseCssLengthBox(meta, kCssPadding);
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
          final padding = tryParseCssLengthBox(meta, kCssPadding);
          if (padding == null) return null;

          return listOrNull(wf
              .buildColumnPlaceholder(meta, widgets)
              ?.wrapWith((c, w) => _build(c, meta, w, padding)));
        },
        priority: 9999,
      );

  Widget _build(BuildContext context, NodeMetadata meta, Widget child,
      CssLengthBox padding) {
    final tsh = meta.tsb().build(context);
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
