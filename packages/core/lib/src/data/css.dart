part of '../core_data.dart';

/// A border of a box.
@immutable
class CssBorder {
  final bool inherit;

  final CssBorderSide? _all;
  final CssBorderSide? _bottom;
  final CssBorderSide? _inlineEnd;
  final CssBorderSide? _inlineStart;
  final CssBorderSide? _left;
  final CssBorderSide? _right;
  final CssBorderSide? _top;

  final CssRadius radiusBottomLeft;
  final CssRadius radiusBottomRight;
  final CssRadius radiusTopLeft;
  final CssRadius radiusTopRight;

  /// Creates a border.
  const CssBorder({
    this.inherit = false,
    CssBorderSide? all,
    CssBorderSide? bottom,
    CssBorderSide? inlineEnd,
    CssBorderSide? inlineStart,
    CssBorderSide? left,
    CssBorderSide? right,
    CssBorderSide? top,
    this.radiusBottomLeft = CssRadius.zero,
    this.radiusBottomRight = CssRadius.zero,
    this.radiusTopLeft = CssRadius.zero,
    this.radiusTopRight = CssRadius.zero,
  })  : _all = all,
        _bottom = bottom,
        _inlineEnd = inlineEnd,
        _inlineStart = inlineStart,
        _left = left,
        _right = right,
        _top = top;

  /// Returns `true` if all sides are unset, all radius are zero.
  bool get isNoOp =>
      (_all == null || _all == CssBorderSide.none) &&
      (_bottom == null || _bottom == CssBorderSide.none) &&
      (_inlineEnd == null || _inlineEnd == CssBorderSide.none) &&
      (_inlineStart == null || _inlineStart == CssBorderSide.none) &&
      (_left == null || _left == CssBorderSide.none) &&
      (_right == null || _right == CssBorderSide.none) &&
      (_top == null || _top == CssBorderSide.none) &&
      radiusBottomLeft == CssRadius.zero &&
      radiusBottomRight == CssRadius.zero &&
      radiusTopLeft == CssRadius.zero &&
      radiusTopRight == CssRadius.zero;

  /// Creates a copy of this border with the sides from [other].
  CssBorder copyFrom(CssBorder other) => copyWith(
        bottom: other._bottom,
        inlineEnd: other._inlineEnd,
        inlineStart: other._inlineStart,
        left: other._left,
        right: other._right,
        top: other._top,
        radiusBottomLeft: other.radiusBottomLeft,
        radiusBottomRight: other.radiusBottomRight,
        radiusTopLeft: other.radiusTopLeft,
        radiusTopRight: other.radiusTopRight,
      );

  /// Creates a copy of this border but with the given fields
  /// replaced with the new values.
  CssBorder copyWith({
    CssBorderSide? bottom,
    CssBorderSide? inlineEnd,
    CssBorderSide? inlineStart,
    CssBorderSide? left,
    CssBorderSide? right,
    CssBorderSide? top,
    CssRadius? radiusBottomLeft,
    CssRadius? radiusBottomRight,
    CssRadius? radiusTopLeft,
    CssRadius? radiusTopRight,
  }) =>
      CssBorder(
        inherit: inherit,
        all: _all,
        bottom: CssBorderSide._copyWith(_bottom, bottom),
        inlineEnd: CssBorderSide._copyWith(_inlineEnd, inlineEnd),
        inlineStart: CssBorderSide._copyWith(_inlineStart, inlineStart),
        left: CssBorderSide._copyWith(_left, left),
        right: CssBorderSide._copyWith(_right, right),
        top: CssBorderSide._copyWith(_top, top),
        radiusBottomLeft: radiusBottomLeft ?? this.radiusBottomLeft,
        radiusBottomRight: radiusBottomRight ?? this.radiusBottomRight,
        radiusTopLeft: radiusTopLeft ?? this.radiusTopLeft,
        radiusTopRight: radiusTopRight ?? this.radiusTopRight,
      );

