part of '../core_ops.dart';

const kCssHeight = 'height';
const kCssMaxHeight = 'max-height';
const kCssMaxWidth = 'max-width';
const kCssMinHeight = 'min-height';
const kCssMinWidth = 'min-width';
const kCssWidth = 'width';

extension CssLengthToSizing on CssLength {
  CssSizingValue? getSizing(TextStyleHtml tsh) {
    final value = getValue(tsh);
    if (value != null) {
      return CssSizingValue.value(value);
    }

    switch (unit) {
      case CssLengthUnit.auto:
        return const CssSizingValue.auto();
      case CssLengthUnit.percentage:
        return CssSizingValue.percentage(number);
      default:
        return null;
    }
  }
}

class StyleSizing {
  static const kPriorityBoxModel3k = 3000;

  final BuildMetadata meta;
  late final BuildOp op;
  final WidgetFactory wf;

  static final _isBlock = Expando<bool>();
  static final _skipBuilding = Expando<bool>();
  static final _customInstances = Expando<StyleSizing>();

  factory StyleSizing(WidgetFactory wf, BuildMetadata meta) {
    final existingInstance = _customInstances[meta];
    if (existingInstance != null) {
      return existingInstance;
    }
    return _customInstances[meta] = StyleSizing._(wf, meta);
  }

  StyleSizing._(this.wf, this.meta) {
    op = _StyleSizingOp(
      meta,
      onChild: (childMeta) {
        if (!identical(childMeta.element.parent, meta.element)) {
          return;
        }

        childMeta.register(
          BuildOp(
            onWidgets: (meta, widgets) {
              final parsed = _parse(meta);
              if (parsed == null ||
                  (parsed.minWidth == null && parsed.preferredWidth == null)) {
                return widgets;
              }

              // this element has some width contraints applied
              // we should reset things back to normal for its children
              final placeholder = wf.buildColumnPlaceholder(meta, widgets);
              placeholder?.wrapWith(
                (context, child) {
                  final textDirection = meta.tsb.build(context).textDirection;
                  return ConstraintsTransformBox(
                    alignment: textDirection == TextDirection.ltr
                        ? Alignment.topLeft
                        : Alignment.topRight,
                    constraintsTransform: (bc) => bc.copyWith(minWidth: 0),
                    child: child,
                  );
                },
              );
              return listOrNull(placeholder);
            },
            onWidgetsIsOptional: true,
            priority: 0,
          ),
        );
      },
      onTreeFlattening: (meta, tree) {
        if (_skipBuilding[meta] == true) {
          return;
        }

        final parsed = _parse(meta);
        if (parsed == null) {
          return;
        }

        WidgetPlaceholder? widget;
        for (final b in tree.bits) {
          if (b is WidgetBit) {
            if (widget != null) {
              return;
            }
            widget = b.child;
          } else {
            return;
          }
        }

        widget?.wrapWith((c, w) => _build(c, w, parsed, meta.tsb));
      },
      onWidgets: (meta, widgets) {
        if (_skipBuilding[meta] == true || widgets.isEmpty) {
          return widgets;
        }

        final parsed = _parse(meta);
        if (parsed == null) {
          return widgets;
        }

        return listOrNull(
          wf
              .buildColumnPlaceholder(meta, widgets)
              ?.wrapWith((c, w) => _build(c, w, parsed, meta.tsb)),
        );
      },
    );
  }

  factory StyleSizing.block(WidgetFactory wf, BuildMetadata meta) {
    _isBlock[meta] = true;
    return StyleSizing(wf, meta);
  }

