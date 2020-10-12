import 'dart:math';

import 'package:flutter/widgets.dart';

import '../core_data.dart';

part 'parser/color.dart';
part 'parser/length.dart';

const kSuffixBlockEnd = '-block-end';
const kSuffixBlockStart = '-block-start';
const kSuffixBottom = '-bottom';
const kSuffixInlineEnd = '-inline-end';
const kSuffixInlineStart = '-inline-start';
const kSuffixLeft = '-left';
const kSuffixRight = '-right';
const kSuffixTop = '-top';

final _spacingRegExp = RegExp(r'\s+');
Iterable<String> splitCssValues(String value) => value.split(_spacingRegExp);

final _attrStyleRegExp = RegExp(r'([a-zA-Z\-]+)\s*:\s*([^;]*)');
Iterable<MapEntry<String, String>> splitAttributeStyle(String value) =>
    _attrStyleRegExp
        .allMatches(value)
        .map((m) => MapEntry(m[1].trim(), m[2].trim()));
