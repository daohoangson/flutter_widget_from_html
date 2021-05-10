import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class HtmlListMarker extends SingleChildRenderObjectWidget {
  final HtmlListMarkerType markerType;
  final TextStyle textStyle;

  const HtmlListMarker.circle(this.textStyle, {Key? key})
      : markerType = HtmlListMarkerType.circle,
        super(key: key);

  const HtmlListMarker.disc(this.textStyle, {Key? key})
      : markerType = HtmlListMarkerType.disc,
        super(key: key);

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
  void updateRenderObject(
      BuildContext _, _ListMarkerRenderObject renderObject) {
    renderObject
      ..markerType = markerType
      ..textStyle = textStyle;
  }
}

class _ListMarkerRenderObject extends RenderBox {
  _ListMarkerRenderObject(this._markerType, this._textStyle);

  HtmlListMarkerType _markerType;
  set markerType(HtmlListMarkerType v) {
    if (v == _markerType) return;
    _markerType = v;
    markNeedsLayout();
  }

  TextPainter? __textPainter;
  TextPainter get _textPainter {
    return __textPainter ??= TextPainter(
      text: TextSpan(style: _textStyle, text: '1.'),
      textDirection: TextDirection.ltr,
    )..layout();
  }

  TextStyle _textStyle;
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

    var lineMetrics = <LineMetrics>[];
    try {
      lineMetrics = _textPainter.computeLineMetrics();
      // ignore: empty_catches
    } on UnimplementedError {}

    final m = lineMetrics.isNotEmpty ? lineMetrics.first : null;
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

enum HtmlListMarkerType {
  circle,
  disc,
  square,
}
