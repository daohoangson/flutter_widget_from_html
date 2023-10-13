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

extension StyleTextAlign on WidgetFactory {
  BuildOp get styleTextAlign => const BuildOp.v2(
        alwaysRenderBlock: false,
        debugLabel: kCssTextAlign,
        onParsed: _onParsed,
        onRenderBlock: _onRenderBlock,
        priority: Early.cssTextAlign,
      );

  static Widget _center(BuildContext _, Widget child) =>
      Center(heightFactor: 1.0, child: child);

  static BuildTree _onParsed(BuildTree tree) {
    final textAlign = tree.textAlignData.textAlign;
    if (textAlign != null) {
      tree.styleBuilder.enqueue(_textAlign, textAlign);
    }
    return tree;
  }

  static Widget _onRenderBlock(BuildTree tree, WidgetPlaceholder placeholder) {
    if (placeholder.isEmpty ||
        tree.textAlignData.term != kCssTextAlignWebkitCenter) {
      return placeholder;
    }

    return placeholder.wrapWith(_center);
  }

  static HtmlStyle _textAlign(HtmlStyle style, TextAlign value) =>
      style.copyWith(value: value);
}

extension on BuildTree {
  _StyleTextAlignData get textAlignData {
    final existing = value<_StyleTextAlignData>();
    if (existing != null) {
      return existing;
    }

    final newData = _parse(this);
    value(newData);
    return newData;
  }

  static _StyleTextAlignData _parse(BuildTree tree) {
    final term = tree.getStyle(kCssTextAlign)?.term;
    if (term == null) {
      return const _StyleTextAlignData(null, null);
    }

    TextAlign? textAlign;
    switch (term) {
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

    return _StyleTextAlignData(term, textAlign);
  }
}

@immutable
class _StyleTextAlignData {
  final String? term;
  final TextAlign? textAlign;
  const _StyleTextAlignData(this.term, this.textAlign);
}
