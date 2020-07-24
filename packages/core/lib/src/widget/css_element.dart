part of '../core_helpers.dart';

class CssBlock extends SingleChildRenderObjectWidget {
  const CssBlock({@required Widget child, Key key})
      : assert(child != null),
        super(child: child, key: key);

  @override
  _RenderCssBlock createRenderObject(BuildContext _) => _RenderCssBlock();
}

class _RenderCssBlock extends RenderProxyBox {
  @override
  void performLayout() {
    final c = constraints;
    final cc = c.copyWith(
      minHeight: c.maxHeight.isFinite ? c.maxHeight : null,
      minWidth: c.maxWidth.isFinite ? c.maxWidth : null,
    );

    child.layout(cc, parentUsesSize: true);
    size = child.size;
  }
}

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

    // we have both preferred width & height
    var cc = _applyPreferredRatio();

    if (cc == null) {
      // enforce additional contraints with parent's
      cc = a.enforce(c);

      if (_preferredSize.height.isFinite) {
        // we have preferred height
        final height = cc.constrainHeight(_preferredSize.height);
        cc = cc.copyWith(maxHeight: height, minHeight: height);
      } else if (_preferredSize.width.isFinite) {
        // we have preferred width
        final width = cc.constrainWidth(_preferredSize.width);
        cc = cc.copyWith(maxWidth: width, minWidth: width);
      }
    }

    child.layout(cc, parentUsesSize: true);
    size = c.constrain(child.size);
  }

  BoxConstraints _applyPreferredRatio() {
    if (_preferredRatio == null) return null;

    final c = constraints;
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

    return BoxConstraints.tight(Size(width, height));
  }

  static double _calculateRatio(Size size) => size.width.isFinite == true &&
          size.height.isFinite == true &&
          size.height != 0
      ? size.width / size.height
      : null;
}
