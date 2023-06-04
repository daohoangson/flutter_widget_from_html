part of '../core_ops.dart';

const kCssVerticalAlign = 'vertical-align';
const kCssVerticalAlignBaseline = 'baseline';
const kCssVerticalAlignTop = 'top';
const kCssVerticalAlignBottom = 'bottom';
const kCssVerticalAlignMiddle = 'middle';
const kCssVerticalAlignSub = 'sub';
const kCssVerticalAlignSuper = 'super';

class StyleVerticalAlign {
  final WidgetFactory wf;

  static final _skipBuilding = Expando<bool>();

  StyleVerticalAlign(this.wf);

  BuildOp get buildOp => BuildOp.v1(
        debugLabel: kCssVerticalAlign,
        mustBeBlock: false,
        onParsed: (tree) {
          final parent = tree.parent;
          if (tree.isInline != true) {
            return tree;
          }

          final v = tree.getStyle(kCssVerticalAlign)?.term;
          if (v == null || v == kCssVerticalAlignBaseline) {
            return tree;
          }

          final alignment = _tryParsePlaceholderAlignment(v);
          if (alignment == null) {
            return tree;
          }

          final placeholder = WidgetPlaceholder(
            builder: (context, child) => tree.build(),
            debugLabel: '${tree.element.localName}--$kCssVerticalAlign',
          );

          if (v == kCssVerticalAlignSub || v == kCssVerticalAlignSuper) {
            placeholder.wrapWith(
              (context, child) {
                final padding = EdgeInsets.only(
                  bottom: v == kCssVerticalAlignSuper ? .4 : 0,
                  top: v == kCssVerticalAlignSub ? .4 : 0,
                );
                return _buildPaddedAlign(context, tree, child, padding);
              },
            );
          }

          _skipBuilding[tree] = true;
          return parent.sub()
            ..append(
              WidgetBit.inline(
                tree,
                placeholder,
                alignment: alignment,
              ),
            );
        },
        onRenderBlock: (tree, placeholder) {
          if (_skipBuilding[tree] == true) {
            return placeholder;
          }

          final v = tree.getStyle(kCssVerticalAlign)?.term;
          if (v == null) {
            return placeholder;
          }

          return placeholder.wrapWith((context, child) {
            final style = tree.styleBuilder.build(context);
            final alignment =
                _tryParseAlignmentGeometry(style.textDirection, v);
            if (alignment == null) {
              return child;
            }

            return wf.buildAlign(tree, child, alignment, widthFactor: 1.0);
          });
        },
        priority: BoxModel.verticalAlign,
      );

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
