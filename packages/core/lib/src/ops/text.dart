part of '../core_widget_factory.dart';

class _TextCompiler {
  final TextBits text;

  List<_TextCompiled> _compiled;
  List<InlineSpan> _spans;
  StringBuffer _buffer, _prevBuffer;
  TextStyleBuilder _tsb, _prevTsb;

  _TextCompiler(this.text) : assert(text != null);

  List<_TextCompiled> compile() {
    _compiled = [];

    _resetLoop(text.tsb);
    for (final bit in text.bits) {
      _loop(bit);
    }
    _completeLoop();

    if (_compiled.isEmpty) {
      _compiled.add(_TextCompiled(
          widget: _MarginVerticalPlaceholder(
              CssLength(1, CssLengthUnit.em), text.tsb)));
    }

    return _compiled;
  }

  void _resetLoop(TextStyleBuilder tsb) {
    _spans = [];
    _buffer = StringBuffer();
    _tsb = tsb;

    _prevBuffer = _buffer;
    _prevTsb = _tsb;
  }

  void _loop(final TextBit bit) {
    final tsb = _getBitTsb(bit);
    if (_spans == null) _resetLoop(tsb);

    final thisTsb = tsb ?? _prevTsb;
    if (thisTsb?.hasSameStyleWith(_prevTsb) == false) _saveSpan();

    if (bit.canCompile) {
      _saveSpan();
      _spans.add(bit.compile(thisTsb));
      return;
    }

    if (bit is TextWhitespace && !bit.hasTrailingWhitespace) {
      _completeLoop();
      final newLines = bit.data.length - 1;
      if (newLines > 0) {
        _compiled.add(_TextCompiled(
          widget: _MarginVerticalPlaceholder(
            CssLength(newLines.toDouble(), CssLengthUnit.em),
            bit.parent.tsb,
          ),
        ));
      }
      return;
    }

    _prevBuffer.write(bit.data);
    _prevTsb = thisTsb;
  }

  void _saveSpan() {
    if (_prevBuffer != _buffer && _prevBuffer.length > 0) {
      _spans.add(TextSpan(
        style: _prevTsb?.build()?.styleWithHeight,
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
          (text.tsb?.build()?.textAlign ?? TextAlign.start) ==
              TextAlign.start) {
        widget = span.child;
      }
    } else if (_spans.isNotEmpty || _buffer.isNotEmpty) {
      span = TextSpan(
        children: _spans,
        style: _tsb?.build()?.styleWithHeight,
        text: _buffer.toString(),
      );
    }

    _spans = null;
    if (span == null) return;
    _compiled.add(_TextCompiled(span: span, widget: widget));
  }

  static TextStyleBuilder _getBitTsb(TextBit bit) {
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

@immutable
class _TextCompiled {
  final InlineSpan span;
  final Widget widget;

  _TextCompiled({this.span, this.widget});
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
    if (prependBuilder != null) text.add(prependBuilder(text));
    if (appendBuilder != null) text.add(appendBuilder(text));
    return pieces;
  }

  final firstBit = firstText?.first;
  final firstBp = firstBit?.parent;
  final lastBit = lastText?.last;
  final lastBp = lastBit?.parent;
  if (firstBp != null && lastBp != null) {
    if (prependBuilder != null) prependBuilder(firstBp).insertBefore(firstBit);
    if (appendBuilder != null) appendBuilder(lastBp).insertAfter(lastBit);
  }

  return pieces;
}
