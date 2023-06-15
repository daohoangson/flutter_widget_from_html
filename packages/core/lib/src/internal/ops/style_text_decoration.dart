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

void textDecorationApply(BuildTree tree, css.Declaration style) {
  for (final value in style.values) {
    if (style.property == kCssTextDecoration ||
        style.property == kCssTextDecorationLine) {
      final line = TextDecorationLine.tryParse(value);
      if (line != null) {
        tree.apply(textDecorationLine, line);
        continue;
      }
    }

    if (style.property == kCssTextDecoration ||
        style.property == kCssTextDecorationStyle) {
      final tds = tryParseTextDecorationStyle(value);
      if (tds != null) {
        tree.apply(textDecorationStyle, tds);
        continue;
      }
    }

    if (style.property == kCssTextDecoration ||
        style.property == kCssTextDecorationColor) {
      final color = tryParseColor(value);
      if (color != null) {
        tree.apply(textDecorationColor, color);
        continue;
      }
    }

    if (style.property == kCssTextDecoration ||
        style.property == kCssTextDecorationThickness ||
        style.property == kCssTextDecorationWidth) {
      final length = tryParseCssLength(value);
      if (length != null && length.unit == CssLengthUnit.percentage) {
        tree.apply(textDecorationThickness, length.number / 100.0);
        continue;
      }
    }
  }
}

HtmlStyle textDecorationColor(HtmlStyle style, Color v) =>
    style.mergeWith(TextStyle(decorationColor: v));

HtmlStyle textDecorationLine(HtmlStyle p, TextDecorationLine v) {
  final parent = p.parent?.textDecoration;
  final parentOverline = parent?.contains(TextDecoration.overline) == true;
  final parentLineThrough =
      parent?.contains(TextDecoration.lineThrough) == true;
  final parentUnderline = parent?.contains(TextDecoration.underline) == true;

  final current = p.textDecoration;
  final currentOverline = current?.contains(TextDecoration.overline) == true;
  final currentLineThrough =
      current?.contains(TextDecoration.lineThrough) == true;
  final currentUnderline = current?.contains(TextDecoration.underline) == true;

  final list = <TextDecoration>[];
  if (parentOverline || (v.over ?? currentOverline)) {
    // 1. Honor parent's styling if the line decoration is turned on
    // 2. Then apply incoing value (if set)
    // 3. Finally fallback to the current styling
    //
    // According to https://developer.mozilla.org/en-US/docs/Web/CSS/text-decoration
    // > Text decorations are drawn across descendant text elements.
    // > This means that if an element specifies a text decoration,
    // > then a child element can't remove the decoration.
    list.add(TextDecoration.overline);
  }
  if (parentLineThrough || (v.strike ?? currentLineThrough)) {
    list.add(TextDecoration.lineThrough);
  }
  if (parentUnderline || (v.under ?? currentUnderline)) {
    list.add(TextDecoration.underline);
  }

  return p.mergeWith(TextStyle(decoration: TextDecoration.combine(list)));
}

HtmlStyle textDecorationStyle(HtmlStyle style, TextDecorationStyle v) =>
    style.mergeWith(TextStyle(decorationStyle: v));

HtmlStyle textDecorationThickness(HtmlStyle style, double v) =>
    style.mergeWith(TextStyle(decorationThickness: v));

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
