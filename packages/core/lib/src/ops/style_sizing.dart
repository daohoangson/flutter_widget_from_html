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

          if (widget != null) widget.wrapWith(_build, input);
          return pieces;
        },
        onWidgets: (meta, widgets) {
          final input = _parse(meta);
          if (input == null) return widgets;

          return [
            WidgetPlaceholder(
              builder: _build,
              children: widgets,
              input: input,
            )
          ];
        },
        priority: 50000,
      );

  Iterable<Widget> _build(BuildContext context, Iterable<Widget> children,
      _StyleSizingInput input) {
    final child = wf.buildColumn(children);
    if (child == null) return null;

    final tsb = input.meta.tsb;

    return [
      CssSizing(
        child: child,
        height: input.height?.getValue(context, tsb),
        maxHeight: input.maxHeight?.getValue(context, tsb),
        maxWidth: input.maxWidth?.getValue(context, tsb),
        minHeight: input.minHeight?.getValue(context, tsb),
        minWidth: input.minWidth?.getValue(context, tsb),
        width: input.width?.getValue(context, tsb),
      )
    ];
  }

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
      meta,
      height: height,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
      minHeight: minHeight,
      minWidth: minWidth,
      width: width,
    );
  }
}

@immutable
class _StyleSizingInput {
  final CssLength height;
  final CssLength maxHeight;
  final CssLength maxWidth;
  final NodeMetadata meta;
  final CssLength minHeight;
  final CssLength minWidth;
  final CssLength width;

  _StyleSizingInput(
    this.meta, {
    this.height,
    this.maxHeight,
    this.maxWidth,
    this.minHeight,
    this.minWidth,
    this.width,
  });
}
