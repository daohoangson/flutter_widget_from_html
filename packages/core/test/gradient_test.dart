import 'dart:math';

import 'package:csslib/parser.dart' as css_parser;
import 'package:csslib/visitor.dart' as css;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/src/core_helpers.dart';
import 'package:flutter_widget_from_html_core/src/internal/core_parser.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '_constants.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Test helpers
// ─────────────────────────────────────────────────────────────────────────────

/// Parses [gradientCss] as a `background-image` value and returns the first
/// CSS expression, which for a gradient will be a [css.FunctionTerm].
css.Expression? _expr(String gradientCss) {
  final sheet = css_parser.parse('a{background-image:$gradientCss}');
  final decls = sheet.collectDeclarations();
  if (decls.isEmpty) {
    return null;
  }
  final values = decls.first.values;
  if (values.isEmpty) {
    return null;
  }
  return values.first;
}

/// Parses and asserts a gradient, then casts it to [T].
T _parseAs<T extends CssGradient>(String gradientCss) {
  final result = tryParseGradient(_expr(gradientCss));
  expect(result, isNotNull, reason: 'Expected "$gradientCss" to parse');
  expect(result, isA<T>(), reason: 'Expected result to be $T');
  return result! as T;
}

void main() async {
  await loadAppFonts();
  // ───────────────────────────────────────────────────────────────────────────
  // tryParseGradient — null / unrecognised inputs
  // ───────────────────────────────────────────────────────────────────────────

  group('tryParseGradient: edge cases', () {
    test('returns null for null input', () {
      expect(tryParseGradient(null), isNull);
    });

    test('returns null for non-function expression', () {
      final sheet = css_parser.parse('a{color:#f00}');
      final decl = sheet.collectDeclarations().first;
      expect(tryParseGradient(decl.values.first), isNull);
    });

    test('returns null for unrecognised function', () {
      expect(tryParseGradient(_expr('drop-shadow(#f00, #00f)')), isNull);
    });

    test('returns null with fewer than 2 color stops', () {
      expect(tryParseGradient(_expr('linear-gradient(red)')), isNull);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // linear-gradient: direction
  // ───────────────────────────────────────────────────────────────────────────

  group('CssLinearGradient: direction', () {
    test('default direction (no hint) is top→bottom (CSS 180deg)', () {
      final g = _parseAs<CssLinearGradient>('linear-gradient(red, blue)');
      expect(g.begin, equals(Alignment.topCenter));
      expect(g.end, equals(Alignment.bottomCenter));
    });

    test('to top  → bottom→top', () {
      final g =
          _parseAs<CssLinearGradient>('linear-gradient(to top, red, blue)');
      expect(g.begin, equals(Alignment.bottomCenter));
      expect(g.end, equals(Alignment.topCenter));
    });

    test('to bottom  → top→bottom', () {
      final g =
          _parseAs<CssLinearGradient>('linear-gradient(to bottom, red, blue)');
      expect(g.begin, equals(Alignment.topCenter));
      expect(g.end, equals(Alignment.bottomCenter));
    });

    test('to left  → right→left', () {
      final g =
          _parseAs<CssLinearGradient>('linear-gradient(to left, red, blue)');
      expect(g.begin, equals(Alignment.centerRight));
      expect(g.end, equals(Alignment.centerLeft));
    });

    test('to right  → left→right', () {
      final g =
          _parseAs<CssLinearGradient>('linear-gradient(to right, red, blue)');
      expect(g.begin, equals(Alignment.centerLeft));
      expect(g.end, equals(Alignment.centerRight));
    });

    test('to top right  → bottomLeft→topRight', () {
      final g = _parseAs<CssLinearGradient>(
          'linear-gradient(to top right, red, blue)');
      expect(g.begin, equals(Alignment.bottomLeft));
      expect(g.end, equals(Alignment.topRight));
    });

    test('to bottom left  → topRight→bottomLeft', () {
      final g = _parseAs<CssLinearGradient>(
          'linear-gradient(to bottom left, red, blue)');
      expect(g.begin, equals(Alignment.topRight));
      expect(g.end, equals(Alignment.bottomLeft));
    });

    test('corner keywords are order-insensitive (right top == top right)', () {
      final a = _parseAs<CssLinearGradient>(
          'linear-gradient(to top right, red, blue)');
      final b = _parseAs<CssLinearGradient>(
          'linear-gradient(to right top, red, blue)');
      expect(a.begin, equals(b.begin));
      expect(a.end, equals(b.end));
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // linear-gradient: angle-to-alignment math
  // ───────────────────────────────────────────────────────────────────────────

  group('CssLinearGradient: angle directions', () {
    test('0deg  → bottomCenter→topCenter (upward)', () {
      final g = _parseAs<CssLinearGradient>('linear-gradient(0deg, red, blue)');
      _expectAlignmentApprox(g.begin, Alignment.bottomCenter);
      _expectAlignmentApprox(g.end, Alignment.topCenter);
    });

    test('90deg  → centerLeft→centerRight (rightward)', () {
      final g =
          _parseAs<CssLinearGradient>('linear-gradient(90deg, red, blue)');
      _expectAlignmentApprox(g.begin, Alignment.centerLeft);
      _expectAlignmentApprox(g.end, Alignment.centerRight);
    });

    test('180deg  → topCenter→bottomCenter (downward)', () {
      final g =
          _parseAs<CssLinearGradient>('linear-gradient(180deg, red, blue)');
      _expectAlignmentApprox(g.begin, Alignment.topCenter);
      _expectAlignmentApprox(g.end, Alignment.bottomCenter);
    });

    test('270deg  → centerRight→centerLeft (leftward)', () {
      final g =
          _parseAs<CssLinearGradient>('linear-gradient(270deg, red, blue)');
      _expectAlignmentApprox(g.begin, Alignment.centerRight);
      _expectAlignmentApprox(g.end, Alignment.centerLeft);
    });

    test('45deg  → bottomLeft quadrant → topRight quadrant', () {
      final g =
          _parseAs<CssLinearGradient>('linear-gradient(45deg, red, blue)');
      // begin should be in bottom-left (-x, +y) quadrant
      expect(g.begin.x, lessThan(0));
      expect(g.begin.y, greaterThan(0));
      // end should be in top-right (+x, -y) quadrant
      expect(g.end.x, greaterThan(0));
      expect(g.end.y, lessThan(0));
    });

    test('0.5turn == 180deg (downward)', () {
      final g =
          _parseAs<CssLinearGradient>('linear-gradient(0.5turn, red, blue)');
      _expectAlignmentApprox(g.begin, Alignment.topCenter);
      _expectAlignmentApprox(g.end, Alignment.bottomCenter);
    });

    test('200grad == 180deg (downward)', () {
      final g =
          _parseAs<CssLinearGradient>('linear-gradient(200grad, red, blue)');
      _expectAlignmentApprox(g.begin, Alignment.topCenter);
      _expectAlignmentApprox(g.end, Alignment.bottomCenter);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // linear-gradient: color stops
  // ───────────────────────────────────────────────────────────────────────────

  group('CssLinearGradient: color stops', () {
    test('two named stops, no positions', () {
      final g = _parseAs<CssLinearGradient>('linear-gradient(red, blue)');
      expect(g.stops.length, 2);
      expect(g.stops[0].color, equals(const Color(0xFFFF0000)));
      expect(g.stops[0].position, isNull);
      expect(g.stops[1].color, equals(const Color(0xFF0000FF)));
      expect(g.stops[1].position, isNull);
    });

    test('hex stops with explicit percentage positions', () {
      final g = _parseAs<CssLinearGradient>(
          'linear-gradient(#ff0000 0%, #0000ff 100%)');
      expect(g.stops[0].color, equals(const Color(0xFFFF0000)));
      expect(g.stops[0].position, closeTo(0.0, 1e-6));
      expect(g.stops[1].color, equals(const Color(0xFF0000FF)));
      expect(g.stops[1].position, closeTo(1.0, 1e-6));
    });

    test('three stops with mid-point position', () {
      final g = _parseAs<CssLinearGradient>(
          'linear-gradient(to right, red 0%, green 50%, blue 100%)');
      expect(g.stops.length, 3);
      expect(g.stops[1].color, equals(const Color(0xFF008000)));
      expect(g.stops[1].position, closeTo(0.5, 1e-6));
    });

    test('rgb() function stop is parsed correctly', () {
      final g = _parseAs<CssLinearGradient>(
          'linear-gradient(rgb(255, 0, 0), rgb(0, 0, 255))');
      expect(g.stops[0].color, equals(const Color(0xFFFF0000)));
      expect(g.stops[1].color, equals(const Color(0xFF0000FF)));
    });

    test('hsl() function stop is parsed correctly', () {
      final g = _parseAs<CssLinearGradient>(
          'linear-gradient(hsl(0, 100%, 50%), hsl(240, 100%, 50%))');
      expect(g.stops[0].color, equals(const Color(0xFFFF0000)));
      expect(g.stops[1].color, equals(const Color(0xFF0000FF)));
    });

    test('transparent stop has rawValue = Color(0x00000000)', () {
      final g =
          _parseAs<CssLinearGradient>('linear-gradient(transparent, red)');
      expect(g.stops.length, 2);
      expect(g.stops[0].color, equals(const Color(0x00000000)));
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // repeating-linear-gradient
  // ───────────────────────────────────────────────────────────────────────────

  group('CssLinearGradient: repeating flag', () {
    test('linear-gradient sets repeating=false', () {
      final g = _parseAs<CssLinearGradient>('linear-gradient(red, blue)');
      expect(g.repeating, isFalse);
    });

    test('repeating-linear-gradient sets repeating=true', () {
      final g = _parseAs<CssLinearGradient>(
          'repeating-linear-gradient(to right, red 0%, blue 20%)');
      expect(g.repeating, isTrue);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // radial-gradient
  // ───────────────────────────────────────────────────────────────────────────

  group('CssRadialGradient: basics', () {
    test('two stops, no hint → defaults', () {
      final g = _parseAs<CssRadialGradient>('radial-gradient(red, blue)');
      expect(g.center, equals(Alignment.center));
      expect(g.isCircle, isFalse);
      expect(g.stops.length, 2);
      expect(g.repeating, isFalse);
    });

    test('circle keyword sets isCircle=true', () {
      final g =
          _parseAs<CssRadialGradient>('radial-gradient(circle, red, blue)');
      expect(g.isCircle, isTrue);
    });

    test('ellipse keyword sets isCircle=false', () {
      final g =
          _parseAs<CssRadialGradient>('radial-gradient(ellipse, red, blue)');
      expect(g.isCircle, isFalse);
    });

    test('circle at top right → center=topRight', () {
      final g = _parseAs<CssRadialGradient>(
          'radial-gradient(circle at top right, red, blue)');
      expect(g.isCircle, isTrue);
      expect(g.center, equals(Alignment.topRight));
    });

    test('at center → center=Alignment.center', () {
      final g =
          _parseAs<CssRadialGradient>('radial-gradient(at center, red, blue)');
      expect(g.center, equals(Alignment.center));
    });

    test('at bottom left → center=bottomLeft', () {
      final g = _parseAs<CssRadialGradient>(
          'radial-gradient(at bottom left, red, blue)');
      expect(g.center, equals(Alignment.bottomLeft));
    });

    test('repeating-radial-gradient sets repeating=true', () {
      final g = _parseAs<CssRadialGradient>(
          'repeating-radial-gradient(circle, red 0%, blue 20%)');
      expect(g.repeating, isTrue);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // conic-gradient
  // ───────────────────────────────────────────────────────────────────────────

  group('CssConicGradient: basics', () {
    test('two stops, no hint → defaults', () {
      final g = _parseAs<CssConicGradient>('conic-gradient(red, blue)');
      expect(g.center, equals(Alignment.center));
      expect(g.startAngle, closeTo(0.0, 1e-6));
      expect(g.stops.length, 2);
      expect(g.repeating, isFalse);
    });

    test('from 90deg → startAngle = π/2', () {
      final g =
          _parseAs<CssConicGradient>('conic-gradient(from 90deg, red, blue)');
      expect(g.startAngle, closeTo(pi / 2, 1e-6));
    });

    test('from 180deg → startAngle = π', () {
      final g =
          _parseAs<CssConicGradient>('conic-gradient(from 180deg, red, blue)');
      expect(g.startAngle, closeTo(pi, 1e-6));
    });

    test('from 0.25turn → startAngle = π/2', () {
      final g = _parseAs<CssConicGradient>(
          'conic-gradient(from 0.25turn, red, blue)');
      expect(g.startAngle, closeTo(pi / 2, 1e-6));
    });

    test('at center → center=Alignment.center', () {
      final g = _parseAs<CssConicGradient>(
          'conic-gradient(from 90deg at center, red, blue)');
      expect(g.center, equals(Alignment.center));
      expect(g.startAngle, closeTo(pi / 2, 1e-6));
    });

    test('at top left → center=topLeft', () {
      final g =
          _parseAs<CssConicGradient>('conic-gradient(at top left, red, blue)');
      expect(g.center, equals(Alignment.topLeft));
    });

    test('repeating-conic-gradient sets repeating=true', () {
      final g = _parseAs<CssConicGradient>(
          'repeating-conic-gradient(from 0deg, red 0%, blue 25%)');
      expect(g.repeating, isTrue);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // conic-gradient: angle-position stops
  // ───────────────────────────────────────────────────────────────────────────

  group('CssConicGradient: angle stop positions', () {
    test('0deg stop position → 0.0', () {
      final g =
          _parseAs<CssConicGradient>('conic-gradient(red 0deg, blue 360deg)');
      expect(g.stops[0].position, closeTo(0.0, 1e-6));
    });

    test('360deg stop position → 1.0 (not 0.0 via modulo)', () {
      final g =
          _parseAs<CssConicGradient>('conic-gradient(red 0deg, blue 360deg)');
      expect(g.stops[1].position, closeTo(1.0, 1e-6));
    });

    test('180deg stop position → 0.5', () {
      final g = _parseAs<CssConicGradient>(
          'conic-gradient(red 0deg, green 180deg, blue 360deg)');
      expect(g.stops[1].position, closeTo(0.5, 1e-6));
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // Golden tests
  //
  // Linux-only check is intentionally bypassed so goldens can be generated and
  // verified on any platform.  Re-enable the check before merging to main:
  //   final goldenSkip = Platform.isLinux ? null : 'Linux only';
  // ───────────────────────────────────────────────────────────────────────────

  // null = never skip (bypassed).  Restore before merging:
  //   Platform.isLinux ? null : 'Linux only'
  // ignore: avoid_redundant_argument_values
  // ignore: prefer_const_declarations
  final String? goldenSkip = null;

  GoldenToolkit.runWithConfiguration(
    () {
      group(
        'gradient',
        () {
          const size = Size(200, 100);

          // ── linear-gradient ─────────────────────────────────────────────
          const linearCases = <String, String>{
            'linear/to_bottom':
                'linear-gradient(to bottom, #e74c3c, #3498db)',
            'linear/to_right':
                'linear-gradient(to right, #e74c3c, #3498db)',
            'linear/45deg':
                'linear-gradient(45deg, #e74c3c, #f39c12, #3498db)',
            'linear/to_bottom_right':
                'linear-gradient(to bottom right, #e74c3c, #3498db)',
            'linear/explicit_stops':
                'linear-gradient(to right, #e74c3c 0%, #f39c12 50%, #3498db 100%)',
            'linear/transparent':
                'linear-gradient(to right, transparent, #3498db)',
            'repeating-linear':
                'repeating-linear-gradient(to right, #e74c3c 0%, #3498db 20%)',
          };

          for (final entry in linearCases.entries) {
            testGoldens(
              entry.key,
              (tester) async {
                final g = _parseAs<CssLinearGradient>(entry.value);
                await tester.pumpWidgetBuilder(
                  _GradientBox(gradient: _toFlutterGradient(g), size: size),
                  wrapper: materialAppWrapper(theme: ThemeData.light()),
                  surfaceSize: size,
                );
                await screenMatchesGolden(tester, entry.key);
              },
              skip: goldenSkip != null,
            );
          }

          // ── radial-gradient ─────────────────────────────────────────────
          const radialCases = <String, String>{
            'radial/default_ellipse':
                'radial-gradient(#e74c3c, #3498db)',
            'radial/circle':
                'radial-gradient(circle, #e74c3c, #3498db)',
            'radial/circle_at_top_right':
                'radial-gradient(circle at top right, #e74c3c, #3498db)',
            'radial/at_bottom_left':
                'radial-gradient(at bottom left, #e74c3c, #3498db)',
            'repeating-radial':
                'repeating-radial-gradient(circle, #e74c3c 0%, #3498db 20%)',
          };

          for (final entry in radialCases.entries) {
            testGoldens(
              entry.key,
              (tester) async {
                final g = _parseAs<CssRadialGradient>(entry.value);
                await tester.pumpWidgetBuilder(
                  _GradientBox(gradient: _toFlutterGradient(g), size: size),
                  wrapper: materialAppWrapper(theme: ThemeData.light()),
                  surfaceSize: size,
                );
                await screenMatchesGolden(tester, entry.key);
              },
              skip: goldenSkip != null,
            );
          }

          // ── conic-gradient ───────────────────────────────────────────────
          const conicCases = <String, String>{
            'conic/default':
                'conic-gradient(#e74c3c, #f39c12, #2ecc71, #3498db)',
            'conic/from_45deg':
                'conic-gradient(from 45deg, #e74c3c, #3498db)',
            'conic/at_top_left':
                'conic-gradient(at top left, #e74c3c, #3498db)',
            'conic/explicit_stops':
                'conic-gradient(#e74c3c 0deg, #f39c12 90deg, #2ecc71 180deg, #3498db 360deg)',
            'repeating-conic':
                'repeating-conic-gradient(from 0deg, #e74c3c 0%, #3498db 25%)',
          };

          for (final entry in conicCases.entries) {
            testGoldens(
              entry.key,
              (tester) async {
                final g = _parseAs<CssConicGradient>(entry.value);
                await tester.pumpWidgetBuilder(
                  _GradientBox(gradient: _toFlutterGradient(g), size: size),
                  wrapper: materialAppWrapper(theme: ThemeData.light()),
                  surfaceSize: size,
                );
                await screenMatchesGolden(tester, entry.key);
              },
              skip: goldenSkip != null,
            );
          }
        },
        skip: goldenSkip,
      );
    },
    config: GoldenToolkitConfiguration(
      fileNameFactory: (name) => '$kGoldenFilePrefix/background/gradient/$name.png',
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

const _eps = 1e-4;

/// Asserts that [a] and [b] are within [_eps] of each other in both axes.
void _expectAlignmentApprox(Alignment a, Alignment b) {
  expect(a.x, closeTo(b.x, _eps), reason: 'x: $a vs $b');
  expect(a.y, closeTo(b.y, _eps), reason: 'y: $a vs $b');
}

// ─────────────────────────────────────────────────────────────────────────────
// Golden helpers
// ─────────────────────────────────────────────────────────────────────────────

/// Converts a parsed [CssGradient] to the corresponding Flutter [Gradient].
///
/// Stop positions:
/// - If **all** stops carry explicit positions they are forwarded as-is.
/// - Otherwise, Flutter automatically spaces them evenly (`stops: null`).
Gradient _toFlutterGradient(CssGradient g) {
  final colors = g.stops.map((s) => s.color).toList(growable: false);
  final allHavePositions = g.stops.every((s) => s.position != null);
  final rawStops = allHavePositions
      ? g.stops.map((s) => s.position!).toList(growable: false)
      : null;

  // Flutter's TileMode.repeated tiles outside the [begin,end] vector but not
  // within it, so it has no effect when the vector spans the whole box.
  // Manually expand the stop pattern to cover [0,1] instead.
  final (effectiveColors, effectiveStops) =
      g.repeating ? _expandRepeatingStops(colors, rawStops) : (colors, rawStops);

  return switch (g) {
    CssLinearGradient(:final begin, :final end) => LinearGradient(
        begin: begin,
        end: end,
        colors: effectiveColors,
        stops: effectiveStops,
        tileMode: TileMode.clamp,
      ),
    CssRadialGradient(:final center, :final isCircle) => RadialGradient(
        center: center,
        colors: effectiveColors,
        stops: effectiveStops,
        tileMode: TileMode.clamp,
        transform: _RadialFarthestCornerTransform(
          center,
          isCircle: isCircle,
        ),
      ),
    CssConicGradient(:final center, :final startAngle) => SweepGradient(
        center: center,
        startAngle: 0,
        endAngle: 2 * pi,
        colors: effectiveColors,
        stops: effectiveStops,
        tileMode: TileMode.clamp,
        transform: _ConicAlignTransform(center, startAngle),
      ),
  };
}

/// Expands a repeating gradient's stop pattern to cover [0, 1].
///
/// Flutter's [TileMode.repeated] tiles outside the gradient vector but not
/// within [0, 1], so it produces no visible repetition when the vector spans
/// the full bounding box.  Manually repeating the tile fixes this.
(List<Color>, List<double>?) _expandRepeatingStops(
  List<Color> colors,
  List<double>? stops,
) {
  if (stops == null || stops.length < 2) return (colors, stops);
  final period = stops.last - stops.first;
  if (period <= 0 || stops.last >= 1.0) return (colors, stops);

  final outColors = <Color>[];
  final outStops = <double>[];

  var offset = 0.0;
  outer:
  while (true) {
    for (var i = 0; i < stops.length; i++) {
      final s = offset + (stops[i] - stops.first);
      if (s >= 1.0) {
        outStops.add(1.0);
        outColors.add(colors[i]);
        break outer;
      }
      outStops.add(s);
      outColors.add(colors[i]);
    }
    offset += period;
  }

  return (outColors, outStops);
}

/// Applies CSS [farthest-corner] sizing to a Flutter [RadialGradient].
///
/// Flutter's [RadialGradient] defaults to `radius: 0.5` (half the shortest
/// side). CSS defaults to `farthest-corner`, meaning the last stop should
/// reach the furthest extent of the bounding box from the gradient centre.
///
/// * **Circle** – radius = Euclidean distance from centre to farthest corner.
/// * **Ellipse** – each axis scaled independently to the farthest distance
///   in that dimension (CSS spec §4.2.1).
class _RadialFarthestCornerTransform implements GradientTransform {
  final Alignment center;
  final bool isCircle;

  const _RadialFarthestCornerTransform(
    this.center, {
    required this.isCircle,
  });

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    // Flutter's RadialGradient pixel radius = shortestSide × 0.5.
    final baseR = bounds.shortestSide / 2.0;
    if (baseR == 0) return null;

    // Gradient centre in absolute pixel coordinates.
    final cx = bounds.left + bounds.width * (center.x + 1) / 2;
    final cy = bounds.top + bounds.height * (center.y + 1) / 2;

    final maxDx = max(cx - bounds.left, bounds.right - cx);
    final maxDy = max(cy - bounds.top, bounds.bottom - cy);

    final double scaleX;
    final double scaleY;
    if (isCircle) {
      // Euclidean distance to the farthest corner.
      final farDist = sqrt(maxDx * maxDx + maxDy * maxDy);
      if (farDist == 0) return null;
      scaleX = farDist / baseR;
      scaleY = scaleX;
    } else {
      if (maxDx == 0 || maxDy == 0) return null;
      scaleX = maxDx / baseR;
      scaleY = maxDy / baseR;
    }

    // M maps gradient space → screen space:
    //   screen = S(scaleX, scaleY) · (gradient − centre) + centre
    return Matrix4.identity()
      ..translate(cx, cy)
      ..scale(scaleX, scaleY, 1.0)
      ..translate(-cx, -cy);
  }
}

class _ConicAlignTransform implements GradientTransform {
  final Alignment center;
  final double startAngle;

  const _ConicAlignTransform(this.center, this.startAngle);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    final cx = bounds.left + bounds.width * (center.x + 1) / 2;
    final cy = bounds.top + bounds.height * (center.y + 1) / 2;
    final angle = startAngle - pi / 2;
    return Matrix4.identity()
      ..translate(cx, cy)
      ..rotateZ(angle)
      ..translate(-cx, -cy);
  }
}

/// A simple fixed-size box filled with [gradient], used as the golden subject.
class _GradientBox extends StatelessWidget {
  final Gradient gradient;
  final Size size;

  const _GradientBox({required this.gradient, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: DecoratedBox(
        decoration: BoxDecoration(gradient: gradient),
      ),
    );
  }
}
