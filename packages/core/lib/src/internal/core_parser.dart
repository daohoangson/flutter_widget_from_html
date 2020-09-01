import 'dart:math';

import 'package:flutter/widgets.dart';

import '../core_data.dart';

part 'parser/border.dart';
part 'parser/color.dart';
part 'parser/length.dart';

double tryParseDoubleFromMap(Map<dynamic, String> map, String key) =>
    map.containsKey(key) ? double.tryParse(map[key]) : null;

int tryParseIntFromMap(Map<dynamic, String> map, String key) =>
    map.containsKey(key) ? int.tryParse(map[key]) : null;

final _spacingRegExp = RegExp(r'\s+');
Iterable<String> splitCssValues(String value) => value.split(_spacingRegExp);

final _attrStyleRegExp = RegExp(r'([a-zA-Z\-]+)\s*:\s*([^;]*)');
Iterable<MapEntry<String, String>> splitAttributeStyle(String value) =>
    _attrStyleRegExp
        .allMatches(value)
        .map((m) => MapEntry(m[1].trim(), m[2].trim()));
