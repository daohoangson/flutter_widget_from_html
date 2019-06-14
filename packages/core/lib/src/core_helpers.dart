import 'package:flutter/widgets.dart';

import 'core_html_widget.dart';
import 'core_widget_factory.dart';
import 'data_classes.dart';

part 'parser/border.dart';
part 'parser/color.dart';
part 'parser/css.dart';

/// A no op placeholder widget.
const widget0 = const SizedBox.shrink();

typedef void OnTapUrl(String url);

typedef WidgetFactory FactoryBuilder(BuildContext context, HtmlWidget widget);
