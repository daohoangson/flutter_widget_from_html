import 'dart:math';

import 'package:flutter/widgets.dart';

import '../core_data.dart';

part 'parser/border.dart';
part 'parser/color.dart';
part 'parser/length.dart';

const kCssTextAlign = 'text-align';
const kCssTextAlignCenter = 'center';
const kCssTextAlignJustify = 'justify';
const kCssTextAlignLeft = 'left';
const kCssTextAlignRight = 'right';
const kAttributeAlign = 'align';

double tryParseDoubleFromMap(Map<dynamic, String> map, String key) =>
    map.containsKey(key) ? double.tryParse(map[key]) : null;

TextAlign tryParseTextAlign(String value) {
  switch (value) {
    case kCssTextAlignCenter:
      return TextAlign.center;
    case kCssTextAlignJustify:
      return TextAlign.justify;
    case kCssTextAlignLeft:
      return TextAlign.left;
    case kCssTextAlignRight:
      return TextAlign.right;
  }

  return null;
}
