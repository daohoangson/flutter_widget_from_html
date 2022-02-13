part of '../core_ops.dart';

const kCssVerticalAlign = 'vertical-align';
const kCssVerticalAlignBaseline = 'baseline';
const kCssVerticalAlignTop = 'top';
const kCssVerticalAlignBottom = 'bottom';
const kCssVerticalAlignMiddle = 'middle';
const kCssVerticalAlignSub = 'sub';
const kCssVerticalAlignSuper = 'super';

class StyleVerticalAlign {
  static const kPriority4k3 = 4300;

  final WidgetFactory wf;

  StyleVerticalAlign(this.wf);

  BuildOp get buildOp => BuildOp(
        onTreeFlattening: (meta, tree, _) {
          final v = meta[kCssVerticalAlign]?.term;
          if (v == null || v == kCssVerticalAlignBaseline) {
            return false;
          }

          final alignment = _tryParsePlaceholderAlignment(v);
          if (alignment == null) {
            return false;
          }

          final built = _buildTree(meta, tree);
          if (built == null) {
            return false;
          }

          if (v == kCssVerticalAlignSub || v == kCssVerticalAlignSuper) {
            built.wrapWith(
              (context, child) => _buildPaddedAlign(
                context,
                meta,
                child,
                EdgeInsets.only(
                  bottom: v == kCssVerticalAlignSuper ? .4 : 0,
                  top: v == kCssVerticalAlignSub ? .4 : 0,
                ),
              ),
            );
          }

          tree.replaceWith(WidgetBit.inline(tree, built, alignment: alignment));
          return true;
        },
        onWidgets: (meta, widgets) {
          if (widgets.isEmpty) {
            return null;
          }

          final v = meta[kCssVerticalAlign]?.term;
          if (v == null) {
            return null;
          }

          return listOrNull(
                wf
                    .buildColumnPlaceholder(meta, widgets)
                    ?.wrapWith((context, child) {
                  final tsh = meta.tsb.build(context);
                  final alignment =
                      _tryParseAlignmentGeometry(tsh.textDirection, v);
                  if (alignment == null) {
                    return child;
                  }

                  return wf.buildAlign(meta, child, alignment);
                }),
              ) ??
              widgets;
        },
        onWidgetsIsOptional: true,
        priority: kPriority4k3,
      );

  WidgetPlaceholder? _buildTree(BuildMetadata meta, BuildTree tree) {
    final bits = tree.bits.toList(growable: false);
    if (bits.length == 1) {
      final firstBit = bits.first;
      if (firstBit is WidgetBit) {
        // use the first widget if possible
        // and avoid creating a redundant `RichText`
        return firstBit.child;
      }
    }

    return wf.buildColumnPlaceholder(meta, tree.build());
  }

  Widget? _buildPaddedAlign(
    BuildContext context,
    BuildMetadata meta,
    Widget child,
    EdgeInsets padding,
  ) {
    final tsh = meta.tsb.build(context);
    final fontSize = tsh.style.fontSize;
    if (fontSize == null) {
      return child;
    }

    final withPadding = wf.buildPadding(
      meta,
      child,
      EdgeInsets.only(
        bottom: fontSize * padding.bottom,
        top: fontSize * padding.top,
      ),
    );
    if (withPadding == null) {
      return child;
    }

    return wf.buildAlign(
      meta,
      withPadding,
      padding.bottom > 0 ? Alignment.topCenter : Alignment.bottomCenter,
      widthFactor: 1.0,
    );
  }
}

AlignmentGeometry? _tryParseAlignmentGeometry(TextDirection dir, String value) {
  final isLtr = dir != TextDirection.rtl;
  switch (value) {
    case kCssVerticalAlignTop:
    case kCssVerticalAlignSuper:
      return isLtr ? Alignment.topLeft : Alignment.topRight;
    case kCssVerticalAlignMiddle:
      return isLtr ? Alignment.centerLeft : Alignment.centerRight;
    case kCssVerticalAlignBottom:
    case kCssVerticalAlignSub:
      return isLtr ? Alignment.bottomLeft : Alignment.bottomRight;
  }

  return null;
}

PlaceholderAlignment? _tryParsePlaceholderAlignment(String value) {
  switch (value) {
    case kCssVerticalAlignTop:
    case kCssVerticalAlignSub:
      return PlaceholderAlignment.top;
    case kCssVerticalAlignSuper:
    case kCssVerticalAlignBottom:
      return PlaceholderAlignment.bottom;
    case kCssVerticalAlignMiddle:
      return PlaceholderAlignment.middle;
  }

  return null;
}
