import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class CssSizing extends SingleChildRenderObjectWidget {
  final BoxConstraints constraints;
  final Size size;

  CssSizing({
    @required Widget child,
    @required this.constraints,
    Key key,
    @required this.size,
  })  : assert(child != null),
        assert(constraints != null),
        assert(constraints.debugAssertIsValid()),
        assert(size != null),
        super(child: child, key: key);

  @override
  _RenderCssSizing createRenderObject(BuildContext _) =>
      _RenderCssSizing(additionalConstraints: constraints, preferredSize: size);

  @override
  void updateRenderObject(BuildContext _, _RenderCssSizing renderObject) {
    renderObject.additionalConstraints = constraints;
    renderObject.preferredSize = size;
  }
}

class _RenderCssSizing extends RenderProxyBox {
  _RenderCssSizing({
    RenderBox child,
    @required BoxConstraints additionalConstraints,
    @required Size preferredSize,
  })  : assert(additionalConstraints != null),
        assert(additionalConstraints.debugAssertIsValid()),
        assert(preferredSize != null),
        _additionalConstraints = additionalConstraints,
        _preferredSize = preferredSize,
        _preferredRatio = _calculateRatio(preferredSize),
        super(child);

  BoxConstraints _additionalConstraints;
  set additionalConstraints(BoxConstraints value) {
    assert(value != null);
    assert(value.debugAssertIsValid());
    if (_additionalConstraints == value) return;
    _additionalConstraints = value;
    markNeedsLayout();
  }

  Size _preferredSize;
  double _preferredRatio;
  set preferredSize(Size value) {
    assert(value != null);
    if (_preferredSize == value) return;
    _preferredSize = value;
    _preferredRatio = _calculateRatio(value);
    markNeedsLayout();
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    if (height.isFinite && _preferredRatio != null) {
      return height * _preferredRatio;
    }

    if (_additionalConstraints.hasBoundedWidth &&
        _additionalConstraints.hasTightWidth) {
      return _additionalConstraints.minWidth;
    }

    final width = super.computeMinIntrinsicWidth(height);
    if (!_additionalConstraints.hasInfiniteWidth) {
      return _additionalConstraints.constrainWidth(width);
    }

    return width;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    if (height.isFinite && _preferredRatio != null) {
      return height * _preferredRatio;
    }

    if (_additionalConstraints.hasBoundedWidth &&
        _additionalConstraints.hasTightWidth) {
      return _additionalConstraints.minWidth;
    }

    final width = super.computeMaxIntrinsicWidth(height);
    if (!_additionalConstraints.hasInfiniteWidth) {
      return _additionalConstraints.constrainWidth(width);
    }

    return width;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    if (width.isFinite && _preferredRatio != null) {
      return width / _preferredRatio;
    }

    if (_additionalConstraints.hasBoundedHeight &&
        _additionalConstraints.hasTightHeight) {
      return _additionalConstraints.minHeight;
    }

    final height = super.computeMinIntrinsicHeight(width);
    if (!_additionalConstraints.hasInfiniteHeight) {
      return _additionalConstraints.constrainHeight(height);
    }

    return height;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    if (width.isFinite && _preferredRatio != null) {
      return width / _preferredRatio;
    }

    if (_additionalConstraints.hasBoundedHeight &&
        _additionalConstraints.hasTightHeight) {
      return _additionalConstraints.minHeight;
    }

    final height = super.computeMaxIntrinsicHeight(width);
    if (!_additionalConstraints.hasInfiniteHeight) {
      return _additionalConstraints.constrainHeight(height);
    }

    return height;
  }

  @override
  void performLayout() {
    final a = _additionalConstraints;
    final c = constraints;

    // enforce additional contraints with parent's (ignoring lower bounds)
    var cc = a.enforce(c.loosen());
    final s = _applyPreferredRatio(cc);

    if (s != null) {
      // we have both preferred width & height
      cc = BoxConstraints.tight(s);
    } else if (_preferredSize.height.isFinite) {
      // we have preferred height
      final height = cc.constrainHeight(_preferredSize.height);
      cc = cc.copyWith(maxHeight: height, minHeight: height);
    } else if (_preferredSize.width.isFinite) {
      // we have preferred width
      final width = cc.constrainWidth(_preferredSize.width);
      cc = cc.copyWith(maxWidth: width, minWidth: width);
    }

    child.layout(cc, parentUsesSize: true);
    size = c.constrain(child.size);
  }

  Size _applyPreferredRatio(BoxConstraints c) {
    if (_preferredRatio == null) return null;

    var width = _preferredSize.width ?? c.maxWidth;
    double height;

    if (width.isFinite) {
      height = width / _preferredRatio;
    } else {
      height = _preferredSize.height ?? c.maxHeight;
      width = height * _preferredRatio;
    }

    if (width > c.maxWidth) {
      width = c.maxWidth;
      height = width / _preferredRatio;
    }

    if (height > c.maxHeight) {
      height = c.maxHeight;
      width = height * _preferredRatio;
    }

    if (width < c.minWidth) {
      width = c.minWidth;
      height = width / _preferredRatio;
    }

    if (height < c.minHeight) {
      height = c.minHeight;
      width = height * _preferredRatio;
    }

    return Size(width, height);
  }

  static double _calculateRatio(Size size) => size.width.isFinite == true &&
          size.height.isFinite == true &&
          size.height != 0
      ? size.width / size.height
      : null;
}
