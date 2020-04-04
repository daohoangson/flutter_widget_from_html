part of '../core_widget_factory.dart';

class _TextCompiler {
  final TextBits text;

  BuilderContext _bc;
  List _compiled;

  List<InlineSpan> _spans;
  StringBuffer _buffer, _prevBuffer;
  GestureRecognizer _recognizer, _prevRecognizer;
  TextStyle _style, _prevStyle;

  _TextCompiler(this.text) : assert(text != null);

  List compile(BuilderContext bc) {
    _bc = bc;
    _compiled = [];

    for (final bit in text.bits) {
      _loop(bit);
    }
    _completeLoop();

    if (_compiled.isEmpty) {
      _compiled.add(_MarginPlaceholder(
        height: CssLength(1, unit: CssLengthUnit.em),
        tsb: text.tsb,
      ));
    }

    return _compiled;
  }

  void _resetLoop(TextStyleBuilders tsb) {
    _spans = <InlineSpan>[];

    _buffer = StringBuffer();
    _recognizer = tsb?.recognizer;
    _style = tsb?.build(_bc);

    _prevBuffer = _buffer;
    _prevStyle = _style;
    _prevRecognizer = _recognizer;
  }

  void _loop(final TextBit bit) {
    final tsb = _getBitTsb(bit);
    if (_spans == null) _resetLoop(tsb);

    final recognizer = tsb?.recognizer ?? bit.tsb?.recognizer;
    final style = tsb?.build(_bc) ?? _prevStyle;
    if (recognizer != _prevRecognizer || style != _prevStyle) _saveSpan();

    if (bit.canCompile) {
      _saveSpan();
      _spans.add(bit.compile(style));
      return;
    }

    if (bit is SpaceBit && bit.data != null) {
      _completeLoop();
      final newLines = bit.data.length - 1;
      if (newLines > 0) {
        _compiled.add(_MarginPlaceholder(
          height: CssLength(newLines.toDouble(), unit: CssLengthUnit.em),
          tsb: bit.parent.tsb,
        ));
      }
      return;
    }

    _prevBuffer.write(bit.data ?? ' ');
    _prevRecognizer = recognizer;
    _prevStyle = style;
  }

  void _saveSpan() {
    if (_prevBuffer != _buffer && _prevBuffer.length > 0) {
      _spans.add(TextSpan(
        recognizer: _prevRecognizer,
        style: _prevStyle,
        text: _prevBuffer.toString(),
      ));
    }
    _prevBuffer = StringBuffer();
  }

  void _completeLoop() {
    _saveSpan();

    InlineSpan span;
    Widget widget;
    if (_spans == null) {
      // intentionally left empty
    } else if (_spans.length == 1 && _buffer.isEmpty) {
      span = _spans[0];

      if (span is WidgetSpan &&
          span.alignment == PlaceholderAlignment.baseline &&
          (text.tsb?.textAlign ?? TextAlign.start) == TextAlign.start) {
        widget = span.child;
      }
    } else if (_spans.isNotEmpty || _buffer.isNotEmpty) {
      span = TextSpan(
        children: _spans,
        recognizer: _recognizer,
        style: _style,
        text: _buffer.toString(),
      );
    }

    _spans = null;

    if (span == null) return;
    _compiled.add(widget ?? span);
  }

  static TextStyleBuilders _getBitTsb(TextBit bit) {
    if (bit.tsb != null) return bit.tsb;

    // the below code will find the best style for this whitespace bit
    // easy case: whitespace at the beginning of a tag, use the previous style
    final parent = bit.parent;
    if (bit == parent.first) return null;

    // complicated: whitespace at the end of a tag, try to merge with the next
    // unless it has unrelated style (e.g. next bit is a sibling)
    if (bit == TextBit.tailOf(parent)) {
      final next = TextBit.nextOf(bit);
      if (next?.tsb != null) {
        // get the outer-most text having this as the last bit
        var bp = bit.parent;
        var bpTail = TextBit.tailOf(bp);
        while (true) {
          final parentTail = TextBit.tailOf(bp.parent);
          if (bpTail != parentTail) break;
          bp = bp.parent;
          bpTail = parentTail;
        }

        if (bp.parent == next.parent) {
          return next.tsb;
        } else {
          return null;
        }
      }
    }

    // fallback to default (style from parent)
    return bit.parent.tsb;
  }
}
