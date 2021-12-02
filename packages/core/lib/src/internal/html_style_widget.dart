import 'package:flutter/widgets.dart';

import '../core_data.dart';

class HtmlStyleWidget extends InheritedWidget {
  final HtmlStyle? style;

  const HtmlStyleWidget({
    Key? key,
    required Widget child,
    required this.style,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(HtmlStyleWidget oldWidget) =>
      style == null || style != oldWidget.style;
}
