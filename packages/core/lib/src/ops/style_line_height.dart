part of '../core_widget_factory.dart';

const _kCssLineHeight = 'line-height';
const _kCssLineHeightNormal = 'normal';

CssLineHeight _parseCssLineHeight(WidgetFactory wf, String value) {
  if (value == null) return null;

  switch (value) {
    case _kCssLineHeightNormal:
      return CssLineHeight.normal();
  }

  if (value.endsWith('%')) {
    final percentage = double.tryParse(value.substring(0, value.length - 1));
    if (percentage != null && percentage > 0) {
      return CssLineHeight.number(percentage / 100);
    }
  }

  final number = double.tryParse(value);
  if (number != null && number > 0) {
    return CssLineHeight.number(number);
  }

  final length = wf.parseCssLength(value);
  if (length != null) {
    return CssLineHeight.length(length);
  }

  return null;
}

BuildOp _styleLineHeight(WidgetFactory wf, CssLineHeight v) =>
    BuildOp(onPieces: (meta, pieces) {
      meta.tsb.enqueue(_styleLineHeightBuilder, v);
      return pieces;
    });

TextStyleHtml _styleLineHeightBuilder(TextStyleBuilders tsb,
        TextStyleHtml parent, CssLineHeight lineHeight) =>
    parent.copyWith(lineHeight: lineHeight);
