import 'dart:math';

import 'package:csslib/parser.dart' as css;
import 'package:csslib/visitor.dart' as css;
import 'package:flutter/widgets.dart';

import '../core_data.dart';
import '../core_helpers.dart';

part 'parser/border.dart';
part 'parser/color.dart';
part 'parser/length.dart';

const kCssSuffixBlockEnd = '-block-end';
const kCssSuffixBlockStart = '-block-start';
const kCssSuffixBottom = '-bottom';
const kCssSuffixInlineEnd = '-inline-end';
const kCssSuffixInlineStart = '-inline-start';
const kCssSuffixLeft = '-left';
const kCssSuffixRight = '-right';
const kCssSuffixTop = '-top';