  /// Calculates [Border].
  Border? getBorder(TextStyleHtml tsh) {
    final bottom = CssBorderSide._copyWith(_all, _bottom)?._getValue(tsh);
    final left = CssBorderSide._copyWith(
      _all,
      _left ??
          (tsh.textDirection == TextDirection.ltr ? _inlineStart : _inlineEnd),
    )?._getValue(tsh);
    final right = CssBorderSide._copyWith(
      _all,
      _right ??
          (tsh.textDirection == TextDirection.ltr ? _inlineEnd : _inlineStart),
    )?._getValue(tsh);
    final top = CssBorderSide._copyWith(_all, _top)?._getValue(tsh);
    if (bottom == null && left == null && right == null && top == null) {
      return null;
    }

    return Border(
      bottom: bottom ?? BorderSide.none,
      left: left ?? BorderSide.none,
      right: right ?? BorderSide.none,
      top: top ?? BorderSide.none,
    );
  }

  /// Calculates [BorderRadius].
  BorderRadius? getBorderRadius(TextStyleHtml tsh) {
    final topLeft = radiusTopLeft._getValue(tsh);
    final topRight = radiusTopRight._getValue(tsh);
    final bottomLeft = radiusBottomLeft._getValue(tsh);
    final bottomRight = radiusBottomRight._getValue(tsh);
    if (topLeft == null &&
        topRight == null &&
        bottomLeft == null &&
        bottomRight == null) {
      return null;
    }

    return BorderRadius.only(
      topLeft: topLeft ?? Radius.zero,
      topRight: topRight ?? Radius.zero,
      bottomLeft: bottomLeft ?? Radius.zero,
      bottomRight: bottomRight ?? Radius.zero,
    );
  }
}

/// A radius.
@immutable
class CssRadius {
  final CssLength x;

  final CssLength y;

  /// Creates a radius with the given radii.
  const CssRadius(this.x, this.y);

  /// A radius with [x] and [y] values set to zero.
  static const zero = CssRadius(CssLength.zero, CssLength.zero);

  Radius? _getValue(TextStyleHtml tsh) => this == zero
      ? null
      : Radius.elliptical(
          x.getValue(tsh) ?? 0.0,
          y.getValue(tsh) ?? 0.0,
        );
}

/// A side of a border of a box.
@immutable
class CssBorderSide {
  /// The color of this side of the border.
  final Color? color;

  /// The style of this side of the border.
  final TextDecorationStyle? style;

  /// The width of this side of the border.
  final CssLength? width;

  /// Creates the side of a border.
  const CssBorderSide({this.color, this.style, this.width});

  /// A border that is not rendered.
  static const none = CssBorderSide();

  BorderSide? _getValue(TextStyleHtml tsh) => identical(this, none)
      ? null
      : BorderSide(
          color: color ?? tsh.style.color ?? const BorderSide().color,
          // TODO: add proper support for other border styles
          style: style != null ? BorderStyle.solid : BorderStyle.none,
          // TODO: look for official document regarding this default value
          // WebKit & Blink seem to follow the same (hidden?) specs
          width: width?.getValue(tsh) ?? 1.0,
        );

  static CssBorderSide? _copyWith(CssBorderSide? base, CssBorderSide? value) =>
      base == null || value == none
          ? value
          : value == null
              ? base
              : CssBorderSide(
                  color: value.color ?? base.color,
                  style: value.style ?? base.style,
                  width: value.width ?? base.width,
                );
}

/// A length measurement.
@immutable
class CssLength {
  /// The measurement number.
  final double number;

  /// The measurement unit.
  final CssLengthUnit unit;

  /// Creates a measurement.
  const CssLength(this.number, [this.unit = CssLengthUnit.px]);

  /// A zero length.
  static const zero = CssLength(0);

  /// Returns `true` if value is larger than zero.
  bool get isPositive => number > 0.0;

  /// Calculates value in logical pixel.
  double? getValue(
    TextStyleHtml tsh, {
    double? baseValue,
    double? scaleFactor,
  }) {
    double value;
    var effectiveScaleFactor = scaleFactor ?? 1.0;

    switch (unit) {
      case CssLengthUnit.auto:
        return null;
      case CssLengthUnit.em:
        baseValue ??= tsh.style.fontSize;
        if (baseValue == null) {
          return null;
        }

        value = baseValue * number;
        effectiveScaleFactor = 1;
        break;
      case CssLengthUnit.percentage:
        // TODO: remove ignore https://github.com/passsy/dart-lint/issues/27
        // ignore: invariant_booleans
        if (baseValue == null) {
          return null;
        }

        value = baseValue * number / 100;
        effectiveScaleFactor = 1;
        break;
      case CssLengthUnit.pt:
        value = number * 96 / 72;
        break;
      case CssLengthUnit.px:
        value = number;
        break;
    }

    return value * effectiveScaleFactor;
  }

