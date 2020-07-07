part of '../core_widget_factory.dart';

const _kCssLineHeight = 'line-height';
const _kCssLineHeightNormal = 'normal';

final _lineHeightPercentageRegExp = RegExp(r'^(.+)%$');

CssLineHeight _parseCssLineHeight(String value) {
  if (value == null) return null;

  switch (value) {
    case _kCssLineHeightNormal:
      return CssLineHeight.normal();
  }

  final match = _lineHeightPercentageRegExp.firstMatch(value);
  if (match != null) {
    final percentage = double.tryParse(match[1]);
    if (percentage != null && percentage > 0) {
      return CssLineHeight.percentage(percentage);
    }
  }

  final number = double.tryParse(value);
  if (number != null && number > 0) {
    return CssLineHeight.number(number);
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
