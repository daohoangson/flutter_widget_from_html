import 'dart:async';
import 'dart:math';

import 'package:csslib/visitor.dart' as css;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart'
    show
        // we want to limit Material usages to be as generic as possible
        ThemeData;
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

import '../core_data.dart';
import '../core_helpers.dart';
import '../core_widget_factory.dart';
import 'core_parser.dart';
import 'margin_vertical.dart';

part 'ops/anchor.dart';
part 'ops/column.dart';
part 'ops/priorities.dart';
part 'ops/style_background.dart';
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
part 'ops/tag_font.dart';
part 'ops/tag_img.dart';
part 'ops/tag_li.dart';
part 'ops/tag_pre.dart';
part 'ops/tag_q.dart';
part 'ops/tag_ruby.dart';
part 'ops/tag_table.dart';
part 'ops/text_style.dart';

const kAttributeId = 'id';

const kTagAcronym = 'acronym';
const kTagAddress = 'address';
const kTagCode = 'code';
const kTagCodeFont1 = 'Courier';
const kTagCodeFont2 = 'monospace';
const kTagDd = 'dd';
const kTagDiv = 'div';
const kTagDt = 'dt';
const kTagFigure = 'figure';
const kTagH1 = 'h1';
const kTagH2 = 'h2';
const kTagH3 = 'h3';
const kTagH4 = 'h4';
const kTagH5 = 'h5';
const kTagH6 = 'h6';
const kTagIns = 'ins';
const kTagKbd = 'kbd';
const kTagMark = 'mark';
const kTagP = 'p';
const kTagSamp = 'samp';
const kTagScript = 'script';
const kTagStrike = 'strike';
const kTagSub = 'sub';
const kTagSup = 'sup';
const kTagTt = 'tt';

const kCssDisplay = 'display';
const kCssDisplayBlock = 'block';
const kCssDisplayInline = 'inline';
const kCssDisplayInlineBlock = 'inline-block';
const kCssDisplayNone = 'none';

const kCssWhitespace = 'white-space';
const kCssWhitespaceNormal = 'normal';
const kCssWhitespaceNowrap = 'nowrap';
const kCssWhitespacePre = 'pre';
