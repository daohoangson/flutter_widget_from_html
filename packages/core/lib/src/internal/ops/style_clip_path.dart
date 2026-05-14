// Public shape classes intentionally reference private helper types
// (_CssClipPathPoint, _CssClipPathTrbl, _CssClipPathRadius) that live in the
// same library via `part`. They are implementation details and not reachable
// by consumers of the public API.
// ignore_for_file: library_private_types_in_public_api
part of '../core_ops.dart';

const kCssClipPath = 'clip-path';
const kCssClipPathCircle = 'circle';
const kCssClipPathEllipse = 'ellipse';
const kCssClipPathInset = 'inset';
const kCssClipPathNone = 'none';
const kCssClipPathPath = 'path';
const kCssClipPathPolygon = 'polygon';
const kCssClipPathRect = 'rect';
const kCssClipPathXywh = 'xywh';

class StyleClipPath {
  final WidgetFactory wf;

  StyleClipPath(this.wf);

  BuildOp get buildOp => BuildOp(
        alwaysRenderBlock: false,
        debugLabel: kCssClipPath,
        onRenderBlock: (tree, placeholder) {
          final shape = tree.clipPathData.shape;
          if (shape == null) {
            return placeholder;
          }

          if (shape is CssClipPathSvgPath) {
            return placeholder.wrapWith(
              (_, child) {
                final path = wf.buildClipPathFromSvgData(shape.pathData);
                if (path == null) {
                  return child;
                }
                return wf.buildClipPath(tree, child, _FixedPathClipper(path)) ??
                    child;
              },
            );
          }

          return placeholder.wrapWith(
            (_, child) =>
                wf.buildClipPath(tree, child, CssClipPathClipper(shape)),
          );
        },
        priority: BoxModel.clipPath,
      );
}

@immutable
class _FixedPathClipper extends CustomClipper<Path> {
  final Path _path;

  const _FixedPathClipper(this._path);

  @override
  Path getClip(Size size) => _path;

  @override
  bool shouldReclip(covariant _FixedPathClipper oldClipper) =>
      oldClipper._path != _path;
}

@immutable
class CssClipPathClipper extends CustomClipper<Path> {
  final CssClipPathShape shape;

  const CssClipPathClipper(this.shape);

  @override
  Path getClip(Size size) => shape.toPath(size);

  @override
  bool shouldReclip(covariant CssClipPathClipper oldClipper) =>
      oldClipper.shape != shape;
}

@immutable
abstract class CssClipPathShape {
  const CssClipPathShape();

  Path toPath(Size size);
}

/// Holds a raw SVG path data string for `clip-path: path("...")`.
/// The actual [Path] is computed at render time by [WidgetFactory.buildClipPathFromSvgData].
/// [toPath] must never be called directly on this shape — the render path
/// in [StyleClipPath.buildOp] handles it via the WF hook before reaching
/// [CssClipPathClipper].
@immutable
class CssClipPathSvgPath extends CssClipPathShape {
  final String pathData;

  const CssClipPathSvgPath(this.pathData);

  @override
  Path toPath(Size size) => throw UnsupportedError(
        'CssClipPathSvgPath.toPath() must not be called directly; '
        'use WidgetFactory.buildClipPathFromSvgData() instead.',
      );
}

@immutable
class CssClipPathPolygon extends CssClipPathShape {
  final List<_CssClipPathPoint> points;

  const CssClipPathPolygon(this.points);

  @override
  Path toPath(Size size) {
    final path = Path();
    if (points.isEmpty) {
      return path;
    }

    path.moveTo(
      points.first.x.resolve(size.width),
      points.first.y.resolve(size.height),
    );

    for (var i = 1; i < points.length; i++) {
      path.lineTo(
        points[i].x.resolve(size.width),
        points[i].y.resolve(size.height),
      );
    }

    path.close();
    return path;
  }
}

@immutable
class CssClipPathCircle extends CssClipPathShape {
  final CssLength radius;
  final CssLength x;
  final CssLength y;

