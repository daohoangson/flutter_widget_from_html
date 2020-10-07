import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A CSS block.
class CssBlock extends SingleChildRenderObjectWidget {
  /// The default constraint for block element.
  static const kBlockWidth = _CssSizingPercentage(100);

  /// Creates a CSS block.
  CssBlock({@required Widget child, Key key})
      : assert(child != null),
        super(child: child, key: key);

  @override
  _RenderCssSizing createRenderObject(BuildContext _) =>
      _RenderCssSizing(preferredWidth: kBlockWidth);
}

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
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _debugFillProperty(properties, 'maxHeight', maxHeight);
    _debugFillProperty(properties, 'maxWidth', maxWidth);
    _debugFillProperty(properties, 'minHeight', minHeight);
    _debugFillProperty(properties, 'minWidth', minWidth);
    _debugFillProperty(properties, 'preferredHeight', preferredHeight);
    _debugFillProperty(properties, 'preferredWidth', preferredWidth);
  }

  void _debugFillProperty(DiagnosticPropertiesBuilder properties, String name,
      CssSizingValue value) {
    if (value == null) return;
    properties.add(DiagnosticsProperty<CssSizingValue>(name, value));
  }

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
    final maxHeight =
        min(c.maxHeight, _maxHeight?.clamp(0.0, c.maxHeight) ?? c.maxHeight);
    final maxWidth =
        min(c.maxWidth, _maxWidth?.clamp(0.0, c.maxWidth) ?? c.maxWidth);
    final minHeight =
        min(maxHeight, _minHeight?.clamp(0.0, c.maxHeight) ?? c.minHeight);
    final minWidth =
        min(maxWidth, _minWidth?.clamp(0.0, c.maxWidth) ?? c.minWidth);

    final __preferredHeight = _preferredHeight?.clamp(minHeight, maxHeight);
    // special handling for tight contraints: ignore min in `clamp()`
    // (usually happen if parent is a block)
    final effectiveMinWidth = minWidth == maxWidth ? 0.0 : minWidth;
    final __preferredWidth =
        _preferredWidth?.clamp(effectiveMinWidth, maxWidth);
    // ignore preferred value if it's infinite
    final preferredHeight =
        __preferredHeight == double.infinity ? null : __preferredHeight;
    final preferredWidth =
        __preferredWidth == double.infinity ? null : __preferredWidth;

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

    child.layout(cc, parentUsesSize: true);
    size = constraints.constrain(child.size);
  }

  Size _guessChildSize({
    double maxHeight,
    double maxWidth,
    double preferredHeight,
    double preferredWidth,
  }) {
    final childHeightByPreferredWidth =
        child.getMaxIntrinsicHeight(preferredWidth);
    if (childHeightByPreferredWidth !=
            child.getMinIntrinsicHeight(preferredWidth) ||
        childHeightByPreferredWidth == 0) {
      return null;
    }

    final childWidthByPreferredHeight =
        child.getMaxIntrinsicWidth(preferredHeight);
    if (childWidthByPreferredHeight !=
        child.getMinIntrinsicWidth(preferredHeight)) {
      return null;
    }

    final childAspectRatio = childWidthByPreferredHeight / preferredHeight;
    if (childAspectRatio != preferredWidth / childHeightByPreferredWidth) {
      return null;
    }

    // child appears to have a stable aspect ratio
    var childWidth = preferredWidth;
    var childHeight = childWidth / childAspectRatio;
    if (childHeight < preferredHeight) {
      childHeight = preferredHeight;
      childWidth = childHeight * childAspectRatio;
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
  double clamp(double min, double max);

  /// Creates an auto value.
  factory CssSizingValue.auto() = _CssSizingAuto;

  /// Creates a percentage value.
  factory CssSizingValue.percentage(double _) = _CssSizingPercentage;

  /// Creates a fixed value.
  factory CssSizingValue.value(double _) = _CssSizingValue;
}

class _CssSizingAuto extends CssSizingValue {
  const _CssSizingAuto() : super._();
  @override
  double clamp(double _, double __) => null;

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
  double clamp(double min, double max) => (max * percentage).clamp(min, max);

  @override
  int get hashCode => percentage.hashCode;
  @override
  bool operator ==(Object other) =>
      other is _CssSizingPercentage ? other.percentage == percentage : false;
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
      other is _CssSizingValue ? other.value == value : false;
  @override
  String toString() => value.toStringAsFixed(1);
}
