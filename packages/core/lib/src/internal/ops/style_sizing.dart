part of '../core_ops.dart';

const kCssHeight = 'height';
const kCssMaxHeight = 'max-height';
const kCssMaxWidth = 'max-width';
const kCssMinHeight = 'min-height';
const kCssMinWidth = 'min-width';
const kCssWidth = 'width';

class StyleSizing {
  final WidgetFactory wf;

  StyleSizing(this.wf);

  BuildOp get buildOp => BuildOp(
        isBlockElement: false,
        onPieces: (meta, pieces) {
          if (meta.isBlockElement) return pieces;

          final input = _parse(meta);
          if (input == null) return pieces;

          WidgetPlaceholder widget;
          for (final p in pieces) {
            if (p.widgets != null) {
              for (final w in p.widgets) {
                if (widget != null) return pieces;
                widget = w;
              }
            } else {
              for (final b in p.text?.bits) {
                if (b is TextWidget) {
                  if (widget != null) return pieces;
                  widget = b.child;
                } else {
                  return pieces;
                }
              }
            }
          }

          widget?.wrapWith((c, w) => _build(c, w, input, meta.tsb()));
          return pieces;
        },
        onWidgets: (meta, widgets) {
          final input = _parse(meta);
          if (input == null) return widgets;
          return listOrNull(wf
              .buildColumnPlaceholder(meta, widgets)
              ?.wrapWith((c, w) => _build(c, w, input, meta.tsb())));
        },
        priority: 50000,
      );

  _StyleSizingInput _parse(BuildMetadata meta) {
    CssLength height, maxHeight, maxWidth, minHeight, minWidth, width;

    for (final style in meta.styles) {
      switch (style.key) {
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
    final constraints = BoxConstraints(
      maxHeight: input.maxHeight?.getValue(tsh) ?? double.infinity,
      maxWidth: input.maxWidth?.getValue(tsh) ?? double.infinity,
      minHeight: input.minHeight?.getValue(tsh) ?? 0,
      minWidth: input.minWidth?.getValue(tsh) ?? 0,
    );
    final size = Size(
      input.width?.getValue(tsh) ?? double.infinity,
      input.height?.getValue(tsh) ?? double.infinity,
    );
    return CssSizing(child: child, constraints: constraints, size: size);
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

  _StyleSizingInput({
    this.height,
    this.maxHeight,
    this.maxWidth,
    this.minHeight,
    this.minWidth,
    this.width,
  });
}
