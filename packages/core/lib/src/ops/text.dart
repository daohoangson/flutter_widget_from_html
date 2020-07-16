part of '../core_widget_factory.dart';

class _TextCompiler {
  final TextBits text;

  BuildContext _context;
  List _compiled;

  List<InlineSpan> _spans;
  StringBuffer _buffer, _prevBuffer;
  TextStyle _style, _prevStyle;

  _TextCompiler(this.text) : assert(text != null);

  List compile(BuildContext context) {
    _context = context;
    _compiled = [];

    _resetLoop(text.tsb);
    for (final bit in text.bits) {
      _loop(bit);
    }
    _completeLoop();

    if (_compiled.isEmpty) {
      _compiled.add(_MarginVerticalPlaceholder(
        text.tsb,
        CssLength(1, unit: CssLengthUnit.em),
      ));
    }

    return _compiled;
  }

  void _resetLoop(TextStyleBuilders tsb) {
    _spans = <InlineSpan>[];

    _buffer = StringBuffer();
    _style = tsb?.style(_context);

    _prevBuffer = _buffer;
    _prevStyle = _style;
  }

  void _loop(final TextBit bit) {
    final tsb = _getBitTsb(bit);
    if (_spans == null) _resetLoop(tsb);

    final style = tsb?.style(_context) ?? _prevStyle;
    if (style != _prevStyle) _saveSpan();

    if (bit.canCompile) {
      _saveSpan();
      _spans.add(bit.compile(style));
      return;
    }

    if (bit is TextWhitespace && !bit.hasTrailingWhitespace) {
      _completeLoop();
      final newLines = bit.data.length - 1;
      if (newLines > 0) {
        _compiled.add(_MarginVerticalPlaceholder(
          bit.parent.tsb,
          CssLength(newLines.toDouble(), unit: CssLengthUnit.em),
        ));
      }
      return;
    }

    _prevBuffer.write(bit.data);
    _prevStyle = style;
  }

  void _saveSpan() {
    if (_prevBuffer != _buffer && _prevBuffer.length > 0) {
      _spans.add(TextSpan(
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
          (text.tsb?.build(_context)?.align ?? TextAlign.start) ==
              TextAlign.start) {
        widget = span.child;
      }
    } else if (_spans.isNotEmpty || _buffer.isNotEmpty) {
      span = TextSpan(
        children: _spans,
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

Iterable<BuiltPiece> _wrapTextBits(
  Iterable<BuiltPiece> pieces, {
  TextBit Function(TextBits) appendBuilder,
  TextBit Function(TextBits) prependBuilder,
}) {
  final firstText = pieces.first?.text;
  final lastText = pieces.last?.text;
  if (firstText == lastText && firstText.isEmpty) {
    final text = firstText;
    if (appendBuilder != null) text.add(appendBuilder(text));
    if (prependBuilder != null) text.add(prependBuilder(text));
    return pieces;
  }

  final firstBit = firstText?.first;
  final firstBp = firstBit?.parent;
  final lastBit = lastText?.last;
  final lastBp = lastBit?.parent;
  if (firstBp != null && lastBp != null) {
    if (appendBuilder != null) prependBuilder(firstBp).insertBefore(firstBit);
    if (prependBuilder != null) prependBuilder(lastBp).insertAfter(lastBit);
  }

  return pieces;
}
