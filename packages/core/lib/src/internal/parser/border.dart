part of '../core_parser.dart';

const kCssBorder = 'border';
const kCssBorderBottom = 'border-bottom';
const kCssBorderTop = 'border-top';

CssBorderSide tryParseCssBorderSide(List<css.Expression> expressions) {
  final width_ = expressions.isNotEmpty ? expressions[0] : null;
  final width = tryParseCssLength(width_);
  if (width == null || width.number <= 0) return null;

  return CssBorderSide(
    color: tryParseColor(expressions.length >= 3 ? expressions[2] : null),
    style:
        tryParseCssBorderStyle(expressions.length >= 2 ? expressions[1] : null),
    width: width,
  );
}

TextDecorationStyle tryParseCssBorderStyle(css.Expression expression) {
  if (expression is css.LiteralTerm) {
    switch (expression.valueAsString) {
      case 'dotted':
        return TextDecorationStyle.dotted;
      case 'dashed':
        return TextDecorationStyle.dashed;
      case 'double':
        return TextDecorationStyle.double;
    }
  }

  return TextDecorationStyle.solid;
}
