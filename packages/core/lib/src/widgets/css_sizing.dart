import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A CSS sizing widget.
class CssSizing extends SingleChildRenderObjectWidget {
  /// The maximum height.
  final CssSizingValue maxHeight;

  /// The maximum width.
  final CssSizingValue maxWidth;

  /// The minimum height.
  final CssSizingValue minHeight;

  // The minimum width;
  final CssSizingValue minWidth;

  /// The preferred height.
  final CssSizingValue preferredHeight;

  /// The preferred width.
  final CssSizingValue preferredWidth;

  /// Creates a CSS sizing.
  CssSizing({
    @required Widget child,
    Key key,
    this.maxHeight,
    this.maxWidth,
    this.minHeight,
    this.minWidth,
    this.preferredHeight,
    this.preferredWidth,
  })  : assert(child != null),
        super(child: child, key: key);

  @override
  _RenderCssSizing createRenderObject(BuildContext _) => _RenderCssSizing(
        maxHeight: maxHeight,
        maxWidth: maxWidth,
        minHeight: minHeight,
        minWidth: minWidth,
        preferredHeight: preferredHeight,
        preferredWidth: preferredWidth,
      );

  @override
  void updateRenderObject(BuildContext _, _RenderCssSizing renderObject) {
    renderObject.setConstraints(
      maxHeight: maxHeight,
      maxWidth: maxWidth,
      minHeight: minHeight,
      minWidth: minWidth,
    );
    renderObject.setPreferredSize(preferredWidth, preferredHeight);
  }
}

class _RenderCssSizing extends RenderProxyBox {
  _RenderCssSizing({
    RenderBox child,
    CssSizingValue maxHeight,
    CssSizingValue maxWidth,
    CssSizingValue minHeight,
    CssSizingValue minWidth,
    CssSizingValue preferredHeight,
    CssSizingValue preferredWidth,
  })  : _maxHeight = maxHeight,
        _maxWidth = maxWidth,
        _minHeight = minHeight,
        _minWidth = minWidth,
        _preferredHeight = preferredHeight,
        _preferredWidth = preferredWidth,
        super(child);

  CssSizingValue _maxHeight;
  CssSizingValue _maxWidth;
  CssSizingValue _minHeight;
  CssSizingValue _minWidth;
  void setConstraints({
    CssSizingValue maxHeight,
    CssSizingValue maxWidth,
    CssSizingValue minHeight,
    CssSizingValue minWidth,
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

  CssSizingValue _preferredHeight;
  CssSizingValue _preferredWidth;
  void setPreferredSize(CssSizingValue width, CssSizingValue height) {
    if (height == _preferredHeight && width == _preferredWidth) return;
    _preferredHeight = height;
    _preferredWidth = width;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    final c = constraints;
    var maxHeight =
        min(c.maxHeight, _maxHeight?.clamp(0.0, c.maxHeight) ?? c.maxHeight);
    var maxWidth =
        min(c.maxWidth, _maxWidth?.clamp(0.0, c.maxWidth) ?? c.maxWidth);
    var minHeight =
        min(maxHeight, _minHeight?.clamp(0.0, c.maxHeight) ?? c.minHeight);
    var minWidth =
        min(maxWidth, _minWidth?.clamp(0.0, c.maxWidth) ?? c.minWidth);

    if (_preferredHeight != null) {
      maxHeight = minHeight = _preferredHeight.clamp(minHeight, maxHeight);
    }
    if (_preferredWidth != null) {
      // special handling for tight contraints: ignore min in `clamp()`
      // (usually happen if parent is a block)
      final effectiveMinWidth = minWidth == maxWidth ? 0.0 : minWidth;
      maxWidth = minWidth = _preferredWidth.clamp(effectiveMinWidth, maxWidth);
    }

    final cc = BoxConstraints(
      maxHeight: maxHeight,
      maxWidth: maxWidth,
      minHeight: minHeight,
      minWidth: minWidth,
    );

    child.layout(cc, parentUsesSize: true);
    size = constraints.constrain(child.size);
  }
}

/// A [CssSizing] value.
abstract class CssSizingValue {
  CssSizingValue._();
  double clamp(double min, double max);

  /// Creates a percentage value.
  factory CssSizingValue.percentage(double _) = _CssSizingPercentage;

  /// Creates a fixed value.
  factory CssSizingValue.value(double _) = _CssSizingValue;
}

class _CssSizingPercentage extends CssSizingValue {
  final double percentage;
  _CssSizingPercentage(this.percentage) : super._();
  @override
  double clamp(double min, double max) => (max * percentage).clamp(min, max);

  @override
  int get hashCode => percentage.hashCode;
  @override
  bool operator ==(Object other) =>
      other is _CssSizingPercentage ? other.percentage == percentage : false;
  @override
  String toString() => '$percentage%';
}

class _CssSizingValue extends CssSizingValue {
  final double value;
  _CssSizingValue(this.value) : super._();
  @override
  double clamp(double min, double max) => value.clamp(min, max);

  @override
  int get hashCode => value.hashCode;
  @override
  bool operator ==(Object other) =>
      other is _CssSizingValue ? other.value == value : false;
  @override
  String toString() => '${value}px';
}
