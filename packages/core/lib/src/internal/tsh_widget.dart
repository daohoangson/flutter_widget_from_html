import 'package:flutter/widgets.dart';

import '../core_data.dart';

class TshWidget extends InheritedWidget {
  final TextStyleHtml? tsh;

  const TshWidget({required super.child, super.key, required this.tsh});

  @override
  bool updateShouldNotify(TshWidget oldWidget) =>
      tsh == null || tsh != oldWidget.tsh;
}
