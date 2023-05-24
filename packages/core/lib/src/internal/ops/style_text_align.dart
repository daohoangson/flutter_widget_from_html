part of '../core_ops.dart';

const kAttributeAlign = 'align';

const kCssTextAlign = 'text-align';
const kCssTextAlignCenter = 'center';
const kCssTextAlignEnd = 'end';
const kCssTextAlignJustify = 'justify';
const kCssTextAlignLeft = 'left';
const kCssTextAlignMozCenter = '-moz-center';
const kCssTextAlignRight = 'right';
const kCssTextAlignStart = 'start';
const kCssTextAlignWebkitCenter = '-webkit-center';

const kTagCenter = 'center';

class StyleTextAlign {
  BuildOp get buildOp => BuildOp(
        debugLabel: kCssTextAlign,
        mustBeBlock: false,
        onParsed: (tree) {
          final textAlign = _parse(tree);
          if (textAlign != null) {
            tree.apply(_textAlign, textAlign);
          }
          return tree;
        },
        onRenderBlock: (tree, placeholder) {
          if (!placeholder.isEmpty &&
              tree[kCssTextAlign]?.term == kCssTextAlignWebkitCenter) {
            return placeholder.wrapWith(_center);
          } else {
            return null;
          }
        },
        priority: Early.cssTextAlign,
      );

  static Widget _center(BuildContext _, Widget child) =>
      Center(heightFactor: 1.0, child: child);

  static TextAlign? _parse(BuildTree tree) {
    TextAlign? textAlign;

    switch (tree[kCssTextAlign]?.term) {
      case kCssTextAlignCenter:
      case kCssTextAlignMozCenter:
      case kCssTextAlignWebkitCenter:
        textAlign = TextAlign.center;
        break;
      case kCssTextAlignEnd:
        textAlign = TextAlign.end;
        break;
      case kCssTextAlignJustify:
        textAlign = TextAlign.justify;
        break;
      case kCssTextAlignLeft:
        textAlign = TextAlign.left;
        break;
      case kCssTextAlignRight:
        textAlign = TextAlign.right;
        break;
      case kCssTextAlignStart:
        textAlign = TextAlign.start;
        break;
    }

    return textAlign;
  }

  static HtmlStyle _textAlign(HtmlStyle style, TextAlign value) =>
      style.copyWith(textAlign: value);
}
