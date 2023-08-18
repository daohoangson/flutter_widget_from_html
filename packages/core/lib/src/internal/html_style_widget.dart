import 'package:flutter/widgets.dart';

import '../core_data.dart';

class HtmlStyleWidget extends InheritedWidget {
  final HtmlStyle? style;

  const HtmlStyleWidget({
    super.key,
    required super.child,
    required this.style,
  });

  @override
  bool updateShouldNotify(HtmlStyleWidget oldWidget) =>
      style == null || style != oldWidget.style;
}