  const CssClipPathCircle({
    required this.radius,
    required this.x,
    required this.y,
  });

  @override
  Path toPath(Size size) {
    final center = Offset(x.resolve(size.width), y.resolve(size.height));
    // Per CSS Shapes spec, percentage radii on circle() resolve against
    // sqrt(width² + height²) / sqrt(2) — the "normalised diagonal".
    final diagonal =
        sqrt(size.width * size.width + size.height * size.height) / sqrt2;
    final r = radius.resolve(diagonal);
    return Path()..addOval(Rect.fromCircle(center: center, radius: r));
  }
}

@immutable
class CssClipPathEllipse extends CssClipPathShape {
  final CssLength radiusX;
  final CssLength radiusY;
  final CssLength x;
  final CssLength y;

  const CssClipPathEllipse({
    required this.radiusX,
    required this.radiusY,
    required this.x,
    required this.y,
  });

  @override
  Path toPath(Size size) {
    return Path()
      ..addOval(
        Rect.fromCenter(
          center: Offset(x.resolve(size.width), y.resolve(size.height)),
          width: radiusX.resolve(size.width) * 2,
          height: radiusY.resolve(size.height) * 2,
        ),
      );
  }
}

@immutable
class CssClipPathInset extends CssClipPathShape {
  final _CssClipPathTrbl cutout;
  final _CssClipPathRadius? radius;

  const CssClipPathInset({required this.cutout, this.radius});

  @override
  Path toPath(Size size) {
    final left = cutout.left.resolve(size.width);
    final top = cutout.top.resolve(size.height);
    final right = cutout.right.resolve(size.width);
    final bottom = cutout.bottom.resolve(size.height);

    final rect = Rect.fromLTWH(
      left,
      top,
      max(0, size.width - left - right),
      max(0, size.height - top - bottom),
    );

    final path = Path();
    final parsedRadius = radius;
    if (parsedRadius == null) {
      path.addRect(rect);
    } else {
      path.addRRect(parsedRadius.toRRect(rect));
    }
    return path;
  }
}

@immutable
class CssClipPathRect extends CssClipPathShape {
  final CssLength x;
  final CssLength y;
  final CssLength width;
  final CssLength height;
  final _CssClipPathRadius? radius;

  const CssClipPathRect({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.radius,
  });

  @override
  Path toPath(Size size) {
    final rect = Rect.fromLTWH(
      x.resolve(size.width),
      y.resolve(size.height),
      width.resolve(size.width),
      height.resolve(size.height),
    );
    final parsedRadius = radius;
    if (parsedRadius == null) {
      return Path()..addRect(rect);
    }
    return Path()..addRRect(parsedRadius.toRRect(rect));
  }
}

// CSS rect(top right bottom left [round <border-radius>]?):
// Each value is an absolute edge coordinate measured from the left/top edge of
// the reference box
@immutable
class CssClipPathRectLtrb extends CssClipPathShape {
  final CssLength top;
  final CssLength right;
  final CssLength bottom;
  final CssLength left;
  final _CssClipPathRadius? radius;

  const CssClipPathRectLtrb({
    required this.top,
    required this.right,
    required this.bottom,
    required this.left,
    this.radius,
  });

  @override
  Path toPath(Size size) {
    final rect = Rect.fromLTRB(
      left.resolve(size.width),
      top.resolve(size.height),
      right.resolve(size.width),
      bottom.resolve(size.height),
    );
    final parsedRadius = radius;
    if (parsedRadius == null) {
      return Path()..addRect(rect);
    }
    return Path()..addRRect(parsedRadius.toRRect(rect));
  }
}

extension on BuildTree {
  _StyleClipPathData get clipPathData =>
      getNonInherited<_StyleClipPathData>() ??
      setNonInherited<_StyleClipPathData>(_parseClipPathData());

