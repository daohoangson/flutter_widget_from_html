part of '../core_ops.dart';

class TextCompiler {
  final TextBits text;

  List<TextCompiled> _compiled;
  List<TextSpanBuilder> _spanBuilders;
  StringBuffer _buffer, _prevBuffer;
  TextStyleBuilder _tsb, _prevTsb;

  TextCompiler(this.text) : assert(text != null);

  List<TextCompiled> compile() {
    _compiled = [];

    _resetLoop(text.tsb);
    for (final bit in text.bits) {
      _loop(bit);
    }
    _completeLoop();

    if (_compiled.isEmpty) {
      _compiled.add(TextCompiled(
          widget: HeightPlaceholder(CssLength(1, CssLengthUnit.em), text.tsb)));
    }

    return _compiled;
  }

  void _resetLoop(TextStyleBuilder tsb) {
    _spanBuilders = [];
    _buffer = StringBuffer();
    _tsb = tsb;

    _prevBuffer = _buffer;
    _prevTsb = _tsb;
  }

  void _loop(final TextBit bit) {
    final tsb = _getBitTsb(bit);
    if (_spanBuilders == null) _resetLoop(tsb);

    final thisTsb = tsb ?? _prevTsb;
    if (thisTsb?.hasSameStyleWith(_prevTsb) == false) _saveSpan();

    if (bit is TextBit<void, String>) {
      _prevBuffer.write(bit.compile(null));
      _prevTsb = thisTsb;
    } else if (bit is TextBit<TextStyleHtml, InlineSpan>) {
      _saveSpan();
      _spanBuilders.add((context) => bit.compile(thisTsb?.build(context)));
    } else if (bit is TextBit<TextStyleBuilder, Widget>) {
      _completeLoop();
      final widget = bit.compile(thisTsb);
      if (widget != null) _compiled.add(TextCompiled(widget: widget));
    }
  }

  void _saveSpan() {
    if (_prevBuffer != _buffer && _prevBuffer.length > 0) {
      final scopedTsb = _prevTsb;
      final scopedText = _prevBuffer.toString();
      _spanBuilders.add((context) => TextSpan(
            style: scopedTsb?.build(context)?.styleWithHeight,
            text: scopedText,
          ));
    }
    _prevBuffer = StringBuffer();
  }

  void _completeLoop() {
    _saveSpan();

    TextSpanBuilder spanBuilder;
    Widget widget;
    if (_spanBuilders == null) {
      // intentionally left empty
    } else if (_spanBuilders.isNotEmpty || _buffer.isNotEmpty) {
      final scopedBuilders = _spanBuilders;
      final scopedTsb = _tsb;
      final scopedText = _buffer.toString();
      spanBuilder = (context) {
        final children = scopedBuilders
            .map((spanBuilder) => spanBuilder(context))
            .toList(growable: false);
        if (scopedText.isEmpty && children.length == 1) return children.first;

        return TextSpan(
          children: children,
          style: scopedTsb?.build(context)?.styleWithHeight,
          text: scopedText,
        );
      };
    }

    _spanBuilders = null;
    if (spanBuilder == null) return;
    _compiled.add(TextCompiled(spanBuilder: spanBuilder, widget: widget));
  }

  static TextStyleBuilder _getBitTsb(TextBit bit) {
    if (bit.tsb != null) return bit.tsb;

    // the below code will find the best style for this whitespace bit
    // easy case: whitespace at the beginning of a tag, use the previous style
    final parent = bit.parent;
    if (parent == null || bit == parent.first) return null;

    // complicated: whitespace at the end of a tag, try to merge with the next
    // unless it has unrelated style (e.g. next bit is a sibling)
    if (bit == parent.last) {
      final next = bit.next;
      if (next?.tsb != null) {
        // get the outer-most bits having this as the last bit
        var bits = parent;
        while (true) {
          final bitsParentLast = bits.parent?.last;
          if (bitsParentLast != bit) break;
          bits = bits.parent;
        }

        if (bits.parent == next.parent) {
          return next.tsb;
        } else {
          return null;
        }
      }
    }

    // fallback to default (style from parent)
    return parent.tsb;
  }
}

@immutable
class TextCompiled {
  final TextSpanBuilder spanBuilder;
  final Widget widget;

  TextCompiled({this.spanBuilder, this.widget});
}

typedef TextSpanBuilder = InlineSpan Function(BuildContext);

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
