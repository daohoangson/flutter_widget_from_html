part of '../core_ops.dart';

const kCssHeight = 'height';
const kCssMaxHeight = 'max-height';
const kCssMaxWidth = 'max-width';
const kCssMinHeight = 'min-height';
const kCssMinWidth = 'min-width';
const kCssWidth = 'width';

class DisplayBlockOp extends BuildOp {
  DisplayBlockOp(WidgetFactory wf)
      : super(
          onWidgets: (tree, widgets) => listOrNull(
            wf
                .buildColumnPlaceholder(tree, widgets)
                ?.wrapWith((_, w) => w is CssSizing ? w : CssBlock(child: w)),
          ),
          priority: StyleSizing.kPriority7k + 1,
        );
}

class StyleSizing {
  static const kPriority7k = 7000;

  final WidgetFactory wf;

  static final _treatHeightAsMinHeight = Expando<bool>();

  StyleSizing(this.wf);

  BuildOp get buildOp => BuildOp(
        onTreeFlattening: (tree) {
          final input = _parse(tree, isDisplayBlock: false);
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

          widget?.wrapWith((c, w) => _build(c, w, input, tree.styleBuilder));
        },
        onWidgets: (tree, widgets) {
          final input = _parse(tree, isDisplayBlock: true);
          if (input == null) {
            return widgets;
          }

          final built = wf.buildColumnPlaceholder(tree, widgets)?.wrapWith(
                (c, w) => _build(c, w, input, tree.styleBuilder),
              );
          return listOrNull(built) ?? widgets;
        },
        onWidgetsIsOptional: true,
        priority: kPriority7k,
      );

  _StyleSizingInput? _parse(BuildTree tree, {required bool isDisplayBlock}) {
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
            if (_treatHeightAsMinHeight[tree] == true) {
              minHeight = parsedHeight;
            } else {
              preferredAxis = Axis.vertical;
              preferredHeight = parsedHeight;
            }
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

    if (maxHeight == null &&
        maxWidth == null &&
        minHeight == null &&
        minWidth == null &&
        preferredHeight == null &&
        preferredWidth == null) {
      return null;
    }

    if (preferredWidth == null && isDisplayBlock) {
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

  static void treatHeightAsMinHeight(BuildTree tree) =>
      _treatHeightAsMinHeight[tree] = true;

  static Widget _build(
    BuildContext context,
    Widget child,
    _StyleSizingInput input,
    HtmlStyleBuilder styleBuilder,
  ) {
    final style = styleBuilder.build(context);

    return CssSizing(
      maxHeight: _getValue(input.maxHeight, style),
      maxWidth: _getValue(input.maxWidth, style),
      minHeight: _getValue(input.minHeight, style),
      minWidth: _getValue(input.minWidth, style),
      preferredAxis: input.preferredAxis,
      preferredHeight: _getValue(input.preferredHeight, style),
      preferredWidth: _getValue(input.preferredWidth, style),
      child: child,
    );
  }

  static CssSizingValue? _getValue(CssLength? length, HtmlStyle style) {
    if (length == null) {
      return null;
    }

    final value = length.getValue(style);
    if (value != null) {
      return CssSizingValue.value(value);
    }

    switch (length.unit) {
      case CssLengthUnit.auto:
        return const CssSizingValue.auto();
      case CssLengthUnit.percentage:
        return CssSizingValue.percentage(length.number);
      default:
        return null;
    }
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
