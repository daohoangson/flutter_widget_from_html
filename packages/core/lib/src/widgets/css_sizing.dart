import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A CSS block.
class CssBlock extends CssSizing {
  /// Creates a CSS block.
  const CssBlock({required Widget child, Key? key})
      : super(child: child, key: key);

  @override
  RenderObject createRenderObject(BuildContext _) =>
      _RenderCssSizing(preferredWidth: const CssSizingValue.percentage(100));

  @override
  void updateRenderObject(BuildContext _, RenderObject renderObject) =>
      (renderObject as _RenderCssSizing).setPreferredSize(
        null,
        const CssSizingValue.percentage(100),
        null,
      );
}

/// A CSS sizing widget.
class CssSizing extends SingleChildRenderObjectWidget {
  /// The maximum height.
  final CssSizingValue? maxHeight;

  /// The maximum width.
  final CssSizingValue? maxWidth;

  /// The minimum height.
  final CssSizingValue? minHeight;

  // The minimum width;
  final CssSizingValue? minWidth;

  /// The preferred axis.
  ///
  /// When both dimensions have preferred value, one will have higher priority.
  /// If the preferred axis is [Axis.vertical] and child size seems to be stable
  /// (e.g. has the same aspect ratio regardless of layout constraints)
  /// the [preferredHeight] will be used for sizing.
  ///
  /// By default (`null` preferred axis), [preferredWidth] will be used.
  final Axis? preferredAxis;

  /// The preferred height.
  final CssSizingValue? preferredHeight;

  /// The preferred width.
  final CssSizingValue? preferredWidth;

  /// Creates a CSS sizing.
  const CssSizing({
    required Widget child,
    Key? key,
    this.maxHeight,
    this.maxWidth,
    this.minHeight,
    this.minWidth,
    this.preferredAxis,
    this.preferredHeight,
    this.preferredWidth,
  }) : super(child: child, key: key);

  @override
  RenderObject createRenderObject(BuildContext _) => _RenderCssSizing(
        maxHeight: maxHeight,
        maxWidth: maxWidth,
        minHeight: minHeight,
        minWidth: minWidth,
        preferredAxis: preferredAxis,
        preferredHeight: preferredHeight,
        preferredWidth: preferredWidth,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperty(properties, 'maxHeight', maxHeight);
    _debugFillProperty(properties, 'maxWidth', maxWidth);
    _debugFillProperty(properties, 'minHeight', minHeight);
    _debugFillProperty(properties, 'minWidth', minWidth);

    final preferredBoth = preferredHeight != null && preferredWidth != null;
    final preferredVertical = preferredBoth && preferredAxis == Axis.vertical;
    final preferredHorizontal =
        preferredBoth && preferredAxis == Axis.horizontal;
    _debugFillProperty(
      properties,
      'preferredHeight${preferredVertical ? '*' : ''}',
      preferredHeight,
    );
    _debugFillProperty(
      properties,
      'preferredWidth${preferredHorizontal ? '*' : ''}',
      preferredWidth,
    );
  }

  void _debugFillProperty(
    DiagnosticPropertiesBuilder properties,
    String name,
    CssSizingValue? value,
  ) {
    if (value == null) {
      return;
    }
    properties.add(DiagnosticsProperty(name, value));
  }

  @override
  void updateRenderObject(BuildContext _, RenderObject renderObject) {
    (renderObject as _RenderCssSizing)
      ..setConstraints(
        maxHeight: maxHeight,
        maxWidth: maxWidth,
        minHeight: minHeight,
        minWidth: minWidth,
      )
      ..setPreferredSize(
        preferredAxis,
        preferredWidth,
        preferredHeight,
      );
  }
}

class _RenderCssSizing extends RenderProxyBox {
  _RenderCssSizing({
    RenderBox? child,
    CssSizingValue? maxHeight,
    CssSizingValue? maxWidth,
    CssSizingValue? minHeight,
    CssSizingValue? minWidth,
    Axis? preferredAxis,
    CssSizingValue? preferredHeight,
    CssSizingValue? preferredWidth,
  })  : _maxHeight = maxHeight,
        _maxWidth = maxWidth,
        _minHeight = minHeight,
        _minWidth = minWidth,
        _preferredAxis = preferredAxis,
        _preferredHeight = preferredHeight,
        _preferredWidth = preferredWidth,
        super(child);

  CssSizingValue? _maxHeight;
  CssSizingValue? _maxWidth;
  CssSizingValue? _minHeight;
  CssSizingValue? _minWidth;
  void setConstraints({
    CssSizingValue? maxHeight,
    CssSizingValue? maxWidth,
    CssSizingValue? minHeight,
    CssSizingValue? minWidth,
  }) {
    if (maxHeight == _maxHeight &&
        maxWidth == _maxWidth &&
        minHeight == _minHeight &&
        minWidth == _minWidth) {
      return;
    }
    _maxHeight = maxHeight;
    _maxWidth = maxWidth;
    _minHeight = minHeight;
    _minWidth = minWidth;
    markNeedsLayout();
  }

  Axis? _preferredAxis;
  CssSizingValue? _preferredHeight;
  CssSizingValue? _preferredWidth;
  void setPreferredSize(
    Axis? axis,
    CssSizingValue? width,
    CssSizingValue? height,
  ) {
    if (axis == _preferredAxis &&
        height == _preferredHeight &&
        width == _preferredWidth) {
      return;
    }

    _preferredAxis = axis;
    _preferredHeight = height;
    _preferredWidth = width;
    markNeedsLayout();
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final cc = _applyContraints(constraints);
    final childSize = child!.getDryLayout(cc);
    return constraints.constrain(childSize);
  }

