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
      (_all?.isNoOp != false) &&
      (_bottom?.isNoOp != false) &&
      (_inlineEnd?.isNoOp != false) &&
      (_inlineStart?.isNoOp != false) &&
      (_left?.isNoOp != false) &&
      (_right?.isNoOp != false) &&
      (_top?.isNoOp != false) &&
      radiusBottomLeft == CssRadius.zero &&
      radiusBottomRight == CssRadius.zero &&
      radiusTopLeft == CssRadius.zero &&
      radiusTopRight == CssRadius.zero;

  /// Creates a copy of this border with the sides from [other].
  CssBorder copyFrom(CssBorder other) => copyWith(
        all: other._all,
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
    CssBorderSide? all,
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
        all: CssBorderSide._copyWith(_all, all),
        bottom: all != null ? null : CssBorderSide._copyWith(_bottom, bottom),
        inlineEnd:
            all != null ? null : CssBorderSide._copyWith(_inlineEnd, inlineEnd),
        inlineStart: all != null
            ? null
            : CssBorderSide._copyWith(_inlineStart, inlineStart),
        left: all != null ? null : CssBorderSide._copyWith(_left, left),
        right: all != null ? null : CssBorderSide._copyWith(_right, right),
        top: all != null ? null : CssBorderSide._copyWith(_top, top),
        radiusBottomLeft: radiusBottomLeft ?? this.radiusBottomLeft,
        radiusBottomRight: radiusBottomRight ?? this.radiusBottomRight,
        radiusTopLeft: radiusTopLeft ?? this.radiusTopLeft,
        radiusTopRight: radiusTopRight ?? this.radiusTopRight,
      );

  /// Calculates [Border].
  Border? getBorder(InheritedProperties resolved) {
    final isRtl = resolved.isRtl;
    final bottom = CssBorderSide._copyWith(_all, _bottom)?._getValue(resolved);
    final left = CssBorderSide._copyWith(
      _all,
      _left ?? (isRtl ? _inlineEnd : _inlineStart),
    )?._getValue(resolved);
    final right = CssBorderSide._copyWith(
      _all,
      _right ?? (isRtl ? _inlineStart : _inlineEnd),
    )?._getValue(resolved);
    final top = CssBorderSide._copyWith(_all, _top)?._getValue(resolved);
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
  BorderRadius? getBorderRadius(InheritedProperties resolved) {
    final topLeft = radiusTopLeft._getValue(resolved);
    final topRight = radiusTopRight._getValue(resolved);
    final bottomLeft = radiusBottomLeft._getValue(resolved);
    final bottomRight = radiusBottomRight._getValue(resolved);
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

  Radius? _getValue(InheritedProperties resolved) => this == zero
      ? null
      : Radius.elliptical(
          x.getValue(resolved) ?? 0.0,
          y.getValue(resolved) ?? 0.0,
        );
}

/// A side of a border of a box.
@immutable
class CssBorderSide {
  /// The color of this side of the border.
  final CssColor? color;

  /// The style of this side of the border.
  final TextDecorationStyle? style;

  /// The width of this side of the border.
  final CssLength? width;

  /// Creates the side of a border.
  const CssBorderSide({this.color, this.style, this.width});

  /// A border that is not rendered.
  static const none = CssBorderSide();

  /// Returns `true` if either [style] or [width] is invalid.
  ///
  /// Border will use the default text color so [color] is not required.
  bool get isNoOp => style == null || width?.isPositive != true;

  BorderSide? _getValue(InheritedProperties resolved) {
    if (identical(this, none)) {
      return null;
    }

    final scopedColor = color?.getValue(resolved);
    if (scopedColor == null) {
      return null;
    }

    final scopedWidth = width?.getValue(resolved);
    if (scopedWidth == null) {
      return null;
    }

    return BorderSide(
      color: scopedColor,
      // TODO: add proper support for other border styles
      style: style != null ? BorderStyle.solid : BorderStyle.none,
      width: scopedWidth,
    );
  }

  static CssBorderSide? _copyWith(CssBorderSide? base, CssBorderSide? value) {
    final CssBorderSide? copied;
    if (base == null || value == none) {
      copied = value;
    } else if (value == null) {
      copied = base;
    } else {
      copied = CssBorderSide(
        color: value.color ?? base.color,
        style: value.style ?? base.style,
        width: value.width ?? base.width,
      );
    }

    if (copied?.isNoOp == true) {
      return none;
    }

    return copied;
  }
}

// A color.
@immutable
abstract class CssColor {
  /// Returns the raw value.
  Color? get rawValue;

  /// Calculates [Color].
  Color? getValue(InheritedProperties resolved);

  /// Creates a color with the given integer value.
  factory CssColor(int value) => _CssColorValue(Color(value));

  /// Creates a `currentcolor`.
  ///
  /// See https://developer.mozilla.org/en-US/docs/Web/CSS/color_value#currentcolor_keyword
  factory CssColor.current() => const _CssColorCurrent();

  /// Creates a color with the given value.
  factory CssColor.value(Color value) => _CssColorValue(value);

  /// Creates a transparent color.
  factory CssColor.transparent() => const _CssColorValue(Color(0x00000000));
}

class _CssColorCurrent implements CssColor {
  const _CssColorCurrent();

  @override
  Color? get rawValue => null;

  @override
  Color? getValue(InheritedProperties resolved) =>
      resolved.get<TextStyle>()?.color;
}

class _CssColorValue implements CssColor {
  @override
  final Color rawValue;

  const _CssColorValue(this.rawValue);

  @override
  Color? getValue(InheritedProperties resolved) => rawValue;
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
    InheritedProperties resolved, {
    double? baseValue,
    double? scaleFactor,
  }) {
    double value;
    var effectiveScaleFactor = scaleFactor ?? 1.0;

    switch (unit) {
      case CssLengthUnit.auto:
        return null;
      case CssLengthUnit.em:
        baseValue ??= resolved.get<TextStyle>()?.fontSize;
        if (baseValue == null) {
          return null;
        }

        value = baseValue * number;
        effectiveScaleFactor = 1;
      case CssLengthUnit.percentage:
        if (baseValue == null) {
          return null;
        }

        value = baseValue * number / 100;
        effectiveScaleFactor = 1;
      case CssLengthUnit.pt:
        value = number * 96 / 72;
      case CssLengthUnit.px:
        value = number;
    }

    return value * effectiveScaleFactor;
  }

  @override
  String toString() =>
      number.toString() + (unit == CssLengthUnit.percentage ? '%' : unit.name);
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

  /// Calculates the left length taking text direction into account.
  CssLength? getLeft(InheritedProperties resolved) =>
      _left ?? (resolved.isRtl ? _inlineEnd : _inlineStart);

  /// Calculates the right length taking text direction into account.
  CssLength? getRight(InheritedProperties resolved) =>
      _right ?? (resolved.isRtl ? _inlineStart : _inlineEnd);

  @override
  String toString() {
    const null_ = 'null';
    final left = (_left ?? _inlineStart)?.toString() ?? null_;
    final top = this.top?.toString() ?? null_;
    final right = (_right ?? _inlineEnd)?.toString() ?? null_;
    final bottom = this.bottom?.toString() ?? null_;
    if (left == right && right == top && top == bottom) {
      return 'CssLengthBox.all($left)';
    }

    final values = [left, top, right, bottom];
    if (values.where((v) => v == null_).length == 3) {
      if (left != null_) {
        if (_left != null) {
          return 'CssLengthBox(left=$_left)';
        } else {
          return 'CssLengthBox(inline-start=$_inlineStart)';
        }
      }
      if (top != null_) {
        return 'CssLengthBox(top=$top)';
      }
      if (right != null_) {
        if (_right != null) {
          return 'CssLengthBox(right=$_right)';
        } else {
          return 'CssLengthBox(inline-end=$_inlineEnd)';
        }
      }
      if (bottom != null_) {
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

/// A single shadow.
///
/// See [Shadow].
class CssShadow {
  /// The blur radius.
  ///
  /// See [Shadow.blurRadius].
  final CssLength blurRadius;

  /// Color that the shadow will be drawn with.
  ///
  /// See [Shadow.color].
  final CssColor color;

  /// The x component of [Shadow.offset].
  ///
  /// See [Offset.dx].
  final CssLength offsetX;

  /// The y component of [Shadow.offset].
  ///
  /// See [Offset.dy]
  final CssLength offsetY;

  /// Creates a single shadow.
  CssShadow({
    required this.blurRadius,
    required this.color,
    required this.offsetX,
    required this.offsetY,
  });

  /// Calculates [Shadow].
  Shadow? getValue(InheritedProperties resolved) {
    final color = this.color.getValue(resolved);
    if (color == null) {
      return null;
    }

    final offsetX = this.offsetX.getValue(resolved);
    if (offsetX == null) {
      return null;
    }

    final offsetY = this.offsetY.getValue(resolved);
    if (offsetY == null) {
      return null;
    }

    final blurRadius = this.blurRadius.getValue(resolved);
    if (blurRadius == null) {
      return null;
    }

    return Shadow(
      blurRadius: blurRadius,
      color: color,
      offset: Offset(offsetX, offsetY),
    );
  }
}

/// The whitespace behavior.
enum CssWhitespace {
  /// Sequences of white space are collapsed.
  /// Newline characters in the source are handled the same as other whitespace.
  /// Lines are broken as necessary to fill line boxes.
  normal,

  /// Collapses white space as for normal,
  /// but suppresses line breaks (text wrapping) within the source.
  nowrap,

  /// Sequences of white space are preserved.
  /// Lines are only broken at newline characters in the source and at `BR`s.
  pre,
}

extension on InheritedProperties {
  bool get isRtl => get<TextDirection>() == TextDirection.rtl;
}
