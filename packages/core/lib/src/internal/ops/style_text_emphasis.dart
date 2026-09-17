part of '../core_ops.dart';

const kCssTextEmphasis = 'text-emphasis';
const kCssTextEmphasisColor = 'text-emphasis-color';
const kCssTextEmphasisStyle = 'text-emphasis-style';

// Shape keywords.
const kCssTextEmphasisStyleDot = 'dot';
const kCssTextEmphasisStyleCircle = 'circle';
const kCssTextEmphasisStyleDoubleCircle = 'double-circle';
const kCssTextEmphasisStyleTriangle = 'triangle';
const kCssTextEmphasisStyleSesame = 'sesame';

// Fill keywords.
const kCssTextEmphasisFillFilled = 'filled';
const kCssTextEmphasisFillOpen = 'open';

/// Parses [style] and, if a recognised shape is found, registers a [BuildOp]
/// that wraps each non-whitespace character in an [HtmlRuby] with the
/// appropriate emphasis glyph above.
///
/// **Ruby interaction**: when `text-emphasis` is applied to an outer element
/// wrapping `<ruby>` children, the emphasis marks appear on direct text nodes
/// only; ruby sub-trees are passed through unchanged — correct CSS behaviour.
/// Applying `text-emphasis` *directly* on a `<ruby>` element causes both the
/// emphasis glyph and the ruby annotation to appear above the character (the
/// emphasis `onParsed` runs at the lower default priority so the glyph is
/// embedded before the ruby op reconstructs the tree). This is an acceptable
/// degradation given Flutter has no concept of opposed-side annotation tracks.
void textEmphasisApply(BuildTree tree, css.Declaration style) {
  if (style.property == kCssTextEmphasisColor) {
    for (final expr in style.values) {
      final color = tryParseColor(expr)?.rawValue;
      if (color != null) {
        tree.inherit(_emphasisColorResolver, color);
        return;
      }
    }
    return;
  }

  final emphasis = _parseEmphasis(style);
  if (emphasis == null) {
    return;
  }

  final (emphasisChar, markColor) = emphasis;
  if (markColor != null) {
    tree.inherit(_emphasisColorResolver, markColor);
  }
  tree.register(
    BuildOp.v2(
      debugLabel: kCssTextEmphasis,
      onParsed: (t) => _applyEmphasis(t, emphasisChar),
    ),
  );
}

InheritedProperties _emphasisColorResolver(
  InheritedProperties resolving,
  Color value,
) =>
    resolving.copyWith(value: _TextEmphasisColor(value));

@immutable
class _TextEmphasisColor {
  final Color color;
  const _TextEmphasisColor(this.color);
}

/// Returns `(glyphChar, optionalColor)` or `null` if the style carries no
/// recognisable emphasis shape.
///
/// Supports both CSS keyword shapes (`dot`, `circle`, etc.) and CSS `<string>`
/// custom marks (e.g. `text-emphasis: '★'` or `text-emphasis-style: "x"`).
/// Per spec, only the first character of a custom string is used.
(String, Color?)? _parseEmphasis(css.Declaration style) {
  String? shape;
  bool open = false; // CSS default is "filled"
  Color? markColor;
  String? customGlyph; // set when the value is a quoted CSS <string>

  for (final expr in style.values) {
    if (expr is css.LiteralTerm) {
      final raw = expr.value;
      if (raw is String) {
        // Quoted CSS string value — e.g. '★' or "x".
        // Per CSS spec, only the first Unicode code point is used; if the
        // string is empty the declaration is invalid and ignored.
        final unquoted = expr.valueAsString;
        if (unquoted.isNotEmpty) {
          customGlyph = String.fromCharCode(unquoted.runes.first);
        }
      } else {
        // Identifier keyword — dot, circle, open, filled, etc.
        final term = expr.valueAsString;
        if (_emphasisChar(term, false) != null) {
          shape = term;
        } else if (term == kCssTextEmphasisFillOpen) {
          open = true;
        } else if (term == kCssTextEmphasisFillFilled) {
          open = false;
        }
      }
    }
    markColor ??= tryParseColor(expr)?.rawValue;
  }

  // A custom <string> mark takes precedence over a keyword shape.
  if (customGlyph != null) {
    return (customGlyph, markColor);
  }

  if (shape == null) {
    return null;
  }

  return (_emphasisChar(shape, open)!, markColor);
}