  @override
  void performLayout() {
    final cc = _applyContraints(constraints);
    child!.layout(cc, parentUsesSize: true);
    size = constraints.constrain(child!.size);
  }

  BoxConstraints _applyContraints(BoxConstraints c) {
    final maxHeight = _maxHeight?.clamp(0.0, c.maxHeight) ?? c.maxHeight;
    final maxWidth = _maxWidth?.clamp(0.0, c.maxWidth) ?? c.maxWidth;

    // special treatment for min values: ignore incoming constraint if it's tight
    final calculatedMinHeight = min(
      maxHeight,
      _minHeight?.clamp(0.0, c.maxHeight) ??
          (c.hasTightHeight ? .0 : c.minHeight),
    );
    final calculatedMinWidth = min(
      maxWidth,
      _minWidth?.clamp(0.0, c.maxWidth) ?? (c.hasTightWidth ? .0 : c.minWidth),
    );
    // ignore min value if it's infinite
    final minHeight = calculatedMinHeight.isFinite ? calculatedMinHeight : .0;
    final minWidth = calculatedMinWidth.isFinite ? calculatedMinWidth : .0;

    final calculatedPreferredHeight =
        _preferredHeight?.clamp(minHeight, maxHeight);
    final calculatedPreferredWidth = _preferredWidth?.clamp(minWidth, maxWidth);
    // ignore preferred value if it's infinite
    final preferredHeight = calculatedPreferredHeight?.isFinite == true
        ? calculatedPreferredHeight
        : null;
    final preferredWidth = calculatedPreferredWidth?.isFinite == true
        ? calculatedPreferredWidth
        : null;

    final stableChildSize = (preferredHeight != null && preferredWidth != null)
        ? _guessChildSize(
            maxHeight: maxHeight,
            maxWidth: maxWidth,
            preferredHeight: preferredHeight,
            preferredWidth: preferredWidth,
          )
        : null;

    final cc = BoxConstraints(
      maxHeight: stableChildSize?.height ?? preferredHeight ?? maxHeight,
      maxWidth: stableChildSize?.width ?? preferredWidth ?? maxWidth,
      minHeight: stableChildSize?.height ?? preferredHeight ?? minHeight,
      minWidth: stableChildSize?.width ?? preferredWidth ?? minWidth,
    );

    return cc;
  }

  Size? _guessChildSize({
    required double maxHeight,
    required double maxWidth,
    required double preferredHeight,
    required double preferredWidth,
  }) {
    final tightHeight = BoxConstraints.tightFor(height: preferredHeight);
    late Size sizeHeight;
    try {
      sizeHeight = child!.getDryLayout(tightHeight);
    } catch (error) {
      debugPrint(
        'Unable to guess child size '
        '(preferred size=${preferredWidth}x$preferredHeight) '
        'on tight height: $error',
      );
      return null;
    }

    // it's unlikely that `getDryLayout` works for tight height constraints
    // then fails for tight width so we are not doing error trapping for this:
    final tightWidth = BoxConstraints.tightFor(width: preferredWidth);
    final sizeWidth = child!.getDryLayout(tightWidth);

    final childAspectRatio = sizeWidth.width / sizeWidth.height;
    const epsilon = 0.01;
    if ((childAspectRatio - sizeHeight.width / sizeHeight.height).abs() >
        epsilon) {
      return null;
    }

    // child appears to have a stable aspect ratio
    double? childWidth;
    double? childHeight;
    if (_preferredAxis == Axis.vertical) {
      childHeight = preferredHeight;
      childWidth = childHeight * childAspectRatio;
    } else {
      childWidth = preferredWidth;
      childHeight = childWidth / childAspectRatio;
    }

    if (childWidth > maxWidth) {
      childWidth = maxWidth;
      childHeight = childWidth / childAspectRatio;
    }
    if (childHeight > maxHeight) {
      childHeight = maxHeight;
      childWidth = childHeight * childAspectRatio;
    }

    return Size(childWidth, childHeight);
  }
}

/// A [CssSizing] value.
abstract class CssSizingValue {
  const CssSizingValue._();
  double? clamp(double min, double max);

  /// Creates an auto value.
  const factory CssSizingValue.auto() = _CssSizingAuto;

  /// Creates a percentage value.
  const factory CssSizingValue.percentage(double _) = _CssSizingPercentage;

  /// Creates a fixed value.
  const factory CssSizingValue.value(double _) = _CssSizingValue;
}

class _CssSizingAuto extends CssSizingValue {
  const _CssSizingAuto() : super._();
  @override
  double? clamp(double _, double __) => null;

  @override
  int get hashCode => 0;
  @override
  bool operator ==(Object other) => other is _CssSizingAuto;
  @override
  String toString() => 'auto';
}

class _CssSizingPercentage extends CssSizingValue {
  final double percentage;
  const _CssSizingPercentage(this.percentage) : super._();
  @override
  double clamp(double min, double max) =>
      (max * percentage / 100.0).clamp(min, max);

  @override
  int get hashCode => percentage.hashCode;
  @override
  bool operator ==(Object other) =>
      other is _CssSizingPercentage && other.percentage == percentage;
  @override
  String toString() => '${percentage.toStringAsFixed(1)}%';
}

class _CssSizingValue extends CssSizingValue {
  final double value;
  const _CssSizingValue(this.value) : super._();
  @override
  double clamp(double min, double max) => value.clamp(min, max);

  @override
  int get hashCode => value.hashCode;
  @override
  bool operator ==(Object other) =>
      other is _CssSizingValue && other.value == value;
  @override
  String toString() => value.toStringAsFixed(1);
}
