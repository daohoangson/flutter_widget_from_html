part of '../core_helpers.dart';

TextSpan compileToTextSpan(TextBlock b) {
  if (b == null || b.isEmpty) return null;

  final i = _getNoTrailing(b).iterator;
  final children = <TextSpan>[];

  i.moveNext();
  final first = i.current;
  final firstSb = StringBuffer(first.data ?? '');

  var prevOnTap = first.onTap;
  var prevStyle = first.style;
  var prevSb = firstSb;
  final addChild = () {
    if (prevSb != firstSb && prevSb.length > 0) {
      children.add(TextSpan(
        recognizer: _buildGestureRecognizer(prevOnTap),
        style: prevStyle,
        text: prevSb.toString(),
      ));
    }
    prevSb = StringBuffer();
  };
  while (i.moveNext()) {
    final bit = i.current;
    final style = _getBitStyle(bit) ?? prevStyle;
    if (bit.onTap != prevOnTap || style != prevStyle) {
      addChild();
    }

    prevOnTap = bit.onTap;
    prevStyle = style;
    prevSb.write(bit.data ?? ' ');
  }

  addChild();

  return TextSpan(
    children: children,
    recognizer: _buildGestureRecognizer(first.onTap),
    style: first.style,
    text: firstSb.toString(),
  );
}

GestureRecognizer _buildGestureRecognizer(VoidCallback onTap) =>
    onTap != null ? (TapGestureRecognizer()..onTap = onTap) : null;

TextStyle _getBitStyle(TextBit bit) {
  if (bit.style != null) return bit.style;

  // the below code will find the best style for this whitespace bit
  // easy case: whitespace at the beginning of a tag, use the previous style
  final iterable = bit.block.iterable;
  if (bit == iterable.first) return null;

  // complicated: whitespace at the end of a tag, try to merge with the next
  // unless it has unrelated style (e.g. next bit is a sibling)
  if (bit == iterable.last) {
    // next should always has `data` and `style` (thanks to `_getNoTrailing`)
    final next = bit.block.next;
    assert(next?.style != null);

    // get the outer-most block having this as the last bit
    var bb = bit.block;
    while (true) {
      if (bb.indexEnd != bb.parent?.indexEnd) break;
      bb = bb.parent;
    }

    if (bb.parent == next.block) {
      return next.style;
    } else {
      return null;
    }
  }

  // fallback to default (style from block)
  return bit.block.style;
}

Iterable<TextBit> _getNoTrailing(TextBlock block) {
  final i = block.iterable;
  return block.hasTrailingSpace ? i.take(i.length - 1) : i;
}
