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
          final gradient = data.gradient;
          final imageUrl = data.imageUrl;

          if (color == null && gradient == null && imageUrl == null) {
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
            (context, child) {
              final resolved = tree.inheritanceResolvers.resolve(context);
              // gradient takes precedence over background-color (BoxDecoration
              // disallows both simultaneously; gradient renders on top anyway).
              final resolvedColor =
                  gradient == null ? color?.getValue(resolved) : null;
              return wf.buildDecoration(
                tree,
                child,
                color: resolvedColor,
                gradient: gradient != null
                    ? _cssGradientToFlutter(gradient)
                    : null,
                image: image,
              );
            },
          );
        },
        onRenderInline: (tree) {
          final color = tree.backgroundData.color;
          if (color == null) {
            return;
          }

          tree.inherit(_textStyleBackground, color);
        },
        priority: BoxModel.background,
      );

  static InheritedProperties _textStyleBackground(
    InheritedProperties resolving,
    CssColor color,
  ) =>
      resolving.copyWith(value: TextStyleBackground(color));
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
        case kCssBackgroundColor:
          data = data.copyWithColor(style);
        case kCssBackgroundImage:
          data = data.copyWithImageUrl(style);
        case kCssBackgroundPosition:
          while (style.hasValue) {
            final prev = data;
            data = data.copyWithPosition(style);
            if (identical(data, prev)) {
              // unrecognized value, ignore it
              style.increaseIndex();
            }
          }
        case kCssBackgroundRepeat:
        case kCssBackgroundSize:
          data = data.copyWithRepeatOrSize(style);
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
  final CssColor? color;
  final CssGradient? gradient;
  final String? imageUrl;
  final ImageRepeat repeat;
  final BoxFit size;
  const _StyleBackgroundData({
    this.alignment = Alignment.topLeft,
    this.color,
    this.gradient,
    this.imageUrl,
    this.repeat = ImageRepeat.noRepeat,
    this.size = BoxFit.scaleDown,
  });

  _StyleBackgroundData copyWith({
    AlignmentGeometry? alignment,
    CssColor? color,
    CssGradient? gradient,
    String? imageUrl,
    ImageRepeat? repeat,
    BoxFit? size,
  }) =>
      _StyleBackgroundData(
        alignment: alignment ?? this.alignment,
        color: color ?? this.color,
        gradient: gradient ?? this.gradient,
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

    // Gradient functions (linear-gradient, radial-gradient, conic-gradient…)
    // are parsed first; they shadow background-color per the CSS spec.
    final cssGradient = tryParseGradient(value);
    if (cssGradient != null) {
      style.increaseIndex();
      return copyWith(gradient: cssGradient);
    }

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

// ──────────────────────────────────────────────────────────────────────────────
// CSS gradient → Flutter Gradient conversion
// ──────────────────────────────────────────────────────────────────────────────

Gradient _cssGradientToFlutter(CssGradient g) {
  final colors = g.stops.map((s) => s.color).toList(growable: false);
  final allHavePositions = g.stops.every((s) => s.position != null);
  final rawStops = allHavePositions
      ? g.stops.map((s) => s.position!).toList(growable: false)
      : null;

  // Flutter's TileMode.repeated tiles outside the [begin,end] vector but not
  // within it, so it has no effect when the vector spans the whole box.
  // Manually expand the stop pattern to cover [0,1] instead.
  final (effectiveColors, effectiveStops) =
      g.repeating ? _expandRepeatingStops(colors, rawStops) : (colors, rawStops);

  return switch (g) {
    CssLinearGradient(:final begin, :final end) => LinearGradient(
        begin: begin,
        end: end,
        colors: effectiveColors,
        stops: effectiveStops,
        tileMode: TileMode.clamp,
      ),
    CssRadialGradient(:final center, :final isCircle) => RadialGradient(
        center: center,
        colors: effectiveColors,
        stops: effectiveStops,
        tileMode: TileMode.clamp,
        transform: _RadialFarthestCornerTransform(center, isCircle: isCircle),
      ),
    CssConicGradient(:final center, :final startAngle) => SweepGradient(
        center: center,
        // Always sweep the full 0→2π so stop positions map correctly and
        // TileMode.clamp doesn't produce a clamped wedge before startAngle.
        startAngle: 0,
        endAngle: 2 * pi,
        colors: effectiveColors,
        stops: effectiveStops,
        tileMode: TileMode.clamp,
        // Rotate around the gradient's own center:
        //   • -π/2 maps CSS 12 o'clock → Flutter 3 o'clock origin
        //   • + startAngle applies the CSS `from <angle>` offset
        transform: _ConicAlignTransform(center, startAngle),
      ),
  };
}

/// Expands a repeating gradient's stop pattern to cover [0, 1].
///
/// Flutter's [TileMode.repeated] tiles outside the gradient vector but not
/// within [0, 1], so it produces no visible repetition when the vector spans
/// the full bounding box.  Manually repeating the tile fixes this.
(List<Color>, List<double>?) _expandRepeatingStops(
  List<Color> colors,
  List<double>? stops,
) {
  if (stops == null || stops.length < 2) return (colors, stops);
  final period = stops.last - stops.first;
  if (period <= 0 || stops.last >= 1.0) return (colors, stops);

  final outColors = <Color>[];
  final outStops = <double>[];

  var offset = 0.0;
  outer:
  while (true) {
    for (var i = 0; i < stops.length; i++) {
      final s = offset + (stops[i] - stops.first);
      if (s >= 1.0) {
        outStops.add(1.0);
        outColors.add(colors[i]);
        break outer;
      }
      outStops.add(s);
      outColors.add(colors[i]);
    }
    offset += period;
  }

  return (outColors, outStops);
}

/// Applies CSS [farthest-corner] sizing to a Flutter [RadialGradient].
///
/// Flutter's [RadialGradient] defaults to `radius: 0.5` (half the shortest
/// side). CSS defaults to farthest-corner, meaning the last stop should reach
/// the furthest corner of the bounding box from the gradient centre.
///
/// * **Circle** – radius = Euclidean distance from centre to farthest corner.
/// * **Ellipse** – each axis scaled independently (CSS spec §4.2.1).
class _RadialFarthestCornerTransform implements GradientTransform {
  final Alignment center;
  final bool isCircle;

  const _RadialFarthestCornerTransform(this.center, {required this.isCircle});

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    final baseR = bounds.shortestSide / 2.0;
    if (baseR == 0) return null;

    final cx = bounds.left + bounds.width * (center.x + 1) / 2;
    final cy = bounds.top + bounds.height * (center.y + 1) / 2;

    final maxDx = max(cx - bounds.left, bounds.right - cx);
    final maxDy = max(cy - bounds.top, bounds.bottom - cy);

    final double scaleX;
    final double scaleY;
    if (isCircle) {
      final farDist = sqrt(maxDx * maxDx + maxDy * maxDy);
      if (farDist == 0) return null;
      scaleX = farDist / baseR;
      scaleY = scaleX;
    } else {
      if (maxDx == 0 || maxDy == 0) return null;
      scaleX = maxDx / baseR;
      scaleY = maxDy / baseR;
    }

    return Matrix4.identity()
      ..translate(cx, cy)
      ..scale(scaleX, scaleY, 1.0)
      ..translate(-cx, -cy);
  }
}

/// Rotates a conic gradient around [center] (not necessarily Alignment.center)
/// by [startAngle] − π/2.
///
/// Flutter's SweepGradient starts at 3 o'clock; CSS starts at 12 o'clock.
/// The extra -π/2 corrects that, and [startAngle] adds the CSS `from <angle>`
/// offset on top.
class _ConicAlignTransform implements GradientTransform {
  final Alignment center;
  final double startAngle;

  const _ConicAlignTransform(this.center, this.startAngle);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    final cx = bounds.left + bounds.width * (center.x + 1) / 2;
    final cy = bounds.top + bounds.height * (center.y + 1) / 2;
    final angle = startAngle - pi / 2;
    return Matrix4.identity()
      ..translate(cx, cy)
      ..rotateZ(angle)
      ..translate(-cx, -cy);
  }
}
