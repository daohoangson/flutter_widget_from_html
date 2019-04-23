part of '../parser.dart';

final _textIsUselessRegExp = RegExp(r'^\s*$');

bool checkTextIsUseless(String text) =>
    text != null && _textIsUselessRegExp.firstMatch(text) != null;

bool checkTextSpanIsUseless(TextSpan span) {
  if (span == null) return true;
  if (span.children?.isNotEmpty == true) return false;

  return checkTextIsUseless(span.text);
}
