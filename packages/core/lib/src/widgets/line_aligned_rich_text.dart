import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../core_helpers.dart';

/// Marks an inline placeholder whose vertical alignment uses CSS line edges.
class CssLinePlaceholder extends WidgetPlaceholder {
  /// Creates a line-aligned placeholder.
  CssLinePlaceholder({super.child, super.debugLabel, super.key});
}

/// An inline box aligned to a CSS line edge, rather than a font edge.
class CssLineSpan extends WidgetSpan {
  /// Creates a line-aligned inline box.
  const CssLineSpan({required super.alignment, required super.child});

  /// Whether [text] contains a line-aligned box.
  static bool contains(InlineSpan text) {
    var found = false;
    text.visitChildren((span) {
      found = span is CssLineSpan;
      return !found;
    });
    return found;
  }

  @override
  void build(
    ui.ParagraphBuilder builder, {
    TextScaler textScaler = TextScaler.noScaling,
    List<PlaceholderDimensions>? dimensions,
  }) {
    final dimension = dimensions![builder.placeholderCount];
    builder.addPlaceholder(
      dimension.size.width,
      dimension.size.height,
      dimension.alignment,
      baseline: dimension.baseline,
      baselineOffset: dimension.baselineOffset,
    );
  }
}

/// Rich text with CSS line-edge alignment for [CssLineSpan] children.
///
/// Flutter retains responsibility for painting, selection, semantics and hit
/// testing. Only the placeholder offsets and corresponding dry measurements
/// differ from [RichText].
class LineAlignedRichText extends RichText {
  /// Creates a paragraph containing CSS line-aligned boxes.
  LineAlignedRichText({
    super.key,
    required super.text,
    super.textAlign,
    super.textDirection,
    super.softWrap,
    super.overflow,
    super.textScaler,
    super.maxLines,
    super.locale,
    super.strutStyle,
    super.textWidthBasis,
    super.textHeightBehavior,
    super.selectionRegistrar,
    super.selectionColor,
  });

  @override
  RenderParagraph createRenderObject(BuildContext context) {
    final paragraph = _RenderLineAlignedParagraph(
      text,
      textDirection: textDirection ?? Directionality.of(context),
    );
    // Let RichText propagate all of its rendering and selection properties.
    super.updateRenderObject(context, paragraph);
    return paragraph;
  }
}

class _RenderLineAlignedParagraph extends RenderParagraph {
  final _probe = TextPainter();

  _RenderLineAlignedParagraph(super.text, {required super.textDirection});

  @override
  List<PlaceholderDimensions> layoutInlineChildren(
    double maxWidth,
    ChildLayouter layoutChild,
    ChildBaselineGetter getChildBaseline,
  ) {
    final dimensions =
        super.layoutInlineChildren(maxWidth, layoutChild, getChildBaseline);
    if (dimensions.isEmpty) {
      return dimensions;
    }
    final edges = <int, PlaceholderAlignment>{};
    var index = 0;
    text.visitChildren((span) {
      if (span is PlaceholderSpan) {
        if (span is CssLineSpan) {
          edges[index] = span.alignment;
        }
        index++;
      }
      return true;
    });

    if (edges.isEmpty) {
      return dimensions;
    }

    // Retain widths to find the real wrapping, but exclude line-aligned boxes
    // from the first pass's ascent/descent. Baseline-aligned boxes still count.
    final probe = _probe
      ..text = text
      ..textAlign = textAlign
      ..textDirection = textDirection
      ..textScaler = textScaler
      ..maxLines = maxLines
      ..ellipsis = overflow == TextOverflow.ellipsis ? '\u2026' : null
      ..locale = locale
      ..strutStyle = strutStyle
      ..textWidthBasis = textWidthBasis
      ..textHeightBehavior = textHeightBehavior
      ..setPlaceholderDimensions([
        for (var i = 0; i < dimensions.length; i++)
          if (edges.containsKey(i))
            PlaceholderDimensions(
              size: Size(dimensions[i].size.width, 0),
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              baselineOffset: 0,
            )
          else
            dimensions[i],
      ])
      ..layout(
        maxWidth: softWrap || overflow == TextOverflow.ellipsis
            ? maxWidth
            : double.infinity,
      );
    final resolved = List<PlaceholderDimensions>.of(dimensions);
    final lines = probe.computeLineMetrics();
    final boxes = probe.inlinePlaceholderBoxes!;
    final descents = lines.map((line) => line.descent).toList();
    final assignments = <int, int>{};
    var lineIndex = 0;
    for (final i in edges.keys) {
      if (i >= boxes.length || lines.isEmpty) {
        break; // This placeholder is hidden by maxLines or ellipsis.
      }
      // A zero-height, baseline-aligned box sits at the line's baseline.
      // Midpoints tolerate SkParagraph's fractional line-height rounding.
      while (lineIndex + 1 < lines.length &&
          boxes[i].top >
              (lines[lineIndex].baseline + lines[lineIndex + 1].baseline) / 2) {
        lineIndex++;
      }
      assignments[i] = lineIndex;
      descents[lineIndex] = max(
        descents[lineIndex],
        dimensions[i].size.height - lines[lineIndex].ascent,
      );
    }
    for (final entry in assignments.entries) {
      final i = entry.key;
      final line = entry.value;
      resolved[i] = PlaceholderDimensions(
        size: dimensions[i].size,
        alignment: PlaceholderAlignment.baseline,
        baseline: TextBaseline.alphabetic,
        baselineOffset: edges[i] == PlaceholderAlignment.top
            ? lines[line].ascent
            : dimensions[i].size.height - descents[line],
      );
    }
    return resolved;
  }

  @override
  void systemFontsDidChange() {
    _probe.markNeedsLayout();
    super.systemFontsDidChange();
  }

  @override
  void dispose() {
    _probe.dispose();
    super.dispose();
  }
}
