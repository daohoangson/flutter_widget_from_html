part of '../core_widget_factory.dart';

const _kCssLineHeight = 'line-height';
const _kCssLineHeightNormal = 'normal';

double _buildTextStyleHeight(
    WidgetFactory wf, BuildContext c, TextStyleHtml p, String v) {
  if (v == null) return null;
  if (v == _kCssLineHeightNormal) return -1;

  final number = double.tryParse(v);
  if (number != null && number > 0) {
    return number;
  }

  final length = wf.parseCssLength(v);
  if (length != null) {
    if (length.unit == CssLengthUnit.percentage) return length.number / 100;
    return length.getValueFromStyle(c, p.style) / p.style.fontSize;
  }

  return null;
}

BuildOp _styleLineHeight(WidgetFactory wf, String v) =>
    BuildOp(onPieces: (m, p) {
      m.tsb.enqueue(_styleLineHeightBuilder, _StyleLineHeightInput(wf, v));
      return p;
    });

TextStyleHtml _styleLineHeightBuilder(
        BuildContext c, TextStyleHtml p, _StyleLineHeightInput i) =>
    p.copyWith(height: i.wf.buildTextStyleHeight(c, p, i.value));

class _StyleLineHeightInput {
  final WidgetFactory wf;
  final String value;

  _StyleLineHeightInput(this.wf, this.value);
}
