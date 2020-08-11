part of '../core_widget_factory.dart';

class _TextCompiler {
  final TextBits text;

  List<TextSpanBuilder> _builders;
  List<TextSpanBuilder> _merged;
  StringBuffer _buffer, _prevBuffer;
  TextStyleBuilder _tsb, _prevTsb;

  _TextCompiler(this.text) : assert(text != null);

  List<TextSpanBuilder> compile() {
    _merged = [];

    _resetLoop(text.tsb);
    for (final bit in text.bits) {
      _loop(bit);
    }
    _completeLoop();

    if (_merged.isEmpty) {
      _merged.add(TextSpanBuilder.prebuilt(
        widget: _MarginVerticalPlaceholder(
            CssLength(1, CssLengthUnit.em), text.tsb),
      ));
    }

    return _merged;
  }

  void _resetLoop(TextStyleBuilder tsb) {
    _builders = [];
    _buffer = StringBuffer();
    _tsb = tsb;

    _prevBuffer = _buffer;
    _prevTsb = _tsb;
  }

  void _loop(final TextBit bit) {
    final tsb = _getBitTsb(bit);
    if (_builders == null) _resetLoop(tsb);

    final thisTsb = tsb ?? _prevTsb;
    if (!thisTsb.hasSameStyleWith(_prevTsb)) _saveSpan();

    if (bit.hasBuilder) {
      _saveSpan();
      _builders.add(bit.prepareBuilder(thisTsb));
      return;
    }

    if (bit is TextWhitespace && !bit.hasTrailingWhitespace) {
      _completeLoop();
      final newLines = bit.data.length - 1;
      if (newLines > 0) {
        _merged.add(TextSpanBuilder.prebuilt(
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
      final scopedTsb = _prevTsb;
      final scopedText = _prevBuffer.toString();
      _builders.add(TextSpanBuilder((context) => TextSpan(
            style: scopedTsb.build(context).styleWithHeight,
            text: scopedText,
          )));
    }
    _prevBuffer = StringBuffer();
  }

  void _completeLoop() {
    _saveSpan();

    TextSpanBuilder builder;
    if (_builders == null) {
      // intentionally left empty
    } else if (_builders.length == 1 && _buffer.isEmpty) {
      builder = _builders[0];
      final prebuiltSpan = builder.span;

      if (prebuiltSpan != null &&
          prebuiltSpan is WidgetSpan &&
          prebuiltSpan.alignment == PlaceholderAlignment.baseline &&
          (text.tsb?.textAlign ?? TextAlign.start) == TextAlign.start) {
        builder = TextSpanBuilder.prebuilt(widget: prebuiltSpan.child);
      }
    } else if (_builders.isNotEmpty || _buffer.isNotEmpty) {
      final scoped = List<TextSpanBuilder>.from(_builders, growable: false);
      final scopedTsb = _tsb;
      final scopedText = _buffer.toString();
      builder = TextSpanBuilder((context) => TextSpan(
            children: scoped
                .map((builder) => builder.build(context))
                .where((span) => span != null)
                .toList(growable: false),
            style: scopedTsb.build(context).styleWithHeight,
            text: scopedText,
          ));
    }

    _builders = null;
    if (builder != null) _merged.add(builder);
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