  _StyleClipPathData _parseClipPathData() {
    var data = const _StyleClipPathData();
    for (final style in styles) {
      if (style.property != kCssClipPath) {
        continue;
      }

      final value = style.value;
      final term = value is css.LiteralTerm ? value.valueAsString : null;
      if (term == kCssClipPathNone) {
        data = const _StyleClipPathData();
        continue;
      }

      final shape = tryParseCssClipPath(value);
      if (shape != null) {
        data = _StyleClipPathData(shape: shape);
      }
    }

    return data;
  }
}

@immutable
class _StyleClipPathData {
  final CssClipPathShape? shape;

  const _StyleClipPathData({this.shape});
}

CssClipPathShape? tryParseCssClipPath(css.Expression? expression) {
  if (expression is! css.FunctionTerm) {
    return null;
  }

  switch (expression.text) {
    case kCssClipPathPolygon:
      return _tryParseCssClipPathPolygon(expression);
    case kCssClipPathCircle:
      return _tryParseCssClipPathCircle(expression);
    case kCssClipPathEllipse:
      return _tryParseCssClipPathEllipse(expression);
    case kCssClipPathInset:
      return _tryParseCssClipPathInset(expression);
    case kCssClipPathPath:
      return _tryParseCssClipPathPath(expression);
    case kCssClipPathRect:
      return _tryParseCssClipPathRect(expression);
    case kCssClipPathXywh:
      return _tryParseCssClipPathXywh(expression);
  }

  return null;
}

CssClipPathShape? _tryParseCssClipPathPath(css.FunctionTerm expression) {
  final params = expression.params;
  if (params.isEmpty) {
    return null;
  }

  final first = params.first;
  // csslib stores quoted CSS strings as LiteralTerm where .value includes the
  // surrounding quote characters. The valueAsString extension strips them.
  if (first is! css.LiteralTerm) {
    return null;
  }

  final pathData = first.valueAsString;
  if (pathData.isEmpty) {
    return null;
  }

  return CssClipPathSvgPath(pathData);
}

CssClipPathShape? _tryParseCssClipPathPolygon(css.FunctionTerm expression) {
  final params = expression.params;
  var startAt = 0;
  if (params.isNotEmpty &&
      params.first is css.LiteralTerm &&
      ((params.first as css.LiteralTerm).valueAsString == 'evenodd' ||
          (params.first as css.LiteralTerm).valueAsString == 'nonzero')) {
    startAt = 1;
  }

  final points = <_CssClipPathPoint>[];
  for (var i = startAt; i + 1 < params.length; i += 2) {
    final x = _tryParseCssLength(params[i]);
    final y = _tryParseCssLength(params[i + 1]);
    if (x == null || y == null) {
      return null;
    }

    points.add(_CssClipPathPoint(x, y));
  }

  return points.length >= 2 ? CssClipPathPolygon(points) : null;
}

CssClipPathShape? _tryParseCssClipPathCircle(css.FunctionTerm expression) {
  final params = expression.params;
  final at = _findParamLiteral(params, 'at');

  final radius = at == 0
      ? null
      : _tryParseCssLength(at > 0 ? params.first : null) ??
          const CssLength(50, CssLengthUnit.percentage);

  if (radius == null) {
    return null;
  }

  var x = const CssLength(50, CssLengthUnit.percentage);
  var y = const CssLength(50, CssLengthUnit.percentage);
  if (at >= 0) {
    if (params.length - at < 3) {
      return null;
    }

    final parsedX = _tryParseCssLength(params[at + 1]);
    final parsedY = _tryParseCssLength(params[at + 2]);
    if (parsedX == null || parsedY == null) {
      return null;
    }
    x = parsedX;
    y = parsedY;
  }

  return CssClipPathCircle(radius: radius, x: x, y: y);
}

