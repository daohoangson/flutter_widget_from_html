part of '../core_data.dart';

/// A border.
@immutable
class CssBorderSide {
  /// The border color.
  final Color color;

  /// The border style.
  final TextDecorationStyle style;

  /// The border width (thickness).
  final CssLength width;

  /// Creates a border.
  CssBorderSide({this.color, this.style, this.width});
}

/// A length measurement.
@immutable
class CssLength {
  /// The measurement number.
  final double number;

  /// The measurement unit.
  final CssLengthUnit unit;

  /// Creates a measurement.
  ///
  /// [number] must not be negative.
  const CssLength(
    this.number, [
    this.unit = CssLengthUnit.px,
  ])  : assert(number >= 0),
        assert(unit != null);

  /// Returns `true` if value is non-zero.
  bool get isNotEmpty => number > 0;

  /// Calculates value in logical pixel.
  double getValue(TextStyleHtml tsh, {double baseValue, double scaleFactor}) {
    double value;
    switch (unit) {
      case CssLengthUnit.auto:
        return null;
      case CssLengthUnit.em:
        baseValue ??= tsh.style.fontSize;
        value = baseValue * number;
        scaleFactor = 1;
        break;
      case CssLengthUnit.percentage:
        if (baseValue == null) return null;
        value = baseValue * number / 100;
        scaleFactor = 1;
        break;
      case CssLengthUnit.pt:
        value = number * 96 / 72;
        break;
      case CssLengthUnit.px:
        value = number;
        break;
    }

    if (value == null) return null;
    if (scaleFactor != null) value *= scaleFactor;

    return value;
  }

  @override
  String toString() =>
      number.toString() + unit.toString().replaceAll('CssLengthUnit.', '');
}

/// A set of length measurements.
@immutable
class CssLengthBox {
  /// The bottom measurement.
  final CssLength bottom;

  /// The inline end (right) measurement.
  final CssLength inlineEnd;

  /// The inline start (left) measurement.
  final CssLength inlineStart;

  final CssLength _left;

  final CssLength _right;

  /// The top measurement.
  final CssLength top;

  /// Creates a set.
  const CssLengthBox({
    this.bottom,
    this.inlineEnd,
    this.inlineStart,
    CssLength left,
    CssLength right,
    this.top,
  })  : _left = left,
        _right = right;

  /// Creates a copy with the given measurements replaced with the new values.
  CssLengthBox copyWith({
    CssLength bottom,
    CssLength inlineEnd,
    CssLength inlineStart,
    CssLength left,
    CssLength right,
    CssLength top,
  }) =>
      CssLengthBox(
        bottom: bottom ?? this.bottom,
        inlineEnd: inlineEnd ?? this.inlineEnd,
        inlineStart: inlineStart ?? this.inlineStart,
        left: left ?? _left,
        right: right ?? _right,
        top: top ?? this.top,
      );

  /// Returns `true` if any of the left, right, inline measurements is set.
  bool get hasLeftOrRight =>
      inlineEnd?.isNotEmpty == true ||
      inlineStart?.isNotEmpty == true ||
      _left?.isNotEmpty == true ||
      _right?.isNotEmpty == true;

  /// Calculates the left value taking text direction into account.
  double getValueLeft(TextStyleHtml tsh) => (_left ??
          (tsh.textDirection == TextDirection.ltr ? inlineStart : inlineEnd))
      ?.getValue(tsh);

  /// Calculates the right value taking text direction into account.
  double getValueRight(TextStyleHtml tsh) => (_right ??
          (tsh.textDirection == TextDirection.ltr ? inlineEnd : inlineStart))
      ?.getValue(tsh);
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
