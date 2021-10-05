import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A list marker.
class HtmlListMarker extends SingleChildRenderObjectWidget {
  /// The marker type.
  final HtmlListMarkerType markerType;

  /// The [TextStyle] to apply to this marker.
  final TextStyle textStyle;

  /// Creates a circle marker.
  const HtmlListMarker.circle(this.textStyle, {Key? key})
      : markerType = HtmlListMarkerType.circle,
        super(key: key);

  /// Creates a disc marker.
  const HtmlListMarker.disc(this.textStyle, {Key? key})
      : markerType = HtmlListMarkerType.disc,
        super(key: key);

  /// Creates a square marker.
  const HtmlListMarker.square(this.textStyle, {Key? key})
      : markerType = HtmlListMarkerType.square,
        super(key: key);

  @override
  RenderObject createRenderObject(BuildContext _) =>
      _ListMarkerRenderObject(markerType, textStyle);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('markerType', markerType));
    properties.add(DiagnosticsProperty('textStyle', textStyle));
  }

  @override
  String toStringShort() {
    // TODO: bring this into test/_.dart once 0.7.0 reaches stable
    switch (markerType) {
      case HtmlListMarkerType.circle:
        return '[HtmlListMarker.circle]';
      case HtmlListMarkerType.disc:
        return '[HtmlListMarker.disc]';
      case HtmlListMarkerType.square:
        return '[HtmlListMarker.square]';
    }
  }

  @override
  void updateRenderObject(
    BuildContext _,
    _ListMarkerRenderObject renderObject,
  ) {
    renderObject
      ..markerType = markerType
      ..textStyle = textStyle;
  }
}

class _ListMarkerRenderObject extends RenderBox {
  _ListMarkerRenderObject(this._markerType, this._textStyle);

  HtmlListMarkerType _markerType;
  // ignore: avoid_setters_without_getters
  set markerType(HtmlListMarkerType v) {
    if (v == _markerType) return;
    _markerType = v;
    markNeedsLayout();
  }

  TextPainter? __textPainter;
  final _textMetrics = <LineMetrics>[];
  TextPainter get _textPainter {
    final existingPainter = __textPainter;
    if (existingPainter != null) return existingPainter;

    final newPainter = __textPainter = TextPainter(
      text: TextSpan(style: _textStyle, text: '1.'),
      textDirection: TextDirection.ltr,
    )..layout();

    _textMetrics
      ..clear()
      ..addAll(newPainter.computeLineMetrics());

    return newPainter;
  }

  TextStyle _textStyle;
  // ignore: avoid_setters_without_getters
  set textStyle(TextStyle v) {
    if (v == _textStyle) return;
    __textPainter = null;
    _textStyle = v;
    markNeedsLayout();
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) =>
      _textPainter.computeDistanceToActualBaseline(baseline);

  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      constraints.constrain(_textPainter.size);

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;

    final m = _textMetrics.isNotEmpty ? _textMetrics.first : null;
    final center = offset +
        Offset(
          size.width / 2,
          (m?.descent.isFinite == true && m?.unscaledAscent.isFinite == true)
              ? size.height -
                  m!.descent -
                  m.unscaledAscent +
                  m.unscaledAscent * .7
              : size.height / 2,
        );

    final color = _textStyle.color;
    final fontSize = _textStyle.fontSize;
    if (color == null || fontSize == null) return;

    final radius = fontSize * .2;
    switch (_markerType) {
      case HtmlListMarkerType.circle:
        canvas.drawCircle(
          center,
          radius * .9,
          Paint()
            ..color = color
            ..strokeWidth = 1
            ..style = PaintingStyle.stroke,
        );
        break;
      case HtmlListMarkerType.disc:
        canvas.drawCircle(
          center,
          radius,
          Paint()..color = color,
        );
        break;
      case HtmlListMarkerType.square:
        canvas.drawRect(
          Rect.fromCircle(center: center, radius: radius * .8),
          Paint()..color = color,
        );
        break;
    }
  }

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
  }
}

/// List marker types.
enum HtmlListMarkerType {
  /// The circle marker type.
  circle,

  /// The disc marker type.
  disc,

  /// The square marker type.
  square,
}
