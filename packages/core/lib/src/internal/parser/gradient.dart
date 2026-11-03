part of '../core_parser.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Public data types
// ─────────────────────────────────────────────────────────────────────────────

/// A single color stop inside a CSS gradient.
///
/// [color] is the resolved ARGB color value.
/// [position] is the normalised position in [0.0, 1.0], or `null` when the
/// browser should distribute the stop automatically.
@immutable
class CssGradientStop {
  final Color color;
  final double? position;

  const CssGradientStop({required this.color, this.position});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CssGradientStop &&
          other.color == color &&
          other.position == position;

  @override
  int get hashCode => Object.hash(color, position);

  @override
  String toString() => 'CssGradientStop(color: $color, position: $position)';
}

/// Base sealed class for all parsed CSS gradient types.
///
/// Subtypes:
/// - [CssLinearGradient] → `linear-gradient` / `repeating-linear-gradient`
/// - [CssRadialGradient] → `radial-gradient` / `repeating-radial-gradient`
/// - [CssConicGradient]  → `conic-gradient`  / `repeating-conic-gradient`
@immutable
sealed class CssGradient {
  final List<CssGradientStop> stops;

  /// Whether this is a `repeating-*` variant, which maps to
  /// Flutter's `TileMode.repeated`.
  final bool repeating;

  const CssGradient({required this.stops, required this.repeating});
}

/// Parsed `linear-gradient` or `repeating-linear-gradient`.
///
/// [begin] and [end] are `Alignment` values in Flutter's coordinate system.
/// They map directly to `LinearGradient.begin` and `LinearGradient.end`.
@immutable
final class CssLinearGradient extends CssGradient {
  /// Gradient start point.  Defaults to `Alignment.topCenter` (CSS `0deg`).
  final Alignment begin;

  /// Gradient end point.  Defaults to `Alignment.bottomCenter` (CSS `0deg`).
  final Alignment end;

