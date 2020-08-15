part of '../core_widget_factory.dart';

const _kCssBorder = 'border';
const _kCssBorderBottom = 'border-bottom';
const _kCssBorderTop = 'border-top';

final _borderValuesThreeRegExp = RegExp(r'^(.+)\s+(.+)\s+(.+)$');
final _borderValuesTwoRegExp = RegExp(r'^(.+)\s+(.+)$');

CssBorderSide _parseCssBorderSide(WidgetFactory wf, String value) {
  final valuesThree = _borderValuesThreeRegExp.firstMatch(value);
  if (valuesThree != null) {
    final width = wf.parseCssLength(valuesThree[1]);
    if (width == null || width.number <= 0) return null;
    return CssBorderSide(
      color: wf.parseColor(valuesThree[3]),
      style: wf.parseCssBorderStyle(valuesThree[2]),
      width: width,
    );
  }

  final valuesTwo = _borderValuesTwoRegExp.firstMatch(value);
  if (valuesTwo != null) {
    final width = wf.parseCssLength(valuesTwo[1]);
    if (width == null || width.number <= 0) return null;
    return CssBorderSide(
      style: wf.parseCssBorderStyle(valuesTwo[2]),
      width: width,
    );
  }

  final width = wf.parseCssLength(value);
  if (width == null || width.number <= 0) return null;
  return CssBorderSide(
    style: TextDecorationStyle.solid,
    width: width,
  );
}

TextDecorationStyle _parseCssBorderStyle(String value) {
  switch (value) {
    case 'dotted':
      return TextDecorationStyle.dotted;
    case 'dashed':
      return TextDecorationStyle.dashed;
    case 'double':
      return TextDecorationStyle.double;
  }

  return TextDecorationStyle.solid;
}
