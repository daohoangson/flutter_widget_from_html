part of '../core_ops.dart';

const kCssBackground = 'background';
const kCssBackgroundColor = 'background-color';
const kCssBackgroundImage = 'background-image';

const kCssBackgroundPosition = 'background-position';
const kCssBackgroundPositionBottom = 'bottom';
const kCssBackgroundPositionCenter = 'center';
const kCssBackgroundPositionLeft = 'left';
const kCssBackgroundPositionRight = 'right';
const kCssBackgroundPositionTop = 'top';

const kCssBackgroundRepeat = 'background-repeat';
const kCssBackgroundRepeatNo = 'no-repeat';
const kCssBackgroundRepeatX = 'repeat-x';
const kCssBackgroundRepeatY = 'repeat-y';
const kCssBackgroundRepeatYes = 'repeat';

const kCssBackgroundSize = 'background-size';
const kCssBackgroundSizeAuto = 'auto';
const kCssBackgroundSizeContain = 'contain';
const kCssBackgroundSizeCover = 'cover';

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
            alignment: data.alignment,
            fit: data.size,
            repeat: data.repeat,
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
            data = data.copyWithTerm(expression);
          }
          break;
        case kCssBackgroundColor:
          data = data.copyWithColor(style.value);
          break;
        case kCssBackgroundImage:
          data = data.copyWithImageUrl(style.value);
          break;
        case kCssBackgroundPosition:
        case kCssBackgroundRepeat:
        case kCssBackgroundSize:
          data = data.copyWithTerm(style.value);
      }
    }

    return data;
  }
}

@immutable
class _StyleBackgroundData {
  final AlignmentGeometry alignment;
  final Color? color;
  final String? imageUrl;
  final ImageRepeat repeat;
  final BoxFit size;
  const _StyleBackgroundData({
    this.alignment = Alignment.center,
    this.color,
    this.imageUrl,
    this.repeat = ImageRepeat.noRepeat,
    this.size = BoxFit.scaleDown,
  });

  _StyleBackgroundData copyWith({
    AlignmentGeometry? alignment,
    Color? color,
    String? imageUrl,
    ImageRepeat? repeat,
    BoxFit? size,
  }) =>
      _StyleBackgroundData(
        alignment: alignment ?? this.alignment,
        color: color ?? this.color,
        imageUrl: imageUrl ?? this.imageUrl,
        repeat: repeat ?? this.repeat,
        size: size ?? this.size,
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

  _StyleBackgroundData copyWithTerm(css.Expression? expression) {
    if (expression is! css.LiteralTerm) {
      return this;
    }

    switch (expression.valueAsString) {
      case kCssBackgroundPositionBottom:
        return copyWith(alignment: Alignment.bottomCenter);
      case kCssBackgroundPositionCenter:
        return copyWith(alignment: Alignment.center);
      case kCssBackgroundPositionLeft:
        return copyWith(alignment: Alignment.centerLeft);
      case kCssBackgroundPositionRight:
        return copyWith(alignment: Alignment.centerRight);
      case kCssBackgroundPositionTop:
        return copyWith(alignment: Alignment.topCenter);
      case kCssBackgroundRepeatNo:
        return copyWith(repeat: ImageRepeat.noRepeat);
      case kCssBackgroundRepeatX:
        return copyWith(repeat: ImageRepeat.repeatX);
      case kCssBackgroundRepeatY:
        return copyWith(repeat: ImageRepeat.repeatY);
      case kCssBackgroundRepeatYes:
        return copyWith(repeat: ImageRepeat.repeat);
      case kCssBackgroundSizeAuto:
        return copyWith(size: BoxFit.scaleDown);
      case kCssBackgroundSizeContain:
        return copyWith(size: BoxFit.contain);
      case kCssBackgroundSizeCover:
        return copyWith(size: BoxFit.cover);
    }

    return this;
  }
}
