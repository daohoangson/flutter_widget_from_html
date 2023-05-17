import 'package:flutter/rendering.dart';
import 'package:fwfh_text_style/fwfh_text_style.dart';

void main() {
  final style = TextStyle(height: 1.0, inherit: false);
  print('style.height=${style.height}'); //       style.height=1.0
  final copy = style.copyWith(height: null);
  print('copy.height=${copy.height}'); //         copy.height=1.0

  final fwfh = FwfhTextStyle.from(style);
  print('fwfh.height=${fwfh.height}'); //         fwfh.height=1.0
  final fwfhCopy = style.copyWith(height: null);
  print('fwfhCopy.height=${fwfhCopy.height}'); // fwfhCopy.height=null
}
