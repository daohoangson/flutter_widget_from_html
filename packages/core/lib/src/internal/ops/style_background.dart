part of '../core_ops.dart';

const kCssBackground = 'background';
const kCssBackgroundColor = 'background-color';
const kCssBackgroundImage = 'background-image';

class StyleBackground {
  final WidgetFactory wf;

  StyleBackground(this.wf);

  BuildOp get buildOp => BuildOp(
        alwaysRenderBlock: false,
        debugLabel: kCssBackground,
        onRenderBlock: (tree, placeholder) {
          final color = _parseColor(tree);
          final imageUrl = _parseBackgroundImageUrl(wf, tree);

          if (color == null && imageUrl == null) {
            return placeholder;
          }

          final image = wf.buildDecorationImage(
            tree,
            imageUrl,
          );

          return placeholder.wrapWith(
            (_, child) => wf.buildDecoration(
              tree,
              child,
              color: color,
              image: image,
            ),
          );
        },
        onRenderInline: (tree) {
          final color = _parseColor(tree);
          if (color == null) {
            return;
          }

          tree.inherit(_color, color);
        },
        priority: BoxModel.background,
      );

  static InheritedProperties _color(
    InheritedProperties resolving,
    Color color,
  ) =>
      resolving.copyWith(
        style: resolving.style.copyWith(
          background: Paint()..color = color,
          debugLabel: 'fwfh: $kCssBackgroundColor',
        ),
      );

  static Color? _parseColor(BuildTree tree) {
    Color? color;
    for (final style in tree.styles) {
      switch (style.property) {
        case kCssBackground:
          for (final expression in style.values) {
            color = tryParseColor(expression) ?? color;
          }
          break;
        case kCssBackgroundColor:
          color = tryParseColor(style.value) ?? color;
          break;
      }
    }

    return color;
  }

  /// Attempts to parse the background image URL from the [tree] styles.
  String? _parseBackgroundImageUrl(WidgetFactory wf, BuildTree tree) {
    for (final style in tree.styles) {
      final styleValue = style.value;
      if (styleValue == null) {
        continue;
      }

      switch (style.property) {
        case kCssBackground:
        case kCssBackgroundImage:
          for (final expression in style.values) {
            if (expression is css.UriTerm) {
              return expression.text;
            }
          }
          break;
      }
    }

    return null;
  }
}
