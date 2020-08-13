part of '../core_widget_factory.dart';

const _kCssHeight = 'height';
const _kCssMaxHeight = 'max-height';
const _kCssMaxWidth = 'max-width';
const _kCssMinHeight = 'min-height';
const _kCssMinWidth = 'min-width';
const _kCssWidth = 'width';

class _StyleSizing {
  final WidgetFactory wf;

  _StyleSizing(this.wf);

  BuildOp get buildOp => BuildOp(
        isBlockElement: false,
        onPieces: (meta, pieces) {
          if (meta.isBlockElement) return pieces;

          final input = _parse(meta);
          if (input == null) return pieces;

          WidgetPlaceholder widget;
          for (final p in pieces) {
            if (p.hasWidgets) {
              for (final w in p.widgets) {
                if (widget != null) return pieces;
                widget = w;
              }
            } else {
              for (final b in p.text?.bits) {
                if (b is TextWidget) {
                  if (widget != null) return pieces;
                  widget = b.widget;
                } else {
                  return pieces;
                }
              }
            }
          }

          widget?.wrapWith((child) => _build(child, input, meta.tsb()));
          return pieces;
        },
        onWidgets: (meta, widgets) {
          final input = _parse(meta);
          if (input == null) return widgets;
          return _listOrNull(wf
              .buildColumnPlaceholder(widgets)
              ?.wrapWith((child) => _build(child, input, meta.tsb())));
        },
        priority: 50000,
      );

  _StyleSizingInput _parse(NodeMetadata meta) {
    CssLength height, maxHeight, maxWidth, minHeight, minWidth, width;
    for (final x in meta.styleEntries) {
      switch (x.key) {
        case _kCssHeight:
          height = wf.parseCssLength(x.value);
          break;
        case _kCssMaxHeight:
          maxHeight = wf.parseCssLength(x.value);
          break;
        case _kCssMaxWidth:
          maxWidth = wf.parseCssLength(x.value);
          break;
        case _kCssMinHeight:
          minHeight = wf.parseCssLength(x.value);
          break;
        case _kCssMinWidth:
          minWidth = wf.parseCssLength(x.value);
          break;
        case _kCssWidth:
          width = wf.parseCssLength(x.value);
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

  static Widget _build(
          Widget child, _StyleSizingInput input, TextStyleBuilder tsb) =>
      Builder(builder: (context) {
        final constraints = BoxConstraints(
          maxHeight: input.maxHeight?.getValue(context, tsb) ?? double.infinity,
          maxWidth: input.maxWidth?.getValue(context, tsb) ?? double.infinity,
          minHeight: input.minHeight?.getValue(context, tsb) ?? 0,
          minWidth: input.minWidth?.getValue(context, tsb) ?? 0,
        );
        final size = Size(
          input.width?.getValue(context, tsb) ?? double.infinity,
          input.height?.getValue(context, tsb) ?? double.infinity,
        );
        return CssSizing(child: child, constraints: constraints, size: size);
      });
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
