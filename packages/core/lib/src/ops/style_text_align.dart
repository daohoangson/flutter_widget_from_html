part of '../core_widget_factory.dart';

const _kAttributeAlign = 'align';
const _kCssTextAlign = 'text-align';
const _kCssTextAlignCenter = 'center';
const _kCssTextAlignJustify = 'justify';
const _kCssTextAlignLeft = 'left';
const _kCssTextAlignRight = 'right';

class _StyleTextAlign {
  static TextAlign tryParse(String value) {
    switch (value) {
      case _kCssTextAlignCenter:
        return TextAlign.center;
      case _kCssTextAlignJustify:
        return TextAlign.justify;
      case _kCssTextAlignLeft:
        return TextAlign.left;
      case _kCssTextAlignRight:
        return TextAlign.right;
    }

    return null;
  }

  static TextStyleHtml _tsb(BuildContext _, TextStyleHtml p, TextAlign v) =>
      p.copyWith(align: v);
}
