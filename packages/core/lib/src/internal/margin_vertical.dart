import 'package:flutter/widgets.dart';

import '../core_data.dart';
import '../core_helpers.dart';

class HeightPlaceholder extends WidgetPlaceholder<CssLength> {
  final CssLength height;
  final TextStyleBuilder tsb;

  HeightPlaceholder(this.height, this.tsb) : super(generator: height) {
    super.wrapWith((c, w) => _build(c, w, height, tsb));
  }

  void mergeWith(HeightPlaceholder other) =>
      super.wrapWith((c, w) => _build(c, w, other.height, other.tsb));

  @override
  HeightPlaceholder wrapWith(Widget Function(BuildContext, Widget) builder) =>
      this;

  static Widget _build(BuildContext context, Widget child, CssLength height,
      TextStyleBuilder tsb) {
    final existing = child is SizedBox ? child.height : 0.0;
    final tsh = tsb.build(context);
    final value = height.getValue(tsh);
    if (value > existing) return SizedBox(height: value);
    return child;
  }
}
