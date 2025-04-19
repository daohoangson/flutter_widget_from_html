part of '../core_ops.dart';

const kCssHeight = 'height';
const kCssMaxHeight = 'max-height';
const kCssMaxWidth = 'max-width';
const kCssMinHeight = 'min-height';
const kCssMinWidth = 'min-width';
const kCssWidth = 'width';

class StyleSizing {
  static const k100percent = CssLength(100, CssLengthUnit.percentage);

  final BuildOp blockOp;
  final BuildOp childOp;
  final BuildOp sizingOp;

  static final _elementTree = Expando<BuildTree>();
  static final _treeIsBlock = Expando<bool>();

  static void maybeRegisterChildOp(BuildTree tree) {
    final parentElement = tree.element.parent;
    if (parentElement == null || _elementTree[parentElement] == null) {
      return;
    }

    tree.register(StyleSizing().childOp);
  }

  static void registerBlockOp(BuildTree tree) {
    _elementTree[tree.element] = tree;
    _treeIsBlock[tree] = true;

    final instance = StyleSizing();
    tree
      ..register(instance.blockOp)
      ..register(instance.sizingOp);
  }

  static void registerSizingOp(BuildTree tree) {
    _elementTree[tree.element] = tree;
    tree.register(StyleSizing().sizingOp);
  }

  factory StyleSizing() => const StyleSizing._(
        blockOp: BuildOp.v2(
          alwaysRenderBlock: true,
          debugLabel: 'display: block',
        ),
        childOp: BuildOp.v2(
          alwaysRenderBlock: false,
          debugLabel: 'sizing (min-width=0)',
          onRenderBlock: _childZero,
          priority: BoxModel.sizingMinWidthZero,
        ),
        sizingOp: BuildOp.v2(
          alwaysRenderBlock: false,
          debugLabel: 'sizing',
          onRenderBlock: _sizingBlock,
          onRenderInline: _sizingInline,
          priority: BoxModel.sizing,
        ),
      );

  const StyleSizing._({
    required this.blockOp,
    required this.childOp,
    required this.sizingOp,
  });

  static Widget _childZero(BuildTree subTree, WidgetPlaceholder placeholder) {
    if (subTree.sizingInput?.preferredWidth == k100percent) {
      return placeholder;
    }

    final parentElement = subTree.element.parent;
    if (parentElement == null) {
      return placeholder;
    }

    final parentTree = _elementTree[parentElement];
    if (parentTree == null) {
      return placeholder;
    }

    final parentInput = parentTree.sizingInput;
    if (parentInput == null ||
        (parentInput.minWidth == null && parentInput.preferredWidth == null)) {
      return placeholder;
    }

    return placeholder.wrapWith((context, child) {
      final dir = subTree.inheritanceResolvers.resolve(context).directionOrLtr;
      return _MinWidthZero(
        textDirection: dir,
        child: child,
      );
    });
  }

  static Widget _sizingBlock(BuildTree tree, WidgetPlaceholder placeholder) {
    if (placeholder.isEmpty) {
      return placeholder;
    }

    final input = tree.sizingInput;
    if (input == null) {
      return placeholder;
    }

    return placeholder.wrapWith(
      (context, child) =>
          _build(context, child, input, tree.inheritanceResolvers),
    );
  }

  static void _sizingInline(BuildTree tree) {
    final input = tree.sizingInput;
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

    placeholder
        .wrapWith((c, w) => _build(c, w, input, tree.inheritanceResolvers));
  }

  static Widget _build(
    BuildContext context,
    Widget child,
    _StyleSizingInput input,
    InheritanceResolvers inheritanceResolvers,
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

    final resolved = inheritanceResolvers.resolve(context);
    return CssSizing(
      maxHeight: input.maxHeight?.getSizing(resolved),
      maxWidth: input.maxWidth?.getSizing(resolved),
      minHeight: input.minHeight?.getSizing(resolved),
      minWidth: input.minWidth?.getSizing(resolved),
      preferredAxis: input.preferredAxis,
      preferredHeight: input.preferredHeight?.getSizing(resolved),
      preferredWidth: input.preferredWidth?.getSizing(resolved),
      child: child,
    );
  }
}

extension on BuildTree {
  _StyleSizingInput? get sizingInput {
    final input = getNonInherited<_StyleSizingInput>() ??
        setNonInherited<_StyleSizingInput>(_parse());

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

  _StyleSizingInput _parse() {
    CssLength? maxHeight;
    CssLength? maxWidth;
    CssLength? minHeight;
    CssLength? minWidth;
    Axis? preferredAxis;
    CssLength? preferredHeight;
    CssLength? preferredWidth;

    for (final style in styles) {
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
        case kCssMaxHeight:
          maxHeight = tryParseCssLength(value) ?? maxHeight;
        case kCssMaxWidth:
          maxWidth = tryParseCssLength(value) ?? maxWidth;
        case kCssMinHeight:
          minHeight = tryParseCssLength(value) ?? minHeight;
        case kCssMinWidth:
          minWidth = tryParseCssLength(value) ?? minWidth;
        case kCssWidth:
          final parsedWidth = tryParseCssLength(value);
          if (parsedWidth != null) {
            preferredAxis = Axis.horizontal;
            preferredWidth = parsedWidth;
          }
      }
    }

    if (preferredWidth == null && StyleSizing._treeIsBlock[this] == true) {
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
}

extension on CssLength {
  CssSizingValue? getSizing(InheritedProperties resolved) {
    final value = getValue(resolved);
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
}
