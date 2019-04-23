part of '../parser.dart';

final _attrStyleRegExp = RegExp(r'([a-zA-Z\-]+)\s*:\s*([^;]*)');
final _lengthRegExp = RegExp(r'^([\d\.]+)(em|px)$');

void attrStyleLoop(dom.Element e, void f(String k, String v)) =>
    e.attributes.containsKey('style')
        ? _attrStyleRegExp
            .allMatches(e.attributes['style'])
            .forEach((match) => f(match[1].trim(), match[2].trim()))
        : null;

CssLength lengthParseValue(String value) {
  if (value == null) return null;
  if (value == '0') return CssLength(0);

  final match = _lengthRegExp.firstMatch(value);
  if (match == null) return null;

  final number = double.tryParse(match[1]);
  if (number == null) return null;

  switch (match[2]) {
    case 'em':
      return CssLength(number, unit: CssLengthUnit.em);
    case 'px':
      return CssLength(number, unit: CssLengthUnit.px);
  }

  return null;
}
