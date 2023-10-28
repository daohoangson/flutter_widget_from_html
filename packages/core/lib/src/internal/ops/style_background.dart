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
          final data = tree.backgroundData;
          final color = data.color;
          final imageUrl = data.imageUrl;

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
          final color = tree.backgroundData.color;
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
}

extension on BuildTree {
  _StyleBackgroundData get backgroundData =>
      getNonInherited<_StyleBackgroundData>() ??
      setNonInherited<_StyleBackgroundData>(_parse());

  _StyleBackgroundData _parse() {
    var data = const _StyleBackgroundData();
    for (final style in styles) {
      switch (style.property) {
        case kCssBackground:
          for (final expression in style.values) {
            data = data.copyWithColor(expression);
            data = data.copyWithImageUrl(expression);
          }
          break;
        case kCssBackgroundColor:
          data = data.copyWithColor(style.value);
          break;
        case kCssBackgroundImage:
          data = data.copyWithImageUrl(style.value);
          break;
      }
    }

    return data;
  }
}

@immutable
class _StyleBackgroundData {
  final Color? color;
  final String? imageUrl;
  const _StyleBackgroundData({
    this.color,
    this.imageUrl,
  });

  _StyleBackgroundData copyWith({
    Color? color,
    String? imageUrl,
  }) =>
      _StyleBackgroundData(
        color: color ?? this.color,
        imageUrl: imageUrl ?? this.imageUrl,
      );

  _StyleBackgroundData copyWithColor(css.Expression? expression) {
    final newColor = tryParseColor(expression) ?? color;
    if (newColor == color) {
      return this;
    }
    return copyWith(color: newColor);
  }

  _StyleBackgroundData copyWithImageUrl(css.Expression? expression) {
    final newImageUrl = expression is css.UriTerm ? expression.text : imageUrl;
    if (newImageUrl == imageUrl) {
      return this;
    }
    return copyWith(imageUrl: newImageUrl);
  }
}
