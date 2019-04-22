part of '../parser.dart';

final _attrStyleRegExp = RegExp(r'([a-zA-Z\-]+)\s*:\s*([^;]*)');

void attrStyleLoop(dom.Element e, void f(String k, String v)) =>
    e.attributes.containsKey('style')
        ? _attrStyleRegExp
            .allMatches(e.attributes['style'])
            .forEach((match) => f(match[1].trim(), match[2].trim()))
        : null;