  @override
  String toString() =>
      number.toString() + unit.toString().replaceAll('CssLengthUnit.', '');
}

/// A set of length measurements.
@immutable
class CssLengthBox {
  /// The bottom measurement.
  final CssLength? bottom;

  final CssLength? _inlineEnd;

  final CssLength? _inlineStart;

  final CssLength? _left;

  final CssLength? _right;

  /// The top measurement.
  final CssLength? top;

  /// Creates a set.
  const CssLengthBox({
    this.bottom,
    CssLength? inlineEnd,
    CssLength? inlineStart,
    CssLength? left,
    CssLength? right,
    this.top,
  })  : _inlineEnd = inlineEnd,
        _inlineStart = inlineStart,
        _left = left,
        _right = right;

  /// Creates a copy with the given measurements replaced with the new values.
  CssLengthBox copyWith({
    CssLength? bottom,
    CssLength? inlineEnd,
    CssLength? inlineStart,
    CssLength? left,
    CssLength? right,
    CssLength? top,
  }) =>
      CssLengthBox(
        bottom: bottom ?? this.bottom,
        inlineEnd: inlineEnd ?? _inlineEnd,
        inlineStart: inlineStart ?? _inlineStart,
        left: left ?? _left,
        right: right ?? _right,
        top: top ?? this.top,
      );

  /// Returns `true` if left or inline measurements are set.
  bool get mayHaveLeft =>
      _inlineEnd?.isPositive == true ||
      _inlineStart?.isPositive == true ||
      _left?.isPositive == true;

  /// Returns `true` if right or inline measurements are set.
  bool get mayHaveRight =>
      _inlineEnd?.isPositive == true ||
      _inlineStart?.isPositive == true ||
      _right?.isPositive == true;

  /// Calculates the left value taking text direction into account.
  double? getValueLeft(TextStyleHtml tsh) => (_left ??
          (tsh.textDirection == TextDirection.ltr ? _inlineStart : _inlineEnd))
      ?.getValue(tsh);

  /// Calculates the right value taking text direction into account.
  double? getValueRight(TextStyleHtml tsh) => (_right ??
          (tsh.textDirection == TextDirection.ltr ? _inlineEnd : _inlineStart))
      ?.getValue(tsh);

  @override
  String toString() {
    const _null = 'null';
    final left = (_left ?? _inlineStart)?.toString() ?? _null;
    final top = this.top?.toString() ?? _null;
    final right = (_right ?? _inlineEnd)?.toString() ?? _null;
    final bottom = this.bottom?.toString() ?? _null;
    if (left == right && right == top && top == bottom) {
      return 'CssLengthBox.all($left)';
    }

    final values = [left, top, right, bottom];
    if (values.where((v) => v == _null).length == 3) {
      if (left != _null) {
        if (_left != null) {
          return 'CssLengthBox(left=$_left)';
        } else {
          return 'CssLengthBox(inline-start=$_inlineStart)';
        }
      }
      if (top != _null) {
        return 'CssLengthBox(top=$top)';
      }
      if (right != _null) {
        if (_right != null) {
          return 'CssLengthBox(right=$_right)';
        } else {
          return 'CssLengthBox(inline-end=$_inlineEnd)';
        }
      }
      if (bottom != _null) {
        return 'CssLengthBox(bottom=$bottom)';
      }
    }

    return 'CssLengthBox($left, $top, $right, $bottom)';
  }
}

/// Length measurement units.
enum CssLengthUnit {
  /// Special value: auto.
  auto,

  /// Relative unit: em.
  em,

  /// Relative unit: percentage.
  percentage,

  /// Absolute unit: points, 1pt = 1/72th of 1in.
  pt,

  /// Absolute unit: pixels, 1px = 1/96th of 1in.
  px,
}

/// The whitespace behavior.
enum CssWhitespace {
  /// Sequences of white space are collapsed.
  /// Newline characters in the source are handled the same as other whitespace.
  /// Lines are broken as necessary to fill line boxes.
  normal,

  /// Sequences of white space are preserved.
  /// Lines are only broken at newline characters in the source and at `BR`s.
  pre,
}
