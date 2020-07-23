part of '../core_helpers.dart';

class CssBlock extends SingleChildRenderObjectWidget {
  const CssBlock({Widget child, Key key}) : super(child: child, key: key);

  @override
  _RenderCssBlock createRenderObject(BuildContext _) => _RenderCssBlock();
}

class _RenderCssBlock extends RenderProxyBox {
  @override
  void performLayout() {
    final c = constraints;
    final cc = c.copyWith(
      minHeight: c.minHeight.isFinite ? c.minHeight : c.minHeight,
      minWidth: c.maxWidth.isFinite ? c.maxWidth : c.minWidth,
    );
    if (child != null) {
      child.layout(cc, parentUsesSize: true);
      size = child.size;
    } else {
      size = cc.constrain(Size.zero);
    }
  }
}

class CssSizing extends SingleChildRenderObjectWidget {
  final BoxConstraints constraints;

  CssSizing({
    Widget child,
    @required this.constraints,
    Key key,
  }) : super(child: child, key: key);

  @override
  _RenderCssSizing createRenderObject(BuildContext _) =>
      _RenderCssSizing(additionalConstraints: constraints);

  @override
  void updateRenderObject(BuildContext _, _RenderCssSizing renderObject) {
    renderObject.additionalConstraints = constraints;
  }
}

class _RenderCssSizing extends RenderProxyBox {
  _RenderCssSizing({
    RenderBox child,
    @required BoxConstraints additionalConstraints,
  })  : assert(additionalConstraints != null),
        assert(additionalConstraints.debugAssertIsValid()),
        _additionalConstraints = additionalConstraints,
        super(child);

  BoxConstraints get additionalConstraints => _additionalConstraints;
  BoxConstraints _additionalConstraints;
  set additionalConstraints(BoxConstraints value) {
    assert(value != null);
    assert(value.debugAssertIsValid());
    if (_additionalConstraints == value) return;
    _additionalConstraints = value;
    markNeedsLayout();
  }

  double get _aspectRatio =>
      _additionalConstraints.isTight && _additionalConstraints.minHeight != 0
          ? _additionalConstraints.minWidth / _additionalConstraints.minHeight
          : null;

  @override
  double computeMinIntrinsicWidth(double height) {
    if (height.isFinite) {
      final aspectRatio = _aspectRatio;
      if (aspectRatio != null) return height * aspectRatio;
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
    if (height.isFinite) {
      final aspectRatio = _aspectRatio;
      if (aspectRatio != null) return height * aspectRatio;
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
    if (width.isFinite) {
      final aspectRatio = _aspectRatio;
      if (aspectRatio != null) return width / aspectRatio;
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
    if (width.isFinite) {
      final aspectRatio = _aspectRatio;
      if (aspectRatio != null) return width / aspectRatio;
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
    final s = _applyAspectRatio();
    final cc = c.copyWith(
      maxHeight: s != null
          ? s.height
          : a.maxHeight > c.maxHeight ? c.maxHeight : a.maxHeight,
      maxWidth: s != null
          ? s.width
          : a.maxWidth > c.maxWidth ? c.maxWidth : a.maxWidth,
      minHeight: s != null
          ? s.height
          : a.minHeight > c.minHeight ? a.minHeight : c.minHeight,
      minWidth: s != null
          ? s.width
          : a.minWidth > c.minWidth ? a.minWidth : c.minWidth,
    );
    if (child != null) {
      child.layout(cc, parentUsesSize: true);
      size = constraints.constrain(child.size);
    } else {
      size = cc.constrain(Size.zero);
    }
  }

  Size _applyAspectRatio() {
    final aspectRatio = _aspectRatio;
    if (aspectRatio == null) return null;

    final a = _additionalConstraints;
    final c = constraints;
    if (a.maxHeight < c.maxHeight && a.maxWidth < c.maxWidth) {
      return Size(a.maxWidth, a.maxHeight);
    }

    var width = c.maxWidth;
    double height;

    if (width.isFinite) {
      height = width / aspectRatio;
    } else {
      height = c.maxHeight;
      width = height * aspectRatio;
    }

    if (width > c.maxWidth) {
      width = c.maxWidth;
      height = width / aspectRatio;
    }

    if (height > c.maxHeight) {
      height = c.maxHeight;
      width = height * aspectRatio;
    }

    if (width < c.minWidth) {
      width = c.minWidth;
      height = width / aspectRatio;
    }

    if (height < c.minHeight) {
      height = c.minHeight;
      width = height * aspectRatio;
    }

    return c.constrain(Size(width, height));
  }
}
