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
  static const k100percent = CssLength(100, CssLengthUnit.percentage);
  static const kPriorityBoxModel3k = 3000;

  late final BuildOp opBlock;
  late final BuildOp opChild;
  late final BuildOp opSizing;
  final WidgetFactory wf;

  static final _instances = Expando<StyleSizing>();
  static final _elementMeta = Expando<BuildMetadata>();
  static final _metaIsBlock = Expando<bool>();
  static final _skipBuilding = Expando<bool>();

  static void registerBlock(WidgetFactory wf, BuildMetadata meta) {
    _elementMeta[meta.element] = meta;
    _metaIsBlock[meta] = true;

    final instance = StyleSizing._factory(wf);
    meta
      ..register(instance.opBlock)
      ..register(instance.opSizing);
  }

  static void registerChild(WidgetFactory wf, BuildMetadata meta) {
    final parentElement = meta.element.parent;
    if (parentElement == null || _elementMeta[parentElement] == null) {
      return;
    }

    meta.register(StyleSizing._factory(wf).opChild);
  }

  static void registerSizing(WidgetFactory wf, BuildMetadata meta) {
    _elementMeta[meta.element] = meta;
    meta.register(StyleSizing._factory(wf).opSizing);
  }

  factory StyleSizing._factory(WidgetFactory wf) {
    final existingInstance = _instances[wf];
    if (existingInstance != null) {
      return existingInstance;
    }
    return _instances[wf] = StyleSizing._(wf);
  }

  StyleSizing._(this.wf) {
    opBlock = const BuildOp(onWidgets: bypass);

    opChild = BuildOp(
      onWidgets: buildMinWidthZero,
      onWidgetsIsOptional: true,
      // min-width resetter should wrap all other box model widgets
      priority: StyleMargin.kPriorityBoxModel9k + 1,
    );

    opSizing = BuildOp(
      onTreeFlattening: handleInlineSizing,
      onWidgets: buildCssSizing,
      onWidgetsIsOptional: true,
      priority: StyleSizing.kPriorityBoxModel3k,
    );
  }

  Iterable<Widget>? buildCssSizing(
    BuildMetadata meta,
    Iterable<WidgetPlaceholder> widgets,
  ) {
    if (_skipBuilding[meta] == true || widgets.isEmpty) {
      return widgets;
    }

    final input = _StyleSizingInput.tryParse(meta);
    if (input == null) {
      return widgets;
    }

    return listOrNull(
      wf
          .buildColumnPlaceholder(meta, widgets)
          ?.wrapWith((c, w) => _build(c, w, input, meta.tsb)),
    );
  }

  Iterable<Widget>? buildMinWidthZero(
    BuildMetadata childMeta,
    Iterable<WidgetPlaceholder> widgets,
  ) {
    if (_StyleSizingInput.tryParse(childMeta)?.preferredWidth == k100percent) {
      return widgets;
    }

    final parentElement = childMeta.element.parent;
    if (parentElement == null) {
      return widgets;
    }

    final parentMeta = _elementMeta[parentElement];
    if (parentMeta == null) {
      return widgets;
    }

    final parentInput = _StyleSizingInput.tryParse(parentMeta);
    if (parentInput == null ||
        (parentInput.minWidth == null && parentInput.preferredWidth == null)) {
      return widgets;
    }

    return listOrNull(
      wf.buildColumnPlaceholder(childMeta, widgets)?.wrapWith(
        (context, child) {
          final textDirection = childMeta.tsb.build(context).textDirection;
          return _MinWidthZero(
            textDirection: textDirection,
            child: child,
          );
        },
      ),
    );
  }

  static Iterable<Widget>? bypass(
    BuildMetadata _,
    Iterable<WidgetPlaceholder> widgets,
  ) =>
      widgets;

  static void handleInlineSizing(BuildMetadata meta, BuildTree tree) {
    if (_skipBuilding[meta] == true) {
      return;
    }

    final input = _StyleSizingInput.tryParse(meta);
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
    if (input.maxHeight == null &&
        input.maxWidth == null &&
        input.minHeight == null &&
        input.minWidth == null &&
        input.preferredHeight == null &&
        input.preferredWidth == StyleSizing.k100percent) {
      if (child is CssBlock) {
        // deduplicate whenever possible
        return child;
      }

      return CssBlock(child: child);
    }

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

class _MinWidthZero extends ConstraintsTransformBox {
  const _MinWidthZero({
    super.child,
    required TextDirection textDirection,
  }) : super(
          alignment: textDirection == TextDirection.ltr
              ? Alignment.topLeft
              : Alignment.topRight,
          constraintsTransform: transform,
        );

  static BoxConstraints transform(BoxConstraints bc) =>
      bc.copyWith(minWidth: 0);
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

  factory _StyleSizingInput.fromMeta(BuildMetadata meta) {
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

    if (preferredWidth == null && StyleSizing._metaIsBlock[meta] == true) {
      // `display: block` implies a 100% width
      // but it MUST NOT reset width value if specified
      // we need to keep track of block width to calculate contraints correctly
      preferredWidth = StyleSizing.k100percent;
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

  static final _metaInput = Expando<_StyleSizingInput>();

  static _StyleSizingInput? tryParse(BuildMetadata meta) {
    var input = _metaInput[meta];
    if (input == null) {
      _metaInput[meta] = input = _StyleSizingInput.fromMeta(meta);
    }

    if (input.maxHeight == null &&
        input.maxWidth == null &&
        input.minHeight == null &&
        input.minWidth == null &&
        input.preferredHeight == null &&
        input.preferredWidth == null) {
      return null;
    }

    return input;
  }
}
