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
  final WidgetFactory wf;
  final String value;

  StyleTextAlign(this.wf, this.value);

  BuildOp get op => BuildOp(onTree: (meta, _) => meta.tsb(_tsb, value));

  static TextStyleHtml _tsb(TextStyleHtml tsh, String value) {
    CrossAxisAlignment crossAxisAlignment;
    TextAlign textAlign;

    switch (value) {
      case kCssTextAlignCenter:
        crossAxisAlignment = CrossAxisAlignment.stretch;
        textAlign = TextAlign.center;
        break;
      case kCssTextAlignMozCenter:
      case kCssTextAlignWebkitCenter:
        crossAxisAlignment = CrossAxisAlignment.center;
        textAlign = TextAlign.center;
        break;
      case kCssTextAlignEnd:
        crossAxisAlignment = CrossAxisAlignment.stretch;
        textAlign = TextAlign.end;
        break;
      case kCssTextAlignJustify:
        crossAxisAlignment = CrossAxisAlignment.stretch;
        textAlign = TextAlign.justify;
        break;
      case kCssTextAlignLeft:
        crossAxisAlignment = CrossAxisAlignment.stretch;
        textAlign = TextAlign.left;
        break;
      case kCssTextAlignRight:
        crossAxisAlignment = CrossAxisAlignment.stretch;
        textAlign = TextAlign.right;
        break;
      case kCssTextAlignStart:
        crossAxisAlignment = CrossAxisAlignment.start;
        textAlign = TextAlign.start;
        break;
    }

    if (crossAxisAlignment == null && textAlign == null) return tsh;
    return tsh.copyWith(
      crossAxisAlignment: crossAxisAlignment,
      textAlign: textAlign,
    );
  }
}
