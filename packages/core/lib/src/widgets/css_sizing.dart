import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A CSS sizing widget.
///
/// [child] will be layouted to match its preferred ratio if [size] is provided.
/// Additional constraints will be applied loosely in order to
/// stay as close as possible to the preferred width / height.
class CssSizing extends SingleChildRenderObjectWidget {
  /// The maximum height.
  final double maxHeight;

  /// The maximum width.
  final double maxWidth;

  /// The minimum height.
  final double minHeight;

  // The minimum width;
  final double minWidth;

  /// The preferred height.
  final double preferredHeight;

  /// The preferred width.
  final double preferredWidth;

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
    Key key,
    double maxHeight,
    double maxWidth,
    double minHeight,
    double minWidth,
    double preferredHeight,
    double preferredWidth,
  })  : _maxHeight = maxHeight,
        _maxWidth = maxWidth,
        _minHeight = minHeight,
        _minWidth = minWidth,
        _preferredHeight = preferredHeight,
        _preferredWidth = preferredWidth,
        super(child);

  double _maxHeight;
  double _maxWidth;
  double _minHeight;
  double _minWidth;
  void setConstraints({
    double maxHeight,
    double maxWidth,
    double minHeight,
    double minWidth,
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

  double _preferredHeight;
  double _preferredWidth;
  void setPreferredSize(double width, double height) {
    if (height == _preferredHeight && width == _preferredWidth) return;
    _preferredHeight = height;
    _preferredWidth = width;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    final c = constraints;
    var maxHeight = min(c.maxHeight, _maxHeight ?? c.maxHeight);
    var maxWidth = min(c.maxWidth, _maxWidth ?? c.maxWidth);
    var minHeight = min(maxHeight, _minHeight ?? c.minHeight);
    var minWidth = min(maxWidth, _minWidth ?? c.minWidth);

    if (_preferredHeight != null) {
      maxHeight = minHeight = _preferredHeight.clamp(minHeight, maxHeight);
    }
    if (_preferredWidth != null) {
      // special handling for tight contraints: ignore min in `clamp()`
      // (usually happen if parent is a block)
      final effectiveMinWidth = minWidth == maxWidth ? 0 : minWidth;
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
