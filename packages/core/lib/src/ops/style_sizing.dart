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
        onWidgets: (meta, widgets) {
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
              width == null) return widgets;

          return [
            WidgetPlaceholder(
              builder: _build,
              children: widgets,
              input: _StyleSizingInput(
                meta,
                height: height,
                maxHeight: maxHeight,
                maxWidth: maxWidth,
                minHeight: minHeight,
                minWidth: minWidth,
                width: width,
              ),
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
    final height = input.height?.getValue(context, tsb);
    final maxHeight = input.maxHeight?.getValue(context, tsb);
    final maxWidth = input.maxWidth?.getValue(context, tsb);
    final minHeight = input.minHeight?.getValue(context, tsb);
    final minWidth = input.minWidth?.getValue(context, tsb);
    final width = input.width?.getValue(context, tsb);

    return [
      LayoutBuilder(
        builder: (_, bc) => _renderAspectRatio(bc, height, width)
            ? AspectRatio(
                aspectRatio: width / height,
                child: child,
              )
            : UnconstrainedBox(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: height ?? maxHeight ?? double.infinity,
                    maxWidth: width ?? maxWidth ?? double.infinity,
                    minHeight: height ?? minHeight ?? 0,
                    minWidth: width ?? minWidth ?? 0,
                  ),
                  child: child,
                ),
                alignment: Alignment.topLeft,
              ),
      ),
    ];
  }

  static bool _renderAspectRatio(BoxConstraints bc, double h, double w) {
    if (h == null || w == null || h == 0) return false;

    final b = bc.biggest;
    if (b.height.isFinite && h > b.height) {
      return true;
    }

    if (b.width.isFinite && w > b.width) {
      return true;
    }

    return false;
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