  _StyleSizingInput? _parse(BuildMetadata meta) {
    CssLength? maxHeight;
    CssLength? maxWidth;
    CssLength? minHeight;
    CssLength? minWidth;
    Axis? preferredAxis;
    CssLength? preferredHeight;
    CssLength? preferredWidth;

    for (final style in meta.styles) {
      final value = style.value;
      if (value == null) {
        continue;
      }

      switch (style.property) {
        case kCssHeight:
          final parsedHeight = tryParseCssLength(value);
          if (parsedHeight != null) {
            preferredAxis = Axis.vertical;
            preferredHeight = parsedHeight;
          }
          break;
        case kCssMaxHeight:
          maxHeight = tryParseCssLength(value) ?? maxHeight;
          break;
        case kCssMaxWidth:
          maxWidth = tryParseCssLength(value) ?? maxWidth;
          break;
        case kCssMinHeight:
          minHeight = tryParseCssLength(value) ?? minHeight;
          break;
        case kCssMinWidth:
          minWidth = tryParseCssLength(value) ?? minWidth;
          break;
        case kCssWidth:
          final parsedWidth = tryParseCssLength(value);
          if (parsedWidth != null) {
            preferredAxis = Axis.horizontal;
            preferredWidth = parsedWidth;
          }
          break;
      }
    }

    if (preferredWidth == null && _isBlock[meta] == true) {
      // `display: block` implies a 100% width
      // but it MUST NOT reset width value if specified
      // we need to keep track of block width to calculate contraints correctly
      preferredWidth = const CssLength(100, CssLengthUnit.percentage);
      preferredAxis ??= Axis.horizontal;
    }

    if (maxHeight == null &&
        maxWidth == null &&
        minHeight == null &&
        minWidth == null &&
        preferredHeight == null &&
        preferredWidth == null) {
      return null;
    }

    return _StyleSizingInput(
      maxHeight: maxHeight,
      maxWidth: maxWidth,
      minHeight: minHeight,
      minWidth: minWidth,
      preferredAxis: preferredAxis,
      preferredHeight: preferredHeight,
      preferredWidth: preferredWidth,
    );
  }

  static void skip(BuildMetadata meta) {
    assert(_skipBuilding[meta] != true, 'Built ${meta.element} already');
    _skipBuilding[meta] = true;
  }

  static Widget _build(
    BuildContext context,
    Widget child,
    _StyleSizingInput input,
    TextStyleBuilder tsb,
  ) {
    final tsh = tsb.build(context);

    return CssSizing(
      maxHeight: input.maxHeight?.getSizing(tsh),
      maxWidth: input.maxWidth?.getSizing(tsh),
      minHeight: input.minHeight?.getSizing(tsh),
      minWidth: input.minWidth?.getSizing(tsh),
      preferredAxis: input.preferredAxis,
      preferredHeight: input.preferredHeight?.getSizing(tsh),
      preferredWidth: input.preferredWidth?.getSizing(tsh),
      child: child,
    );
  }
}

class _StyleSizingOp extends BuildOp {
  final BuildMetadata meta;

  const _StyleSizingOp(
    this.meta, {
    required void Function(BuildMetadata meta) onChild,
    required void Function(BuildMetadata meta, BuildTree tree) onTreeFlattening,
    required Iterable<Widget>? Function(
      BuildMetadata meta,
      Iterable<WidgetPlaceholder> widgets,
    )
        onWidgets,
  }) : super(
          onChild: onChild,
          onTreeFlattening: onTreeFlattening,
          onWidgets: onWidgets,
          priority: StyleSizing.kPriorityBoxModel3k,
        );

  @override
  bool get onWidgetsIsOptional {
    // an element is inline unless specified otherwise
    final isBlock = StyleSizing._isBlock[meta] ?? false;
    // `onWidgets` callback is optional unless it's a block element
    return !isBlock;
  }
}

@immutable
class _StyleSizingInput {
  final CssLength? maxHeight;
  final CssLength? maxWidth;
  final CssLength? minHeight;
  final CssLength? minWidth;
  final Axis? preferredAxis;
  final CssLength? preferredHeight;
  final CssLength? preferredWidth;

  const _StyleSizingInput({
    this.maxHeight,
    this.maxWidth,
    this.minHeight,
    this.minWidth,
    this.preferredAxis,
    this.preferredHeight,
    this.preferredWidth,
  });
}