  const CssLinearGradient({
    required super.stops,
    required super.repeating,
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CssLinearGradient &&
          other.begin == begin &&
          other.end == end &&
          other.stops == stops &&
          other.repeating == repeating;

  @override
  int get hashCode => Object.hash(begin, end, stops, repeating);

  @override
  String toString() => 'CssLinearGradient(begin: $begin, end: $end, '
      'stops: $stops, repeating: $repeating)';
}

/// Parsed `radial-gradient` or `repeating-radial-gradient`.
///
/// [center] maps to `RadialGradient.center`.
/// [isCircle] distinguishes the CSS `circle` keyword from the default ellipse.
/// Flutter's `RadialGradient` is always circular; ellipse support requires a
/// custom transform (handled downstream in the rendering layer).
@immutable
final class CssRadialGradient extends CssGradient {
  final Alignment center;

  /// `true` when the CSS `circle` keyword was present; `false` for the
  /// default ellipse behaviour.
  final bool isCircle;

  const CssRadialGradient({
    required super.stops,
    required super.repeating,
    this.center = Alignment.center,
    this.isCircle = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CssRadialGradient &&
          other.center == center &&
          other.isCircle == isCircle &&
          other.stops == stops &&
          other.repeating == repeating;

  @override
  int get hashCode => Object.hash(center, isCircle, stops, repeating);

  @override
  String toString() =>
      'CssRadialGradient(center: $center, isCircle: $isCircle, '
      'stops: $stops, repeating: $repeating)';
}

/// Parsed `conic-gradient` or `repeating-conic-gradient`.
///
/// [center] maps to `SweepGradient.center`.
/// [startAngle] is in **radians** and maps to `SweepGradient.startAngle`.
/// CSS `from 0deg` = `startAngle: 0.0` (sweep starts at 3 o'clock in Flutter's
/// coordinate system, which aligns with CSS conic-gradient's 0-degree start).
@immutable
final class CssConicGradient extends CssGradient {
  final Alignment center;

  /// Starting angle in radians. Maps to `SweepGradient.startAngle`.
  final double startAngle;

  const CssConicGradient({
    required super.stops,
    required super.repeating,
    this.center = Alignment.center,
    this.startAngle = 0.0,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CssConicGradient &&
          other.center == center &&
          other.startAngle == startAngle &&
          other.stops == stops &&
          other.repeating == repeating;

  @override
  int get hashCode => Object.hash(center, startAngle, stops, repeating);

  @override
  String toString() =>
      'CssConicGradient(center: $center, startAngle: $startAngle, '
      'stops: $stops, repeating: $repeating)';
}

// ─────────────────────────────────────────────────────────────────────────────
// Entry point
// ─────────────────────────────────────────────────────────────────────────────

/// Attempts to parse a CSS gradient from a csslib [expression].
///
/// Returns a typed [CssGradient] on success, or `null` when [expression] is
/// not a recognised gradient function or the content is malformed.
///
/// Recognises:
/// * `linear-gradient` / `repeating-linear-gradient`
/// * `radial-gradient`  / `repeating-radial-gradient`
/// * `conic-gradient`   / `repeating-conic-gradient`
CssGradient? tryParseGradient(css.Expression? expression) {
  if (expression is! css.FunctionTerm) {
    return null;
  }

  final kind = _cssGradientKind(expression.text);
  if (kind == null) {
    return null;
  }

  // Split the function's params on top-level commas, preserving structure
  // inside nested function calls such as rgb(…) or hsl(…).
  final groups = _splitGradientArgs(expression);
  if (groups.isEmpty) {
    return null;
  }

  return switch (kind) {
    _CssGradientKind.linear ||
    _CssGradientKind.repeatingLinear =>
      _parseLinearGradient(groups, kind.isRepeating),
    _CssGradientKind.radial ||
    _CssGradientKind.repeatingRadial =>
      _parseRadialGradient(groups, kind.isRepeating),
    _CssGradientKind.conic ||
    _CssGradientKind.repeatingConic =>
      _parseConicGradient(groups, kind.isRepeating),
  };
}

// ─────────────────────────────────────────────────────────────────────────────
// Private: gradient-kind enum
// ─────────────────────────────────────────────────────────────────────────────

enum _CssGradientKind {
  linear,
  repeatingLinear,
  radial,
  repeatingRadial,
  conic,
  repeatingConic;

  bool get isRepeating =>
      this == repeatingLinear ||
      this == repeatingRadial ||
      this == repeatingConic;
}

_CssGradientKind? _cssGradientKind(String funcName) {
  return switch (funcName.toLowerCase()) {
    'linear-gradient' => _CssGradientKind.linear,
    'repeating-linear-gradient' => _CssGradientKind.repeatingLinear,
    'radial-gradient' => _CssGradientKind.radial,
    'repeating-radial-gradient' => _CssGradientKind.repeatingRadial,
    'conic-gradient' => _CssGradientKind.conic,
    'repeating-conic-gradient' => _CssGradientKind.repeatingConic,
    _ => null,
  };
}

// ─────────────────────────────────────────────────────────────────────────────
// Private: param splitting
// ─────────────────────────────────────────────────────────────────────────────

/// Splits the direct params of [term] into comma-separated groups.
///
/// Uses a single-pass [css.Visitor] that captures the top-level [Expressions]
/// node of the function (which includes [css.OperatorComma] items) without
/// recursing into nested function calls such as `rgb(…)`.
///
/// Example: `linear-gradient(to right, rgb(255,0,0), blue)` →
/// ```dart
/// [ [LiteralTerm('to'), LiteralTerm('right')],
///   [FunctionTerm('rgb', …)],
///   [HexColorTerm('0000ff')] ]
/// ```
List<List<css.Expression>> _splitGradientArgs(css.FunctionTerm term) {
  final rawParams = <css.Expression>[];
  term.visit(_GradientParamsCollector(rawParams));

  final groups = <List<css.Expression>>[<css.Expression>[]];
  for (final expr in rawParams) {
    if (expr is css.OperatorComma) {
      groups.add(<css.Expression>[]);
    } else {
      groups.last.add(expr);
    }
  }

  // Drop any empty trailing group caused by a trailing comma.
  while (groups.isNotEmpty && groups.last.isEmpty) {
    groups.removeLast();
  }

  return groups;
}

/// A [css.Visitor] that captures the direct params of a [css.FunctionTerm]
/// (with [css.OperatorComma] preserved) without recursing into nested calls.
class _GradientParamsCollector extends css.Visitor {
  final List<css.Expression> _target;

  _GradientParamsCollector(this._target);

  @override
  void visitExpressions(css.Expressions node) {
    _target.addAll(node.expressions);
    // Intentionally NOT calling super — prevents recursion into nested
    // function params (e.g. the comma-separated args inside rgb(…)).
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private: linear-gradient parser
// ─────────────────────────────────────────────────────────────────────────────

CssLinearGradient? _parseLinearGradient(
  List<List<css.Expression>> groups,
  bool repeating,
) {
  var begin = Alignment.topCenter;
  var end = Alignment.bottomCenter;
  var stopStart = 0;

  // Detect optional direction in the first group.
  if (groups.isNotEmpty) {
    final first = groups[0];
    if (first.isNotEmpty) {
      final head = first[0];
      if (head is css.AngleTerm) {
        // e.g. `linear-gradient(45deg, …)`
        final degrees = _angleTermToDegrees(head);
        if (degrees != null) {
          (begin, end) = _degreesToAlignment(degrees);
          stopStart = 1;
        }
      } else if (head is css.LiteralTerm &&
          head.valueAsString == 'to' &&
          first.length > 1) {
        // e.g. `linear-gradient(to right, …)` or `to bottom right`
        final dir = _parseToDirection(first.skip(1).toList());
        if (dir != null) {
          (begin, end) = dir;
          stopStart = 1;
        }
      }
    }
  }

  final stops = _parseColorStops(groups, from: stopStart);
  if (stops.length < 2) {
    return null;
  }

  return CssLinearGradient(
    begin: begin,
    end: end,
    stops: stops,
    repeating: repeating,
  );
}

/// Parses a `to <side> [<side>]` CSS direction into a (begin, end) pair.
(Alignment, Alignment)? _parseToDirection(List<css.Expression> keywords) {
  if (keywords.isEmpty) {
    return null;
  }

  String? keyword(int i) =>
      i < keywords.length && keywords[i] is css.LiteralTerm
          ? (keywords[i] as css.LiteralTerm).valueAsString
          : null;

  final k1 = keyword(0);
  final k2 = keyword(1);

  if (k2 == null) {
    return switch (k1) {
      'top' => (Alignment.bottomCenter, Alignment.topCenter),
      'bottom' => (Alignment.topCenter, Alignment.bottomCenter),
      'left' => (Alignment.centerRight, Alignment.centerLeft),
      'right' => (Alignment.centerLeft, Alignment.centerRight),
      _ => null,
    };
  }

  // Corner: order-insensitive; CSS allows `top right` or `right top`.
  final corner = {k1, k2};
  if (corner.containsAll(['top', 'right'])) {
    return (Alignment.bottomLeft, Alignment.topRight);
  }
  if (corner.containsAll(['top', 'left'])) {
    return (Alignment.bottomRight, Alignment.topLeft);
  }
  if (corner.containsAll(['bottom', 'right'])) {
    return (Alignment.topLeft, Alignment.bottomRight);
  }
  if (corner.containsAll(['bottom', 'left'])) {
    return (Alignment.topRight, Alignment.bottomLeft);
  }
  return null;
}

/// Converts a CSS angle term to degrees.
double? _angleTermToDegrees(css.AngleTerm term) {
  final v = term.angle.toDouble();
  return switch (term.unit) {
    css.TokenKind.UNIT_ANGLE_DEG => v,
    css.TokenKind.UNIT_ANGLE_RAD => v * (180.0 / pi),
    css.TokenKind.UNIT_ANGLE_GRAD => v * 0.9, // 400grad = 360deg
    css.TokenKind.UNIT_ANGLE_TURN => v * 360.0,
    _ => null,
  };
}

/// Converts a CSS **angle in degrees** to a Flutter `(begin, end)` alignment
/// pair for use in [LinearGradient].
///
/// CSS `0deg` points upward (`to top`):
/// ```dart
/// 0deg   → begin=bottomCenter, end=topCenter
/// 90deg  → begin=centerLeft,   end=centerRight
/// 180deg → begin=topCenter,    end=bottomCenter
/// 270deg → begin=centerRight,  end=centerLeft
/// ```
///
/// The direction vector (begin→end) = (sin θ, −cos θ) in normalised space.
(Alignment, Alignment) _degreesToAlignment(double degrees) {
  final rad = degrees * pi / 180.0;
  // Unit vector pointing in the gradient direction (CSS convention).
  final dx = sin(rad); // positive = rightward
  final dy = -cos(rad); // positive = downward (Flutter y increases downward)
  return (Alignment(-dx, -dy), Alignment(dx, dy));
}

// ─────────────────────────────────────────────────────────────────────────────
// Private: radial-gradient parser
// ─────────────────────────────────────────────────────────────────────────────

CssRadialGradient? _parseRadialGradient(
  List<List<css.Expression>> groups,
  bool repeating,
) {
  var center = Alignment.center;
  var isCircle = false;
  var stopStart = 0;

  // The first group is a shape/size/position hint iff its first token is NOT
  // parseable as a color.  Position keywords, shape keywords (`circle`,
  // `ellipse`), and size keywords (`closest-side`, etc.) all fail color
  // parsing, while valid color names always succeed.
  if (groups.isNotEmpty &&
      groups[0].isNotEmpty &&
      tryParseColor(groups[0][0]) == null) {
    final hint = groups[0];
    stopStart = 1;

    for (final expr in hint) {
      if (expr is! css.LiteralTerm) {
        continue;
      }
      switch (expr.valueAsString) {
        case 'circle':
          isCircle = true;
        case 'ellipse':
          isCircle = false;
      }
    }

    // Look for `at <position>` within the hint group.
    final atIdx = hint.indexWhere(
      (e) => e is css.LiteralTerm && e.valueAsString == 'at',
    );
    if (atIdx >= 0) {
      center = _parsePositionKeywords(hint.sublist(atIdx + 1)) ?? center;
    }
  }

  final stops = _parseColorStops(groups, from: stopStart);
  if (stops.length < 2) {
    return null;
  }

  return CssRadialGradient(
    center: center,
    isCircle: isCircle,
    stops: stops,
    repeating: repeating,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Private: conic-gradient parser
// ─────────────────────────────────────────────────────────────────────────────

CssConicGradient? _parseConicGradient(
  List<List<css.Expression>> groups,
  bool repeating,
) {
  var center = Alignment.center;
  var startAngle = 0.0; // radians
  var stopStart = 0;

  // Same heuristic as radial: first group is a hint iff its first token is
  // not a valid color.
  if (groups.isNotEmpty &&
      groups[0].isNotEmpty &&
      tryParseColor(groups[0][0]) == null) {
    final hint = groups[0];
    stopStart = 1;

    // Scan for `from <angle>`.
    for (var i = 0; i < hint.length - 1; i++) {
      if (hint[i] is css.LiteralTerm &&
          (hint[i] as css.LiteralTerm).valueAsString == 'from' &&
          hint[i + 1] is css.AngleTerm) {
        final deg = _angleTermToDegrees(hint[i + 1] as css.AngleTerm);
        if (deg != null) {
          startAngle = deg * pi / 180.0;
        }
        break;
      }
    }

    // Scan for `at <position>`.
    final atIdx = hint.indexWhere(
      (e) => e is css.LiteralTerm && e.valueAsString == 'at',
    );
    if (atIdx >= 0) {
      center = _parsePositionKeywords(hint.sublist(atIdx + 1)) ?? center;
    }
  }

  final stops = _parseColorStops(groups, from: stopStart);
  if (stops.length < 2) {
    return null;
  }

  return CssConicGradient(
    center: center,
    startAngle: startAngle,
    stops: stops,
    repeating: repeating,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Private: shared position-keyword parser
// ─────────────────────────────────────────────────────────────────────────────

/// Resolves a list of CSS position keywords to an [Alignment].
///
/// Handles single keywords (`center`, `top`, `left`, …) and two-keyword
/// combinations (`top right`, `bottom left`, …).  Percentage / length tokens
/// are currently ignored (not yet supported; falls back to `null`).
Alignment? _parsePositionKeywords(List<css.Expression> exprs) {
  final keywords = exprs
      .whereType<css.LiteralTerm>()
      .map((e) => e.valueAsString)
      .where((s) => s.isNotEmpty)
      .toList(growable: false);

  if (keywords.isEmpty) {
    return null;
  }

  double? x;
  double? y;

  for (final kw in keywords) {
    switch (kw) {
      case 'left':
        x = -1.0;
      case 'right':
        x = 1.0;
      case 'top':
        y = -1.0;
      case 'bottom':
        y = 1.0;
      case 'center':
        // Assign to whichever axis hasn't been set yet. On a second `center`
        // both axes default to 0.
        x ??= 0.0;
        y ??= 0.0;
    }
  }

  if (x == null && y == null) {
    return null;
  }
  return Alignment(x ?? 0.0, y ?? 0.0);
}

// ─────────────────────────────────────────────────────────────────────────────
// Private: color-stop parser
// ─────────────────────────────────────────────────────────────────────────────

/// Parses color stops from [groups] starting at index [from].
///
/// Each group corresponds to one comma-separated argument in the original CSS,
/// e.g. `["#f00", "20%"]` or `["blue"]`.
List<CssGradientStop> _parseColorStops(
  List<List<css.Expression>> groups, {
  required int from,
}) {
  final stops = <CssGradientStop>[];
  for (var i = from; i < groups.length; i++) {
    final stop = _parseColorStop(groups[i]);
    if (stop != null) {
      stops.add(stop);
    }
  }
  return stops;
}

/// Parses a single color-stop group such as `[HexColorTerm, PercentageTerm]`
/// or `[FunctionTerm('rgb'), PercentageTerm]`.
CssGradientStop? _parseColorStop(List<css.Expression> group) {
  if (group.isEmpty) {
    return null;
  }

  final cssColor = tryParseColor(group[0]);
  final raw = cssColor?.rawValue;
  if (raw == null) {
    // also skips currentcolor
    return null;
  }

  double? position;
  if (group.length >= 2) {
    position = _parseStopPosition(group[1]);
  }

  return CssGradientStop(color: raw, position: position);
}

/// Resolves a stop-position expression to a normalised [0.0, 1.0] fraction.
///
/// * `PercentageTerm` → value / 100.
/// * `AngleTerm`      → degrees / 360 (used by conic-gradient).
/// * Other terms      → `null`.
double? _parseStopPosition(css.Expression expr) {
  if (expr is css.PercentageTerm) {
    return expr.valueAsDouble.clamp(0.0, 1.0);
  }
  if (expr is css.AngleTerm) {
    final deg = _angleTermToDegrees(expr);
    if (deg != null) {
      // Do NOT use modulo: 360deg must map to 1.0 (end of sweep), not 0.0.
      return (deg / 360.0).clamp(0.0, 1.0);
    }
  }
  return null;
}
