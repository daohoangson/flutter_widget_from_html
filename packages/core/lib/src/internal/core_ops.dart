import 'dart:async';
import 'dart:math';

import 'package:csslib/visitor.dart' as css;
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:html/dom.dart' as dom;

import '../core_data.dart';
import '../core_helpers.dart';
import '../core_widget_factory.dart';
import 'core_parser.dart';
import 'margin_vertical.dart';

part 'ops/anchor.dart';
part 'ops/column.dart';
part 'ops/style_bg_color.dart';
part 'ops/style_border.dart';
part 'ops/style_margin.dart';
part 'ops/style_padding.dart';
part 'ops/style_sizing.dart';
part 'ops/style_text_align.dart';
part 'ops/style_text_decoration.dart';
part 'ops/style_vertical_align.dart';
part 'ops/tag_a.dart';
part 'ops/tag_br.dart';
part 'ops/tag_details.dart';
part 'ops/tag_img.dart';
part 'ops/tag_li.dart';
part 'ops/tag_q.dart';
part 'ops/tag_ruby.dart';
part 'ops/tag_table.dart';
part 'ops/text_style.dart';

const kAttributeId = 'id';

const kTagCode = 'code';
const kTagCodeFont1 = 'Courier';
const kTagCodeFont2 = 'monospace';
const kTagKbd = 'kbd';
const kTagPre = 'pre';
const kTagSamp = 'samp';
const kTagTt = 'tt';

const kTagFont = 'font';
const kAttributeFontColor = 'color';
const kAttributeFontFace = 'face';
const kAttributeFontSize = 'size';

const kCssDisplay = 'display';
const kCssDisplayBlock = 'block';
const kCssDisplayInline = 'inline';
const kCssDisplayInlineBlock = 'inline-block';
const kCssDisplayNone = 'none';

const kCssWhitespace = 'white-space';
const kCssWhitespacePre = 'pre';
const kCssWhitespaceNormal = 'normal';

void wrapTree(
  BuildTree tree, {
  BuildBit Function(BuildTree parent)? append,
  BuildBit Function(BuildTree parent)? prepend,
}) {
  final children = tree.directChildren;
  final first0 = children.isEmpty ? null : children.first;
  final first = (first0 is BuildTree ? first0.first : null) ?? first0;
  final last0 = children.isEmpty ? null : children.last;
  final last = (last0 is BuildTree ? last0.last : null) ?? last0;

  if (first == null || last == null) {
    if (prepend != null) {
      final prependBit = prepend(tree);
      tree.add(prependBit);
    }
    if (append != null) {
      final appendBit = append(tree);
      tree.add(appendBit);
    }
    return;
  }

  if (prepend != null) {
    prepend(first.parent!).insertBefore(first);
  }

  if (append != null) {
    append(last.parent!).insertAfter(last);
  }
}
