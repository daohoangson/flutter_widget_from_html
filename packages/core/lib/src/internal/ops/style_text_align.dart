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
  late final BuildOp op;
  final WidgetFactory wf;
  final String value;

  StyleTextAlign(this.wf, this.value) {
    op = BuildOp(
      onTree: _onTree,
      onWidgets: _onWidgets,
      onWidgetsIsOptional: true,
      priority: 0,
    );
  }

  void _onTree(BuildMetadata meta, BuildTree _) =>
      meta.tsb.enqueue(_tsb, value);

  Iterable<Widget> _onWidgets(BuildMetadata _, Iterable<Widget> widgets) {
    switch (value) {
      case kCssTextAlignCenter:
      case kCssTextAlignEnd:
      case kCssTextAlignJustify:
      case kCssTextAlignLeft:
      case kCssTextAlignRight:
        return widgets.map(_toStretchWidth);
      case kCssTextAlignMozCenter:
      case kCssTextAlignWebkitCenter:
        return widgets.map(_toCenter);
    }

    return widgets;
  }

  static Widget _toCenter(Widget w) =>
      WidgetPlaceholder.lazy(w).wrapWith(_toCenterBuilder);

  static Widget _toCenterBuilder(BuildContext _, Widget w) =>
      _TextAlignCenter(w);

  static Widget _toStretchWidth(Widget w) =>
      WidgetPlaceholder.lazy(w).wrapWith(_toStretchWidthBuilder);

  static Widget _toStretchWidthBuilder(BuildContext _, Widget w) =>
      _TextAlignStretchWidth(w);

  static TextStyleHtml _tsb(TextStyleHtml tsh, String value) {
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

    return textAlign == null ? tsh : tsh.copyWith(textAlign: textAlign);
  }
}

class _TextAlignCenter extends Center {
  const _TextAlignCenter(Widget child, {Key? key})
      : super(child: child, heightFactor: 1.0, key: key);
}

class _TextAlignStretchWidth extends ConstraintsTransformBox {
  const _TextAlignStretchWidth(Widget child, {Key? key})
      : super(constraintsTransform: transform, child: child, key: key);

  static BoxConstraints transform(BoxConstraints bc) =>
      bc.copyWith(minWidth: bc.hasBoundedWidth ? bc.maxWidth : null);
}
