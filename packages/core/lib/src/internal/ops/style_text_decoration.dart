part of '../core_ops.dart';

const kCssTextDecoration = 'text-decoration';
const kCssTextDecorationColor = 'text-decoration-color';
const kCssTextDecorationThickness = 'text-decoration-thickness';
const kCssTextDecorationWidth = 'text-decoration-width';

const kCssTextDecorationLine = 'text-decoration-line';
const kCssTextDecorationLineThrough = 'line-through';
const kCssTextDecorationNone = 'none';
const kCssTextDecorationOverline = 'overline';
const kCssTextDecorationUnderline = 'underline';

class StyleTextDecoration {
  final WidgetFactory wf;

  StyleTextDecoration(this.wf);

  BuildOp get buildOp => BuildOp(
        onTree: (tree) {
          for (final style in tree.styles) {
            for (final value in style.values) {
              if (style.property == kCssTextDecoration ||
                  style.property == kCssTextDecorationLine) {
                final line = TextDecorationLine.tryParse(value);
                if (line != null) {
                  tree.styleBuilder.enqueue(textDecorationLine, line);
                  continue;
                }
              }

              if (style.property == kCssTextDecoration ||
                  style.property == kCssTextDecorationStyle) {
                final tds = tryParseTextDecorationStyle(value);
                if (tds != null) {
                  tree.styleBuilder.enqueue(textDecorationStyle, tds);
                  continue;
                }
              }

              if (style.property == kCssTextDecoration ||
                  style.property == kCssTextDecorationColor) {
                final color = tryParseColor(value);
                if (color != null) {
                  tree.styleBuilder.enqueue(textDecorationColor, color);
                  continue;
                }
              }

              if (style.property == kCssTextDecoration ||
                  style.property == kCssTextDecorationThickness ||
                  style.property == kCssTextDecorationWidth) {
                final length = tryParseCssLength(value);
                if (length != null && length.unit == CssLengthUnit.percentage) {
                  tree.styleBuilder
                      .enqueue(textDecorationThickness, length.number / 100.0);
                  continue;
                }
              }
            }
          }
        },
      );
}

HtmlStyle textDecorationColor(HtmlStyle style, Color v) =>
    style.copyWith(textStyle: style.textStyle.copyWith(decorationColor: v));

HtmlStyle textDecorationLine(HtmlStyle style, TextDecorationLine v) {
  final decoration = style.textStyle.decoration;
  final lineThough = decoration?.contains(TextDecoration.lineThrough) == true;
  final overline = decoration?.contains(TextDecoration.overline) == true;
  final underline = decoration?.contains(TextDecoration.underline) == true;

  final list = <TextDecoration>[];
  if (v.over == true || (overline && v.over != false)) {
    list.add(TextDecoration.overline);
  }
  if (v.strike == true || (lineThough && v.strike != false)) {
    list.add(TextDecoration.lineThrough);
  }
  if (v.under == true || (underline && v.under != false)) {
    list.add(TextDecoration.underline);
  }

  return style.copyWith(
    textStyle:
        style.textStyle.copyWith(decoration: TextDecoration.combine(list)),
  );
}

HtmlStyle textDecorationStyle(HtmlStyle style, TextDecorationStyle v) =>
    style.copyWith(textStyle: style.textStyle.copyWith(decorationStyle: v));

HtmlStyle textDecorationThickness(HtmlStyle style, double v) =>
    style.copyWith(textStyle: style.textStyle.copyWith(decorationThickness: v));

@immutable
class TextDecorationLine {
  final bool? over;
  final bool? strike;
  final bool? under;

  const TextDecorationLine({
    this.over,
    this.strike,
    this.under,
  });

  static TextDecorationLine? tryParse(css.Expression expression) {
    if (expression is css.LiteralTerm) {
      switch (expression.valueAsString) {
        case kCssTextDecorationLineThrough:
          return const TextDecorationLine(strike: true);
        case kCssTextDecorationNone:
          return const TextDecorationLine(
            over: false,
            strike: false,
            under: false,
          );
        case kCssTextDecorationOverline:
          return const TextDecorationLine(over: true);
        case kCssTextDecorationUnderline:
          return const TextDecorationLine(under: true);
      }
    }

    return null;
  }
}
