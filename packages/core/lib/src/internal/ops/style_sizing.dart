part of '../core_ops.dart';

const kCssHeight = 'height';
const kCssMaxHeight = 'max-height';
const kCssMaxWidth = 'max-width';
const kCssMinHeight = 'min-height';
const kCssMinWidth = 'min-width';
const kCssWidth = 'width';

extension CssLengthToSizing on CssLength {
  CssSizingValue? getSizing(HtmlStyle style) {
    final value = getValue(style);
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

  final WidgetFactory wf;

  late final BuildOp _blockOp;
  late final BuildOp _childOp;
  late final BuildOp _sizingOp;

  static final _instances = Expando<StyleSizing>();

  static final _elementTree = Expando<BuildTree>();
  static final _treeIsBlock = Expando<bool>();
  static final _skipBuilding = Expando<bool>();

  static void maybeRegisterChildOp(WidgetFactory wf, BuildTree tree) {
    final parentElement = tree.element.parent;
    if (parentElement == null || _elementTree[parentElement] == null) {
      return;
    }

    tree.register(StyleSizing._factory(wf)._childOp);
  }

  static void registerBlockOp(WidgetFactory wf, BuildTree tree) {
    _elementTree[tree.element] = tree;
    _treeIsBlock[tree] = true;

    final instance = StyleSizing._factory(wf);
    tree
      ..register(instance._blockOp)
      ..register(instance._sizingOp);
  }

  static void registerSizingOp(WidgetFactory wf, BuildTree tree) {
    _elementTree[tree.element] = tree;
    tree.register(StyleSizing._factory(wf)._sizingOp);
  }

  factory StyleSizing._factory(WidgetFactory wf) {
    final existingInstance = _instances[wf];
    if (existingInstance != null) {
      return existingInstance;
    }
    return _instances[wf] = StyleSizing._(wf);
  }

  StyleSizing._(this.wf) {
    _blockOp = const BuildOp(debugLabel: 'display: block', onBuilt: bypass);

    _childOp = BuildOp(
      debugLabel: 'sizing (min-width=0)',
      mustBeBlock: false,
      onBuilt: buildMinWidthZero,
      // min-width resetter should wrap all other box model widgets
      priority: StyleMargin.kPriorityBoxModel9k + 1,
    );

    _sizingOp = BuildOp(
      debugLabel: 'sizing',
      mustBeBlock: false,
      onBuilt: buildCssSizing,
      onFlattening: handleInlineSizing,
      priority: StyleSizing.kPriorityBoxModel3k,
    );
  }

  Widget? buildCssSizing(BuildTree tree, WidgetPlaceholder placeholder) {
    if (_skipBuilding[tree] == true || placeholder.isEmpty) {
      return null;
    }

    final input = _StyleSizingInput.tryParse(tree);
    if (input == null) {
      return null;
    }

    return placeholder.wrapWith(
      (context, child) => _build(context, child, input, tree.styleBuilder),
    );
  }

  Widget? buildMinWidthZero(BuildTree subTree, WidgetPlaceholder placeholder) {
    if (_StyleSizingInput.tryParse(subTree)?.preferredWidth == k100percent) {
      return null;
    }

    final parentElement = subTree.element.parent;
    if (parentElement == null) {
      return null;
    }

    final parentMeta = _elementTree[parentElement];
    if (parentMeta == null) {
      return null;
    }

    final parentInput = _StyleSizingInput.tryParse(parentMeta);
    if (parentInput == null ||
        (parentInput.minWidth == null && parentInput.preferredWidth == null)) {
      return null;
    }

    return placeholder.wrapWith((context, child) {
      final textDirection = subTree.styleBuilder.build(context).textDirection;
      return _MinWidthZero(
        textDirection: textDirection,
        child: child,
      );
    });
  }

  static Widget? bypass(BuildTree _, WidgetPlaceholder placeholder) =>
      placeholder;

  static void handleInlineSizing(BuildTree tree) {
    if (_skipBuilding[tree] == true) {
      return;
    }

    final input = _StyleSizingInput.tryParse(tree);
    if (input == null) {
      return;
    }

    WidgetPlaceholder? placeholder;
    for (final b in tree.bits) {
      if (b is WidgetBit) {
        if (placeholder != null) {
          // TODO: handle multiple inline widgets in the same tree
          return;
        }
        placeholder = b.child;
      } else {
        return;
      }
    }

    if (placeholder == null || placeholder.isEmpty) {
      return;
    }

    placeholder.wrapWith((c, w) => _build(c, w, input, tree.styleBuilder));
  }

  static void skip(BuildTree tree) {
    assert(_skipBuilding[tree] != true, 'Built ${tree.element} already');
    _skipBuilding[tree] = true;
  }

  static Widget _build(
    BuildContext context,
    Widget child,
    _StyleSizingInput input,
    HtmlStyleBuilder styleBuilder,
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

    final style = styleBuilder.build(context);
    return CssSizing(
      maxHeight: input.maxHeight?.getSizing(style),
      maxWidth: input.maxWidth?.getSizing(style),
      minHeight: input.minHeight?.getSizing(style),
      minWidth: input.minWidth?.getSizing(style),
      preferredAxis: input.preferredAxis,
      preferredHeight: input.preferredHeight?.getSizing(style),
      preferredWidth: input.preferredWidth?.getSizing(style),
      child: child,
    );
  }
}

class _MinWidthZero extends ConstraintsTransformBox {
  const _MinWidthZero({
    required Widget child,
    Key? key,
    required TextDirection textDirection,
  }) : super(
          alignment: textDirection == TextDirection.ltr
              ? Alignment.topLeft
              : Alignment.topRight,
          constraintsTransform: transform,
          key: key,
          child: child,
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

  factory _StyleSizingInput.fromTree(BuildTree tree) {
    CssLength? maxHeight;
    CssLength? maxWidth;
    CssLength? minHeight;
    CssLength? minWidth;
    Axis? preferredAxis;
    CssLength? preferredHeight;
    CssLength? preferredWidth;

    for (final style in tree.styles) {
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

    if (preferredWidth == null && StyleSizing._treeIsBlock[tree] == true) {
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

  static _StyleSizingInput? tryParse(BuildTree tree) {
    _StyleSizingInput input;
    final existing = tree.value<_StyleSizingInput>();
    if (existing == null) {
      input = _StyleSizingInput.fromTree(tree);
      tree.value(input);
    } else {
      input = existing;
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
