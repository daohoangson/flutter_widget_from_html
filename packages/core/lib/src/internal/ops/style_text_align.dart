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

  BuildOp get buildOp => BuildOp(
        onTree: (tree) => tree.apply(_builder, value),
        onWidgets: (_, widgets) => _onWidgets(widgets, value),
        onWidgetsIsOptional: true,
        priority: 0,
      );

  static Iterable<Widget> _onWidgets(Iterable<Widget> widgets, String value) {
    switch (value) {
      case kCssTextAlignCenter:
      case kCssTextAlignEnd:
      case kCssTextAlignJustify:
      case kCssTextAlignLeft:
      case kCssTextAlignRight:
        return widgets
            .map((child) => WidgetPlaceholder.lazy(child).wrapWith(_block));
      case kCssTextAlignMozCenter:
      case kCssTextAlignWebkitCenter:
        return widgets
            .map((child) => WidgetPlaceholder.lazy(child).wrapWith(_center));
    }

    return widgets;
  }

  static Widget _block(BuildContext _, Widget child) =>
      child is CssBlock ? child : CssBlock(child: child);

  static Widget _center(BuildContext _, Widget child) =>
      _TextAlignCenter(child);

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

class _TextAlignCenter extends Center {
  const _TextAlignCenter(Widget child, {Key? key})
      : super(child: child, heightFactor: 1.0, key: key);
}
