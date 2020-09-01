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

  BuildOp get op => BuildOp(
      isBlockElement: false,
      onTree: (meta, tree) {
        final textAlign = _tryParse(value);
        if (textAlign != null) {
          meta.tsb(_tsb, textAlign);
        }
      },
      onWidgets: (meta, widgets) {
        if (!meta.isBlockElement) return widgets;

        if (value != kCssTextAlignMozCenter &&
            value != kCssTextAlignWebkitCenter) return widgets;

        return listOrNull(wf
            .buildColumnPlaceholder(meta, widgets)
            .wrapWith((_, child) => wf.buildCenter(meta, child)));
      });

  static TextAlign _tryParse(String value) {
    switch (value) {
      case kCssTextAlignCenter:
      case kCssTextAlignMozCenter:
      case kCssTextAlignWebkitCenter:
        return TextAlign.center;
      case kCssTextAlignEnd:
        return TextAlign.end;
      case kCssTextAlignJustify:
        return TextAlign.justify;
      case kCssTextAlignLeft:
        return TextAlign.left;
      case kCssTextAlignRight:
        return TextAlign.right;
      case kCssTextAlignStart:
        return TextAlign.start;
    }

    return null;
  }

  static TextStyleHtml _tsb(TextStyleHtml tsb, TextAlign textAlign) =>
      tsb.copyWith(textAlign: textAlign);
}
