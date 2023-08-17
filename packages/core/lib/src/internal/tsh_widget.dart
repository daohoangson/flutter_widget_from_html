import 'package:flutter/widgets.dart';

import '../core_data.dart';

class TshWidget extends InheritedWidget {
  final TextStyleHtml? tsh;

  const TshWidget({
    super.key,
    required super.child,
    required this.tsh,
  });

  @override
  bool updateShouldNotify(TshWidget oldWidget) =>
      tsh == null || tsh != oldWidget.tsh;
}