CssClipPathShape? _tryParseCssClipPathEllipse(css.FunctionTerm expression) {
  final params = expression.params;
  final at = _findParamLiteral(params, 'at');
  final hasAt = at >= 0;

  CssLength radiusX = const CssLength(50, CssLengthUnit.percentage);
  CssLength radiusY = const CssLength(50, CssLengthUnit.percentage);
  if ((!hasAt && params.length >= 2) || at >= 2) {
    final parsedRadiusX = _tryParseCssLength(params[0]);
    final parsedRadiusY = _tryParseCssLength(params[1]);
    if (parsedRadiusX == null || parsedRadiusY == null) {
      return null;
    }
    radiusX = parsedRadiusX;
    radiusY = parsedRadiusY;
  }

  var x = const CssLength(50, CssLengthUnit.percentage);
  var y = const CssLength(50, CssLengthUnit.percentage);
  if (hasAt) {
    if (params.length - at < 3) {
      return null;
    }

    final parsedX = _tryParseCssLength(params[at + 1]);
    final parsedY = _tryParseCssLength(params[at + 2]);
    if (parsedX == null || parsedY == null) {
      return null;
    }
    x = parsedX;
    y = parsedY;
  }

  return CssClipPathEllipse(radiusX: radiusX, radiusY: radiusY, x: x, y: y);
}

CssClipPathShape? _tryParseCssClipPathInset(css.FunctionTerm expression) {
  final params = expression.params;
  if (params.isEmpty) {
    return null;
  }

  final roundAt = _findParamLiteral(params, 'round');
  final cutoutExpressions = roundAt > -1
      ? params.sublist(0, roundAt)
      : params.toList(growable: false);
  final cutout = _tryParseCssClipPathTrbl(cutoutExpressions);
  if (cutout == null) {
    return null;
  }

  _CssClipPathRadius? radius;
  if (roundAt > -1 && roundAt + 1 < params.length) {
    radius = _tryParseCssClipPathRadius(params.sublist(roundAt + 1));
    if (radius == null) {
      return null;
    }
  }

  return CssClipPathInset(cutout: cutout, radius: radius);
}

CssClipPathShape? _tryParseCssClipPathRect(css.FunctionTerm expression) {
  final params = expression.params;
  if (params.length < 4) {
    return null;
  }

  final roundAt = _findParamLiteral(params, 'round');
  final edgeExpressions =
      roundAt > -1 ? params.sublist(0, roundAt) : params.sublist(0, 4);
  if (edgeExpressions.length != 4) {
    return null;
  }

  final top = _tryParseCssLength(edgeExpressions[0]);
  final right = _tryParseCssLength(edgeExpressions[1]);
  final bottom = _tryParseCssLength(edgeExpressions[2]);
  final left = _tryParseCssLength(edgeExpressions[3]);
  if (top == null || right == null || bottom == null || left == null) {
    return null;
  }

  _CssClipPathRadius? radius;
  if (roundAt > -1 && roundAt + 1 < params.length) {
    radius = _tryParseCssClipPathRadius(params.sublist(roundAt + 1));
    if (radius == null) {
      return null;
    }
  }

  return CssClipPathRectLtrb(
    top: top,
    right: right,
    bottom: bottom,
    left: left,
    radius: radius,
  );
}

CssClipPathShape? _tryParseCssClipPathXywh(css.FunctionTerm expression) {
  final params = expression.params;
  if (params.length < 4) {
    return null;
  }

  final roundAt = _findParamLiteral(params, 'round');
  final x = _tryParseCssLength(params[0]);
  final y = _tryParseCssLength(params[1]);
  final width = _tryParseCssLength(params[2]);
  final height = _tryParseCssLength(params[3]);
  if (x == null || y == null || width == null || height == null) {
    return null;
  }

  _CssClipPathRadius? radius;
  if (roundAt > -1 && roundAt + 1 < params.length) {
    radius = _tryParseCssClipPathRadius(params.sublist(roundAt + 1));
    if (radius == null) {
      return null;
    }
  }

  return CssClipPathRect(
      x: x, y: y, width: width, height: height, radius: radius);
}

int _findParamLiteral(List<css.Expression> params, String literal) {
  for (var i = 0; i < params.length; i++) {
    final param = params[i];
    if (param is css.LiteralTerm && param.valueAsString == literal) {
      return i;
    }
  }

  return -1;
}

