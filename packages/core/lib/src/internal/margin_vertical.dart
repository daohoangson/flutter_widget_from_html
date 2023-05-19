import 'package:flutter/widgets.dart';

import '../core_data.dart';
import '../core_helpers.dart';

class HeightPlaceholder extends WidgetPlaceholder {
  final HtmlStyleBuilder styleBuilder;

  final List<CssLength> _heights = [];

  HeightPlaceholder(CssLength height, this.styleBuilder, {Key? key})
      : super(
          builder: (c, w) => _build(c, w, height, styleBuilder),
          debugLabel: 'height',
          key: key,
        ) {
    _heights.add(height);
  }

  CssLength get height => _heights.first;

  @override
  bool get isEmpty => false;

  @override
  Widget build(BuildContext context) {
    if (context.skipBuildHeightPlaceholder) {
      return this;
    } else {
      return super.build(context);
    }
  }

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

extension SkipBuildHeightPlaceholder on BuildContext {
  static final _skipBuild = Expando<int>();

  bool get skipBuildHeightPlaceholder => _skipBuildOrZero > 0;

  set skipBuildHeightPlaceholder(bool newValue) {
    final v = _skipBuildOrZero;
    _skipBuild[this] = newValue ? (v + 1) : (v > 0 ? v - 1 : 0);
  }

  int get _skipBuildOrZero => _skipBuild[this] ?? 0;
}
