import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';

import '../core_data.dart';
import '../core_helpers.dart';
import '../core_widget_factory.dart';
import 'builder.dart';
import 'core_parser.dart';
import 'css_sizing.dart';
import 'margin_vertical.dart';

part 'ops/column.dart';
part 'ops/style_bg_color.dart';
part 'ops/style_margin.dart';
part 'ops/style_padding.dart';
part 'ops/style_sizing.dart';
part 'ops/style_vertical_align.dart';
part 'ops/tag_a.dart';
part 'ops/tag_code.dart';
part 'ops/tag_font.dart';
part 'ops/tag_img.dart';
part 'ops/tag_li.dart';
part 'ops/tag_q.dart';
part 'ops/tag_ruby.dart';
part 'ops/tag_table.dart';
part 'ops/text.dart';
part 'ops/text_style.dart';

const kCssDisplay = 'display';
const kCssDisplayBlock = 'block';
const kCssDisplayInline = 'inline';
const kCssDisplayInlineBlock = 'inline-block';
const kCssDisplayNone = 'none';

const kCssMaxLines = 'max-lines';
const kCssMaxLinesNone = 'none';
const kCssMaxLinesWebkitLineClamp = '-webkit-line-clamp';

const kCssTextOverflow = 'text-overflow';
const kCssTextOverflowClip = 'clip';
const kCssTextOverflowEllipsis = 'ellipsis';

String convertColorToHex(Color value) {
  final r = value.red.toRadixString(16).padLeft(2, '0');
  final g = value.green.toRadixString(16).padLeft(2, '0');
  final b = value.blue.toRadixString(16).padLeft(2, '0');
  final a = value.alpha.toRadixString(16).padLeft(2, '0');
  return '#$r$g$b$a';
}

Iterable<Widget> listOrNull(Widget x) => x == null ? null : [x];
