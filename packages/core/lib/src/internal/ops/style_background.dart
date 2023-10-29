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
    for (final style_ in styles) {
      final style = _StyleBackgroundDeclaration(style_);
      switch (style.property) {
        case kCssBackground:
          while (style.hasValue) {
            final prev = data;
            data = data.copyWithColor(style);
            if (style.hasValue) {
              data = data.copyWithImageUrl(style);
            }
            if (style.hasValue) {
              data = data.copyWithPosition(style);
            }
            if (style.hasValue) {
              data = data.copyWithRepeatOrSize(style);
            }
            if (identical(data, prev)) {
              // unrecognized value, ignore it
              style.increaseIndex();
            }
          }
          break;
        case kCssBackgroundColor:
          data = data.copyWithColor(style);
          break;
        case kCssBackgroundImage:
          data = data.copyWithImageUrl(style);
          break;
        case kCssBackgroundPosition:
          while (style.hasValue) {
            final prev = data;
            data = data.copyWithPosition(style);
            if (identical(data, prev)) {
              // unrecognized value, ignore it
              style.increaseIndex();
            }
          }
          break;
        case kCssBackgroundRepeat:
        case kCssBackgroundSize:
          data = data.copyWithRepeatOrSize(style);
          break;
      }
    }

    return data;
  }
}

extension on css.Expression {
  _StyleBackgroundPosition? get position {
    final self = this;
    final term = self is css.LiteralTerm ? self.valueAsString : null;
    switch (term) {
      case kCssBackgroundPositionBottom:
        return _StyleBackgroundPosition.bottom;
      case kCssBackgroundPositionCenter:
        return _StyleBackgroundPosition.center;
      case kCssBackgroundPositionLeft:
        return _StyleBackgroundPosition.left;
      case kCssBackgroundPositionRight:
        return _StyleBackgroundPosition.right;
      case kCssBackgroundPositionTop:
        return _StyleBackgroundPosition.top;
    }

    return null;
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
    this.alignment = Alignment.topLeft,
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

  _StyleBackgroundData copyWithColor(_StyleBackgroundDeclaration style) {
    final color = tryParseColor(style.value);
    if (color == null) {
      return this;
    }

    style.increaseIndex();
    return copyWith(color: color);
  }

  _StyleBackgroundData copyWithImageUrl(_StyleBackgroundDeclaration style) {
    final value = style.value;
    final imageUrl = value is css.UriTerm ? value.text : null;
    if (imageUrl == null) {
      return this;
    }

    style.increaseIndex();
    return copyWith(imageUrl: imageUrl);
  }

  _StyleBackgroundData copyWithPosition(_StyleBackgroundDeclaration style) {
    final value1 = style.value;
    final position1 = value1?.position;
    if (position1 == null) {
      return this;
    }

    final value2 = style.valuePlus1;
    final position2 = value2?.position;
    if (position2 == null) {
      // single keyword position
      style.increaseIndex();
      switch (position1) {
        case _StyleBackgroundPosition.bottom:
          return copyWith(alignment: Alignment.bottomCenter);
        case _StyleBackgroundPosition.center:
          return copyWith(alignment: Alignment.center);
        case _StyleBackgroundPosition.left:
          return copyWith(alignment: Alignment.centerLeft);
        case _StyleBackgroundPosition.right:
          return copyWith(alignment: Alignment.centerRight);
        case _StyleBackgroundPosition.top:
          return copyWith(alignment: Alignment.topCenter);
      }
    } else {
      // double keywords position
      style.increaseIndex(2);
      switch (position1) {
        case _StyleBackgroundPosition.bottom:
          switch (position2) {
            case _StyleBackgroundPosition.left:
              return copyWith(alignment: Alignment.bottomLeft);
            case _StyleBackgroundPosition.right:
              return copyWith(alignment: Alignment.bottomRight);
            case _StyleBackgroundPosition.bottom:
            case _StyleBackgroundPosition.center:
            case _StyleBackgroundPosition.top:
              return copyWith(alignment: Alignment.bottomCenter);
          }
        case _StyleBackgroundPosition.center:
          switch (position2) {
            case _StyleBackgroundPosition.bottom:
              return copyWith(alignment: Alignment.bottomCenter);
            case _StyleBackgroundPosition.center:
              return copyWith(alignment: Alignment.center);
            case _StyleBackgroundPosition.left:
              return copyWith(alignment: Alignment.centerLeft);
            case _StyleBackgroundPosition.right:
              return copyWith(alignment: Alignment.centerRight);
            case _StyleBackgroundPosition.top:
              return copyWith(alignment: Alignment.topCenter);
          }
        case _StyleBackgroundPosition.left:
          switch (position2) {
            case _StyleBackgroundPosition.bottom:
              return copyWith(alignment: Alignment.bottomLeft);
            case _StyleBackgroundPosition.top:
              return copyWith(alignment: Alignment.topLeft);
            case _StyleBackgroundPosition.center:
            case _StyleBackgroundPosition.left:
            case _StyleBackgroundPosition.right:
              return copyWith(alignment: Alignment.centerLeft);
          }
        case _StyleBackgroundPosition.right:
          switch (position2) {
            case _StyleBackgroundPosition.bottom:
              return copyWith(alignment: Alignment.bottomRight);
            case _StyleBackgroundPosition.top:
              return copyWith(alignment: Alignment.topRight);
            case _StyleBackgroundPosition.left:
            case _StyleBackgroundPosition.right:
            case _StyleBackgroundPosition.center:
              return copyWith(alignment: Alignment.centerRight);
          }
        case _StyleBackgroundPosition.top:
          switch (position2) {
            case _StyleBackgroundPosition.left:
              return copyWith(alignment: Alignment.topLeft);
            case _StyleBackgroundPosition.right:
              return copyWith(alignment: Alignment.topRight);
            case _StyleBackgroundPosition.bottom:
            case _StyleBackgroundPosition.center:
            case _StyleBackgroundPosition.top:
              return copyWith(alignment: Alignment.topCenter);
          }
      }
    }
  }

  _StyleBackgroundData copyWithRepeatOrSize(_StyleBackgroundDeclaration style) {
    final value = style.value;
    final term = value is css.LiteralTerm ? value.valueAsString : null;
    final copied = copyWithTerm(term);
    if (identical(copied, this)) {
      return this;
    }

    style.increaseIndex();
    return copied;
  }

  _StyleBackgroundData copyWithTerm(String? term) {
    switch (term) {
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

class _StyleBackgroundDeclaration {
  final String property;
  final List<css.Expression> values;

  var _i = 0;

  _StyleBackgroundDeclaration(css.Declaration style)
      : property = style.property,
        values = style.values;

  bool get hasValue => _i < values.length;

  css.Expression? get value => hasValue ? values[_i] : null;

  css.Expression? get valuePlus1 =>
      _i + 1 < values.length ? values[_i + 1] : null;

  void increaseIndex([int delta = 1]) => _i += delta;
}

enum _StyleBackgroundPosition {
  bottom,
  center,
  left,
  right,
  top,
}