/// Returns the CSS Text Decoration Level 3 glyph for [shape] / [open].
String? _emphasisChar(String shape, bool open) {
  switch ((shape, open)) {
    case (kCssTextEmphasisStyleDot, false):
      return '\u2022'; // • BULLET
    case (kCssTextEmphasisStyleDot, true):
      return '\u25e6'; // ◦ WHITE BULLET
    case (kCssTextEmphasisStyleCircle, false):
      return '\u25cf'; // ● BLACK CIRCLE
    case (kCssTextEmphasisStyleCircle, true):
      return '\u25cb'; // ○ WHITE CIRCLE
    case (kCssTextEmphasisStyleDoubleCircle, false):
      return '\u25c9'; // ◉ FISHEYE
    case (kCssTextEmphasisStyleDoubleCircle, true):
      return '\u25ce'; // ◎ BULLSEYE
    case (kCssTextEmphasisStyleTriangle, false):
      return '\u25b2'; // ▲ BLACK UP-POINTING TRIANGLE
    case (kCssTextEmphasisStyleTriangle, true):
      return '\u25b3'; // △ WHITE UP-POINTING TRIANGLE
    case (kCssTextEmphasisStyleSesame, false):
      return '\ufe45'; // ﹅ SESAME DOT
    case (kCssTextEmphasisStyleSesame, true):
      return '\ufe46'; // ﹆ WHITE SESAME DOT
    default:
      return null;
  }
}

/// Rebuilds [tree] so that every non-whitespace character is wrapped in an
/// [HtmlRuby] with the emphasis glyph displayed above it.
BuildTree _applyEmphasis(
  BuildTree tree,
  String emphasisChar,
) {
  // Preserve the original element so that structural checks like isRtTree
  // (which tests element.localName == 'rt') still pass after the replacement.
  // tree.parent.sub() would inherit the parent's element, breaking ruby layout
  // when emphasis is applied directly to an <rt> element.
  final replacement = tree.parent.sub(element: tree.element);

  for (final bit in tree.children) {
    if (bit is TextBit) {
      for (final rune in bit.data.runes) {
        final char = String.fromCharCode(rune);
        if (char.trim().isEmpty) {
          replacement.addWhitespace(char);
        } else {
          final rubyTree = tree.sub();
          rubyTree.addText(char);

          final rtTree = tree.sub();
          rtTree.inherit(text_ops.fontSizeEm, .5);
          // Clear text-decoration and text-shadow so the glyph does not
          // inherit underlines, overlines, strikethroughs, or drop shadows
          // from the base text.
          rtTree.inherit(_clearEmphasisMarkStyle, true);
          rtTree.inherit(_applyEmphasisMarkColor);
          rtTree.addText(emphasisChar);

          replacement.append(
            WidgetBit.inline(
              replacement,
              WidgetPlaceholder(
                debugLabel: kCssTextEmphasis,
                builder: (_, __) => HtmlRuby(
                  ruby: rubyTree.build(),
                  // Wrap in SelectionContainer.disabled so the glyph is
                  // excluded from text selection.
                  rt: _disableSelection(rtTree.build()),
                ),
              ),
            ),
          );
        }
      }
    } else {
      // Non-text bits (sub-trees, WidgetBits for images, nested ruby, etc.)
      // are passed through unchanged.
      replacement.append(bit);
    }
  }

  return replacement;
}

/// Reads [_TextEmphasisColor] from inherited properties and applies it as the
/// text color for the emphasis glyph.
InheritedProperties _applyEmphasisMarkColor(
  InheritedProperties resolving, [
  void _,
]) {
  final emphColor = resolving.get<_TextEmphasisColor>();
  if (emphColor != null) {
    return resolving.copyWith(
      style: TextStyle(color: emphColor.color),
    );
  }
  return resolving;
}

/// Clears [TextDecoration] and [TextStyleShadows] so they are not inherited by
/// the emphasis glyph.
InheritedProperties _clearEmphasisMarkStyle(
  InheritedProperties resolving,
  bool _,
) =>
    resolving
        .copyWith(style: const TextStyle(decoration: TextDecoration.none))
        .copyWith(value: const TextStyleShadows([]));

Widget? _disableSelection(Widget? widget) =>
    widget != null ? SelectionContainer.disabled(child: widget) : null;
