part of '../core_widget_factory.dart';

class _TextBlockCompiler {
  final TextBlock block;

  BuilderContext _bc;
  List _compiled;

  List<InlineSpan> _spans;
  TextBit _bit;
  StringBuffer _buffer, _prevBuffer;
  TextStyle _style, _prevStyle;
  GestureTapCallback _prevOnTap;

  _TextBlockCompiler(this.block) : assert(block != null);

  List compile(BuilderContext bc) {
    _bc = bc;
    _compiled = [];

    block.forEachBit(_loop);
    _completeLoop();

    if (_compiled.isEmpty)
      _compiled.add(SpacingPlaceholder(
        height: CssLength(1, unit: CssLengthUnit.em),
        tsb: block.tsb,
      ));

    return _compiled;
  }

  void _resetLoop(TextBit bit) {
    _spans = <InlineSpan>[];

    _bit = bit;
    _buffer = StringBuffer();
    _style = _bit.tsb?.build(_bc);

    _prevBuffer = _buffer;
    _prevStyle = _style;
    _prevOnTap = _bit.onTap;
  }

  void _loop(TextBit bit, int _) {
    if (_spans == null) _resetLoop(bit);

    final style = _getBitTsb(bit)?.build(_bc) ?? _prevStyle;
    if (bit.onTap != _prevOnTap || style != _prevStyle) _saveSpan();

    if (bit is WidgetBit) {
      _saveSpan();
      _spans.add(bit.widgetSpan);
      return;
    }

    if (bit is SpaceBit && bit.data != null) {
      _completeLoop();
      final newLines = bit.data.length - 1;
      if (newLines > 0) {
        _compiled.add(SpacingPlaceholder(
          height: CssLength(newLines.toDouble(), unit: CssLengthUnit.em),
          tsb: bit.parent.tsb,
        ));
      }
      return;
    }

    _prevBuffer.write(bit.data ?? ' ');
    _prevStyle = style;
    _prevOnTap = bit.onTap;
  }

  void _saveSpan() {
    if (_prevBuffer != _buffer && _prevBuffer.length > 0) {
      _spans.add(TextSpan(
        recognizer: _buildGestureRecognizer(_prevOnTap),
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
          (block.tsb?.textAlign ?? TextAlign.start) == TextAlign.start) {
        widget = span.child;
      }
    } else if (_spans.isNotEmpty || _buffer.isNotEmpty) {
      span = TextSpan(
        children: _spans,
        recognizer: _buildGestureRecognizer(_bit.onTap),
        style: _style,
        text: _buffer.toString(),
      );
    }

    _spans = null;

    if (span == null) return;
    _compiled.add(widget ?? span);
  }

  static GestureRecognizer _buildGestureRecognizer(VoidCallback onTap) =>
      onTap != null ? (TapGestureRecognizer()..onTap = onTap) : null;

  static TextStyleBuilders _getBitTsb(TextBit bit) {
    if (bit.tsb != null) return bit.tsb;

    // the below code will find the best style for this whitespace bit
    // easy case: whitespace at the beginning of a tag, use the previous style
    final parent = bit.parent;
    if (bit.isFirst) return null;

    // complicated: whitespace at the end of a tag, try to merge with the next
    // unless it has unrelated style (e.g. next bit is a sibling)
    if (bit == TextBit.lastOf(parent)) {
      final next = TextBit.nextOf(bit);
      if (next?.tsb != null) {
        // get the outer-most block having this as the last bit
        var bp = bit.parent;
        var bpLast = TextBit.lastOf(bp);
        while (true) {
          final parentLast = TextBit.lastOf(bp.parent);
          if (bpLast != parentLast) break;
          bp = bp.parent;
          bpLast = parentLast;
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