CssLength? _tryParseCssLength(css.Expression? expression) {
  if (expression == null) {
    return null;
  }

  if (expression is css.NumberTerm) {
    return CssLength(expression.number.toDouble());
  }

  return tryParseCssLength(expression);
}

_CssClipPathTrbl? _tryParseCssClipPathTrbl(List<css.Expression> params) {
  final lengths = params.map(_tryParseCssLength).toList(growable: false);
  if (lengths.any((x) => x == null)) {
    return null;
  }

  switch (lengths.length) {
    case 1:
      final all = lengths[0]!;
      return _CssClipPathTrbl(top: all, right: all, bottom: all, left: all);
    case 2:
      final vertical = lengths[0]!;
      final horizontal = lengths[1]!;
      return _CssClipPathTrbl(
        top: vertical,
        right: horizontal,
        bottom: vertical,
        left: horizontal,
      );
    case 3:
      return _CssClipPathTrbl(
        top: lengths[0]!,
        right: lengths[1]!,
        bottom: lengths[2]!,
        left: lengths[1]!,
      );
    case 4:
      return _CssClipPathTrbl(
        top: lengths[0]!,
        right: lengths[1]!,
        bottom: lengths[2]!,
        left: lengths[3]!,
      );
  }

  return null;
}

_CssClipPathRadius? _tryParseCssClipPathRadius(List<css.Expression> params) {
  final lengths = params.map(_tryParseCssLength).toList(growable: false);
  if (lengths.isEmpty || lengths.any((x) => x == null)) {
    return null;
  }

  switch (lengths.length) {
    case 1:
      final all = lengths[0]!;
      return _CssClipPathRadius(
        topLeft: all,
        topRight: all,
        bottomRight: all,
        bottomLeft: all,
      );
    case 2:
      return _CssClipPathRadius(
        topLeft: lengths[0]!,
        topRight: lengths[1]!,
        bottomRight: lengths[0]!,
        bottomLeft: lengths[1]!,
      );
    case 3:
      return _CssClipPathRadius(
        topLeft: lengths[0]!,
        topRight: lengths[1]!,
        bottomRight: lengths[2]!,
        bottomLeft: lengths[1]!,
      );
    default:
      return _CssClipPathRadius(
        topLeft: lengths[0]!,
        topRight: lengths[1]!,
        bottomRight: lengths[2]!,
        bottomLeft: lengths[3]!,
      );
  }
}

@immutable
class _CssClipPathPoint {
  final CssLength x;
  final CssLength y;

  const _CssClipPathPoint(this.x, this.y);
}

@immutable
class _CssClipPathTrbl {
  final CssLength top;
  final CssLength right;
  final CssLength bottom;
  final CssLength left;

  const _CssClipPathTrbl({
    required this.top,
    required this.right,
    required this.bottom,
    required this.left,
  });
}

@immutable
class _CssClipPathRadius {
  final CssLength topLeft;
  final CssLength topRight;
  final CssLength bottomRight;
  final CssLength bottomLeft;

  const _CssClipPathRadius({
    required this.topLeft,
    required this.topRight,
    required this.bottomRight,
    required this.bottomLeft,
  });

  RRect toRRect(Rect rect) {
    final base = min(rect.width, rect.height);
    return RRect.fromRectAndCorners(
      rect,
      topLeft: Radius.circular(topLeft.resolve(base)),
      topRight: Radius.circular(topRight.resolve(base)),
      bottomRight: Radius.circular(bottomRight.resolve(base)),
      bottomLeft: Radius.circular(bottomLeft.resolve(base)),
    );
  }
}

extension on CssLength {
  double resolve(double baseValue) {
    switch (unit) {
      case CssLengthUnit.auto:
        return 0;
      case CssLengthUnit.percentage:
        return baseValue * number / 100;
      case CssLengthUnit.pt:
        return number * 96 / 72;
      case CssLengthUnit.em:
      case CssLengthUnit.px:
        return number;
    }
  }
}
