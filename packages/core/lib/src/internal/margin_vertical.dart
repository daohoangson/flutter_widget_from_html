import 'package:flutter/widgets.dart';

import '../core_data.dart';
import '../core_helpers.dart';

class HeightPlaceholder extends WidgetPlaceholder<CssLength> {
  final CssLength height;
  final TextStyleBuilder tsb;

  HeightPlaceholder(this.height, this.tsb) : super(generator: height) {
    super.wrapWith((child) => _build(child, height, tsb));
  }

  void mergeWith(HeightPlaceholder other) =>
      super.wrapWith((child) => _build(child, other.height, other.tsb));

  @override
  HeightPlaceholder wrapWith(Widget Function(Widget) builder) => this;

  static Widget _build(Widget child, CssLength height, TextStyleBuilder tsb) {
    final existing = child is SizedBox ? child.height : 0.0;
    final value = height.getValue(tsb.build());
    if (value > existing) return SizedBox(height: value);
    return child;
  }
}
