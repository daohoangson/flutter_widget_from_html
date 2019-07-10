part of '../core_widget_factory.dart';

InlineSpan _compileToTextSpan(TextBlock b) {
  if (b == null || b.isEmpty) return null;

  b.trimRight();

  final children = <InlineSpan>[];

  final first = b.first;
  final firstSb = StringBuffer();

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

  b.forEachBit((bit, i) {
    final style = _getBitStyle(bit) ?? prevStyle;
    if (bit.onTap != prevOnTap || style != prevStyle) {
      addChild();
    }

    if (bit.isWidget) {
      addChild();
      children.add(bit.widgetSpan);
      return;
    }

    prevOnTap = bit.onTap;
    prevStyle = style;
    prevSb.write(bit.data ?? ' ');
  });

  addChild();

  if (children.length == 1 && first.onTap == null && firstSb.length == 0) {
    return children[0];
  }

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
  final block = bit.block;
  if (bit == block.first) return null;

  // complicated: whitespace at the end of a tag, try to merge with the next
  // unless it has unrelated style (e.g. next bit is a sibling)
  if (bit == block.last) {
    final next = bit.block.next;
    if (next?.style != null) {
      // get the outer-most block having this as the last bit
      var bb = bit.block;
      while (true) {
        if (bb.last != bb.parent?.last) break;
        bb = bb.parent;
      }

      if (bb.parent == next.block) {
        return next.style;
      } else {
        return null;
      }
    }
  }

  // fallback to default (style from block)
  return bit.block.style;
}
