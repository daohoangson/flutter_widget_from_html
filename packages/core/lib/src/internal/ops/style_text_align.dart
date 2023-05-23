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
  final String value;

  StyleTextAlign(this.value);

  BuildOp get buildOp => BuildOp(
        debugLabel: kCssTextAlign,
        mustBeBlock: false,
        onRenderBlock: (tree, placeholder) {
          tree.apply(_builder, value);

          if (!placeholder.isEmpty && value == kCssTextAlignWebkitCenter) {
            return placeholder.wrapWith(_center);
          } else {
            return null;
          }
        },
        onRenderInline: (tree) => tree.apply(_builder, value),
        priority: Early.cssTextAlign,
      );

  static Widget _center(BuildContext _, Widget child) =>
      Center(heightFactor: 1.0, child: child);

  static HtmlStyle _builder(HtmlStyle style, String value) {
    TextAlign? textAlign;

    switch (value) {
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

    return textAlign == null ? style : style.copyWith(textAlign: textAlign);
  }
}
