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

  late final BuildOp inlineOp;
  late final BuildOp blockOp;

  static final _skipBuilding = Expando<bool>();

  StyleVerticalAlign(this.wf) {
    inlineOp = BuildOp(
      debugLabel: '$kCssVerticalAlign--inline',
      onFlattening: (tree) {
        final v = tree[kCssVerticalAlign]?.term;
        if (v == null || v == kCssVerticalAlignBaseline) {
          return;
        }

        final alignment = _tryParsePlaceholderAlignment(v);
        if (alignment == null) {
          return;
        }

        _skipBuilding[tree] = true;
        final built = tree.build();
        if (built == null) {
          return;
        }

        if (v == kCssVerticalAlignSub || v == kCssVerticalAlignSuper) {
          built.wrapWith(
            (context, child) {
              return _buildPaddedAlign(
                context,
                tree,
                child,
                EdgeInsets.only(
                  bottom: v == kCssVerticalAlignSuper ? .4 : 0,
                  top: v == kCssVerticalAlignSub ? .4 : 0,
                ),
              );
            },
          );
        }

        tree.replaceWith(WidgetBit.inline(tree, built, alignment: alignment));
      },
      priority: 0,
    );

    blockOp = BuildOp(
      debugLabel: '$kCssVerticalAlign--block',
      mustBeBlock: false,
      onBuilt: (tree, placeholder) {
        if (_skipBuilding[tree] == true) {
          return null;
        }

        final v = tree[kCssVerticalAlign]?.term;
        if (v == null) {
          return null;
        }

        return placeholder.wrapWith((context, child) {
          final style = tree.styleBuilder.build(context);
          final alignment = _tryParseAlignmentGeometry(style.textDirection, v);
          if (alignment == null) {
            return child;
          }

          return wf.buildAlign(tree, child, alignment, widthFactor: 1.0);
        });
      },
      priority: kPriority4k3,
    );
  }

  Widget? _buildPaddedAlign(
    BuildContext context,
    BuildTree tree,
    Widget child,
    EdgeInsets padding,
  ) {
    final style = tree.styleBuilder.build(context);
    final fontSize = style.textStyle.fontSize;
    if (fontSize == null) {
      return child;
    }

    final withPadding = wf.buildPadding(
      tree,
      child,
      EdgeInsets.only(
        bottom: fontSize * padding.bottom,
        top: fontSize * padding.top,
      ),
    );
    if (withPadding == null) {
      return child;
    }

    final alignment =
        padding.bottom > 0 ? Alignment.topCenter : Alignment.bottomCenter;
    return wf.buildAlign(tree, withPadding, alignment, widthFactor: 1.0);
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
