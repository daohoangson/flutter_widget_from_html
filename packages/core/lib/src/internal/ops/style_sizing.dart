part of '../core_ops.dart';

const kCssHeight = 'height';
const kCssMaxHeight = 'max-height';
const kCssMaxWidth = 'max-width';
const kCssMinHeight = 'min-height';
const kCssMinWidth = 'min-width';
const kCssWidth = 'width';

class StyleSizing {
  static const kPriority = 50000;

  final WidgetFactory wf;

  StyleSizing(this.wf);

  BuildOp get buildOp => BuildOp(
        onTree: (meta, tree) {
          if (meta.willBuildSubtree) return;

          final input = _parse(meta);
          if (input == null) return;

          WidgetPlaceholder widget;
          for (final b in tree.bits) {
            if (b is WidgetBit) {
              if (widget != null) return;
              widget = b.child;
            } else {
              return;
            }
          }

          widget?.wrapWith((c, w) => _build(c, w, input, meta.tsb()));
        },
        onWidgets: (meta, widgets) {
          if (!meta.willBuildSubtree) return widgets;

          final input = _parse(meta);
          if (input == null) return widgets;
          return listOrNull(wf
              .buildColumnPlaceholder(meta, widgets)
              ?.wrapWith((c, w) => _build(c, w, input, meta.tsb())));
        },
        onWidgetsIsOptional: true,
        priority: kPriority,
      );

  _StyleSizingInput _parse(BuildMetadata meta) {
    CssLength height, maxHeight, maxWidth, minHeight, minWidth, width;
    bool isBlock;

    for (final style in meta.styles) {
      switch (style.key) {
        case kCssDisplay:
          isBlock = style.value == kCssDisplayBlock;
          break;
        case kCssHeight:
          height = tryParseCssLength(style.value);
          break;
        case kCssMaxHeight:
          maxHeight = tryParseCssLength(style.value);
          break;
        case kCssMaxWidth:
          maxWidth = tryParseCssLength(style.value);
          break;
        case kCssMinHeight:
          minHeight = tryParseCssLength(style.value);
          break;
        case kCssMinWidth:
          minWidth = tryParseCssLength(style.value);
          break;
        case kCssWidth:
          width = tryParseCssLength(style.value);
          break;
      }
    }

    if (isBlock == true) width ??= _StyleSizingInput.blockWidth;

    if (height == null &&
        maxHeight == null &&
        maxWidth == null &&
        minHeight == null &&
        minWidth == null &&
        width == null) return null;

    return _StyleSizingInput(
      height: height,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
      minHeight: minHeight,
      minWidth: minWidth,
      width: width,
    );
  }

  static Widget _build(BuildContext context, Widget child,
      _StyleSizingInput input, TextStyleBuilder tsb) {
    final tsh = tsb.build(context);

    if (input.maxHeight == null &&
        input.maxWidth == null &&
        input.minHeight == null &&
        input.minWidth == null &&
        input.height == null &&
        input.width == _StyleSizingInput.blockWidth) {
      if (child is CssBlock) return child;
      return CssBlock(child: child);
    }

    return CssSizing(
      child: child,
      maxHeight: _getValue(input.maxHeight, tsh),
      maxWidth: _getValue(input.maxWidth, tsh),
      minHeight: _getValue(input.minHeight, tsh),
      minWidth: _getValue(input.minWidth, tsh),
      preferredHeight: _getValue(input.height, tsh),
      preferredWidth: _getValue(input.width, tsh),
    );
  }

  static CssSizingValue _getValue(CssLength length, TextStyleHtml tsh) {
    if (length == null) return null;

    final value = length.getValue(tsh);
    if (value != null) return CssSizingValue.value(value);

    if (length.unit != CssLengthUnit.percentage) return null;
    return CssSizingValue.percentage(length.number);
  }
}

@immutable
class _StyleSizingInput {
  final CssLength height;
  final CssLength maxHeight;
  final CssLength maxWidth;
  final CssLength minHeight;
  final CssLength minWidth;
  final CssLength width;

  static const CssLength blockWidth = CssLength(100, CssLengthUnit.percentage);

  _StyleSizingInput({
    this.height,
    this.maxHeight,
    this.maxWidth,
    this.minHeight,
    this.minWidth,
    this.width,
  });
}
