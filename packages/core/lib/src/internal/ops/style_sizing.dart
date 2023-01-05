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

  late final BuildOp op;
  final WidgetFactory wf;

  static final _elementMeta = Expando<BuildMetadata>();
  static final _instances = Expando<StyleSizing>();
  static final _metaIsBlock = Expando<bool>();
  static final _metaParsedInput = Expando<_StyleSizingInput>();
  static final _skipBuilding = Expando<bool>();

  factory StyleSizing(WidgetFactory wf, BuildMetadata meta) {
    _elementMeta[meta.element] = meta;
    final existingInstance = _instances[wf];
    if (existingInstance != null) {
      return existingInstance;
    }
    return _instances[wf] = StyleSizing._(wf);
  }

  StyleSizing._(this.wf) {
    op = _StyleSizingOp(
      onChild: (childMeta) {
        final parentElement = childMeta.element.parent;
        if (parentElement == null) {
          return;
        }
        final parentMeta = _elementMeta[parentElement];
        if (parentMeta == null) {
          // parent element is not a sizing element, nothing to do here
          return;
        }

        childMeta.register(
          BuildOp(
            onWidgets: (meta, widgets) {
              final parentInput = _tryParseInput(parentMeta);
              if (parentInput == null ||
                  (parentInput.minWidth == null &&
                      parentInput.preferredWidth == null)) {
                return widgets;
              }

              // the parent element has some width contraints applied
              // we should reset things back to normal for this child
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

        final input = _tryParseInput(meta);
        if (input == null) {
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

        widget?.wrapWith((c, w) => _build(c, w, input, meta.tsb));
      },
      onWidgets: (meta, widgets) {
        if (_skipBuilding[meta] == true || widgets.isEmpty) {
          return widgets;
        }

        final input = _tryParseInput(meta);
        if (input == null) {
          return widgets;
        }

        return listOrNull(
          wf
              .buildColumnPlaceholder(meta, widgets)
              ?.wrapWith((c, w) => _build(c, w, input, meta.tsb)),
        );
      },
    );
  }

  factory StyleSizing.block(WidgetFactory wf, BuildMetadata meta) {
    _metaIsBlock[meta] = true;
    return StyleSizing(wf, meta);
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

  static _StyleSizingInput _parseInput(BuildMetadata meta) {
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

    if (preferredWidth == null && _metaIsBlock[meta] == true) {
      // `display: block` implies a 100% width
      // but it MUST NOT reset width value if specified
      // we need to keep track of block width to calculate contraints correctly
      preferredWidth = const CssLength(100, CssLengthUnit.percentage);
      preferredAxis ??= Axis.horizontal;
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

  static _StyleSizingInput? _tryParseInput(BuildMetadata meta) {
    var parsed = _metaParsedInput[meta];
    if (parsed == null) {
      _metaParsedInput[meta] = parsed = _parseInput(meta);
    }

    if (parsed.maxHeight == null &&
        parsed.maxWidth == null &&
        parsed.minHeight == null &&
        parsed.minWidth == null &&
        parsed.preferredHeight == null &&
        parsed.preferredWidth == null) {
      return null;
    }

    return parsed;
  }
}

class _StyleSizingOp extends BuildOp {
  const _StyleSizingOp({
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
  bool shouldBuildSubTreeAsBlocks(BuildMetadata meta) {
    // an element is inline unless specified otherwise
    return StyleSizing._metaIsBlock[meta] ?? false;
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
