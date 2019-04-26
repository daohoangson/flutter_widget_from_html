part of '../core_wf.dart';

TextSpan compileToTextSpan(TextBlock b, TextStyle defaultStyle) {
  if (b == null || b.isEmpty) return null;

  final i = _getNoTrailing(b).iterator;
  final children = <TextSpan>[];

  i.moveNext();
  final first = i.current;
  final firstSb = StringBuffer(first.text);

  var prevBit = first;
  var prevSb = firstSb;
  final addChild = () {
    if (prevSb != firstSb && prevSb.length > 0) {
      children.add(TextSpan(
        recognizer: _buildGestureRecognizer(prevBit),
        style: prevBit.style ?? defaultStyle,
        text: prevSb.toString(),
      ));
    }
    prevSb = StringBuffer();
  };
  while (i.moveNext()) {
    final bit = i.current;
    if (bit.onTap != prevBit.onTap || bit.style != prevBit.style) {
      addChild();
    }

    prevBit = bit;
    prevSb.write(bit.text);
  }

  addChild();

  return TextSpan(
    children: children,
    recognizer: _buildGestureRecognizer(first),
    style: first.style ?? defaultStyle,
    text: firstSb.toString(),
  );
}

String compileToString(TextBlock b) {
  if (b == null || b.isEmpty) return null;

  final sb = StringBuffer();
  _getNoTrailing(b).forEach((b) => sb.write(b.text));

  return sb.toString();
}

GestureRecognizer _buildGestureRecognizer(TextBit bit) =>
    bit.onTap != null ? (TapGestureRecognizer()..onTap = bit.onTap) : null;

Iterable<TextBit> _getNoTrailing(TextBlock block) {
  final i = block.iterable;
  return block.hasTrailingSpace ? i.take(i.length - 1) : i;
}
