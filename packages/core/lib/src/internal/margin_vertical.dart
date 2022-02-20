import 'package:flutter/widgets.dart';

import '../core_data.dart';
import '../core_helpers.dart';

class HeightPlaceholder extends WidgetPlaceholder {
  final HtmlStyleBuilder styleBuilder;

  final List<CssLength> _heights = [];

  HeightPlaceholder(CssLength height, this.styleBuilder, {Key? key})
      : super(
          autoUnwrap: false,
          builder: (c, w) => _build(c, w, height, styleBuilder),
          debugLabel: 'height',
          key: key,
        ) {
    _heights.add(height);
  }

  CssLength get height => _heights.first;

  void mergeWith(HeightPlaceholder other) {
    final height = other.height;
    _heights.add(height);

    super.wrapWith((c, w) => _build(c, w, height, other.styleBuilder));
  }

  @override
  HeightPlaceholder wrapWith(Widget? Function(BuildContext, Widget) builder) =>
      this;

  static Widget _build(
    BuildContext context,
    Widget child,
    CssLength height,
    HtmlStyleBuilder styleBuilder,
  ) {
    final existing = (child is SizedBox ? child.height : null) ?? 0.0;
    final value = height.getValue(styleBuilder.build(context));
    if (value != null && value > existing) {
      return SizedBox(height: value);
    }
    return child;
  }
}
